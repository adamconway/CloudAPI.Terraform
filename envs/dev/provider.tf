terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.81.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-conwaynz-management"
    storage_account_name = "stconwaynzmanagment"
    container_name       = "terraform"
    key                  = "cloudapi-dev.tfstate"
    subscription_id      = "30488513-6cba-450a-9431-64d9bf16a526"
    tenant_id            = "8bf4adbf-1b38-40ef-863d-797e1793e3a7"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "30488513-6cba-450a-9431-64d9bf16a526"
}