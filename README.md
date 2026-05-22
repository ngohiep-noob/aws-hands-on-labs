# Terraform AWS Test/Dev Environment

This repository provisions multiple AWS labs with Terraform.

The quickstart entrypoint is the `getting-started` lab. Its Terraform code lives under `terraform/labs/getting-started`, while implementation code belongs under `labs/getting-started`.
Each lab uses its own Terraform working directory and local state files, so destroying one lab only affects the state and resources for that lab folder.

## Quickstart Lab

The `getting-started` lab provisions a small baseline environment that you can use as the starting point for other labs.

## What gets created

- VPC
- Public subnet
- Internet Gateway + route table
- Security group (HTTP/HTTPS/SSH ingress)
- S3 bucket (name is randomized to avoid global conflicts)

## Prerequisites

- Terraform `>= 1.6.0`
- AWS credentials configured locally (see [AWS Credentials Setup](#aws-credentials-setup))
- AWS region and profile values in `terraform.tfvars`

## AWS Credentials Setup

Choose **one** of these methods:

### Option 1: Environment Variables (Recommended for local dev)

1. Create a `.env` file in the project root:
```
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
```

2. Load before running Terraform:
```powershell
Get-Content .env | ForEach-Object {
  if ($_ -match '^\s*([^#=]+)=(.*)$') {
    [Environment]::SetEnvironmentVariable($matches[1], $matches[2], 'Process')
  }
}

./terraform/scripts/plan.cmd -LabPath terraform/labs/getting-started
```

If your machine has a restrictive PowerShell execution policy, use the `.cmd` launchers in `terraform/scripts/` instead of invoking the `.ps1` files directly.

### Option 2: AWS Credentials File

1. Run AWS CLI setup:
```powershell
aws configure --profile default
```
(Stores credentials in `~/.aws/credentials`)

2. Terraform automatically reads from `~/.aws/credentials` using the profile in the selected lab's `terraform.tfvars`.

### Option 3: AWS CLI Profile

Update the selected lab's `terraform.tfvars` with your profile name only if you want Terraform to use a named shared profile:
```hcl
aws_profile = "your-profile-name"
```

If you are using aws login / SSO-backed credentials, leave `aws_profile` unset so Terraform can use the active login session from your AWS CLI environment.

The `terraform/scripts/*` launchers will also try to export AWS CLI login credentials into the Terraform process automatically when no `.env` file is present.

**⚠️ IMPORTANT:** Never commit `.env` or any lab-specific `terraform.tfvars` file to git (already in `.gitignore`).

## Quick start

1. Copy the quickstart lab sample variables:

```powershell
Copy-Item terraform/labs/getting-started/terraform.tfvars.example terraform/labs/getting-started/terraform.tfvars
```

2. Update `terraform/labs/getting-started/terraform.tfvars` with your values.

3. Run common operations:

```powershell
./terraform/scripts/plan.cmd -LabPath terraform/labs/getting-started
./terraform/scripts/apply.cmd -LabPath terraform/labs/getting-started
./terraform/scripts/destroy.cmd -LabPath terraform/labs/getting-started
```

You can replace `getting-started` with any other lab folder name that follows the same `terraform/labs/<lab-name>` layout.

Lab-specific docs live in each lab's `labs/<lab-name>/README.md` file.

## Manual Terraform commands

```powershell
terraform -chdir=terraform/labs/getting-started init
terraform -chdir=terraform/labs/getting-started plan -out tfplan
terraform -chdir=terraform/labs/getting-started apply tfplan
terraform -chdir=terraform/labs/getting-started destroy
```

For a different lab, change the `-chdir` path to match that lab's folder under `terraform/labs`.

## State Isolation

Terraform state is isolated by lab folder. Use one Terraform directory per lab under `terraform/labs/<lab-name>`, and run commands with `-chdir` or the `terraform/scripts/*` wrappers so each lab reads and writes only its own state.

Do not share a single `terraform.tfstate` file across labs. If you add a new lab, create a new folder under `terraform/labs` and keep its state inside that folder.
