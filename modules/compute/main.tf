locals {
  resource_suffix = "cloudapi-${var.environment_name}-aueast"
  storage_resource_suffix = "capi${var.environment_name}aueast"

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

// az apim api import --service-name apim-cloudapi-dev-australiaeast -g rg-core-cloudapi-dev-australiaeast --api-id func-cloudapi-dev-australiaeast-api --path cloudapi --specification-format Swagger --specification-url https://func-cloudapi-dev-australiaeast.azurewebsites.net/api/swagger.json
module "cloudapi" {
  source = "../shared/function-apim"

  name = "func-${local.resource_suffix}"
  location =var.region
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.functions.id
  function_version = "~3"

  storage_account_name       = azurerm_storage_account.functions.name
  storage_account_access_key = azurerm_storage_account.functions.primary_access_key

  apim_name = "apim-${local.resource_suffix}"
  apim_resource_group_name = data.azurerm_resource_group.core.name
  api_path = "cloudapi"
}

