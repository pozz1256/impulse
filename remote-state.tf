terraform {
  required_version = "= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
# will need in future
#  backend "s3" {
#    bucket  = "warp-terraform-remote-state"
#    key     = "stack/-/terraform.tfstate"
#    region  = "us-west-2"
#    acl     = "private"
#    encrypt = true
#  }
}

provider "aws" {
  region = "us-west-2"
}
provider "aws" {
  alias  = "acm_provider"
  region = "us-west-2"
}
