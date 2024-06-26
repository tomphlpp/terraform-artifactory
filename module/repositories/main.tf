#--- repositories/main.tf ---#

terraform {
  required_providers {
    artifactory = {
      source  = "jfrog/artifactory"
    }
  }
}


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

resource "artifactory_local_docker_v1_repository" "docker_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "docker" }

  key             = each.value.key
  repo_layout_ref = each.value.repo_layout_ref
  description     = each.value.description
  notes           = each.value.notes
}

resource "artifactory_virtual_generic_repository" "virtual_generic_repos" {
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "generic" && contains(keys(artifactory_local_generic_repository.generic_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.suffix == "dev-local" ? "dev" : "prod"}")
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
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "helm" && contains(keys(artifactory_local_helm_repository.helm_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.suffix == "dev-local" ? "dev" : "prod"}")
  repositories               = concat(
    [each.value.key],
    lookup(local.remote_repos, "helm", [])
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
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "npm" && contains(keys(artifactory_local_npm_repository.npm_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.suffix == "dev-local" ? "dev" : "prod"}")
  repositories               = concat(
    [each.value.key],
    lookup(local.remote_repos, "npm", [])
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
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "nuget" && contains(keys(artifactory_local_nuget_repository.nuget_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.suffix == "dev-local" ? "dev" : "prod"}")
  repositories               = concat(
    [each.value.key],
    lookup(local.remote_repos, "nuget", [])
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
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "pypi" && contains(keys(artifactory_local_pypi_repository.pypi_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.suffix == "dev-local" ? "dev" : "prod"}")
  repositories               = concat(
    [each.value.key],
    lookup(local.remote_repos, "pypi", [])
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
  for_each = { for r in local.repo_definitions : r.key => r if r.package_type == "docker" && contains(keys(artifactory_local_docker_repository.docker_repos), r.key) }

  key                        = lower("${each.value.team}-${each.value.package_type}-${each.value.suffix == "dev-local" ? "dev" : "prod"}")
  repositories               = concat(
    [each.value.key],
    lookup(local.remote_repos, "docker", [])
  )
  default_deployment_repo    = lower(each.value.key)
  repo_layout_ref            = each.value.repo_layout_ref
  description                = each.value.description
  notes                      = each.value.notes
  depends_on = [
    artifactory_local_docker_repository.docker_repos
  ]
}
