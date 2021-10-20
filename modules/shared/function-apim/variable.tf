variable "name" {
  description = "Specifies the name of the Function App."
}

variable "location" {
  description = "Specifies the supported Azure location where the function is deployed to."
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Function App."
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan within which to create this Function App.."
}

variable "storage_account_name" {
  description = "The backend storage account name which will be used by this Function App (such as the dashboard, logs)"
}

variable "storage_account_access_key" {
  description = "The access key which will be used to access the backend storage account for the Function App."
}

variable "function_version" {
  description = "Version of the function runtime to use"
  default = "~3"
}

variable "app_settings" {
  description = "A map of key-value pairs for App Settings and custom values."
  default = {}
}

variable "apim_name" {
  description = "Existing APIM name"
}

variable "apim_resource_group_name" {
  description = "The name of the resource group where the APIM instance exists."
}

variable "api_path" {
  description = "APIM API Path"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  default = {}
}