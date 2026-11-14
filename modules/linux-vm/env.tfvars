
# Environment-specific variables
location    = "eastus"
team        = "devops"
environment = "dev"
domain      = "loizbi-example.com"
domain_rg   = "admin-ssh-keys"

# Resource-specific variables
project = "docker-swarm"

vnet_rg     = "vms-example-01-dev-eastus-rg"
vnet_name   = "vms-example-01-dev-eastus-vnet"
subnet_name = "vms-example-01-dev-eastus-subnet"

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
