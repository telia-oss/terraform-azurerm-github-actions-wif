module "gha_repo1" {
  source        = "../../"
  name_prefix   = "demo"
  environment   = "development"
  identity_type = "azureAdApplication"

  repositories = {
    "rickardl/teliacompany-azure-wif-test" = {
      environments = {
        development = {
          name_prefix     = "app1-dev"
          subscription_id = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"

          tags = {
            Environment = "development"
            Application = "App1"
          }

          roles = {
            Contributor = {
              scopes = [
                "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"
              ]
            }
          }

          inline_roles = {
            "[Custom] Resource Group Owner 2" = {
              name       = "Resource Group Owner"
              assignable = true
              scope      = "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"

              permissions = {
                actions     = ["*"]
                not_actions = []
              }
            }
          }
        }

        production = {
          name_prefix     = "app1-prod"
          subscription_id = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"

          tags = {
            Environment = "production"
            Application = "App1"
          }

          roles = {
            Contributor = {
              scopes = [
                "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"
              ]
            }
          }
        }
      }
    }
  }
}

module "gha_repo2" {
  source        = "../../"
  name_prefix   = "demo"
  environment   = "development"
  identity_type = "userAssignedIdentity"

  repositories = {
    "rickardl/teliacompany-azure-wif-test-2" = {
      environments = {
        development = {
          name_prefix         = "app1-dev"
          subscription_id     = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"
          resource_group_name = "github-oidc-demo-2-dev"

          tags = {
            Environment = "development"
            Application = "App1"
          }

          roles = {
            Contributor = {
              scopes = [
                "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"
              ]
            }
          }

          inline_roles = {
            "[Custom] Resource Group Owner 3" = {
              name       = "Resource Group Owner"
              assignable = true
              scope      = "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"

              permissions = {
                actions     = ["*"]
                not_actions = []
              }
            }
          }
        }

        production = {
          name_prefix         = "app1-prod"
          resource_group_name = "github-oidc-demo-2-dev"
          subscription_id     = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"

          tags = {
            Environment = "production"
            Application = "App1"
          }

          roles = {
            Contributor = {
              scopes = [
                "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"
              ]
            }
          }
        }
      }
    }
  }
}
