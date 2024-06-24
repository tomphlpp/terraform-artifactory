#--- permissions/main.tf ---#

terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
      version = "10.5.1"
    }
    platform = {
      source  = "jfrog/platform"
      version = "1.6.0"
    }
  }
}

provider "artifactory" {
  url          = var.jfrog_url
  access_token = var.jfrog_access_token
}

provider "platform" {
  url          = var.jfrog_url
  access_token = var.jfrog_access_token
}

data "local_file" "repos" {
  filename = var.path_to_repos_yaml
}

locals {
  repos_yaml  = yamldecode(data.local_file.repos.content)
  repos = local.repos_yaml.repositories
  teams       = local.repos_yaml.teams
  env_prefix = ["dv", "pd"]
}

resource "platform_permission" "repo_permissions" {
  for_each = toset(local.teams)

  name = "${each.value}-${var.env_prefix}-users"

  artifact = {
    actions = {
      groups = [
        {
          name = "artifactory_${each.value}_users"
          permissions = ["READ", "ANNOTATE", "WRITE", "DELETE"]
        }
      ]
    }

    targets = flatten([
      for repo in local.repos:
      {
        name = "${repo.team}-${repo.package_type}-${each.value}-local"
        include_patterns = ["**/*"]
      } if repo.team == each.value
    ])
  }
}
