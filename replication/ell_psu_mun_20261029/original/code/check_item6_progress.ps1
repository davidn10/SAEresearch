param(
  [string]$OutputRoot = "C:\DavidNewhouse2024\SAEresearch-Codex\Results\item6_sequential",
  [int]$Tail = 30
)

$SummaryCsv = Join-Path $OutputRoot "run_summary.csv"
$ProgressLog = Join-Path $OutputRoot "progress.log"
$LogDir = Join-Path $OutputRoot "logs"

Write-Host "Output root: $OutputRoot"

if (Test-Path -LiteralPath $SummaryCsv) {
  $rows = Import-Csv -LiteralPath $SummaryCsv
  if ($rows.Count -gt 0) {
    Write-Host ""
    Write-Host "Summary by round / arm / model_parameters / status:"
    $rows |
      Group-Object round, arm, model_parameters, status |
      Sort-Object Name |
      Select-Object Name, Count |
      Format-Table -AutoSize

    Write-Host ""
    Write-Host "Most recent completed samples:"
    $rows |
      Select-Object -Last 10 timestamp, round, arm, model_parameters, index, status, seconds, log |
      Format-Table -AutoSize
  } else {
    Write-Host "Summary CSV exists but has no completed sample rows yet."
  }
} else {
  Write-Host "No summary CSV yet: $SummaryCsv"
}

if (Test-Path -LiteralPath $ProgressLog) {
  Write-Host ""
  Write-Host "Last $Tail progress lines:"
  Get-Content -LiteralPath $ProgressLog -Tail $Tail
} else {
  Write-Host "No progress log yet: $ProgressLog"
}

if (Test-Path -LiteralPath $LogDir) {
  $latest = Get-ChildItem -LiteralPath $LogDir -Filter "*.log" -File |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1
  if ($latest) {
    Write-Host ""
    Write-Host "Latest sample log: $($latest.FullName)"
    Get-Content -LiteralPath $latest.FullName -Tail $Tail
  }
}
