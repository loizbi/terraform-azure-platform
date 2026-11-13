locals {
  common_tags = {
    Team        = var.team
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}