
# I need to find a good way to update the variables. 

variable "cdb_rg_name" {
    type = string
    default = "rg-cdb-westus-002"
    description = "name of resource group"
}

variable "name_prefix" {
    type = string
    default = "101_cosmos_db_analyticalstore"
    description = "Prefix for resource group name"
}

variable "cdb_rglocation" {
    type = string
    default = "West US 2"
    description = "location of resource group"
}

#variable "cdb_accountname" {
#    type = string
#    default = "gbcosmosdb_${UniqueStringAz}"
#    description = "name of Azure CosmosDB account"
#}

variable "cdb_account_location" {
    type = string
    default = "West US 2"
    description = "Cosmos DB account location"
}









variable "api_mng_name" {
    type = string
    default = "api_mng"
    description = "API Management name"
}

variable "publisher_email" {
  default     = "justin.j.furrow@gmail.com"
  description = "The email address of the owner of the service"
  type        = string
  validation {
    condition     = length(var.publisher_email) > 0
    error_message = "The publisher_email must contain at least one character."
  }
}

variable "publisher_name" {
  default     = "Justin Furrow"
  description = "The name of the owner of the service"
  type        = string
  validation {
    condition     = length(var.publisher_name) > 0
    error_message = "The publisher_name must contain at least one character."
  }
}

variable "sku" {
  description = "The pricing tier of this API Management service"
  default     = "Developer"
  type        = string
  validation {
    condition     = contains(["Developer", "Standard", "Premium"], var.sku)
    error_message = "The sku must be one of the following: Developer, Standard, Premium."
  }
}

variable "sku_count" {
  description = "The instance size of this API Management service."
  default     = 1
  type        = number
  validation {
    condition     = contains([1, 2], var.sku_count)
    error_message = "The sku_count must be one of the following: 1, 2."
  }
}

# create these in Azure portal and call them using "data" instead of "resource" in main.tf
# "data" in main.tf can be used to reference resources which were created outside of Terraform (or in other Terraform configs) without having to manually recreate them here.
variable "loganalyticsname" {
    type = string
    default = ""
}

variable "loganalytics_resource_group_name" {
    type = string
    default = ""
}

variable "cdb_log_settings_name" {
    type = string
    default = "cosmoslogsettings"
}