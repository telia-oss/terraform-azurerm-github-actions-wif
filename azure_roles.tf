# The roles.tf file for the terraform-azure-github-actions-wif module
#
# This file contains resources for managing role assignments in Azure,
# including both standard and inline role assignments for the configured repositories and environments.
#


locals {

  # Flatten the environments into a single list
  repo_environments = flatten([
    for repo in var.repositories : [
      for environment in repo.environments : {
        repository_name = repo.repository_name
        application_id  = environment.application_id
        name_prefix     = environment.name_prefix
        environment     = environment.environment
        tags            = lookup(environment, "tags", {})
        roles           = lookup(environment, "roles", {})
        inline_roles    = lookup(environment, "inline_roles", [])
      }
    ]
  ])

  # Flatten the inline roles into a single list
  inline_roles = flatten([
    for env in local.repo_environments : [
      for role_name, role in env.inline_roles : {
        repository_name   = env.repository_name
        application_id    = env.application_id
        role_name         = role_name
        name_prefix       = env.name_prefix
        environment       = env.environment
        assignable        = role.assignable
        permissions       = role.permissions
        scope             = try(role.scope, "/subscriptions/${data.azurerm_subscription.current.subscription_id}")
        assignable_scopes = try(role.assignable_scopes, null)
      }
    ] if env.inline_roles != null ? length(env.inline_roles) > 0 : false
  ])

  # Flatten the standard roles into a single list
  standard_roles = flatten([
    for env in local.repo_environments : [
      for role_name, role in env.roles : [
        for scope in lookup(role, "scopes", []) : {
          repository_name    = env.repository_name
          name_prefix        = env.name_prefix
          application_id     = env.application_id
          environment        = env.environment
          role_name          = role_name
          role_definition_id = null
          scope              = scope
        }
      ]
    ] if env.roles != null ? length(env.roles) > 0 : false
  ])
}

# Lookup the service principal for the application
data "azuread_service_principal" "lookup" {
  for_each = {
    for env in local.repo_environments : "${env.repository_name}-${env.environment}" => env
  }
  application_id = try(azuread_application.github_oidc[each.value.environment].application_id, data.azuread_application.existing[each.value.environment].application_id)
}

# Standard roles
resource "azurerm_role_assignment" "standard_role_assignment" {
  for_each = {
    for role_assignment in local.standard_roles :

    "${role_assignment.repository_name}-${role_assignment.application_id}-${role_assignment.role_name}-${role_assignment.scope}" => role_assignment
  }
  principal_id         = data.azuread_service_principal.lookup["${each.value.repository_name}-${each.value.environment}"].object_id
  scope                = each.value.scope
  role_definition_name = each.value.role_name
}

output "inline_roles" {

  value = local.inline_roles

}

# Inline roles
resource "azurerm_role_assignment" "inline_role_assignment" {
  for_each = {
    for role_assignment in local.inline_roles :
    "${role_assignment.repository_name}-${role_assignment.application_id}-${role_assignment.role_name}-${role_assignment.environment}" => role_assignment
  }

  principal_id = data.azuread_service_principal.lookup["${each.value.repository_name}-${each.value.application_id}-${each.value.environment}"].object_id
  scope        = each.value.scope

  role_definition_name = azurerm_role_definition.inline_role_definition["${each.value.repository_name}-${each.value.application_id}-${each.value.role_name}"].name
}

# Inline role definitions
resource "azurerm_role_definition" "inline_role_definition" {
  for_each = {
    for role in local.inline_roles :
    "${role.repository_name}-${role.application_id}-${role.role_name}-${role.environment}" => role
  }

  name              = each.value.role_name
  description       = "Custom role definition for ${each.value.role_name}"
  scope             = each.value.scope
  assignable_scopes = each.value.assignable_scopes

  permissions {
    actions     = each.value.permissions.actions
    not_actions = each.value.permissions.not_actions
  }

}
