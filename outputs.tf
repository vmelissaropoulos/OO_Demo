output "Public_IP_Linux" {
    value = azurerm_public_ip.linux_pip.ip_address
}
output "Public_IP_Windows" {
    value = azurerm_public_ip.win_pip.ip_address
}
output "Private_IP_Linux" {
    value = azurerm_linux_virtual_machine.linux.private_ip_address
}

output "Private_IP_Windows" {
    value = azurerm_windows_virtual_machine.win.private_ip_address
}