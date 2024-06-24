#--- repositories/locals.tf ---#

locals {
  repositories = yamldecode(file(var.path_to_repos_yaml)).repositories
  local_repos  = { for repo in local.repositories : "${repo.team}-${repo.package_type}-local" => repo if repo.repo_type == "local" }
  remote_repos = { for repo in local.repositories : "${repo.team}-${repo.package_type}-remote" => repo if repo.repo_type == "remote" }
  teams        = distinct([for repo in local.repositories : repo.team])
  repo_types   = ["docker", "maven", "helm", "generic", "npm", "nuget", "pypi"]
}



output "repositories_debug" {
  value = local.repositories
}
