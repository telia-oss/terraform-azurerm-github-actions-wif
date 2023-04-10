# Terraform Azure GitHub Actions Workload Identity Federation (WIF) Module

> **WARNING:** This module is currently under active development and is not yet ready for production use.

This Terraform module integrates GitHub Actions with Workload Identity Federation for Microsoft Azure. It simplifies the process of setting up and managing Azure Role-based Access Control (RBAC) for GitHub Actions environments by creating the necessary resources and configuring the required secrets.

## Background

Workload Identity Federation for Microsoft Azure allows you to use Azure AD to authenticate and authorize users and applications to access Azure resources. This module simplifies the process of setting up and managing Azure RBAC for GitHub Actions environments by creating the necessary resources and configuring the required secrets.

See references below for more information about Workload Identity Federation for Microsoft Azure and GitHub Actions.

## Requirements

- Existing Azure Active Directory (AD) tenant.
- Permissions to create and manage Azure AD applications and service principals.
- Existing GitHub repository with GitHub Actions enabled, and GitHub Actions environments configured.
- Logged in to Azure CLI using `az login`.
- Credentials fo GitHub, either using a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) or [GitHub App](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps).

## Features

- Creates and manage existing Azure Active Directory (AD) applications and service principals for GitHub repositories' environments.
- Assign custom and built-in Azure RBAC roles to the service principal associated with each environment.
- Configures trust against GitHub through GitHub Actions environments with Azure AD application federated credentials.
- Configure existing GitHub repository with environment secrets, that provides required configurations.

## Usage

The following example creates a new Azure AD application and service principal for each environment in the repository `my-repo`. The service principal is assigned the built-in Azure RBAC role `Contributor` for the subscription `your-subscription-id` in the environment `staging`. The service principal is assigned the built-in Azure RBAC role `Reader` for the subscription `your-subscription-id` in the environment `production`. The service principal for the environment `production` is configured to use an existing Azure AD application with the ID `your-existing-application-id`.

```hcl
module "azure_gha_wif" {
  source = "github.com/telia-oss/terraform-azure-github-actions-wif"

  repositories = [
    {
      repository_name = "my-repo"
      environments = [
        {
          environment     = "staging"
          name_prefix     = "staging"
          roles           = {
            "Contributor" = ["/subscriptions/your-subscription-id"]
          }
        },
        {
          environment     = "production"
          name_prefix     = "prod"
          application_id  = "your-existing-application-id"
          roles           = {
            "Reader" = ["/subscriptions/your-subscription-id"]
          }
        }
      ]
    }
  ]

  user_defined_tags = {
    "ManagedBy" = "my-team"
  }
}
```

## Examples

Please see the [examples](./examples) directory for examples of how to use this module.

## Providers

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| azuread   | >= 2.0  |
| azurerm   | >= 2.0  |
| github    | >= 4.0  |

## Inputs

| Name              | Description                                      | Type     | Default | Required |
| ----------------- | ------------------------------------------------ | -------- | ------- | :------: |
| repositories      | List of repositories with environments to set up | `list`   | n/a     |   yes    |
| github_issuer_url | GitHub Actions issuer URL for generating tokens  | `string` | n/a     |   yes    |
| audience_name     | The audience for the generated tokens            | `string` | n/a     |          |
| user_defined_tags | A map of tags to add to all resources            | `map`    | `{}`    |          |

## References

- [Workload Identity Federation for Microsoft Azure](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-convert-app-to-be-workload-identity)
- [GitHub Actions: Workload Identity Federation](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-workload-identity-federation-for-azure)
- [GitHub Actions: Azure credentials](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-azure-credentials-for-github-actions)

## Contributing

Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for details on submitting patches and the contribution workflow.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
