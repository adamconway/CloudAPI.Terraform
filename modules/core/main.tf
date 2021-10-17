locals {
  resource_suffix = "cloudapi-${var.environment_name}-${var.region}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-core-${local.resource_suffix}"
  location = var.region
}

resource "azurerm_api_management" "core" {
  name                = "apim-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Conway"
  publisher_email     = "adam@conway.nz"

  sku_name = "Consumption_0"
}