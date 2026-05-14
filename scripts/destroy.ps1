$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "load-env.ps1")

terraform init -input=false
terraform destroy
