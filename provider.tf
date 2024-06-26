#--- driver/provider.tf ---#

terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "10.5.1"
    }
     external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}

provider "artifactory" {
  url          = var.jfrog_url
  access_token = var.jfrog_access_token
}
