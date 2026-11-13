terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "example-bootstraps-dev-eastus-rg"
    storage_account_name = "examplebsdeveastusst"
    container_name       = "terraform-state-files"
    key                  = "bootstrap-vms-docker-swarm.tfstate"
  }
}