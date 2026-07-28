data "azurerm_public_ip" "pip" {
  for_each            = var.natgateways
  name                = each.value.pip_name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_nat_gateway" "nat" {
  for_each            = var.natgateways
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  for_each             = var.natgateways
  nat_gateway_id       = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
}

locals {
  nat_subnet_associations = flatten([
    for nat_key, nat_val in var.natgateways : [
      for subnet in nat_val.subnets : {
        nat_key             = nat_key
        subnet_name         = subnet.name
        vnet_name           = subnet.vnet_name
        resource_group_name = subnet.resource_group_name
      }
    ]
  ])
}

data "azurerm_subnet" "subnets" {
  for_each             = { for assoc in local.nat_subnet_associations : "${assoc.nat_key}-${assoc.subnet_name}" => assoc }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}

resource "azurerm_subnet_nat_gateway_association" "assoc" {
  for_each       = { for assoc in local.nat_subnet_associations : "${assoc.nat_key}-${assoc.subnet_name}" => assoc }
  subnet_id      = data.azurerm_subnet.subnets[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat[each.value.nat_key].id
}
