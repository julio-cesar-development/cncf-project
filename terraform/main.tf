terraform {
  required_version = "~> 0.12.0"

  # TODO: activate backend
  # backend "s3" {
  #   bucket = "blackdevs-aws"
  #   key    = "terraform/cncf-project/state.tfstate"
  #   region = "sa-east-1"
  # }
}

