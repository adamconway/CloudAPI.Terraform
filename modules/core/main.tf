locals {
  resource_suffix = "cloudapi-${var.environment_name}-aueast"
}

resource "azurerm_resource_group" "core" {
  name     = "rg-core-${local.resource_suffix}"
  location = var.region
}

resource "azurerm_api_management" "core" {
  name                = "apim-${local.resource_suffix}"
  location            = azurerm_resource_group.core.location
  resource_group_name = azurerm_resource_group.core.name
  publisher_name      = "Conway"
  publisher_email     = "adam@conway.nz"
  sku_name = "Consumption_0"
}

#resource "azurerm_key_vault" "core" {
#  name                        = "kv-${local.resource_suffix}"
#  location                    = azurerm_resource_group.core.location
#  resource_group_name         = azurerm_resource_group.core.name
#
#  tenant_id                   = data.azurerm_client_config.current.tenant_id
#
#  sku_name = "standard"
#}