locals {
  name_prefix = var.project_prefix

  common_tags = {
    Project     = "RSU-IaC-Security"
    Environment = "Research"
    Owner       = "Athul"
    ManagedBy   = "Terraform"
    Thesis      = "IaC Security Framework for RSUs"
  }
}
