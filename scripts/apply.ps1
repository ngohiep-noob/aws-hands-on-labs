$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "load-env.ps1")

terraform init -input=false
if (Test-Path "tfplan") {
  terraform apply tfplan
} else {
  terraform apply
}
