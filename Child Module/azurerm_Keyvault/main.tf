data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "example" {
    for_each = var.keyvault
  name                        = each.value.name
  location                    = each.value.location
  resource_group_name         = each.value.resource_group_name
  rbac_authorization_enabled  = false
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"


  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

  secret_permissions = [
  "Get",
  "Set",
  "Delete",
  "Recover",
  "Purge",
]

    storage_permissions = [
      "Get",
    ]
  }
}
variable "keyvault" {
  
}

resource "azurerm_key_vault_secret" "example" {
    for_each = var.keyvault
  name         = each.value.keyvaultsecretname
  value        = each.value.value
  key_vault_id = azurerm_key_vault.example[each.key].id
}