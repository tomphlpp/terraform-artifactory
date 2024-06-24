#--- permissions/variables.tf ---#

variable "jfrog_url" {
  description = "URL of the Artifactory instance"
  type        = string
}

variable "jfrog_access_token" {
  description = "Access token for Artifactory"
  type        = string
  sensitive   = true
}

variable "path_to_repos_yaml" {
  description = "path to the list"
  type        = string
  sensitive   = true
}

variable "env_prefix" {
  description = "List of environment prefixes"
  type        = list(string)
}
