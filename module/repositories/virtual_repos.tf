#--- repositories/virtual_repos.tf

#this helper gets the remotes owned by the team to attach them to the virtual
locals {
  team_remote_repos = {
    for team in local.teams :
    team => [
      for repo in local.remote_repos :
      "${repo.team}-${repo.package_type}-remote"
      if repo.team == team
    ]
  }
}

# virtuals for dev
resource "artifactory_virtual_generic_repository" "virtual_repos_dev" {
  for_each = {
    for repo in local.local_repos :
    "${repo.team}-${repo.package_type}-${local.dev_suffix}" => repo
  }
  key                        = lower("${each.value.team}-${each.value.package_type}-dev")
  repositories               = concat(
    local.team_remote_repos[each.value.team],
    ["${each.value.team}-${each.value.package_type}-dev-local"]
  )
  default_deployment_repo    = lower("${each.value.team}-${each.value.package_type}-dev-local")
  repo_layout_ref            = each.value.repo_layout_ref
  description                = lookup(each.value, "description", null)
  notes                      = lookup(each.value, "notes", null)
  depends_on = [
    artifactory_local_generic_repository.local_repos_dev,
    artifactory_local_generic_repository.local_repos_prod
  ]
}

# virtuals for prod
resource "artifactory_virtual_generic_repository" "virtual_repos_prod" {
  for_each = {
    for repo in local.local_repos :
    "${repo.team}-${repo.package_type}-${local.prod_suffix}" => repo
  }
  key                        = lower("${each.value.team}-${each.value.package_type}-prod")
  repositories               = concat(
    local.team_remote_repos[each.value.team],
    ["${each.value.team}-${each.value.package_type}-prod-local"]
  )
  default_deployment_repo    = lower("${each.value.team}-${each.value.package_type}-prod-local")
  repo_layout_ref            = each.value.repo_layout_ref
  description                = lookup(each.value, "description", null)
  notes                      = lookup(each.value, "notes", null)
  depends_on = [
    artifactory_local_generic_repository.local_repos_dev,
    artifactory_local_generic_repository.local_repos_prod
  ]
}