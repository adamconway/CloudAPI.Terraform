locals {
  resource_suffix = "cloudapi-${var.environment_name}-${var.region}"
  storage_resource_suffix = "capi${var.environment_name}${var.region}"

}

resource "azurerm_resource_group" "rg" {
  name     = "rg-compute-${local.resource_suffix}"
  location = var.region
}

resource "azurerm_storage_account" "functions" {
  name                     = "st${local.storage_resource_suffix}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "functions" {
  name                = "asp-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "compute" {
  name                       = "func-${local.resource_suffix}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key

  https_only = true

  version = "~3"
}

data "azurerm_function_app_host_keys" "compute" {
  name                = azurerm_function_app.compute.name
  resource_group_name = azurerm_resource_group.rg.name
}


