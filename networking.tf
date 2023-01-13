# Create a resource group to maintain security settings along with network interfaces for VMs
resource "azurerm_resource_group" "ooDemo" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = { source = var.resources_tag }
}
# ASSIGN ADDRESS SPACE TO RESOURCE GROUP
resource "azurerm_virtual_network" "ooDemo_vnet" {
  name                = "${var.resources_prefix}-vnet"
  address_space       = ["${var.address_spaces}"]
  location            = azurerm_resource_group.ooDemo.location
  resource_group_name = azurerm_resource_group.ooDemo.name

  tags = { source = var.resources_tag }
}
# ASSIGN SUBNET TO NETWORK ADDRESS SPACE
resource "azurerm_subnet" "subnet1" {
  name                 = "${var.resources_prefix}-internal"
  resource_group_name  = azurerm_resource_group.ooDemo.name
  virtual_network_name = azurerm_virtual_network.ooDemo_vnet.name
  address_prefixes     = [var.subnets]
}
# Create public IP variable for Linux machine
resource "azurerm_public_ip" "linux_pip" {
  name                = "${var.resources_prefix}-${var.linux_server}-pip"
  resource_group_name = azurerm_resource_group.ooDemo.name
  location            = azurerm_resource_group.ooDemo.location
  allocation_method   = "Static"
}
# Create public IP variable for Windows machine
resource "azurerm_public_ip" "win_pip" {
  name                = "${var.resources_prefix}-${var.win_cental}-pip"
  resource_group_name = azurerm_resource_group.ooDemo.name
  location            = azurerm_resource_group.ooDemo.location
  allocation_method   = "Static"
}
# ASSIGN NETWORK INTERFACE PER VM WE WILL BE USING
resource "azurerm_network_interface" "linux_nic" {
  name                = "${var.resources_prefix}-${var.linux_server}-nic"
  location            = azurerm_resource_group.ooDemo.location
  resource_group_name = azurerm_resource_group.ooDemo.name

  tags = { source = var.resources_tag }

  ip_configuration {
    name                          = "${var.resources_prefix}-internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.linux_private_ip
    public_ip_address_id          = azurerm_public_ip.linux_pip.id
  }
}
resource "azurerm_network_interface" "win_nic" {
  name                = "${var.resources_prefix}-${var.win_cental}-nic"
  location            = azurerm_resource_group.ooDemo.location
  resource_group_name = azurerm_resource_group.ooDemo.name

  tags = { source = var.resources_tag }

  ip_configuration {
    name                          = "${var.resources_prefix}-internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.win_private_ip
    public_ip_address_id          = azurerm_public_ip.win_pip.id
  }
}

# CREATE SECURITY GROUPs TO ALLOW SSH/RDP/ANSIBLE FOR VMs
resource "azurerm_network_security_group" "linux_nsg" {
  name                = "${var.resources_prefix}-${var.linux_server}-nsg"
  location            = azurerm_resource_group.ooDemo.location
  resource_group_name = azurerm_resource_group.ooDemo.name

  tags = { source = var.resources_tag }

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "postgres"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "win_nsg" {
  name                = "${var.resources_prefix}-${var.win_cental}-nsg"
  location            = azurerm_resource_group.ooDemo.location
  resource_group_name = azurerm_resource_group.ooDemo.name

  tags = { source = var.resources_tag }

  security_rule {
    name                       = "RDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ANSIBLE"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "OO_8443"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
# ASSIGN SECURITY GROUPS TO INTERFACES
# LINUX SSH
resource "azurerm_network_interface_security_group_association" "linux" {
  network_interface_id      = azurerm_network_interface.linux_nic.id
  network_security_group_id = azurerm_network_security_group.linux_nsg.id
}
# WINSERV RDP
resource "azurerm_network_interface_security_group_association" "win" {
  network_interface_id      = azurerm_network_interface.win_nic.id
  network_security_group_id = azurerm_network_security_group.win_nsg.id
}

