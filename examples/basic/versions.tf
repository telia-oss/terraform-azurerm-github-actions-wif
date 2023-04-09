terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.51"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.36.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}
