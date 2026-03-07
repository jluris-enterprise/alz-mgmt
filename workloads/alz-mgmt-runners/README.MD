mgmt-runners && terraform fmt && terraform init -backend-config="resource_group_name=rg-alz-mgmt-state-uaenorth-001" -backend-config="storage_account_name=stoalzmgmuae001wksi" -backend-config="container_name=mgmt-tfstate" -backend-config="key=alz-mgmt-runners.tfstate"

