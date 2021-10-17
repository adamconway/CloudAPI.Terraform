terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.81.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "30488513-6cba-450a-9431-64d9bf16a526"
}

# Core Layer
module "core" {
  source = "../../modules/core"

  environment_name = "dev"
  region           = "australiaeast"
}

# Compute Layer
module "compute" {
  source = "../../modules/compute"

  environment_name = "dev"
  region           = "australiaeast"
}

# Data Layer
module "data" {
  source = "../../modules/data"

  environment_name = "dev"
  region           = "australiaeast"
}