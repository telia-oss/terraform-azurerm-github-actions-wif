output "github_oidc_applications" {
  value = {
    for key, app in azuread_application.github_oidc : key => {
      application_id = app.application_id
      display_name   = app.display_name
    }
  }
  description = "Information about the created GitHub OIDC applications."
}

output "github_oidc_service_principals" {
  value = {
    for key, sp in azuread_service_principal.github_oidc : key => {
      object_id      = sp.object_id
      application_id = sp.application_id
    }
  }
  description = "Information about the created GitHub OIDC service principals."
}

output "github_repository_environments" {
  value = {
    for key, env in github_repository_environment.repo_environment : key => {
      environment = env.environment
      repository  = env.repository
    }
  }
  description = "Information about the created GitHub repository environments."
}

output "azure_client_id_secrets" {
  value = {
    for key, secret in github_actions_environment_secret.azure_client_id : key => {
      repository      = secret.repository
      environment     = secret.environment
      secret_name     = secret.secret_name
      plaintext_value = secret.plaintext_value
    }
  }
  description = "Information about the AZURE_CLIENT_ID secrets for GitHub repository environments."
}

output "azure_subscription_id_secrets" {
  value = {
    for key, secret in github_actions_environment_secret.azure_subscription_id : key => {
      repository      = secret.repository
      environment     = secret.environment
      secret_name     = secret.secret_name
      plaintext_value = secret.plaintext_value
    }
  }
  description = "Information about the AZURE_SUBSCRIPTION_ID secrets for GitHub repository environments."
}

output "azure_tenant_id_secrets" {
  value = {
    for key, secret in github_actions_environment_secret.azure_tenant_id : key => {
      repository      = secret.repository
      environment     = secret.environment
      secret_name     = secret.secret_name
      plaintext_value = secret.plaintext_value
    }
  }
  description = "Information about the AZURE_TENANT_ID secrets for GitHub repository environments."
}

output "standard_role_assignments" {
  value = {
    for key, assignment in azurerm_role_assignment.standard_role_assignment : key => {
      principal_id         = assignment.principal_id
      scope                = assignment.scope
      role_definition_name = assignment.role_definition_name
    }
  }
  description = "Information about the standard role assignments."
}

output "inline_role_definitions" {
  value = {
    for key, definition in azurerm_role_definition.inline_role_definition : key => {
      name        = definition.name
      description = definition.description
      scope       = definition.scope
    }
  }
  description = "Information about the inline role definitions."
}

output "inline_role_assignments" {
  value = {
    for key, assignment in azurerm_role_assignment.inline_role_assignment : key => {
      principal_id         = assignment.principal_id
      scope                = assignment.scope
      role_definition_name = assignment.role_definition_name
    }
  }
  description = "Information about the inline role assignments."
}
