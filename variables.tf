
# I need to find a good way to update the variables. 

variable "cdb-rgname" {
    type = string
    default = "rg-cdb-westus-002"
    description = "name of resource group"
}

variable "name_prefix" {
    type = string
    default = "101-cosmos-db-analyticalstore"
    description = "Prefix for resource group name"
}

variable "cdb-rglocation" {
    type = string
    default = "West US 2"
    description = "location of resource group"
}

variable "cdb-accountname" {
    type = string
    default = "gbcosmosdb-${UniqueStringAz}"
    description = "name of Azure CosmosDB account"
}

variable "cdb_account_location" {
    type = string
    default = "West US 2"
    description = "Cosmos DB account location"
}

variable "cdb_sqldb_name" {
  type        = string
  default     = "serverlessLabsqlCDB"
  description = "value"
}

variable "msi_id" {
    type = string
    default = null
    description = "If you're executing the test with user assigned identity, please pass the identity principal id to this variable."
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

variable "sql_container_name" {
    type = string
    default = "serverlessLabCDBContainer"
    description = "SQL API container name."
}