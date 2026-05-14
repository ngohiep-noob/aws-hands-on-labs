# Auto-load AWS credentials from .env file
$envFile = Join-Path $PSScriptRoot "..\\.env"

if (Test-Path $envFile) {
  Write-Host "Loading credentials from .env..." -ForegroundColor Green
  Get-Content $envFile | Where-Object { $_ -match '^\s*([^#=]+)=(.*)$' } | ForEach-Object {
    $key = $matches[1].Trim()
    $value = $matches[2].Trim()
    [Environment]::SetEnvironmentVariable($key, $value, 'Process')
  }
} else {
  Write-Host ".env file not found. Using existing AWS credentials." -ForegroundColor Yellow
}
