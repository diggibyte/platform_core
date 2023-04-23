resource "azurerm_storage_account" "this" {
  name                      = var.storage_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  account_tier              = var.account_tier
  account_kind              = var.account_kind
  account_replication_type  = var.account_replication_type
  is_hns_enabled            = var.is_hns_enabled
  access_tier               = var.access_tier
  enable_https_traffic_only = var.enable_https_traffic_only
}

