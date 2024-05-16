# Terraform Project for Managing Free VMs on GCP and OCI

This Terraform project is designed to manage free virtual machines (VMs) on Google Cloud Platform (GCP) and Oracle Cloud Infrastructure (OCI). The project sets up and maintains infrastructure for personal use or development purposes utilizing free-tier resources from these cloud providers.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
- [OCI CLI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)

## Setup

### 1. Configure Google Cloud SDK

1. **Install Google Cloud SDK**:
   Follow the [installation guide](https://cloud.google.com/sdk/docs/install) for your operating system.

2. **Initialize the SDK**:
   ```sh
   gcloud init
   ```

3. **Login to your GCP account**:
   ```sh
   gcloud auth login
   ```

4. **Set your GCP project**:
   ```sh
   gcloud config set project YOUR_PROJECT_ID
   ```

### 2. Configure Oracle Cloud Infrastructure CLI

1. **Install OCI CLI**:
   Follow the [installation guide](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm) for your operating system.

2. **Configure the CLI**:
   ```sh
   oci setup config
   ```

   Follow the prompts to generate an API key and set up your CLI configuration.

### 3. Initialize and Apply Terraform Configurations
1. **Navigate to the shared directory**:
   ```sh
   terraform init -backend-config="env/backend_s3_dev.hcl"
   ```

2. **Review and apply the Terraform plan**:
   ```sh
   terraform plan
   terraform apply
   ```

## Terraform Configuration

### Dynamic Backend Configuration

All the backend configure locate in `provider.tf` file to configure the backend for storing the Terraform state.

For dynamic configuration, all the environment store in `env/*.hcl`, choose the environment when init the terraform

### Variables

Each environment has a `variables.tf` file where you can define and manage input variables.

### Outputs

Each environment has an `outputs.tf` file to define the outputs of the Terraform configuration.

## Notes

- Ensure you have sufficient permissions on both GCP and OCI to create and manage resources.
- Use environment variables or a secrets manager to handle sensitive data like credentials.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request with your changes.