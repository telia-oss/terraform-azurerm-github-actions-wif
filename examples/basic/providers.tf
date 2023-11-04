provider "azurerm" {
  features {}
  use_oidc = true

  tenant_id       = "05764a73-8c6f-4538-83cd-413f1e1b5665"
  subscription_id = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"
}

provider "azuread" {
  tenant_id = "05764a73-8c6f-4538-83cd-413f1e1b5665"
  use_oidc  = true

}

provider "github" {
  owner = "rickardl"
}
