data "azurerm_resource_group" "core" {
  name     = "rg-core-${local.resource_suffix}"
}

data "azurerm_api_management" "core" {
  name                = "apim-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.core.name
}

resource "azurerm_api_management_backend" "func" {
  name                = "func-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.core.name
  api_management_name = data.azurerm_api_management.core.name
  protocol            = "http"
  url                 = "https://${azurerm_function_app.compute.name}.azurewebsites.net"

  resource_id = "https://management.azure.com/${azurerm_function_app.compute.id}"

  credentials {
    header = {
      "x-functions-key": data.azurerm_function_app_host_keys.compute.default_function_key
    }
  }
}