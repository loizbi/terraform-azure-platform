terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "example01-terraform-dev-eastus-rg"
    storage_account_name = "example01bsdeveastusst"
    container_name       = "terraform-state-files"
    key                  = "example-01-net-vm-01.tfstate"
  }
}