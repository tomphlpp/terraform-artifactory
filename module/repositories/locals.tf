#--- module/repositories/locals.tf ---#


locals {
  repos_config = yamldecode(file(var.path_to_repos_yaml))
  local_repos = local.repos_config.local_repos
  remote_repos = {
    helm  = local.repos_config.remote_repos.helm
    npm   = local.repos_config.remote_repos.npm
    pypi  = local.repos_config.remote_repos.pypi
    nuget = local.repos_config.remote_repos.nuget
  }

  repo_definitions = [
    for repo in local.local_repos : {
      key             = "${repo.team}-${repo.package_type}-${repo.env}-local"
      team            = repo.team
      package_type    = repo.package_type
      env             = repo.env
      repo_layout_ref = repo.repo_layout_ref
      description     = repo.description
      notes           = repo.notes
      remote_urls     = lookup(repo, "remote_urls", [])
    }
  ]
}