# ELL PSU and Municipality Arms: Code and Original Outputs

This handoff provides the code and original per-sample, per-municipality outputs requested for common evaluation and the replication package.

**[Download the complete code-and-outputs ZIP](David_ELL_code_outputs_20261029.zip?raw=true)** (41 MB).

The ZIP contains all 1,000 point-output DTA files: 100 samples for each arm in MEX2010, MEX2015, MEX2020, BRA2000 and BRA2010. It also contains 998 available coefficient files, the code, run records, dependency metadata and file checksums. Census and household sample microdata are not included.

## Code for Both Arms

Both arms use [`original/code/ell_cluster.R`](original/code/ell_cluster.R):

| Arm | Argument | Random-effect domain | Output level |
| --- | --- | --- | --- |
| Cluster / PSU | `--re psu` | `psu_id` | Municipality (`aggregate_to="mun_id"`) |
| Municipality | `--re mun` | `mun_id` | Municipality |

The original settings are fixed model parameters, `L=100`, seed 7 for each sample, `errors="nonnormal"`, no outcome transformation, rescaled survey weights and person-weighted population aggregation. Per-round thresholds and paths are in [`original/round_constants.csv`](original/round_constants.csv).

The estimator includes the chunked design-matrix and rowsum Monte Carlo overrides used locally. They are part of the supplied code. The installed povmap build identified at handoff is version 1.0.0, revision `0a6aa3a411c6dfab2788d57b51462d3875d84114` (`david3`); see [`environment/`](environment/). The dependency information in the older original README names a different build, as explained in the package documentation.

[`tools/run_original_arms.R`](tools/run_original_arms.R) launches the archived estimator in fresh R processes with an explicit data root and a new output directory. It maps numeric sample IDs to the original lexicographic file positions and checks beta/alpha file alignment. It does not invoke the historical scorer.

## Outputs and Verification

Extract the ZIP and use its `David_ELL_code_outputs_20261029/` directory as the package root. Point estimates are under `outputs/<round>/<arm>/sim_ebp_sample_<id>.dta`. Each file contains `area` (municipality ID) and `fgt` (estimated poverty headcount on the 0-1 scale). The unique key is `(round, arm, sample_id, area)`.

- [`output_index.csv`](output_index.csv): sample IDs, area counts, file paths, data types and SHA-256 checksums.
- [`output_completeness.csv`](output_completeness.csv): completeness by round and arm.
- [`tools/read_outputs.R`](tools/read_outputs.R): reader for the extracted package, adding the round, arm and sample ID to each area record.
- [`provenance/validation.txt`](provenance/validation.txt): validation checks, including reproduction of all 1,000 historical per-sample MAEs within `1e-12`.
- [`PACKAGE_README.md`](PACKAGE_README.md): full replication instructions and limitations.

MEX2020 municipality samples 25 and 50 store `fgt` as numeric text. All values convert cleanly to numbers; the supplied reader handles this. The original DTA files are preserved unchanged. Their coefficient files are unavailable and are listed in the package.

## Evaluation Basis and Uncertainty

These are the original outputs and historical scores. They have not been rerun or rescored under the revised truth, evaluation population or weighting. [`historical_evaluation/`](historical_evaluation/) is retained for context. Use the shared revised scorer for comparison with other methods.

The original exports do not contain ELL variance/MSE or actual fitted-row membership flags. Coverage is therefore unavailable from these files. A future uncertainty run must retain those quantities and verify the aggregation population and truth definition. See [`coverage_audit/`](coverage_audit/).

Current local input fingerprints and comparison with the inherited reference manifest are under [`provenance/`](provenance/). They describe files at handoff time and do not certify that the inputs or installed environment were unchanged since each run.

The browsable files in this directory are a subset of the complete ZIP. `UPLOAD_MANIFEST.csv` records their hashes. The ZIP retains its original package manifest and checksums.
