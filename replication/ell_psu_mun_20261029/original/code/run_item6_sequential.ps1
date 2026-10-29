param(
  [string[]]$Rounds = @("MEX2020", "BRA2000", "BRA2010"),
  [string[]]$Arms = @("psu", "mun"),
  [string[]]$ModelParameters = @("fixed"),
  [int]$From = 1,
  [int]$To = 100,
  [int[]]$Indices = @(),
  [int]$L = 100,
  [string]$HandoffDir = "C:\DavidNewhouse2024\SAEresearch-Codex\handoff_item6_codex",
  [string]$SaeRoot = "C:\DavidNewhouse2024\SAEresearch-Codex\work\sae_root_mapped",
  [string]$OutputRoot = "C:\DavidNewhouse2024\SAEresearch-Codex\Results\item6_sequential",
  [string]$Rscript = "C:\Program Files\R\R-4.4.2\bin\Rscript.exe",
  [string]$PovmapLib = "C:\Users\haian\AppData\Local\R\win-library\4.4;C:\Program Files\R\R-4.4.2\library"
)

$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $false

New-Item -ItemType Directory -Force -Path $OutputRoot | Out-Null
$LogDir = Join-Path $OutputRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$SummaryCsv = Join-Path $OutputRoot "run_summary.csv"
$ProgressLog = Join-Path $OutputRoot "progress.log"

function Write-RunLog {
  param([string]$Message)
  $line = "[{0}] {1}" -f (Get-Date).ToString("s"), $Message
  $line | Tee-Object -FilePath $ProgressLog -Append
}

$RunIndices = if ($Indices.Count -gt 0) { $Indices } else { $From..$To }

if (-not (Test-Path -LiteralPath $SummaryCsv)) {
  "timestamp,round,arm,model_parameters,index,L,exit_code,status,seconds,log,out_dir" | Out-File -LiteralPath $SummaryCsv -Encoding utf8
}

Write-RunLog "RUNNER START rounds=$($Rounds -join ',') arms=$($Arms -join ',') model_parameters=$($ModelParameters -join ',') index=$($RunIndices -join ',') L=$L"
Write-RunLog "output_root=$OutputRoot"
Write-RunLog "summary_csv=$SummaryCsv"
Write-RunLog "sample_logs=$LogDir"

$env:SAE_ROOT = $SaeRoot
$env:POVMAP_LIB = $PovmapLib

try {
  foreach ($round in $Rounds) {
    foreach ($arm in $Arms) {
      foreach ($modpar in $ModelParameters) {
        $OutDir = Join-Path $OutputRoot "$round`_L$L`_results_ell_$arm`_$modpar\unit\output"
        New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
        Write-RunLog "ARM START round=$round arm=$arm model_parameters=$modpar out=$OutDir"

        foreach ($i in $RunIndices) {
          $Log = Join-Path $LogDir "$round`_$arm`_$modpar`_idx$i`_L$L.log"
          $StdOut = Join-Path $LogDir "$round`_$arm`_$modpar`_idx$i`_L$L.stdout.tmp"
          $StdErr = Join-Path $LogDir "$round`_$arm`_$modpar`_idx$i`_L$L.stderr.tmp"
        $args = @(
          "code\ell_cluster.R",
          "--round", $round,
          "--re", $arm,
          "--model-parameters", $modpar,
          "--from", "$i",
          "--to", "$i",
          "--L", "$L",
          "--out", $OutDir
        )
        $started = Get-Date
          "[$($started.ToString('s'))] START round=$round arm=$arm model_parameters=$modpar index=$i L=$L out=$OutDir" | Tee-Object -FilePath $Log
          Write-RunLog "SAMPLE START round=$round arm=$arm model_parameters=$modpar index=$i log=$Log"
        Push-Location $HandoffDir
        try {
          $p = Start-Process -FilePath $Rscript -ArgumentList $args -WorkingDirectory $HandoffDir -NoNewWindow -Wait -PassThru -RedirectStandardOutput $StdOut -RedirectStandardError $StdErr
          if (Test-Path -LiteralPath $StdOut) { Get-Content -LiteralPath $StdOut | Tee-Object -FilePath $Log -Append }
          if (Test-Path -LiteralPath $StdErr) { Get-Content -LiteralPath $StdErr | Tee-Object -FilePath $Log -Append }
          $code = $p.ExitCode
        } finally {
          Pop-Location
          Remove-Item -LiteralPath $StdOut,$StdErr -ErrorAction SilentlyContinue
        }
        $ended = Get-Date
        $seconds = [math]::Round(($ended - $started).TotalSeconds, 1)
          $hasFailure = Select-String -LiteralPath $Log -Pattern "FAILED:" -Quiet
          $hasDone = Select-String -LiteralPath $Log -Pattern "^DONE$" -Quiet
          $wasSkipped = Select-String -LiteralPath $Log -Pattern "already done, skipping" -Quiet
          $status = if ($code -ne 0 -or $hasFailure -or -not $hasDone) { "failed" } elseif ($wasSkipped) { "skipped" } else { "ok" }
          "[$($ended.ToString('s'))] END round=$round arm=$arm model_parameters=$modpar index=$i exit=$code status=$status seconds=$seconds" | Tee-Object -FilePath $Log -Append
          Write-RunLog "SAMPLE END round=$round arm=$arm model_parameters=$modpar index=$i exit=$code status=$status seconds=$seconds"
          $row = '"{0}","{1}","{2}","{3}",{4},{5},{6},"{7}",{8},"{9}","{10}"' -f $ended.ToString("s"), $round, $arm, $modpar, $i, $L, $code, $status, $seconds, $Log.Replace('"','""'), $OutDir.Replace('"','""')
        Add-Content -LiteralPath $SummaryCsv -Value $row
        }
        Write-RunLog "ARM END round=$round arm=$arm model_parameters=$modpar"
      }
    }
  }
  Write-RunLog "RUNNER END"
} finally {
  Remove-Item Env:SAE_ROOT -ErrorAction SilentlyContinue
  Remove-Item Env:POVMAP_LIB -ErrorAction SilentlyContinue
}
