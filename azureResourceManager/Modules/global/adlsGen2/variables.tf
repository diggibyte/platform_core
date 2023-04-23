variable "resource_group_name" {
  type        = string
  description = "Name of Resource Group"
}

variable "storage_name" {
  type        = string
  description = "Name of storage account"
}

variable "location" {
  type        = string
  description = "Name of location"
  default = "Central India"
}

variable "account_tier" {
  type        = string
  description = "Value of account tier"
  default = "Standard"
}

variable "account_kind" {
  type        = string
  description = "Name of account kind"
  default = "StorageV2"
}

variable "account_replication_type" {
  type        = string
  description = "account replication type"
  default = "LRS"
}

variable "is_hns_enabled" {
  type        = string
  description = "hierarchical namespace or not"
  default = "true"
}

variable "access_tier" {
  type        = string
  description = "access tier type"
  default = "Hot"
}

variable "enable_https_traffic_only" {
  type        = string
  description = "only HTTPS traffic only"
  default = "true"
}