param(
  [Parameter(Mandatory = $true)]
  [string]$TableName,

  [Parameter(Mandatory = $true)]
  [string]$ObjectKey,

  [string]$VersionId = "null"
)

$ErrorActionPreference = 'Stop'

$expressionAttributeValues = @{
  ':object_key' = @{ S = $ObjectKey }
  ':version_id' = @{ S = $VersionId }
} | ConvertTo-Json -Compress

$queryArgs = @(
  'dynamodb', 'query',
  '--table-name', $TableName,
  '--key-condition-expression', 'object_key = :object_key and version_id = :version_id',
  '--expression-attribute-values', $expressionAttributeValues
)

Write-Host "Querying $TableName for object_key=$ObjectKey version_id=$VersionId"
aws @queryArgs