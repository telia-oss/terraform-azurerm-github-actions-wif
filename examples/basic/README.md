# Terraform Azure GitHub Actions Workload Identity Federation (WIF) - Basic Example

This example demonstrates the basic usage of the `terraform-azure-github-actions-wif` module to set up Workload Identity Federation for a GitHub Actions environment.

> **WARNIG:** Clean this exampe up from sensitive data before sharing it with others.

> **NOTE:** This example uses the `terraform-azure-github-actions-wif` module from the root of the repository. In a real-world scenario, you would use the module from the [Terraform Registry](https://registry.terraform.io/modules/telia-oss/terraform-azure-github-actions-wif).

## Usage

1. Run `terraform init` to initialize the Terraform working directory.
2. Run `terraform apply` to create the resources.
3. Verify the resources created by checking the output values.

## Outputs

- `application_id`: The Application ID for each repository and environment.
- `subscription_id`: The Subscription ID for each repository and environment.
- `resource_group_names`: The Resource Group names for each repository and environment.
- `assigned_roles`: The assigned roles for each repository and environment.
- `inline_roles`: The inline roles for each repository and environment.
