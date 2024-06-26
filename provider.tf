#--- driver/provider.tf ---#

terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "2.6.15"
    }
  }
}

provider "artifactory" {
  url          = var.jfrog_url
  access_token = var.jfrog_access_token
}
