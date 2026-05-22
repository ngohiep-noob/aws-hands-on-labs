param(
  [Parameter(Mandatory = $true)]
  [string]$BucketName,

  [Parameter(Mandatory = $true)]
  [string]$FilePath,

  [string]$Prefix = "incoming/",

  [string]$Key,

  [string]$ContentType = "application/octet-stream"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $FilePath)) {
  throw "File not found: $FilePath"
}

$resolvedPrefix = $Prefix
if ($resolvedPrefix -and -not $resolvedPrefix.EndsWith('/')) {
  $resolvedPrefix = "$resolvedPrefix/"
}

if ([string]::IsNullOrWhiteSpace($Key)) {
  $Key = "$resolvedPrefix$(Split-Path -Path $FilePath -Leaf)"
}

$uploadArgs = @(
  's3', 'cp', $FilePath, "s3://$BucketName/$Key",
  '--content-type', $ContentType,
  '--metadata', 'demo=true'
)

Write-Host "Uploading $FilePath to s3://$BucketName/$Key"
aws @uploadArgs