
variable "name_prefix" {
  description = "The value is a prefix for the name of the resources created."
  type        = string

  validation {
    condition     = length(var.name_prefix) > 0
    error_message = "The name_prefix value must be a non-empty string."
  }
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
  type = map(object({
    environments = map(object({
      name_prefix           = string
      client_id             = optional(string)
      subscription_id       = optional(string)
      resource_group_name   = optional(string)
      managed_identity_name = optional(string)
      tags                  = optional(map(string))
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
  description = "Map of repositories and their respective environments for which to create secrets and configure permissions."
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

variable "owners" {
  description = "List of object IDs of the application owners."
  type        = list(string)
  default     = null
}

variable "override_subject_template_path" {
  description = "set this to override the default subject template for the workload identity subject."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Defines the Azure identity type to be utilized when creating new resources. Choose 'userAssignedIdentity' to create a user managed identity or 'azureAdApplication' to create an Azure Active Directory application."
  type        = string
  default     = "userAssignedIdentity"
  validation {
    condition     = var.identity_type == "userAssignedIdentity" || var.identity_type == "azureAdApplication"
    error_message = "The identity_type value must be either 'azureAdApplication' (for creating Active Directory applications) or 'userAssignedIdentity' (for creating user managed identities)."
  }
}
