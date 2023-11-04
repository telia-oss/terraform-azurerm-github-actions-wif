locals {
  environments_to_create_managed_identities = [
    for env in local.repo_environments : env if env.managed_identity_name == null && var.identity_type == "userAssignedIdentity"
  ]
  environments_to_reference_managed_identities = [
    for env in local.repo_environments : env if env.managed_identity_name != null && var.identity_type == "userAssignedIdentity"
  ]
}

resource "azurerm_user_assigned_identity" "github_oidc" {
  for_each            = { for env in local.environments_to_create_managed_identities : "${env.repository_name}-${env.environment}" => env }
  name                = "umi-${each.value.name_prefix}-github-oidc"
  resource_group_name = each.value.resource_group_name
  location            = data.azurerm_resource_group.managed_identity_resource_group["${each.value.repository_name}-${each.value.environment}-${each.value.resource_group_name}"].location
  tags = {
    environment = each.value.environment
  }
}

resource "azurerm_federated_identity_credential" "github_oidc" {
  for_each = { for env in local.environments_to_create_managed_identities : "${env.repository_name}-${env.environment}" => env }

  name                = "umi-${each.value.name_prefix}-github-oidc"
  resource_group_name = each.value.resource_group_name
  audience            = [var.audience_name]
  issuer              = var.github_issuer_url
  parent_id           = each.value.managed_identity_name != null ? data.azurerm_user_assigned_identity.lookup["${each.value.repository_name}-${each.value.environment}"].id : azurerm_user_assigned_identity.github_oidc["${each.value.repository_name}-${each.value.environment}"].id
  subject = replace(templatefile(local.subject_template_path, {
    repository_name = each.value.repository_name,
    environment     = each.value.environment
  }), "\n", "")
}


locals {
  environments_to_create_managed_identities_map    = { for env in local.environments_to_create_managed_identities : "${env.repository_name}-${env.environment}" => env }
  environments_to_reference_managed_identities_map = { for env in local.environments_to_reference_managed_identities : "${env.repository_name}-${env.environment}" => env }
}

data "azurerm_resource_group" "managed_identity_resource_group" {
  for_each = {
    for env in merge(
      local.environments_to_create_managed_identities_map,
      local.environments_to_reference_managed_identities_map
    ) : "${env.repository_name}-${env.environment}-${env.resource_group_name}" => env
  }

  name = each.value.resource_group_name
}


data "azurerm_user_assigned_identity" "lookup" {
  for_each = { for env in local.environments_to_reference_managed_identities : "${env.repository_name}-${env.environment}" => env }

  name                = try(each.value.managed_identity_name, "")
  resource_group_name = each.value.resource_group_name
}
