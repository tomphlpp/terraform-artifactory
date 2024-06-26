#--- modules/repositories/locals.tf ---#

locals {
  suffixes = ["dev-local", "prod-local"]
  repos_config = yamldecode(file(var.path_to_repos_yaml))
  local_repos = local.repos_config.local_repos
  remote_repos = local.repos_config.remote_repos

  repo_definitions = flatten([
    for repo in local.local_repos : [
      for suffix in local.suffixes : {
        key             = "${repo.team}-${repo.package_type}-${suffix}"
        team            = repo.team
        package_type    = repo.package_type
        suffix          = suffix
        repo_layout_ref = repo.repo_layout_ref
        description     = lookup(repo, "description", null)
        notes           = lookup(repo, "notes", null)
      }
    ]
  ])
}
