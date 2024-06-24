# #--- repositories/main.tf ---#

# terraform {
#   required_providers {
#     artifactory = {
#       source  = "jfrog/artifactory"
#       version = "10.5.1"
#     }

#     external = {
#       source  = "hashicorp/external"
#       version = "~> 2.0"
#     }
#   }
# }

# provider "artifactory" {
#   url          = var.jfrog_url
#   access_token = var.jfrog_access_token
# }

# locals {
#   repositories = yamldecode(file(var.path_to_repos_yaml)).repositories
#   local_repos  = { for repo in local.repositories : "${repo.team}-${repo.package_type}-local" => repo if repo.repo_type == "local" }
#   remote_repos = { for repo in local.repositories : "${repo.team}-${repo.package_type}-remote" => repo if repo.repo_type == "remote" }
#   teams        = distinct([for repo in local.repositories : repo.team])
# }

# output "repositories_debug" {
#   value = local.repositories
# }

# # Helper locals for types of repos
# locals {
#   repo_types = ["docker", "maven", "helm", "generic", "npm", "nuget", "pypi"]
# }

# # create locals
# resource "artifactory_local_generic_repository" "local_repos_dev" {
#   for_each = {
#     for repo in local.local_repos :
#     "${repo.team}-${repo.package_type}-dev-local" => repo
#     if contains(local.repo_types, repo.package_type)
#   }
#   key             = "${each.value.team}-${each.value.package_type}-dev-local"
#   repo_layout_ref = each.value.repo_layout_ref
#   description     = lookup(each.value, "description", null)
#   notes           = lookup(each.value, "notes", null)
# }

# # repos for prod
# resource "artifactory_local_generic_repository" "local_repos_prod" {
#   for_each = {
#     for repo in local.local_repos :
#     "${repo.team}-${repo.package_type}-prod-local" => repo
#     if contains(local.repo_types, repo.package_type)
#   }
#   key             = "${each.value.team}-${each.value.package_type}-prod-local"
#   repo_layout_ref = each.value.repo_layout_ref
#   description     = lookup(each.value, "description", null)
#   notes           = lookup(each.value, "notes", null)
# }

# # Create virtual repositories for dev
# resource "artifactory_virtual_generic_repository" "virtual_repos_dev" {
#   for_each = {
#     for repo in local.local_repos :
#     "${repo.team}-${repo.package_type}-dev" => repo
#     if contains(local.repo_types, repo.package_type)
#   }
#   key             = "${each.value.team}-${each.value.package_type}-dev"
#   repositories    = flatten(concat(
#     [["${each.value.team}-${each.value.package_type}-dev-local"]],
#     [
#       for remote_repo in local.remote_repos :
#       ["${remote_repo.team}-docker-${remote_repo.site}-remote"]
#       if remote_repo.package_type == each.value.package_type
#     ]
#   ))
#   repo_layout_ref = each.value.repo_layout_ref
#   description     = lookup(each.value, "description", null)
#   notes           = lookup(each.value, "notes", null)
# }





# resource "artifactory_virtual_generic_repository" "virtual_repos_prod" {
#   for_each = {
#     for repo in local.local_repos :
#     "${repo.team}-${repo.package_type}-prod" => repo
#     if contains(local.repo_types, repo.package_type)
#   }
#   key             = "${each.value.team}-${each.value.package_type}-prod"
#   repositories    = flatten(concat(
#     [["${each.value.team}-${each.value.package_type}-prod-local"]],
#     [
#       for remote_repo in local.remote_repos :
#       ["${remote_repo.team}-docker-${remote_repo.site}-remote"]
#       if remote_repo.package_type == each.value.package_type
#     ]
#   ))
#   repo_layout_ref = each.value.repo_layout_ref
#   description     = lookup(each.value, "description", null)
#   notes           = lookup(each.value, "notes", null)

# }
# # create remotes
# # resource "artifactory_remote_docker_repository" "remote_docker" {
# #   for_each = {
# #     for repo in local.remote_repos :
# #     "${repo.team}-docker-${repo.site}-remote" => repo
# #     if repo.package_type == "docker"
# #   }
# #   key             = "${each.value.team}-docker-${each.value.site}-remote"
# #   repo_layout_ref = each.value.repo_layout_ref
# #   url             = each.value.url
# #   username        = lookup(each.value, "username", null)
# #   password        = lookup(each.value, "password", null)
# #   description     = lookup(each.value, "description", null)
# #   notes           = lookup(each.value, "notes", null)
# # }


# ### repeat this pattern for helm, maven, npm, nuget?