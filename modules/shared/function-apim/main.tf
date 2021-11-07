# Azure Function Backend Setup
resource "azurerm_function_app" "func" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  https_only = true

  version = var.function_version

  app_settings = var.app_settings

  tags = var.tags
}

data "azurerm_function_app_host_keys" "func" {
  name                = azurerm_function_app.func.name
  resource_group_name = var.resource_group_name
}

# APIM Setup
resource "azurerm_api_management_backend" "func" {
  name                = var.name
  resource_group_name = var.apim_resource_group_name
  api_management_name = var.apim_name
  protocol            = "http"
  url                 = "https://${azurerm_function_app.func.default_hostname}/api"

  resource_id = "https://management.azure.com${azurerm_function_app.func.id}"

  credentials {
    header = {
      "x-functions-key": azurerm_api_management_named_value.func.value
    }
  }
}

resource "azurerm_api_management_api" "func" {
  name                = "${var.name}-api"
  display_name        = "${var.name}-api"
  resource_group_name = var.apim_resource_group_name
  api_management_name = var.apim_name
  revision            = "1"
  path                = var.api_path
  protocols           = ["https"]
  service_url         = "https://${azurerm_function_app.func.default_hostname}/api"

  lifecycle {
    ignore_changes = [display_name, description]
  }
}

resource "azurerm_api_management_api_policy" "func" {
  api_name            = azurerm_api_management_api.func.name
  resource_group_name = var.apim_resource_group_name
  api_management_name = var.apim_name

  xml_content = <<XML
<policies>
  <inbound>
    <set-backend-service id="terraform-backend-policy" backend-id="${azurerm_api_management_backend.func.name}" />
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

resource "azurerm_api_management_named_value" "func" {
  name                = "${var.name}-key"
  resource_group_name = var.apim_resource_group_name
  api_management_name = var.apim_name
  display_name        = "${var.name}-key"
  value               = data.azurerm_function_app_host_keys.func.default_function_key
  secret              = "true"
}