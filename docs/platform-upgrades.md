# Platform upgrades and pipeline runbook

What has been upgraded in this platform landing zone, what is still to do, and how to recover when a CD run goes wrong.

Last updated: 2026-11-22.

## Upgrade status

| Component | Where it is pinned | From | To | Status |
|---|---|---|---|---|
| ALZ policy library (`platform/alz`) | [`lib/alz_library_metadata.json`](../lib/alz_library_metadata.json) | `2025.09.2` | `2026.11.0` | Done (PR #3) |
| `Azure/avm-ptn-alz` (management groups, policy) | [`modules/management_groups/main.tf`](../modules/management_groups/main.tf) | `0.12.3` | `0.23.0` | Done (PR #4) |
| `Azure/avm-ptn-alz-management` (Log Analytics, AMA, DCRs) | [`modules/management_resources/main.tf`](../modules/management_resources/main.tf) | `0.7.0` | `0.10.0` | Done (PR #5) |
| `Azure/avm-ptn-alz-connectivity-hub-and-spoke-vnet` (hub VNet, firewall, DNS, bastion) | [`main.connectivity.hub.and.spoke.virtual.network.tf`](../main.connectivity.hub.and.spoke.virtual.network.tf) | `0.12.0` | `0.17.2` | Done (PR #6, plus the custom-zone fix). `0.18.x` is deferred until the ALZ accelerator adopts it. |
| `Azure/alz` provider | [`terraform.tf`](../terraform.tf) | `0.21.0` | `0.22.1` | Optional; `avm-ptn-alz 0.23.0` only needs `~> 0.21` |

`avm-ptn-alz-connectivity-virtual-wan` (`0.11.8`) is also declared, but this platform uses hub and spoke, so it deploys nothing. Leave it until there is a reason to change it.

### How to run an upgrade

1. Upgrade one component per branch and PR. For a big version gap, step through the minor versions.
2. Read the release notes for every version in the gap and look for breaking changes.
3. Run `terraform validate` locally against the new version before pushing.
4. Open the PR. CI runs only on pull requests; pushing a branch does nothing.
5. Read the CI plan. Search it for `must be replaced` and `will be destroyed`, and group the actions by resource type. Don't merge if a management group, VNet, firewall, route table or Log Analytics workspace would be replaced.
6. After merging, check that the CD plan matches the PR plan before approving `alz-mgmt-apply`.

### Notes on the `avm-ptn-alz` 0.23.0 upgrade

These wrapper changes were needed in [`modules/management_groups/main.tf`](../modules/management_groups/main.tf):

- `partner_id` was removed upstream (0.19.0), so it is no longer passed.
- `dependencies` was split into `policy_assignments_dependencies` and `policy_role_assignments_dependencies` (0.18.0).
- `policy_assignment_non_compliance_message_settings` defaults to `{ merge_mode = "prefer_existing" }`. The module default (`replace`) overwrote the custom non-compliance messages on 58 assignments with a generic one.

Expected plan churn: about 213 policy role assignments are replaced with the same names, scopes and roles. The schema now adds `identity_ids = []` to policy assignment identities, so `principalId` shows as unknown during planning. This is safe. The 38 new role assignments give the AMA and change-tracking policies access to the user-assigned identity, the DCRs and Log Analytics.

## Pipeline setup

- **Runner:** CI and CD run on a self-hosted runner in WSL on the operator's laptop, which is registered to this repo. The Azure runner VM `vm-mgmt-uan-001` is deallocated and not registered.
- **State:** stored in `stoalzmgmuae001wksi` / container `mgmt-tfstate` / key `alz-terraform.tfstate`. There is a blob private endpoint, `pep-stoalzmgmuae001wksi-blob` (172.16.0.69), in the runner VNet. Public access is limited to the operator's public IP. If that IP changes, update the storage firewall rule or every run fails with a `403 AuthorizationFailure` during init.
- **OIDC:** the federated credentials trust `ci-template.yaml` and `cd-template.yaml` only at `refs/heads/main`. [`ci.yaml`](../.github/workflows/ci.yaml) therefore calls `ci-template.yaml@main`, and [`cd.yaml`](../.github/workflows/cd.yaml) has no `pull_request` trigger. Don't add credentials for `refs/pull/*`.
- **WSL networking:** the WSL runner must use mirrored networking (`networkingMode=mirrored` in `%USERPROFILE%\.wslconfig`). The default NAT mode drops long-lived connections to Azure Resource Manager.

## Runbook: when a CD run goes wrong

### The apply fails partway (for example `connection reset by peer`)

Terraform replaces policy role assignments by deleting first and creating second. If the apply stops in between, policies that deploy or modify resources have no permissions until the apply finishes. Deny and Audit policies keep working.

1. Check the state lock (see below) and make sure no other run is in progress.
2. Use **Re-run all jobs**, not "Re-run failed jobs". The saved plan from the failed attempt is stale.
3. Review the new plan before approving it. It should mainly contain the remaining creates.

### A plan hangs on `Refreshing state...` for a role assignment

The cause is a role assignment that was deleted in Azure but is still recorded in state, which happens when a delete's response is lost. The wrapper retries `RoleAssignmentNotFound` on read (see `default_retries` in [`modules/management_groups/locals.tf`](../modules/management_groups/locals.tf)) with a 60-minute timeout, so the plan waits instead of failing.

1. Cancel the run. A plan changes nothing.
2. Check each role assignment the log mentions:
   ```bash
   az rest --method get --url "https://management.azure.com/<scope>/providers/Microsoft.Authorization/roleAssignments/<id>?api-version=2022-04-01"
   ```
3. Back up state, then remove only the ones that return `RoleAssignmentNotFound`:
   ```bash
   terraform state pull > ~/alz-state-backup-$(date +%Y%m%d-%H%M%S).tfstate
   terraform state rm 'module.management_groups[0].module.management_groups.azapi_resource.policy_role_assignments["<id>"]'
   ```
   Run these from a folder initialised against the backend (`terraform init` with the same `-backend-config` values the workflows use). The next plan creates the role assignments again.
4. Re-run all jobs.

### The state is locked and nothing is running

A cancelled or killed job can leave the blob lease in place. First confirm that no run is in progress or queued (`gh run list --status in_progress`). Then:

```bash
az storage blob lease break --account-name stoalzmgmuae001wksi -c mgmt-tfstate -b alz-terraform.tfstate --auth-mode login --subscription <management-subscription-id>
```

To see who holds the lock, base64-decode the `Terraformlockid` metadata on the blob (`az storage blob metadata show`).

### A job stays "pending" and the runner shows as busy

After a job is killed, GitHub can keep showing the runner as busy. Restart the service in WSL:

```bash
sudo systemctl restart actions.runner.jluris-enterprise-alz-mgmt.Dell-Predator-G15-5530.service
```

### General rules during a run

- Run one CD at a time. Don't start a manual run while another is in progress, and don't cancel a run that is applying.
- Keep the laptop plugged in and awake until the apply finishes. Use a wired connection for large applies.

## Open items

- **Defender for Cloud settings are not applied.** In [`platform-landing-zone.auto.tfvars`](../platform-landing-zone.auto.tfvars), `policy_assignments_to_modify` is keyed by `alz`, but the root management group is `jl-enterprise`. The plan warns `Management group 'alz' not found in hierarchy`. In Azure, `Deploy-MDFC-Config-H224` has the security contact `security_contact@replace_me`, and the Defender plans are `Disabled`. Changing the key to `jl-enterprise` turns on every plan set to `DeployIfNotExists`, which has a cost. Choose the plans before making the change.
- **Move CI/CD to the Azure runner VM.** Start `vm-mgmt-uan-001`, register it with an extra label, target that label in `runs-on`, then remove the laptop IP from the storage firewall and disable public access.
- **Upgrade hub and spoke** (see the status table above).
- **Commit `.terraform.lock.hcl`.** It is not committed, so every CI run installs the newest provider versions the constraints allow (currently azurerm 4.81.0). azurerm 5.x exists, but the AVM modules in use still require `< 5.0.0`.
- **The `Deploy-MCSB2-Monitoring` warnings in every plan are harmless.** The provider cannot work out role assignments for that assignment's diagnostic-settings policies, because the destinations are blank. In this assignment all of those policies run as `AuditIfNotExists`, so they don't need permissions.

### Notes on the hub-and-spoke 0.17.2 upgrade

The target is `0.17.2`, not `0.18.x`, because the latest ALZ accelerator (v17.7.0) pins `0.17.2`. Only the hub VNet, its 6 subnets and 7 private DNS zones (with links) are deployed. Firewall, Bastion, gateways, the DNS resolver and DDoS protection are all off.

- **Inputs:** the inputs were restructured in 0.13 and 0.14 (flattened, with the enabled flags moved into `enabled_resources`). The hub section of [`platform-landing-zone.auto.tfvars`](../platform-landing-zone.auto.tfvars) was ported to the new layout.
- **`enabled_resources`:** every flag defaults to `true` in the module, which would deploy a firewall, Bastion and gateways. All of them are set explicitly in tfvars. Don't remove any.
- **Variable type:** `hub_and_spoke_vnet_virtual_networks` is now `type = any`. The old typed object silently dropped new attributes such as `enabled_resources`.
- **Runner links:** [`main.management.runner.private-dns-links.tf`](../main.management.runner.private-dns-links.tf) reads `private_dns_zones.private_link_private_dns_zones`. The old path, inside `try()`, would have returned `{}` and planned the deletion of all runner VNet links. `try()` was removed so a wrong path now fails the plan.
- **DNS link moves:** 0.16 moved DNS links from azurerm to azapi. The module's moved blocks cover only the standard ALZ zone keys. [`moved.connectivity.hub.and.spoke.virtual.network.tf`](../moved.connectivity.hub.and.spoke.virtual.network.tf) covers `azure_postgres_sql_database`, `custom_jlurisenterprise` and `azure_aks_mgmt_uaen`. **Any new non-standard zone key added before this upgrade is applied needs a block there too.**
- **Output rename:** the module output `firewall_policy_ids` was renamed to `firewall_policies`.
- **Custom zones need `private_dns_zone_supports_private_link = false`.** Zones that aren't Private Link zones, such as `jlurisenterprise.com`, need this setting. Otherwise the module sets `resolutionPolicy` on their VNet links, and Azure rejects the apply with `400 The ResolutionPolicy property is applicable exclusively to private link zones`. Plans can't catch this. The first apply of 0.17.2 failed on exactly this link, and the rest of the apply completed.
- **Validation:** a local read-only plan (`-lock=false`) against real state showed 22 to add (telemetry only), 37 to change (in place) and 0 to destroy.

### Notes on the `avm-ptn-alz-management` 0.10.0 upgrade

- `log_analytics_workspace_local_authentication_disabled` became `..._enabled`, with the meaning inverted. The wrapper accepts either and defaults to enabled, which matches the live workspace.
- The workspace moved to `azurerm_log_analytics_workspace.management[0]` through the module's own `moved` block, so it was not replaced. The old telemetry resources were removed from state, not destroyed.
- Sentinel isn't onboarded, so the 0.9.0 change ("Sentinel no longer default") had no effect.
- **Upgrading hub and spoke may fix a Terraform 1.15 init problem.** The `avm-res-network-bastionhost 0.6.0` cross-variable validation it pulls in (hashicorp/terraform#38482) was the cause. The pipelines currently work on Terraform 1.15.2.
