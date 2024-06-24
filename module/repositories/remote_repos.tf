#--- repositories/remote_repositories.tf ---#


# Create remote repositories
resource "artifactory_remote_docker_repository" "remote_docker" {
  for_each = {
    for repo in local.remote_repos :
    "${repo.team}-${repo.package_type}-remote" => repo
    if repo.package_type == "docker"
  }
  key             = "${each.value.team}-${each.value.package_type}-remote"
  repo_layout_ref = each.value.repo_layout_ref
  url             = each.value.url
  username        = lookup(each.value, "username", null)
  password        = lookup(each.value, "password", null)
  description     = lookup(each.value, "description", null)
  notes           = lookup(each.value, "notes", null)
}

# add some more here for remote npm, helm, etc.
