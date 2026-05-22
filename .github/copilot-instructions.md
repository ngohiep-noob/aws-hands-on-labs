# Copilot Instructions

- Terraform code lives in `terraform/labs/<lab-name>`.
- Runtime and lab implementation code lives in `labs/<lab-name>`.
- Terraform launchers live in `terraform/scripts`.
- Use `getting-started` as the default quickstart lab.
- Keep Terraform state isolated per lab folder.
- Prefer service-specific Terraform files like `vpc.tf`, `s3.tf`, and `lambda.tf`.
- Use `terraform/scripts/*.cmd` on Windows for plan/apply/destroy.
- Launchers accept `-LabPath` and default to `terraform/labs/getting-started`.
- Do not commit `.env` or lab-specific `terraform.tfvars` files.
- Update `README.md` belonging to the lab when the workflow or layout changes.

# Repo Instructions

## Purpose
This repository contains AWS hands-on labs provisioned with Terraform.

## Layout
- Terraform code lives under `terraform/labs/<lab-name>`.
- Runtime or lab implementation code lives under `labs/<lab-name>`.
- Terraform launchers live under `terraform/scripts`.
- The default quickstart lab is `getting-started`.

## Conventions
- Keep Terraform state isolated per lab folder.
- Prefer service-specific Terraform files inside each lab (for example `s3.tf`, `vpc.tf`, `lambda.tf`).
- Keep root-level Terraform files out of the repo root.
- Use `terraform/scripts/*.cmd` on Windows so launches work even when PowerShell script execution is restricted.
- Launchers accept `-LabPath` and should default to `terraform/labs/getting-started`.

## Common Commands
```powershell
./terraform/scripts/plan.cmd -LabPath terraform/labs/<lab-name>
./terraform/scripts/apply.cmd -LabPath terraform/labs/<lab-name>
./terraform/scripts/destroy.cmd -LabPath terraform/labs/<lab-name>
```

## Notes for Future Changes
- If you add a new lab, create a new folder under `terraform/labs/<lab-name>` and keep its state inside that folder.
- Update a lab-specific `labs/<lab-name>/README.md` file when workflow or layout conventions change.
- Never commit `.env` or lab-specific `terraform.tfvars` files.
