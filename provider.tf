terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.23.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}