param(
  [string]$SourceRoot = "C:\DavidNewhouse2024",
  [string]$MappedRoot = "C:\DavidNewhouse2024\SAEresearch-Codex\work\sae_root_mapped"
)

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path $MappedRoot | Out-Null

$mexLink = Join-Path $MappedRoot "MEX"
if (-not (Test-Path -LiteralPath $mexLink)) {
  New-Item -ItemType Junction -Path $mexLink -Target (Join-Path $SourceRoot "MEX") | Out-Null
}

New-Item -ItemType Directory -Force -Path (Join-Path $MappedRoot "BRA\2000\full_census") | Out-Null
$bra2000Link = Join-Path $MappedRoot "BRA\2000\full_census\BRA_2000_new"
if (-not (Test-Path -LiteralPath $bra2000Link)) {
  New-Item -ItemType Junction -Path $bra2000Link -Target (Join-Path $SourceRoot "BRA\BRA_2000\2000\full_census\BRA_2000_new") | Out-Null
}

New-Item -ItemType Directory -Force -Path (Join-Path $MappedRoot "BRA\2010") | Out-Null
$bra2010Link = Join-Path $MappedRoot "BRA\2010\full_census_new"
if (-not (Test-Path -LiteralPath $bra2010Link)) {
  New-Item -ItemType Junction -Path $bra2010Link -Target (Join-Path $SourceRoot "BRA\2010\full_census\BRA_2010_new") | Out-Null
}

Write-Host "Mapped SAE root ready: $MappedRoot"
Get-ChildItem -LiteralPath $MappedRoot -Recurse -Depth 4 -Force |
  Select-Object FullName, LinkType, Target |
  Format-Table -AutoSize
