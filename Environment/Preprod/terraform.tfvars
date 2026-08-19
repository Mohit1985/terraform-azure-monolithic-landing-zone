rgs = {
  rg1 = {
    name     = "mango-preprod"
    location = "centralindia"
  }

}
vnet = {
  vnet1 = {
    name                = "mango-vnet"
    resource_group_name = "mango-preprod"
    location            = "centralindia"
    address_space       = ["10.0.0.0/16"]
  }

}
subnets = {
  sub1 = {
    name                 = "frontend-subnet"
    resource_group_name  = "mango-preprod"
    virtual_network_name = "mango-vnet"
    address_prefixes     = ["10.0.1.0/24"]
  }
  sub2 = {
    name                 = "backend-subnet"
    resource_group_name  = "mango-preprod"
    virtual_network_name = "mango-vnet"
    address_prefixes     = ["10.0.2.0/24"]
  }

  sub3 = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "mango-preprod"
    virtual_network_name = "mango-vnet"
    address_prefixes     = ["10.0.4.0/26"]
  }
}
pips = {
  pip1 = {
    name                = "bastion-pip"
    resource_group_name = "mango-preprod"
    location            = "centralindia"
    allocation_method   = "Static"
    sku                 = "Standard"
  }
  pip2 = {
    name                = "nat-pip-mango"
    resource_group_name = "mango-preprod"
    location            = "centralindia"
    allocation_method   = "Static"
    sku                 = "Standard"
  }

}
vms = {
  vm1 = {
    name                          = "frontend-nic"
    location                      = "centralindia"
    resource_group_name           = "mango-preprod"
    virtual_network_name          = "mango-vnet"
    private_ip_address_allocation = "Dynamic"
    nic_subnet_name               = "frontend-subnet"
    size                          = "Standard_D2s_v3"
    admin_username                = "mohithalve"

    keyvaultname       = "keyvault-preprod009"
    keyvaultsecretname = "ramlkahan9967"

    vmname = "frontend-vm"
  }

  vm2 = {
    name                          = "backend-nic"
    location                      = "centralindia"
    resource_group_name           = "mango-preprod"
    virtual_network_name          = "mango-vnet"
    private_ip_address_allocation = "Dynamic"
    nic_subnet_name               = "backend-subnet"
    size                          = "Standard_D2s_v3"
    admin_username                = "mohithalve"

    keyvaultname       = "keyvault-preprod20078"
    keyvaultsecretname = "ramlkahan9689"

    vmname = "backend-vm"
  }
}


keyvault = {
  vm1 = {
    name                = "keyvault-preprod009"
    keyvaultsecretname  = "ramlkahan9967"
    location            = "centralindia"
    resource_group_name = "mango-preprod"
    value               = "Szechuan@12345"
  }
  vm2 = {
    name                = "keyvault-preprod20078"
    keyvaultsecretname  = "ramlkahan9689"
    location            = "centralindia"
    resource_group_name = "mango-preprod"
    value               = "Szechuan@12345"
  }

}
bastions = {
  bastion1 = {
    name                 = "mango-bastion"
    location             = "centralindia"
    resource_group_name  = "mango-preprod"
    virtual_network_name = "mango-vnet"
    subnet_name          = "AzureBastionSubnet"
    pip_name             = "bastion-pip"
  }
}


natgateways = {
  nat1 = {
    name                = "mango-nat"
    location            = "centralindia"
    resource_group_name = "mango-preprod"
    pip_name            = "nat-pip-mango"
    subnets = [
      { name = "frontend-subnet", vnet_name = "mango-vnet", resource_group_name = "mango-preprod" },
      { name = "backend-subnet", vnet_name = "mango-vnet", resource_group_name = "mango-preprod" }
    ]
  }

}
nsgs = {
  nsg1 = {
    name                       = "frontend-nsg"
    location                   = "centralindia"
    resource_group_name        = "mango-preprod"
    subnet_name                = "frontend-subnet"
    vnet_name                  = "mango-vnet"
    subnet_resource_group_name = "mango-preprod"
    rules = [
      {
        name                       = "AllowHTTP"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
  }
  nsg2 = {
    name                       = "backend-nsg"
    location                   = "centralindia"
    resource_group_name        = "mango-preprod"
    subnet_name                = "backend-subnet"
    vnet_name                  = "mango-vnet"
    subnet_resource_group_name = "mango-preprod"
    rules = [
      {
        name                       = "AllowApp"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "10.0.1.0/24"
        destination_address_prefix = "*"
      }
    ]
  }


}