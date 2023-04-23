
variable "resource_group_name" {
  type        = string
  description = "Name of Resource Group"
}

variable "env" {
  type        = string
  description = "Name of Enviornment"
}

variable "module_path" {
  type        = string
  description = "Path to Module"
  default = "../../../Modules"
}

variable "subscription_id" {
  type        = string
  description = "subscription id"
}

variable "client_id" {
  type        = string
  description = "Service principal client id"
}

variable "client_secret" {
  type        = string
  description = "Service principal client secrete"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id"
}

variable "storage_name_001" {
  type        = string
  description = "Name of storage account"
}