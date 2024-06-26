#--- driver ---#

module "repositories" {
  source             = "./module/repositories"
  path_to_repos_yaml = var.path_to_repos_yaml

  providers = {
    artifactory = artifactory
  }
}

