terraform {
  #############################################################
  ## Run terraform apply (with local backend) & uncomment the azurerm backend configuration below
  ## Initialize Terraform to copy existing state to the new backend - terraform init
  ## Verify - terraform state list
  #############################################################
  backend "azurerm" {
      use_azuread_auth     = true                        
      resource_group_name  = "example-bootstraps-dev-eastus-rg"
      storage_account_name = "examplebsdeveastusst"
      container_name       = "terraform-state-files"
      key                  = "bootstrap-backend.tfstate"  
    }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = "${var.project}-bootstraps-${var.environment}-${var.region}-rg"
  location = var.region

  # Merging common tags with resource-specific tags
  tags = merge(local.common_tags, {
    Project = var.project
  })
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.project}bs${var.environment}${var.region}st"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  # Merging common tags with resource-specific tags
  tags = merge(local.common_tags, {
    Project = var.project
  })
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.storage_container
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_role_assignment" "tfstate_admin" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.admin_object_id
  principal_type       = "User"
}