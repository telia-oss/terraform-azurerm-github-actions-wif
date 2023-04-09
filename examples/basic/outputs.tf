output "application_id" {
  description = "The Application ID for each repository and environment."
  value       = module.gha_repo1.application_id
}

output "subscription_id" {
  description = "The Subscription ID for each repository and environment."
  value       = module.gha_repo1.subscription_id
}

output "resource_group_names" {
  description = "The Resource Group names for each repository and environment."
  value       = module.gha_repo1.resource_group_names
}

output "assigned_roles" {
  description = "The assigned roles for each repository and environment."
  value       = module.gha_repo1.assigned_roles
}

output "inline_roles" {
  description = "The inline roles for each repository and environment."
  value       = module.gha_repo1.inline_roles
}
