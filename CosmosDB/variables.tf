variable "base_name" {
    type = string
    default = "GraniteBlog"
    description = "The storage account base name"
}

variable "resource_group_name" {
    type = string
    default = "azurerm_resource_group.cdb_rg.name"
    description = "Name of the resource group"
}

variable "location" {
    type = string
    default = "westus2"
    description = "The location for the deployment"
}

variable "throughput" {
    type = number
    default = 400
    description = "Cosmos db database throughput"
    validation {
        condition = var.throughput >= 400 && var.throughput <= 1000000
        error_message = "Cosmos db manual throughput should be equal to or greater than 400 and less than or equal to 1000000."
    }
    validation {
        condition = var.throughput % 100 == 0
        error_message = "Cosmos db throughput should be in increments of 100."
    }
}

variable "cdb_sqldb_name" {
  type        = string
  default     = "azurerm_cosmosdb_sql_database.cdb_sql.name"
  description = "value"
}

variable "sql_container_name" {
    type = string
    default = "serverlessLabCDBContainer"
    description = "SQL API container name."
}

variable "cdb_sql_roledef" {
    type = string
    default = "SQLroledefname"
    description = "SQL role definition name"
}

variable "cdb_sql_roleassignment" {
    type = string
    default = "SQLroleAssignmentName"
    description = "SQL role assignment name"
}

# problem here is I can't pass a value from something's name into this to export into other resources. There's probably a better way to do this. 
#variable "cdb_account_name" {
#    type = string
#    description = "CDB account name"
#}


#variable "msi_id" {
#    type = string
#    default = null
#    description = "If you're executing the test with user assigned identity, please pass the identity principal id to this variable."
#}