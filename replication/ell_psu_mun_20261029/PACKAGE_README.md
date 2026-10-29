# ELL PSU and Municipality Arms: Code and Original Outputs

Prepared for David Newhouse on 2026-10-29. These files document the completed runs under the original evaluation basis. They have not been rerun or rescored under the revised truth, evaluation population or weighting.

## Contents

- `original/`: unchanged copy of the estimation code, configuration, original input reference manifest and earlier documentation.
- `outputs/<round>/<arm>/`: original `sim_ebp_sample_<id>.dta` files and available coefficient files. `psu` is the cluster random effect; `mun` is the municipality random effect. Both report municipality estimates.
- `output_index.csv`: one row per point-output file, identifying round, arm, numeric sample ID, area count, relative path and SHA-256.
- `output_completeness.csv`: sample counts, returned area counts and available coefficient counts by round and arm.
- `environment/`: package versions, session information and the installed povmap identity captured at handoff time. These are not a historical lockfile from the run dates.
- `provenance/`: current local input fingerprints, comparisons with the original reference manifest, code/output copy checks and package checksums.
- `historical_evaluation/`: the five final per-sample score CSVs from the earlier evaluation basis, retained for context only.
- `run_records/`: available per-sample logs and original runner summary. Some log files were overwritten by resume attempts. The historical summary also contains failed early invocations; use the actual output index for completeness.
- `coverage_audit/`: the audit documenting why coverage could not yet be computed.
- `tools/run_original_arms.R`: new portable launcher for the archived estimator, with numeric sample IDs, isolated R processes and a fresh output directory. It does not call the historical scorer.
- `tools/read_outputs.R`: reader that adds the round, arm and numeric sample ID to the municipality-level records.

## Both Arms

The estimator is `original/code/ell_cluster.R`. The arm difference is:

| Setting | PSU/cluster arm | Municipality arm |
| --- | --- | --- |
| Argument | `--re psu` | `--re mun` |
| Population random-effect domain | `psu_id` | `mun_id` |
| Sample random-effect domain | `psu_id` | `mun_id` |
| `aggregate_to` | `mun_id` | `NULL` |
| Output area | Municipality | Municipality |

The supplied production results use `model_parameters="fixed"`, `L=100` and `set.seed(7)` separately for each sample. The mean-model outcome is `ln_pchinc`; beta and alpha variable lists are read separately for each sample. Both arms use `weights="FACTOR"`, `pop_weights="popwt"`, rescaled weights, `transformation="no"`, `errors="nonnormal"`, `na.rm=TRUE` and the Head_Count indicator. Thresholds and input paths are in `original/round_constants.csv`.

The estimator contains two local povmap overrides: a chunked population design-matrix calculation and a rowsum Head_Count Monte Carlo calculation. Both are part of the archived script and must accompany any replication. They are not changes made for this handoff.

## Output Dictionary and Join Keys

Each point-output DTA contains:

| Field | Meaning |
| --- | --- |
| `area` | Municipality identifier, saved as a string. Preserve it as an identifier. |
| `fgt` | Estimated municipality poverty headcount, on the 0-1 scale. |

Use `(round, arm, sample_id, area)` as the unique key. `sample_id` comes from the numeric filename suffix. The archived estimator's `--from` and `--to` arguments are positions in a lexicographically sorted file list, not numeric sample IDs: `sample_100` can be at position 3. The new launcher resolves numeric IDs to those original positions and checks that the beta/alpha files match. Do not pair arms by row order or by the historical scorer's `sim` counter.

Coefficient files contain `names` and `coefficients` for the fitted mean model. Missing coefficient files are listed in `provenance/missing_coefficient_files.csv`; they do not imply missing point outputs.

**Two supplied files use a different storage type:** MEX2020 municipality `sample_25` and `sample_50` store `fgt` as text containing numeric values. All values convert to finite numbers in [0,1]. The original files are preserved unchanged and flagged in `output_index.csv` and `provenance/output_quality_issues.csv`. The supplied reader converts `fgt` to numeric for every file. There are valid numeric-convertible point estimates in all 1,000 supplied files.

**Saved uncertainty and membership are absent.** The original point outputs contain no ELL variance/MSE, standard errors or fitted-row membership flags. Coverage cannot be recovered from them. The estimator computed variance internally but its export retained only `area` and `fgt`. The archived code preserves that behavior. It requires a deliberate export extension before any uncertainty rerun.

## Dependencies and Provenance

The local installation inspected for this handoff is R 4.4.2 with povmap 1.0.0, `RemoteRef=david3`, `RemoteSha=0a6aa3a411c6dfab2788d57b51462d3875d84114`. The earlier README names another pin (`b635434`) and another R version. Treat those historical statements as superseded by the captured environment metadata for this machine. The metadata identifies the current installation; no installation snapshot from each historical run date exists in this handoff.

Install the captured povmap revision when reproducing these arms, subject to your replication environment:

```r
install.packages(c("haven", "digest", "remotes"))
remotes::install_github(
  "SSA-Statistical-Team-Projects/povmap",
  ref = "0a6aa3a411c6dfab2788d57b51462d3875d84114"
)
```

`environment/` contains the actual installed package description and function fingerprints for auditing, plus the source archive's URL and hash. The 62 MB upstream source archive is supplied separately alongside the handoff ZIP to keep the main attachment smaller; it can also be downloaded from that recorded URL. Upstream povmap is GPL-2; the source archive carries its upstream attribution and license metadata. This handoff does not add a license to the research scripts.

`original/data_manifest.csv` is the inherited reference manifest, not a claim that the local inputs match it. `provenance/local_input_manifest.csv` fingerprints the inputs present at handoff time; `provenance/local_vs_reference.csv` lists differences. Several local census/truth files previously differed from that reference. Today's hashes cannot establish that files were unchanged since the runs. No census, sample household microdata or truth microdata are included in this package.

## Reproduce the Original Estimation Settings

The root must have the `MEX/` and `BRA/` layout in `original/round_constants.csv`. Set library paths normally, or supply `POVMAP_LIB` as a semicolon-separated list on Windows and a colon-separated list elsewhere.

First inspect a plan. From the extracted package directory:

```powershell
Rscript tools/run_original_arms.R --sae-root "D:/sae_data" --out "D:/ell_new_run" --rounds MEX2010 --arms psu,mun --samples 1 --L 100 --plan-only
```

Remove `--plan-only` to estimate that sample. For all five rounds and both arms:

```powershell
Rscript tools/run_original_arms.R --sae-root "D:/sae_data" --out "D:/ell_full_new_run" --rounds MEX2010,MEX2015,MEX2020,BRA2000,BRA2010 --arms psu,mun --samples 1:100 --L 100
```

`--out` must not already exist. The new launcher stops on an unsuccessful child process or missing exports, writes logs and a sample-to-index plan, and does not write into the supplied original outputs. It deliberately reproduces the old estimator; it does not implement the revised evaluation definition. The original Windows runner is included as historical code but has machine-specific default paths.

## Read the Supplied Outputs

```r
source("tools/read_outputs.R")
x <- read_ell_outputs(".", round = "MEX2015", arm = "psu", sample_id = 1)
# Columns: round, arm, sample_id, area, fgt
```

Omit filters to read all supplied outputs. The reader uses `output_index.csv`, so file order does not determine sample pairing.

## Revised Evaluation Basis

David's updated truth, evaluation population and weighting specification are not part of the available inputs. The historical scorer is archived for reference and is not invoked by the new launcher. Use the common revised scorer for both arms and the other methods.

Before rerunning, agree on the exact outcome/zero/missing-income rules, prediction population, municipality eligibility, person weights and survey weights, and how beta/alpha lists and sample IDs map to the updated data. A change in prediction population or aggregation weights can change the estimates themselves, not only their scores.

For uncertainty, extend the export to retain the municipality ELL variance and actual fitted-row membership, confirm the correct population for aggregation and truth, and validate one sample before a full rerun. Avoid labeling the old results as estimates under the new basis.

## Verification

`provenance/validation.txt` records file counts, unique municipality keys, numeric sample alignment, valid estimate ranges, paired area sets, exact-copy checks, R syntax checks and the dry run of the new launcher. Package file hashes are in `provenance/package_manifest.csv`. The ZIP was independently checked against these hashes before delivery. No new model fits or revised-basis scoring were performed while making this handoff.
