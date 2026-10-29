# Codex Item 6 Handoff

This folder contains a Codex-prepared copy of the item 6 ELL cluster-random-effect workflow.

## What Changed

The key item 6 change is already supported by `povmap:::ell()`:

```r
pop_domains = "psu_id"
smp_domains = "psu_id"
aggregate_to = "mun_id"
```

`psu_id` is the random-effect/domain level. `aggregate_to = "mun_id"` keeps output at the
municipality level so it can be compared with the paper results.

No `povmap` rewrite is needed for this change.

## Local Environment Found

Use this R executable:

```powershell
C:\Program Files\R\R-4.4.2\bin\Rscript.exe
```

Use this library path when running from batch/Codex:

```powershell
C:\Users\haian\AppData\Local\R\win-library\4.4;C:\Program Files\R\R-4.4.2\library
```

Installed `povmap` reported version `1.0.0`.

## Data Layout

The item 6 handoff expects Brazil at:

```text
BRA\2000\full_census\BRA_2000_new
BRA\2010\full_census_new
```

The local machine stores those under:

```text
BRA\BRA_2000\2000\full_census\BRA_2000_new
BRA\2010\full_census\BRA_2010_new
```

Use `code\setup_sae_root_mapped.ps1` to create a mapped root with junctions.

## Verification Status

Quick manifest against the mapped root:

```text
BRA2000: size-ok
BRA2010: size-ok
MEX2020: size-ok
MEX2010: missing 100 top-level alphavars_selected files
MEX2015: one census size mismatch
```

Because of that, production runs should focus first on `BRA2000`, `BRA2010`, and `MEX2020`.
Do not use `MEX2010` or `MEX2015` for paper results until David confirms those inputs.

## Runs Completed In Codex

Official probe:

```text
MEX2020, cluster-RE, L=2, sample 1
RAN in 1.28 min
PSU nests inside municipality
output rows: 2466
vs published municipality-RE: mean abs diff 0.03064, correlation 0.9793
```

Partial low-L run:

```text
MEX2020, L=10
cluster-RE succeeded for sample_100, sample_11, sample_12
municipality-RE succeeded for sample_11, sample_12
```

Paired score, only `sample_11` and `sample_12`:

```text
cluster-RE minus municipality-RE
mae_eq   -0.002763
mae_pop  -0.004246
rmse_eq  -0.004191
rankcor  +0.010963
```

These are partial trial results, not paper evidence.

## Memory Warning

This Codex shell hit memory allocation failures on some one-sample runs, for example:

```text
MEX2020 cluster index 1, L=10: cannot allocate vector of size 2.8 Gb
BRA2000 cluster index 1, L=10: cannot allocate vector of size 3.0 Gb
```

Run production from a normal PowerShell/RStudio session with enough RAM. Use the sequential
runner so each sample starts in a fresh R process.

## Suggested Production Command

From `C:\DavidNewhouse2024\SAEresearch-Codex\handoff_item6_codex`:

```powershell
.\code\setup_sae_root_mapped.ps1
.\code\run_item6_sequential.ps1 -Rounds MEX2020,BRA2000,BRA2010 -Arms psu,mun -ModelParameters fixed,variable -From 1 -To 100 -L 100
```

Then score matched outputs using `code\score_ell.R` from the copied handoff code.

## Checking Progress

The sequential runner writes:

```text
C:\DavidNewhouse2024\SAEresearch-Codex\Results\item6_sequential\progress.log
C:\DavidNewhouse2024\SAEresearch-Codex\Results\item6_sequential\run_summary.csv
C:\DavidNewhouse2024\SAEresearch-Codex\Results\item6_sequential\logs\*.log
```

To check progress from another PowerShell window:

```powershell
cd C:\DavidNewhouse2024\SAEresearch-Codex\handoff_item6_codex
.\code\check_item6_progress.ps1
```

To watch the master progress log continuously:

```powershell
Get-Content C:\DavidNewhouse2024\SAEresearch-Codex\Results\item6_sequential\progress.log -Wait -Tail 20
```
