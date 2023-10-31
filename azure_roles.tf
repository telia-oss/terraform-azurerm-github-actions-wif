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
        client_id       = environment.client_id
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
        client_id         = env.client_id
        role_name         = role_name
        name_prefix       = env.name_prefix
        environment       = env.environment
        assignable        = role.assignable
        permissions       = role.permissions
        scope             = role.scope
        assignable_scopes = try(role.assignable_scopes, [role.scope])
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
          client_id          = env.client_id
          environment        = env.environment
          role_name          = role_name
          role_definition_id = null
          scope              = scope
        }
      ]
    ] if env.roles != null ? length(env.roles) > 0 : false
  ])
}

# Lookup the service principal for the applications where we got an application ID
data "azuread_service_principal" "lookup" {
  for_each = {
    for env in local.environments_to_reference_apps : "${env.repository_name}-${env.client_id}-${env.environment}" => env
  }
  client_id = data.azuread_application.existing["${each.value.repository_name}-${each.value.environment}"].client_id
}

# Standard roles
resource "azurerm_role_assignment" "standard_role_assignment" {
  for_each = {
    for role_assignment in local.standard_roles :

    "${role_assignment.repository_name}-${role_assignment.environment}-${role_assignment.role_name}-${role_assignment.scope}" => role_assignment
  }
  principal_id = try(data.azuread_service_principal.lookup["${each.value.repository_name}-${each.value.client_id}-${each.value.environment}"].object_id,
  azuread_service_principal.github_oidc["${each.value.repository_name}-${each.value.environment}"].object_id)
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
    "${role_assignment.repository_name}-${role_assignment.environment}-${role_assignment.role_name}-${role_assignment.scope}" => role_assignment
  }

  principal_id = try(data.azuread_service_principal.lookup["${each.value.repository_name}-${each.value.client_id}-${each.value.environment}"].object_id,
  azuread_service_principal.github_oidc["${each.value.repository_name}-${each.value.environment}"].object_id)
  scope = each.value.scope

  role_definition_id = azurerm_role_definition.inline_role_definition["${each.value.repository_name}-${each.value.role_name}-${each.value.environment}"].role_definition_resource_id
}

# Inline role definitions
resource "azurerm_role_definition" "inline_role_definition" {
  for_each = {
    for role in local.inline_roles :
    "${role.repository_name}-${role.role_name}-${role.environment}" => role
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
