module "rgs" {
  source = "../../Child Module/azurerm_resource_group"
  rgs    = var.rgs
}
module "vnet" {
  depends_on = [module.rgs]
  source     = "../../Child Module/azurerm_Virtual_Network"
  vnet       = var.vnet

}
module "subnets" {
  depends_on = [module.vnet]
  source     = "../../Child Module/azurerm_Subnet"
  subnets    = var.subnets

}
module "pips" {
  depends_on = [module.rgs]
  source     = "../../Child Module/azurerm_publicip"
  pips       = var.pips

}

module "vms" {
  depends_on = [module.subnets, module.pips, module.keyvault]
  source     = "../../Child Module/azurerm_VM_NIC"
  vms        = var.vms

}

module "keyvault" {
  depends_on = [module.rgs]
  source     = "../../Child Module/azurerm_Keyvault"
  keyvault   = var.keyvault

}

module "bastions" {
  depends_on = [module.subnets, module.pips]
  source     = "../../Child Module/azurerm_Bastion"
  bastions   = var.bastions
}


module "nat_gateways" {
  depends_on  = [module.subnets, module.pips]
  source      = "../../Child Module/azurerm_Nat_Gateway"
  natgateways = var.natgateways
}

module "nsgs" {
  depends_on = [module.subnets]
  source     = "../../Child Module/azurerm_NSG"
  nsgs       = var.nsgs
}