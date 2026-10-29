# ELL coverage input audit

Coverage could not be computed from the saved production outputs. The required ELL variance was not saved.
As requested, the analysis stops at this input gate. No uncertainty estimates were inferred from point estimates, and no ELL models were rerun.

Scope: fixed model parameters, L=100, samples 1-100 in MEX2010, MEX2015, MEX2020, BRA2000 and BRA2010, for PSU and municipality random effects.

## Audit results

### MEX2010

| Arm | Point outputs | Present outputs lacking variance | Missing output files | Samples requiring variance |
| --- | ---: | ---: | ---: | --- |
| PSU/cluster | 100/100 | 100 | 0 | 1-100 |
| Municipality | 100/100 | 100 | 0 | 1-100 |

### MEX2015

| Arm | Point outputs | Present outputs lacking variance | Missing output files | Samples requiring variance |
| --- | ---: | ---: | ---: | --- |
| PSU/cluster | 100/100 | 100 | 0 | 1-100 |
| Municipality | 100/100 | 100 | 0 | 1-100 |

### MEX2020

| Arm | Point outputs | Present outputs lacking variance | Missing output files | Samples requiring variance |
| --- | ---: | ---: | ---: | --- |
| PSU/cluster | 100/100 | 100 | 0 | 1-100 |
| Municipality | 100/100 | 100 | 0 | 1-100 |

### BRA2000

| Arm | Point outputs | Present outputs lacking variance | Missing output files | Samples requiring variance |
| --- | ---: | ---: | ---: | --- |
| PSU/cluster | 100/100 | 100 | 0 | 1-100 |
| Municipality | 100/100 | 100 | 0 | 1-100 |

### BRA2010

| Arm | Point outputs | Present outputs lacking variance | Missing output files | Samples requiring variance |
| --- | ---: | ---: | ---: | --- |
| PSU/cluster | 100/100 | 100 | 0 | 1-100 |
| Municipality | 100/100 | 100 | 0 | 1-100 |

## Cause and evidence

Every readable point-output file has only `area` and `fgt`. Coefficient files contain regression coefficients, not uncertainty for municipality poverty estimates.
The existing `code/ell_cluster.R` constructs `var_estimates` inside its Monte Carlo function, but writes only `fit$ind$Domain` and `fit$ind$Head_Count` to `sim_ebp_sample_*.dta`, plus a separate coefficient file.
There are 0 candidate variance sidecars or R workspaces under the audited results root.
See `sample_input_audit.csv` for every round, arm and numeric sample ID, and `output_file_inventory.csv` for the actual files.

## Other required inputs

Fitted-row membership flags are not saved in these point outputs. Sample membership must be reconstructed from the rows actually used by the fitted model, or saved explicitly in new runs; drawn sample rows alone are insufficient.
The current runner passes the census to ELL without an explicit observed-income-only aggregation filter in the runner. This audit did not reconstruct census truth or verify the package's complete-case filtering. Whether the estimates include missing-income households remains unverified. Any later coverage results with a mismatched aggregation population must be labeled `uncorrected aggregation`.
The requested truth must include observed positive and zero income, count zero-income households as poor, and use person weights. Existing truth files cannot simply be assumed to satisfy this definition.
Earlier comparisons used current local input versions; some local census/truth files were previously reported not to match the bundled manifest. This audit does not certify those inputs.

## Controls and predictions

| Check | Result |
| --- | --- |
| Required saved ELL variance | FAIL: analysis stopped |
| Original output preservation | PASS: 1998 original files hashed before and after |
| Synthetic coverage self-test | NOT RUN: coverage scorer not reached |
| Permute estimated MSE across areas | NOT RUN: estimated MSE absent |
| Reproduce a previously reported MAE | NOT RUN: input gate failed before scoring |

The two supplied predictions are recorded in `predictions.md` before any coverage scoring. Neither can be evaluated from these saved outputs.

## Next required work

A new run must save municipality poverty estimates, the matching ELL variance, and actual fitted-row municipality membership for each numeric sample ID. First validate one new sample against its old point estimate, using the same inputs, settings and seed. Save new results in a separate directory.
Retain the package's variance of the simulated poverty indicator, rather than dividing it by L (which would estimate Monte Carlo error of the mean). Verify this quantity's interpretation in the installed ELL implementation before scoring.
After those inputs exist, verify the truth/aggregation population, reproduce a prior MAE, run the synthetic and permutation controls, and calculate the requested coverage, tracking, deciles, split-half and paired comparisons.
No coverage-summary or decile values are supplied because computing them without estimated MSE would be invalid.

## Files

- `input_summary.csv`: completeness counts per round and arm.
- `samples_lacking_variance.csv`: all sample IDs lacking the required saved uncertainty.
- `sample_input_audit.csv`: file-level columns and availability audit.
- `control_status.csv`: failed prerequisite, integrity check and unexecuted scoring controls.
- `existing_outputs_integrity.csv`: content hash evidence that original files were preserved.
- `audit.log`: audit process log.
