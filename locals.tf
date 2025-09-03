locals {
  environment = "dev"
  project     = var.project_name
  
    tags = {
       project     = local.project
       environment = local.environment
    }
}