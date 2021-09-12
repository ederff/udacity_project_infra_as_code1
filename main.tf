provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "main" {
    name = "${var.prefix}-rg"
    location = var.location
}


resource "azurerm_virtual_network" "main" {
    name = "${var.prefix}-network"
    address_space = ["10.0.1.0/24"]
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    tags = var.tags
}

resource "azurerm_subnet" "main" {
    name = "internal"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name = "${var.prefix}-nsg"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = var.tags

  security_rule {
      name = "allow_subnet_access"
      description = "Allow connectivity to others VMs on the subnet"
      protocol = "*"
      source_port_range = "*"
      destination_port_range = "*"
      source_address_prefixes = azurerm_subnet.main.address_prefixes
      destination_address_prefixes = azurerm_subnet.main.address_prefixes
      access = "Allow"
      priority = 100
      direction = "Inbound"
  }
  security_rule {
      name = "deny_all_other_access"
      protocol = "*"
      source_port_range = "*"
      destination_port_range = "*"
      source_address_prefix = "*"
      destination_address_prefixes = azurerm_subnet.main.address_prefixes
      access = "Deny"
      priority = 110
      direction = "Inbound"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-publicIP"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  tags = var.tags
}

resource "azurerm_network_interface" "main" {
  count = var.number_of_vms
  name                = "${var.prefix}-nic-${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb" "main" {
  name                = "AppLoadBalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.main.id
  }
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "BackEndAddressPool"
}


resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count = var.number_of_vms
  network_interface_id    = element(azurerm_network_interface.main.*.id, count.index)
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                = "app-aset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "main" {
  count = var.number_of_vms
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  availability_set_id = azurerm_availability_set.main.id
  admin_username                  = "${var.admin_user}"
  admin_password                  = "${var.admin_password}"
  disable_password_authentication = false
  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]


  source_image_id = var.source_image_id

  os_disk {
    name = "${var.prefix}-osdisk-${count.index}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
  tags = var.tags
}