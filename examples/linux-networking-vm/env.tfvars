
# Common variables
location    = "eastus"
team        = "devops"
environment = "dev"
project     = "example-01"

# Networking module
vnet_address_space    = "10.0.0.0/16"
subnet_address_prefix = "10.0.1.0/24"

# Linux vm module
domain    = "loizbi-example.com"
domain_rg = "admin-ssh-keys"

#vnet_rg     = "vms-example-01-dev-eastus-rg"
#vnet_name   = "vms-example-01-dev-eastus-vnet"
#subnet_name = "vms-example-01-dev-eastus-subnet"

image_reference = [
  "Canonical",
  "ubuntu-24_04-lts",
  "server",
  "latest"
]

vm_type             = "Standard_D2als_v6"
vm_name             = "swarm-vm"
ssh_public_key_name = "win_laptop_ed25519"
ssh_public_key_rg   = "admin-ssh-keys"
vm_username         = "the_admin"
vm_count            = 2

vm_allowed_ips = ["0.0.0.0/0"]
