#--- module/repositories/main.tf ---#

terraform {
  required_providers {
    artifactory = {
      source = "jfrog/artifactory"
    }
  }
}

# these resource blocks use a for_each to iterate over "repo_definitions" a list of maps, and 
# uses map comprehension to create key value pairs according to the conditional,
# which makes this module a into flat loops. for example: 

# locals {
#   items = [
#     { key = "item1", type = "docker" },
#     { key = "item2", type = "generic" },
#     { key = "item3", type = "docker" },
#   ]

#   docker_items = {
#     for item in local.items : 
#     item.key => item 
#     if item.type == "docker"
#   }
# }


resource "artifactory_local_generic_repository" "generic_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "generic" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_local_helm_repository" "helm_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "helm" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_local_npm_repository" "npm_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "npm" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_local_nuget_repository" "nuget_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "nuget" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_local_pypi_repository" "pypi_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "pypi" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_local_docker_v2_repository" "docker_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "docker" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_virtual_generic_repository" "virtual_generic_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "generic" && contains(keys(artifactory_local_generic_repository.generic_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.env}")
  repositories               = concat(
    [each.value.key],
    lookup(local.remote_repos, "generic", [])
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_generic_repository.generic_repos
  ]
}

resource "artifactory_virtual_helm_repository" "virtual_helm_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "helm" }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.env}")
  repositories               = concat(
    [each.value.key],
    local.remote_repos.helm
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_helm_repository.helm_repos
  ]
}

resource "artifactory_virtual_npm_repository" "virtual_npm_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "npm" }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.env}")
  repositories               = concat(
    [each.value.key],
    local.remote_repos.npm
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_npm_repository.npm_repos
  ]
}

resource "artifactory_virtual_nuget_repository" "virtual_nuget_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "nuget" }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.env}")
  repositories               = concat(
    [each.value.key],
    local.remote_repos.nuget
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_nuget_repository.nuget_repos
  ]
}

resource "artifactory_virtual_pypi_repository" "virtual_pypi_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "pypi" }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.env}")
  repositories               = concat(
    [each.value.key],
    local.remote_repos.pypi
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_pypi_repository.pypi_repos
  ]
}

resource "artifactory_virtual_docker_repository" "virtual_docker_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "docker" && contains(keys(artifactory_local_docker_v2_repository.docker_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.env}")
  repositories               = concat(
    [each.value.key],
    each.value.remote_urls
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_docker_v2_repository.docker_repos
  ]
}
