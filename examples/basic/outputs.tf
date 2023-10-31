# Description: Outputs for the basic example

output "azure_subscription_id_secrets" {
  description = "Information about the AZURE_SUBSCRIPTION_ID secrets for GitHub repository environments."
  value       = module.gha_repo1.azure_subscription_id_secrets
  sensitive   = true
}

output "azure_tenant_id_secrets" {
  description = "Information about the AZURE_TENANT_ID secrets for GitHub repository environments."
  value       = module.gha_repo1.azure_tenant_id_secrets
  sensitive   = true
}

output "standard_role_assignments" {
  description = "Information about the standard role assignments."
  value       = module.gha_repo1.standard_role_assignments
  sensitive   = true
}

output "inline_role_definitions" {
  description = "Information about the inline role definitions."
  value       = module.gha_repo1.inline_role_definitions
  sensitive   = true
}

output "github_oidc_applications" {
  description = "Information about the created GitHub OIDC applications."
  value       = module.gha_repo1.github_oidc_applications
  sensitive   = true
}
