# Overview 
Creates the following:
- Windows Server (OO Central)
- Ubuntu Server (Ansible + postgres)

## How to create
1. Install terraform.
2. Initialize terraform workspace  
`terraform init`
3. Login to the desired Azure subscription:  
`az login`
1. Command to create the demo:  
`terraform plan -out="tfplan.out" && terraform apply --auto-approve tfplan.out`
1. OO will be publicly available at:  
`https://<public_windows_ip>:8443`

## How to destroy
1. Command to destroy the demo:  
`terraform destroy --auto-approve`