#--- driver ---#

module "repositories" {
  source             = "../module/repositories"
  jfrog_url          = var.jfrog_url
  jfrog_access_token = var.jfrog_access_token
  path_to_repos_yaml = var.path_to_repos_yaml
}

# module "permissions" {
#   source             = "../module/permissions"
#   jfrog_url          = var.jfrog_url
#   jfrog_access_token = var.jfrog_access_token
#   path_to_repos_yaml = var.path_to_repos_yaml
#   env_prefix         = var.env_prefix
# }