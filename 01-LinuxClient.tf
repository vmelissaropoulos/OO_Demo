resource "tls_private_key" "postgres_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# This pulls a Ubuntu Datacenter from Microsoft's VM platform directly
resource "azurerm_linux_virtual_machine" "linux" {
  name                            = "${var.resources_prefix}-${var.linux_server}"
  resource_group_name             = azurerm_resource_group.ooDemo.name
  location                        = azurerm_resource_group.ooDemo.location
  size                            = var.linux_vm_size
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false

  tags = { source = var.resources_tag }

  network_interface_ids = [
    azurerm_network_interface.linux_nic.id
  ]

  admin_ssh_key {
    username   = var.username
    public_key = tls_private_key.postgres_ssh.public_key_openssh
  }

  # Cloud-Init passed here
  # custom_data = data.template_cloudinit_config.config.rendered

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.linux_sa_type
  }

  source_image_reference {
    publisher = var.linux_vm_os_publisher
    offer     = var.linux_vm_os_offer
    sku       = var.linux_vm_os_sku
    version   = "latest"
  }

  depends_on = [azurerm_resource_group.ooDemo, azurerm_network_interface.linux_nic, azurerm_windows_virtual_machine.win]
}

# Create cloud-init file to be passed into linux vm
# data "template_file" "user_data" {
#   template = file("./cloudinit/custom.yml")
# }

# Render a multi-part cloud-init config making use of the part
# above, and other source files
# data "template_cloudinit_config" "config" {
#   gzip          = true
#   base64_encode = true

#   # Main cloud-config configuration file.
#   part {
#     filename     = "init.cfg"
#     content_type = "text/cloud-config"
#     content      = data.template_file.user_data.rendered
#   }
# }


# Pass Ansible File into created Linux VM using SCP (SSH Port 22)
# resource "null_resource" "copyansible" {
#   connection {
#     type     = "ssh"
#     host     = azurerm_public_ip.linux_pip.ip_address
#     user     = var.username
#     password = var.password
#     # private_key = var.linux_ssh_key_pv
#     private_key = tls_private_key.postgres_ssh.private_key_openssh
#     # private_key = file("${var.linux_ssh_key_pv}")
#   }

#   provisioner "file" {
#     source      = "${path.module}/Ansible"
#     destination = "/tmp/"
#   }

#   depends_on = [azurerm_linux_virtual_machine.linux]
# }

resource "null_resource" "installansible" {
  connection {
    type     = "ssh"
    host     = azurerm_public_ip.linux_pip.ip_address
    user     = var.username
    password = var.password
    # private_key = var.linux_ssh_key_pv
    private_key = tls_private_key.postgres_ssh.private_key_openssh
    # private_key = file("${var.linux_ssh_key_pv}")
  }

  provisioner "file" {
    source      = "${path.module}/Ansible"
    destination = "/tmp/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install python-pip -y",
      "pip install ansible",
      "/home/ooadmin/.local/bin/ansible-galaxy install azure.azure_preview_modules",
      "pip install -r ~/.ansible/roles/azure.azure_preview_modules/files/requirements-azure.txt",
      "pip install 'pywinrm>=0.2.2'",
      # "sudo chmod 777 /home/ooadmin/.ansible -R",
      "cd /tmp/Ansible",
      "/home/ooadmin/.local/bin/ansible-playbook /tmp/Ansible/postgres.yml",
      "/home/ooadmin/.local/bin/ansible-playbook /tmp/Ansible/oo.yml"
    ]
  }
  depends_on = [azurerm_linux_virtual_machine.linux]
}