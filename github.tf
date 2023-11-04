
# The github.tf file for the terraform-azure-github-actions-wif module
#
# This file contains resources for managing GitHub repository environments,
# creating secrets for Azure authentication in GitHub Actions environments,
# and other GitHub-related configurations.
#

locals {
  flattened_environments = flatten([
    for repo in var.repositories : [
      for environment in repo.environments : {
        repository_name       = repo.repository_name
        environment           = environment.environment
        name_prefix           = environment.name_prefix
        subscription_id       = try(environment.subscription_id, data.azurerm_subscription.current.subscription_id)
        client_id             = try(environment.client_id, null)
        managed_identity_name = try(environment.managed_identity_name, null)
        resource_group_name   = try(environment.resource_group_name, null)
        tags                  = try(environment.tags, {})
        roles                 = try(environment.roles, null)
        inline_roles          = try(environment.inline_roles, null)
      }
    ]
  ])
  environment_map = { for env in local.flattened_environments : "${env.repository_name}-${env.environment}" => env }
}

# The GitHub repository data source is used to retrieve the repository name
data "github_repository" "repo" {
  for_each  = { for repo in var.repositories : repo.repository_name => repo }
  full_name = each.value.repository_name
}


# The GitHub repository environment resource is used to create the repository environments
resource "github_repository_environment" "repo_environment" {
  for_each    = local.environment_map
  environment = each.value.environment
  repository  = data.github_repository.repo[each.value.repository_name].name
}

# The GitHub repository environment secret resource is used to create the repository environment secrets
resource "github_actions_environment_secret" "azure_client_id" {
  for_each        = local.environment_map
  repository      = data.github_repository.repo[each.value.repository_name].name
  environment     = each.value.environment
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = var.identity_type == "azureAdApplication" ? each.value.client_id != null ? data.azuread_application.existing["${each.value.repository_name}-${each.value.environment}"].client_id : azuread_application.github_oidc["${each.value.repository_name}-${each.value.environment}"].client_id : each.value.managed_identity_name != null ? data.azurerm_user_assigned_identity.lookup["${each.value.repository_name}-${each.value.environment}"].client_id : azurerm_user_assigned_identity.github_oidc["${each.value.repository_name}-${each.value.environment}"].client_id
}

# The GitHub repository environment secret resource is used to create the repository environment secrets
resource "github_actions_environment_secret" "azure_subscription_id" {
  for_each        = local.environment_map
  repository      = data.github_repository.repo[each.value.repository_name].name
  environment     = each.value.environment
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = each.value.subscription_id
}

# The GitHub repository environment secret resource is used to create the repository environment secrets
resource "github_actions_environment_secret" "azure_tenant_id" {
  for_each        = local.environment_map
  repository      = data.github_repository.repo[each.value.repository_name].name
  environment     = each.value.environment
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_subscription.current.tenant_id
}

/*
# This section will be used to to enable Azure backend configuration in GitHub Actions
resource "github_actions_environment_secret" "backend_azure_resource_group_name" {
  for_each        = local.environment_map
  repository      = data.github_repository.repo[each.value.repository_name].id
  environment     = each.value.environment
  secret_name     = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
  plaintext_value = azurerm_resource_group.state.name
}

resource "github_actions_environment_secret" "backend_azure_storage_account_name" {
  for_each        = local.environment_map
  repository      = data.github_repository.repo[each.value.repository_name].id
  environment     = each.value.environment
  secret_name     = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
  plaintext_value = azurerm_storage_account.example.name
}

resource "github_actions_environment_secret" "backend_azure_storage_account_container_name" {
  for_each        = local.environment_map
  repository      = data.github_repository.repo[each.value.repository_name].id
  environment     = each.value.environment
  secret_name     = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
  plaintext_value = azurerm_storage_container.example[each.key].name
}
*/
