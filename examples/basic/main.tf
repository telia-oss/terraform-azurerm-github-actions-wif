module "gha_repo1" {
  source = "../../"

  name_prefix = "app1"
  environment = "development"

  repositories = [
    {
      repository_name = "rickardl/teliacompany-azure-wif-test"
      environments = [
        {
          environment     = "development"
          name_prefix     = "app1-dev"
          application_id  = "770b4589-b52a-4b10-a039-c4988027dd9a"
          subscription_id = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"
          tags = {
            Environment = "development"
            Application = "App1"
          }
          roles = {
            Contributor = {
              scopes = ["subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"]
            }
          }
          inline_roles = {
            "[Telia] Resource Group Owner" = {
              name       = "Resource Group Owner"
              assignable = true
              scope      = "/subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"
              permissions = {
                actions     = ["*"]
                not_actions = []
              }
            }
          }
        },
        {
          environment     = "production"
          name_prefix     = "app1-prod"
          application_id  = "01b38d31-bb2a-4eff-963d-a166b9a8358a"
          subscription_id = "232dfc78-375f-4f06-9e1d-e4d622ccbb60"
          tags = {
            Environment = "production"
            Application = "App1"
          }
          roles = {
            Contributor = {
              scopes = ["subscriptions/232dfc78-375f-4f06-9e1d-e4d622ccbb60/resourceGroups/github-oidc-demo-2-dev"]
            }
          }
        }
      ],

    },

  ]
}

output "module" {
  value = module.gha_repo1
}
