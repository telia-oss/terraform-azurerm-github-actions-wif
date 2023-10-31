# Terraform Azure GitHub Actions Workload Identity Federation (WIF) - Basic Example

This example demonstrates the basic usage of the `terraform-azure-github-actions-wif` module to set up Workload Identity Federation for a GitHub Actions environment.

> **WARNIG:** Clean this example up from sensitive data before sharing it with others.

```mermaid
graph TD;
    subgraph Azure
        OIDC_App[OIDC Application] --> SP[Service Principal]
        SP --> RA_Inline[Role Assignment Inline]
        SP --> RA_Standard[Role Assignment Standard]
        RA_Inline --> RD[Role Definition]
    end
    subgraph GitHub
        Repo[Repository] --> GA[GitHub Actions]
        GA --> ES_ClientID[Environment Secret: Client ID]
        GA --> ES_SubscriptionID[Environment Secret: Subscription ID]
        GA --> ES_TenantID[Environment Secret: Tenant ID]
        GA --> Env_Prod[Environment: Production]
        GA --> Env_Dev[Environment: Development]
    end
    subgraph Workload_Identity_Federation
        OIDC_App --> WIF[Trust Relationship]
        WIF --> GitHub_Issuer[GitHub as Issuer]
    end
    GitHub_Issuer --> GA[GitHub Actions]
    style OIDC_App fill:#ffcccc
    style SP fill:#ccffcc
    style RA_Inline fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style RA_Standard fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style RD fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style Repo fill:#ffcccc
    style GA fill:#ccffcc
    style ES_ClientID fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style ES_SubscriptionID fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style ES_TenantID fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style Env_Prod fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style Env_Dev fill:#ccccff,stroke:#ffccff,stroke-width:2px
    style WIF fill:#ffcccc
    style GitHub_Issuer fill:#ccffcc
```

> **NOTE:** This example uses the `terraform-azure-github-actions-wif` module from the root of the repository. In a real-world scenario, you would use the module from the [Terraform Registry](https://registry.terraform.io/modules/telia-oss/terraform-azure-github-actions-wif).

## Usage

1. Run `terraform init` to initialize the Terraform working directory.
2. Run `terraform apply` to create the resources.
3. Verify the resources created by checking the output values.

## Inputs

No inputs.

## Outputs

| Name                                                                                                                                       | Description                                                                               |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------- |
| <a name="output_azure_subscription_id_secrets"></a> [azure\_subscription\_id\_secrets](#output\_azure\_subscription\_id\_secrets)          | Information about the AZURE\_SUBSCRIPTION\_ID secrets for GitHub repository environments. |
| <a name="output_azure_tenant_id_secrets"></a> [azure\_tenant\_id\_secrets](#output\_azure\_tenant\_id\_secrets)                            | Information about the AZURE\_TENANT\_ID secrets for GitHub repository environments.       |
| <a name="output_github_oidc_applications"></a> [github\_oidc\_applications](#output\_github\_oidc\_applications)                           | Information about the created GitHub OIDC applications.                                   |
| <a name="output_github_oidc_applications_secrets"></a> [github\_oidc\_applications\_secrets](#output\_github\_oidc\_applications\_secrets) | Information about the created GitHub OIDC applications secrets.                           |
| <a name="output_github_oidc_service_principals"></a> [github\_oidc\_service\_principals](#output\_github\_oidc\_service\_principals)       | Information about the created GitHub OIDC service principals.                             |
| <a name="output_inline_role_definitions"></a> [inline\_role\_definitions](#output\_inline\_role\_definitions)                              | Information about the inline role definitions.                                            |
| <a name="output_standard_role_assignments"></a> [standard\_role\_assignments](#output\_standard\_role\_assignments)                        | Information about the standard role assignments.                                          |
