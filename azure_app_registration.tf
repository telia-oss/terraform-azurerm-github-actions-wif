# The app_registration.tf file for the terraform-azure-github-actions-wif module
#
# This file contains resources related to the Azure Active Directory application registrations,
# service principals, and federated identity credentials for the GitHub OIDC app.
#


locals {

  application_owners = var.owners == null ? [data.azurerm_client_config.current.object_id] : var.owners

  environments_to_create_apps = [
    for env in local.repo_environments : env if env.application_id == null
  ]

  environments_to_reference_apps = [
    for env in local.repo_environments : env if env.application_id != null
  ]
}

# The Azure Active Directory application resource is used to create the GitHub OIDC app
resource "azuread_application" "github_oidc" {
  for_each = { for env in local.environments_to_create_apps : "${env.repository_name}-${env.environment}" => env }

  display_name = "${each.value.name_prefix}-github-oidc"
  api {
    requested_access_token_version = 2
  }

  owners = local.application_owners
}

# The Azure Active Directory service principal resource is used to create the GitHub OIDC app service principal
data "azuread_application" "existing" {
  for_each       = { for env in local.environments_to_reference_apps : "${env.repository_name}-${env.environment}" => env }
  application_id = try(each.value.application_id, "")
}

# The Azure Active Directory service principal resource is used to create the GitHub OIDC app service principal
resource "azuread_service_principal" "github_oidc" {
  for_each       = { for env in local.environments_to_create_apps : "${env.repository_name}-${env.environment}" => env }
  application_id = azuread_application.github_oidc["${each.value.repository_name}-${each.value.environment}"].application_id
}

# The Azure Active Directory application resource is used to create the GitHub OIDC app
resource "azuread_application_federated_identity_credential" "github_oidc" {
  for_each              = { for e in local.repo_environments : "${e.repository_name}-${e.environment}" => e }
  application_object_id = try(azuread_application.github_oidc["${each.value.repository_name}-${each.value.environment}"].object_id, data.azuread_application.existing["${each.value.repository_name}-${each.value.environment}"].object_id)
  display_name          = replace(each.key, "/", "%2F")
  description           = "Deployments for ${each.value.repository_name} for environment ${each.value.environment}"
  audiences             = [var.audience_name]
  issuer                = var.github_issuer_url
  subject               = "repo:${each.value.repository_name}:environment:${each.value.environment}"
}
