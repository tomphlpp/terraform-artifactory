#--- repositories/local_repos.tf ---#

locals {
  dev_suffix  = "dev-local"
  prod_suffix = "prod-local"
}

# dev and prod
resource "artifactory_local_generic_repository" "local_repos_dev" {
  for_each = {
    for repo in local.local_repos :
    "${repo.team}-${repo.package_type}-${local.dev_suffix}" => repo
    if contains(local.repo_types, repo.package_type)
  }
  key             = "${each.value.team}-${each.value.package_type}-${local.dev_suffix}"
  repo_layout_ref = each.value.repo_layout_ref
  description     = lookup(each.value, "description", null)
  notes           = lookup(each.value, "notes", null)
}


resource "artifactory_local_generic_repository" "local_repos_prod" {
  for_each = {
    for repo in local.local_repos :
    "${repo.team}-${repo.package_type}-${local.prod_suffix}" => repo
    if contains(local.repo_types, repo.package_type)
  }
  key             = "${each.value.team}-${each.value.package_type}-${local.prod_suffix}"
  repo_layout_ref = each.value.repo_layout_ref
  description     = lookup(each.value, "description", null)
  notes           = lookup(each.value, "notes", null)
}
