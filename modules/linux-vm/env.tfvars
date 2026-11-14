
# Environment-specific variables
location    = "eastus"
environment = "dev"
domain      = "loizbi-example.com"
domain_rg   = "admin-ssh-keys"

# Resource-specific variables
project = "docker-swarm"

vnet_rg     = "vms-example-01-dev-eastus-rg"
vnet_name   = "vms-example-01-dev-eastus-vnet"
subnet_name = "vms-example-01-dev-eastus-subnet"

vm_type             = "Standard_F1als_v7"
vm_name             = "swarm-vm"
ssh_public_key_name = "win_laptop_ed25519"
ssh_public_key_rg   = "admin-ssh-keys"
vm_username         = "the_admin"
vm_count            = 2

vm_allowed_ips = ["1.1.1.1/32"]
