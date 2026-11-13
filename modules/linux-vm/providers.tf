terraform {
  required_version = ">=1.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>5.12.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.10.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}