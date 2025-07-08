module "regions" {
  source  = "Azure/regions/azurerm"
  version = "0.8.2"
}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.4"
}

locals {
  deployment_region = "japaneast" #pinning on single region
  tags = {
    scenario = "Default"
  }
}

resource "random_integer" "region_index" {
  max = length(module.regions.regions_by_name) - 1
  min = 0
}

resource "random_integer" "zone_index" {
  max = length(module.regions.regions_by_name[local.deployment_region].zones)
  min = 1
}

resource "azurerm_resource_group" "this_rg" {
  location = local.deployment_region
  name     = module.naming.resource_group.name_unique
  tags     = local.tags
}

module "vm_sku" {
  source  = "Azure/avm-utl-sku-finder/azapi"
  version = "0.3.0"

  location      = azurerm_resource_group.this_rg.location
  cache_results = true
  vm_filters = {
    min_vcpus                      = 2
    max_vcpus                      = 2
    encryption_at_host_supported   = true
    accelerated_networking_enabled = true
    premium_io_supported           = true
    location_zone                  = random_integer.zone_index.result
  }

  depends_on = [random_integer.zone_index]
}

module "natgateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"
  version = "0.2.1"

  location            = azurerm_resource_group.this_rg.location
  name                = module.naming.nat_gateway.name_unique
  resource_group_name = azurerm_resource_group.this_rg.name
  enable_telemetry    = false
  public_ips = {
    public_ip_1 = {
      name = "nat_gw_pip1"
    }
  }
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "=0.8.1"

  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this_rg.location
  resource_group_name = azurerm_resource_group.this_rg.name
  name                = module.naming.virtual_network.name_unique
  subnets = {
    vm_subnet_1 = {
      name             = "${module.naming.subnet.name_unique}-1"
      address_prefixes = ["10.0.1.0/24"]
      nat_gateway = {
        id = module.natgateway.resource_id
      }
    }
    vm_subnet_2 = {
      name             = "${module.naming.subnet.name_unique}-2"
      address_prefixes = ["10.0.2.0/24"]
      nat_gateway = {
        id = module.natgateway.resource_id
      }
    }
    AzureBastionSubnet = {
      name             = "AzureBastionSubnet"
      address_prefixes = ["10.0.3.0/24"]
    }
  }
}

data "azurerm_client_config" "current" {}

module "jfsvm" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.19.3"

  location = azurerm_resource_group.this_rg.location
  name     = module.naming.virtual_machine.name_unique
  network_interfaces = {
    network_interface_1 = {
      name = module.naming.network_interface.name_unique
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${module.naming.network_interface.name_unique}-ipconfig1"
          private_ip_subnet_resource_id = module.vnet.subnets["vm_subnet_1"].resource_id
          create_public_ip_address      = true
          public_ip_address_name        = "jfsvm-publicip1"
        }
      }
    }
  }
  resource_group_name        = azurerm_resource_group.this_rg.name
  zone                       = random_integer.zone_index.result
  enable_telemetry           = var.enable_telemetry
  os_type                    = "Linux"
  sku_size                   = module.vm_sku.sku
  encryption_at_host_enabled = false

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  tags = local.tags
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = module.naming.network_security_group.name_unique
  location            = azurerm_resource_group.this_rg.location
  resource_group_name = azurerm_resource_group.this_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_network_interface_security_group_association" "vm_nsg_association" {
  network_interface_id      = module.jfsvm.network_interfaces["network_interface_1"].id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

module "redis" {
  source  = "cloudnationhq/redis/azure"
  version = "~> 3.0"
  count   = 1

  cache = {
    name                = "redis-terraform-jfs"
    resource_group_name = azurerm_resource_group.this_rg.name
    location            = local.deployment_region
    sku_name            = "Premium"
    capacity            = 1
    family              = "P"
    subnet_id           = module.vnet.subnets.vm_subnet_1.resource_id
    zones               = [random_integer.zone_index.result]

    firewall_rules = {
      rule1 = {
        name     = "redis_rule1"
        start_ip = "10.0.0.0"
        end_ip   = "10.0.255.255"
      }
    }
  }
}
