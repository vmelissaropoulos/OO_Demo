# This pulls the latest Windows Server Datacenter from Microsoft's VM platform directly
resource "azurerm_windows_virtual_machine" "win" {
  name                = "${var.resources_prefix}-${var.win_cental}"
  resource_group_name = azurerm_resource_group.ooDemo.name
  location            = azurerm_resource_group.ooDemo.location
  size                = var.win_vm_size
  admin_username      = var.username
  admin_password      = var.password

  tags = { source = var.resources_tag }

  network_interface_ids = [
    azurerm_network_interface.win_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.win_sa_type
  }

  source_image_reference {
    publisher = var.win_vm_os_publisher
    offer     = var.win_vm_os_offer
    sku       = var.win_vm_os_sku
    version   = "latest"
  }

  additional_unattend_content {
    content = local.auto_logon
    setting = "AutoLogon"
  }

  additional_unattend_content {
    content = local.first_logon_commands
    setting = "FirstLogonCommands"
  }

  depends_on = [azurerm_resource_group.ooDemo, azurerm_network_interface.win_nic]
}


resource "null_resource" "copy_winfiles" {
  connection {
    type     = "winrm"
    host     = azurerm_public_ip.win_pip.ip_address
    user     = var.username
    password = var.password
    # private_key = var.linux_ssh_key_pv
    # private_key = tls_private_key.postgres_ssh.private_key_openssh
    # private_key = file("${var.linux_ssh_key_pv}")
  }

  provisioner "file" {
    source      = "${path.module}/winfiles"
    destination = "C:\\Temp\\"
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
      # TODO: 
      # TODO: Install VC Redist too (ansible maybe? see: https://topic.alibabacloud.com/a/ansible-remote-installation-in-windows-server-r2-vcredist-2008-2010-font-colorred2012font-2013_1_15_30854065.html)
      # TODO: download, extract and install OO (Ansible: ansible.windows.win_shell)
      # TODO: copy bookmarks to C:\Users\ooadmin\AppData\Local\Microsoft\Edge\User Data\Default
    ]
  }
  depends_on = [azurerm_windows_virtual_machine.win]
}

