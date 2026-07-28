resource "azurerm_network_security_group" "nsg" {
  for_each            = var.nsgs
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  dynamic "security_rule" {
    for_each = lookup(each.value, "rules", [])
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

data "azurerm_subnet" "nsg_subnet" {
  for_each             = var.nsgs
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.subnet_resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = var.nsgs
  subnet_id                 = data.azurerm_subnet.nsg_subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
