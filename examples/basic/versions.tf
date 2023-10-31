terraform {
  required_version = ">=1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.78"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.45.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.41"
    }
  }
}
