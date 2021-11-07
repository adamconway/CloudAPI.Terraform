# Core Layer
module "core" {
  source = "../../modules/core"

  environment_name = "dev"
  region           = "australiaeast"
}

# Compute Layer
module "compute" {
  source = "../../modules/compute"

  environment_name = "dev"
  region           = "australiaeast"
}

# Data Layer
module "data" {
  source = "../../modules/data"

  environment_name = "dev"
  region           = "australiaeast"
}