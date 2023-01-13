variable "win_vm_os_publisher" {}
variable "win_vm_os_offer" {}
variable "win_vm_os_sku" {}
variable "win_vm_size" {}
variable "win_license" {}
variable "win_sa_type" {}
variable "win_cental" {}
variable "win_allocation_method" {}
variable "win_public_ip_sku" {}
variable "win_private_ip" {}

variable "linux_server" {}
variable "linux_vm_os_publisher" {}
variable "linux_vm_os_offer" {}
variable "linux_vm_os_sku" {}
variable "linux_vm_size" {}
variable "linux_ssh_key" {}
variable "linux_sa_type" {}
variable "linux_ssh_key_pv" {}
variable "linux_private_ip" {}

variable "username" {}
variable "password" {}

variable "address_spaces" {}
variable "subnets" {}

variable "resource_group_name" {}
variable "resource_group_location" {}
variable "resources_prefix" {}
variable "resources_tag" {}


locals {
  first_logon_commands = file("${path.module}/winfiles/FirstLogonCommands.xml")
  auto_logon           = "<AutoLogon><Password><Value>${var.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.username}</Username></AutoLogon>"
}
