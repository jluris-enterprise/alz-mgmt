# Azure Landing Zones Accelerator Starter Module for Terraform - Azure Verified Modules Complete Multi-Region

This module is part of the Azure Landing Zones Accelerator solution. It is a complete multi-region implementation of the Azure Landing Zones Platform Landing Zone for Terraform.

It deploys a hub and spoke virtual network or Virtual WAN architecture across multiple regions.

The module deploys the following resources:

- Management group hierarchy
- Azure Policy definitions and assignments
- Role definitions
- Management resources, including Log Analytics workspace and Automation account
- Hub and spoke virtual network or Virtual WAN architecture across multiple regions
- DDOS protection plan
- Private DNS zones

## Usage

The module is intended to be used with the [Azure Landing Zones Accelerator](https://aka.ms/alz/acc). Head over there to get started.

>NOTE: The module can be used independently if needed. Example `tfvars` files can be found in the `examples` directory for that use case.

### Running Directly

#### Run the local examples

Create a `terraform.tfvars` file in the root of the module directory with the following content, replacing the placeholders with the actual values:

```hcl
starter_locations            = ["uksouth", "ukwest"]
subscription_id_connectivity = "00000000-0000-0000-0000-000000000000"
subscription_id_identity     = "00000000-0000-0000-0000-000000000000"
subscription_id_management   = "00000000-0000-0000-0000-000000000000"
```

##### Hub and Spoke Virtual Networks Multi Region

```powershell
terraform init
terraform apply -var-file ./examples/full-multi-region/hub-and-spoke-vnet.tfvars
```

##### Virtual WAN Multi Region

```powershell
terraform init
terraform apply -var-file ./examples/full-multi-region/virtual-wan.tfvars
```


#####

✅CI/CD Pipeline Blueprint
This document outlines the end-to-end CI/CD pipeline for the alz-mgmt and alz-mgmt-templates repositories, detailing the flow of events from a code change to a deployment in Azure.

Phase 1: Continuous Integration (CI)
Goal: To automatically validate code changes before they are merged into the main branch.

1. Trigger
Action: A developer creates or updates a Pull Request (PR) in the alz-mgmt repository.

Event: The on: pull_request: trigger in the ci.yaml file is activated.

2. Workflow Call
The ci.yaml file in alz-mgmt calls the reusable workflow in ci-templates.yaml in the alz-mgmt-templates repository.

The ci-templates.yaml workflow starts running in its own dedicated GitHub Actions runner.

3. CI Jobs
Job: lint_and_validate

Steps:

Checks out the code from the PR branch.

Installs the specified Terraform CLI version.

Runs terraform fmt -check to enforce code formatting standards.

Runs terraform validate to check for syntax and configuration errors.

Outcome: If the job fails, the PR is blocked, and the developer receives an immediate notification to fix the issues.

Phase 2: Continuous Delivery (CD)
Goal: To safely and manually apply infrastructure changes to Azure after code is merged.

1. Trigger
Action: A developer merges the approved PR into the main branch of alz-mgmt.

Event: The on: push: branches: [main] trigger in the cd.yaml file is activated.

2. First Workflow Run (Plan)
Workflow Call: cd.yaml calls the reusable workflow in cd-templates.yaml.

Job: plan

A new, clean runner is provisioned.

Steps:

Checks out the merged main branch code.

Runs terraform init to configure the backend.

Runs terraform plan -out=tfplan to create an immutable plan file.

Creates and uploads the tfplan file as a module artifact.

Runs terraform show tfplan to print the human-readable plan to the workflow log for review.

Outcome: The workflow waits for a manual trigger.

3. Manual Trigger (Apply)
Action: A human with the appropriate permissions reviews the plan output in the workflow log.

Event: The user manually triggers the workflow from the GitHub Actions UI.

Input: The user selects the terraform_action input and sets its value to 'apply'.

4. Second Workflow Run (Apply)
Job: plan

This job runs again, creating a new tfplan artifact.

Job: apply

Conditional: This job only runs if inputs.terraform_action == 'apply'.

Steps:

A new, separate runner is provisioned for this job.

Downloads the module artifact created in the plan job.

Runs terraform init to re-initialize the backend.

Runs terraform apply -auto-approve tfplan, using the exact plan from the artifact to update Azure resources.

Outcome: The infrastructure is deployed in Azure.

###

