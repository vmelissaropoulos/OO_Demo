# Azure Resources
resource_group_name     = "ooDemo"
resource_group_location = "westeurope"
resources_prefix        = "OO"
resources_tag           = "ooDemo"

# Azure Windows Server related params
win_vm_os_publisher   = "MicrosoftWindowsServer"
win_vm_os_offer       = "WindowsServer"
win_vm_os_sku         = "2022-Datacenter"
win_vm_size           = "Standard_B4ms"
win_license           = "Windows_Server"
win_allocation_method = "Static"
win_public_ip_sku     = "Standard"
win_sa_type           = "Standard_LRS"

# Azure Linux Server related params
linux_vm_os_publisher = "Canonical"
linux_vm_os_offer     = "UbuntuServer"
linux_vm_os_sku       = "18.04-LTS"
linux_vm_size         = "Standard_B2s"
linux_sa_type         = "Premium_LRS"
linux_ssh_key         = "https://pt-demos-kv.vault.azure.net/secrets/PT-Demos-cert/ab1abd68e9f2444b8eb2aa08bef94134"
linux_ssh_key_pv      = "https://pt-demos-kv.vault.azure.net/secrets/PT-Demos-cert/ab1abd68e9f2444b8eb2aa08bef94134"

# Which Windows administrator password to set during vm customization
username = "ooadmin"
password = "n2!U6ABvy*VYJ" # Allowed: [a-z][A-Z][0-9][@*!-]

# Naming Schemes 
win_cental   = "centralSRV"
linux_server = "postgreSRV"

# Networking Variables
win_private_ip   = "10.0.0.10"
linux_private_ip = "10.0.0.9"
address_spaces   = "10.0.0.0/16"
subnets          = "10.0.0.0/24"
