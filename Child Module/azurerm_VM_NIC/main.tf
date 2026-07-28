data "azurerm_key_vault" "kv" {
  for_each            = var.vms
  name                = each.value.keyvaultname
  resource_group_name = each.value.resource_group_name
}

data "azurerm_key_vault_secret" "vm_password" {
  for_each     = var.vms
  name         = each.value.keyvaultsecretname
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

variable "vms" {
  
}
data "azurerm_subnet" "subdb" {
    for_each = var.vms
  name                 = each.value.nic_subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}


resource "azurerm_network_interface" "nicinterface" {
    for_each = var.vms
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = each.value.name
    subnet_id                     = data.azurerm_subnet.subdb[each.key].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
  }
}
resource "azurerm_linux_virtual_machine" "example" {
  for_each = var.vms
  name                = each.value.vmname
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password = data.azurerm_key_vault_secret.vm_password[each.key].value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nicinterface[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


