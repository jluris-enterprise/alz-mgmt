# Sequence
https://learn.microsoft.com/en-us/samples/azure-samples/avm-terraform-labs/avm-terraform-labs/

1) copy the registry module in Terraform or AVM
  * AVM - https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/
  * Terraform Registry - https://registry.terraform.io/browse/modules?provider=azure
2) Add a variable in resource_name_templates
3) 

# Errors

 Error: Resource not found
│
│   with data.azapi_resource.resource_group,
│   on data.tf line 19, in data "azapi_resource" "resource_group":
│   19: data "azapi_resource" "resource_group" {
│
│ resource "Resource: (ResourceId \"/subscriptions/0f360a6d-0f50-47f1-8530-48fdc5828b03/resourceGroups/rg-acr-k8s-dev-uksouth-001\" / Api Version \"2021-04-01\")" not found
