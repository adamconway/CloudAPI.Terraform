data "azurerm_api_management" "core" {
  name                = "apim-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.core.name
}

resource "azurerm_api_management_named_value" "func_key" {
  name                = "func-${local.resource_suffix}-key"
  resource_group_name = data.azurerm_resource_group.core.name
  api_management_name = "apim-${local.resource_suffix}"
  display_name        = "func-${local.resource_suffix}-key"
  value               = data.azurerm_function_app_host_keys.compute.default_function_key
  secret              = "true"
  tags = []
}

resource "azurerm_api_management_backend" "func" {
  name                = "func-${local.resource_suffix}"
  title               = "func-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.core.name
  api_management_name = data.azurerm_api_management.core.name
  protocol            = "http"
  url                 = "https://${azurerm_function_app.compute.name}.azurewebsites.net/api"

  resource_id = "https://management.azure.com${azurerm_function_app.compute.id}"

  credentials {
    header = {
      "x-functions-key": azurerm_api_management_named_value.func_key.value
    }
  }
}

resource "azurerm_api_management_api" "func" {
  name                = "func-${local.resource_suffix}"
  resource_group_name = data.azurerm_resource_group.core.name
  api_management_name = data.azurerm_api_management.core.name
  revision            = "1"
  path                = "cloud"
  protocols           = ["https"]
}

resource "azurerm_api_management_api_policy" "api_policy" {
  api_name            = azurerm_api_management_api.func.name
  api_management_name = data.azurerm_api_management.core.name
  resource_group_name = data.azurerm_resource_group.core.name

  xml_content = <<XML
<policies>
  <inbound>
    <set-backend-service id="tf-generated-policy" backend-id="${azurerm_api_management_backend.func.name}" />
    <base />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}