# Import the existing MG into the exact resource address TF is trying to create
# import {
#   to = module.management_groups[0].module.management_groups.azapi_resource.management_groups_level_2["security"]
#   id = "/providers/Microsoft.Management/managementGroups/security"
# }