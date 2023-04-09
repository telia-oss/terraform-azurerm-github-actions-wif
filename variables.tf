
variable "name_prefix" {
  description = "The value is a prefix for the name of the resources created."
  type        = string

  validation {
    condition     = length(var.name_prefix) > 0
    error_message = "The name_prefix value must be a non-empty string."
  }
}

variable "location" {
  type        = string
  default     = "swedencentral"
  description = "value is the location/region where the resources in the module should be created."
}

variable "github_issuer_url" {
  type        = string
  default     = "https://token.actions.githubusercontent.com"
  description = "value is the issuer URL for the GitHub OIDC provider."

}

variable "environment" {
  type        = string
  description = "value is the environment for the resources created."
}

variable "repositories" {
  type = list(object({
    repository_name = string
    environments = list(object({
      environment     = string
      name_prefix     = string
      application_id  = optional(string)
      subscription_id = optional(string)
      tags            = optional(map(string))
      roles = optional(map(object({
        scopes = set(string)
      })))
      inline_roles = optional(map(object({
        name              = string
        assignable        = bool
        scope             = string
        assignable_scopes = optional(set(string))
        permissions = object({
          actions     = list(string)
          not_actions = list(string)
        })
      })))
    }))
  }))
  description = "List of repositories and their respective environments for which to create secrets and configure permissions."
}

variable "audience_name" {
  type        = string
  default     = "api://AzureADTokenExchange"
  description = "The value is the audience name for the GitHub OIDC provider."
}

variable "user_defined_tags" {
  description = "The value is a map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "The value is a map of default tags to assign to the resource."
  type        = map(string)
  default = {
    "CreatedBy" = "Terraform"
  }
}

variable "roles" {
  description = "Built-in roles and scopes for the Service Principal"
  type        = map(list(string))
  default     = {}
}

variable "custom_roles" {
  description = "Custom roles and scopes for the Service Principal"
  type        = map(object({ scopes = list(string), description = string }))
  default     = {}
}

variable "owners" {
  description = "List of object IDs of the application owners."
  type        = list(string)
  default     = null
}
