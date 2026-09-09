# Item 6 — ELL with the random effect at cluster level

Code to re-estimate ELL with the random effect at **cluster (PSU)** level instead of
**municipality** level, and to score both against the census truth, for all five rounds
(MEX 2010/2015/2020, BRA 2000/2010).

Written for someone who has the data and none of the project context.

---

## 1. This is a subset, on purpose

This is **not** the project codebase. It is only what the ELL path touches.

The full tree carries six known hard defects, hard-coded paths to drives that exist on one
machine, and scripts that cannot execute against the censuses they name. Several of those
defects **fail silently** — they produce plausible wrong numbers rather than an error. Handing
over the whole thing would mean inheriting all of that to run one model.

So: the ELL estimation path, the scoring, and the shared configuration. Nothing else. If you go
looking for the EBP, BRF, sub-area or Fay–Herriot code, it is deliberately not here — ask
David rather than assuming it was forgotten.

**The scoped set is clean.** Both project-wide checks were run over exactly these files:

| check | what it looks for | result |
|---|---|---|
| constants check | per-round constants transcribed by hand instead of read from configuration | **clean — none** |
| wrong-year scan | a script whose hard-coded year disagrees with the round it processes | **clean — no hard-coded years, and no `.do` files in scope** |

Neither check applies vacuously: the first is the check that caught a poverty threshold copied
from MEX2015 into MEX2020, which had survived in seven scripts; the second found two of the six
hard defects elsewhere in the package.

---

## 2. What you need

**R.** Developed and measured on **R 4.5.3**. Packages: `haven`, `digest`, and `povmap`.

**povmap — use the pinned build.**

```
remotes::install_github("SSA-Statistical-Team-Projects/povmap", ref = "b635434")
```

That is povmap **1.0.0** at commit `b635434`, the build the project's estimates were produced
against.

**You do not need any patched build for item 6.** The project keeps a variant carrying a fix for
an internal issue, but that fix touches only `point_estim` and `update_sigma2`, which are on the
EBP path. A full namespace comparison of the two builds (346 objects, ~13,800 lines) shows they
differ in exactly two places, and neither `point_estim(` nor `update_sigma2(` is called anywhere
in `ell()`, `framework_ell()` or `point_estim_ell()`. So for ELL the plain pin and the patched
build are identical in effect.

If povmap and its dependencies live in different library directories, set `POVMAP_LIB` to all of
them separated by `;` (Windows) or `:` (macOS/Linux). If everything is in your normal user
library, leave it unset.

---

## 3. Point it at your data

The code resolves everything from **one** root — the directory that contains `MEX/` and `BRA/`.
Set it either way:

```bash
export SAE_ROOT=/path/to/data          # macOS / Linux
setx SAE_ROOT D:\path\to\data          # Windows, new shell afterwards
```

or create a file `code/config.local` containing that one path.

There are no absolute paths anywhere in the scripts you run. If a path is wrong you get a named
error listing which input is missing, not a failure deep inside povmap.

---

## 4. Check your data matches ours first

**Do this before anything else.** If the inputs differ, everything downstream differs, and the
difference will look like a modelling result rather than a data mismatch.

```bash
Rscript code/verify_manifest.R --quick     # sizes only, seconds
Rscript code/verify_manifest.R             # full SHA-256, ~2-3 min for ~32 GB
```

Exit status is 0 when everything matches and 1 otherwise, so it can gate a pipeline — verified
both ways, including against a deliberately corrupted manifest. The full check needs the `digest`
package; `--quick` does not. `data_manifest.csv` carries a SHA-256
for every file the ELL path reads: the census, the truth file, the 100 drawn samples, and the
per-sample `betavars_selected` and `alphavars_selected` predictor lists, for each of the five
rounds. **No data is transferred — hashes only.**

Result directories are deliberately not hashed. See §8.

---

## 5. Running it

Start small. One round, five samples, low `L`:

```bash
Rscript code/run_all.R --rounds MEX2010 --to 5 --L 10
```

Then the real thing — all five rounds, both arms, `L = 100`:

```bash
Rscript code/run_all.R
```

**It is resumable.** Any sample whose output already exists is skipped, so an interruption costs
one sample. Delete an output file to force a recompute.

Individual pieces, if you prefer:

```bash
Rscript code/ell_cluster.R --round MEX2010 --re psu --to 100 --L 100
Rscript code/ell_cluster.R --round MEX2010 --re mun --to 100 --L 100
Rscript code/score_ell.R --round MEX2010 \
  --dir  <root>/MEX/2010/full_census_new/results/results_ell_psu/unit/output --label cluster-RE \
  --compare <root>/MEX/2010/full_census_new/results/results_ell_mun/unit/output --compare-label municipality-RE
```

Outputs go to **new** directories — `results_ell_psu/` and `results_ell_mun/` — and never touch
the published `results_ell/`.

---

## 6. What each script does

| file | what it does |
|---|---|
| `round_config.R` | Per-round constants and paths. Resolves `SAE_ROOT`, asserts every input exists, and refuses to proceed if two rounds share a poverty threshold. |
| `round_constants.csv` | The constants themselves, with a SHA-256 of each source script they were read from. See §9. |
| `ell_cluster.R` | The estimation. `--re psu` for cluster-level, `--re mun` for the published baseline. |
| `score_ell.R` | MAE / RMSE / bias / rank correlation against census truth, equal- and population-weighted, with **paired** Monte Carlo errors when comparing two arms. |
| `run_all.R` | Driver: rounds × arms, then scoring. |
| `probe_cluster_feasible.R` | One sample, reports timing and checks the output really is at municipality level. Run this first on a new machine. |
| `verify_manifest.R` | Checks your data against `data_manifest.csv`. |
| `provenance/` | Two generators that produced `round_constants.csv` and `data_manifest.csv`. **They ran on the reference machine and contain absolute paths — they are here as a record, not to be run.** |

---

## 7. What actually changes for item 6

The published ELL scripts put the random effect at municipality level:

```r
pop_domains = "mun_id",  smp_domains = "mun_id"
```

In povmap the domain arguments **are** the random-effect level. So the change is to point them at
the cluster **and** to add `aggregate_to`, which is population-side and controls only the level
results are reported at:

```r
pop_domains = "psu_id",  smp_domains = "psu_id",  aggregate_to = "mun_id"
```

Without `aggregate_to` you get PSU-level output, which is not comparable to anything in the paper.
This was read out of `framework_ell()` and then confirmed by running it: output came back with
exactly one row per municipality.

Everything else — alpha model, `rescale_weights`, `errors = "nonnormal"`, `transformation = "no"`,
`L`, threshold, seed — is held at the published values. Running the baseline through this same
script with `--re mun` is what makes the comparison attributable to the random-effect level and
nothing else.

`ell_cluster.R` checks that PSU nests inside municipality before running, and stops if it does
not, rather than letting `aggregate_to` do something ambiguous.

### The alpha model

ELL needs **two** predictor lists per sample: `betavars_selected` for the mean model and
`alphavars_selected` for the Elbers–Lanjouw heteroskedasticity model. The EBP path uses only the
first. `round_config.R` fails immediately if the sample, beta and alpha counts disagree — an
unequal alphavars directory would otherwise surface as an out-of-range subscript somewhere around
sample 87.

### Scale — read this before launching all five rounds

Moving to the cluster multiplies the number of domains, and by very different factors:

| round | census PSUs | municipalities | ratio |
|---|---|---|---|
| MEX2010 | 177,957 | 2,456 | **72x** |
| MEX2015 | 273,773 | 2,457 | **111x** |
| MEX2020 | 252,558 | 2,469 | **102x** |
| BRA2000 | 9,336 | 5,507 | 1.7x |
| BRA2010 | 10,184 | 5,565 | 1.8x |

The Brazilian PSUs are much coarser than the Mexican ones — under two per municipality against
roughly seventy. "Cluster" therefore means a materially different thing in the two countries, and
that is worth a sentence in the annex rather than being left implicit.

### Measured cost

Per-sample times are in the table below. For 100 samples that is roughly **3-6 hours per round per
arm**, about **24 hours for one arm across all five rounds**, and about **44 hours for both arms**.
Comfortably affordable; it does not need a cluster.

**Cost is driven by census size, not by the number of domains.** BRA2010 has 17x fewer PSUs than
MEX2010 and still takes nearly twice as long, because its census is more than twice as large. An
earlier draft of this note claimed the Mexican rounds would be the expensive ones because of their
100x domain count. That was wrong, and measurement corrected it.

**Runtime is almost flat in `L`.** Measured on MEX2010 sample 1: L=2 took 55.2 s, L=10 took 59.1 s,
L=100 took about 114 s. Roughly 54 s is fixed — loading the census and building the domain
structure — and only about 0.5 s is added per unit of `L`. Do not estimate a production cost by
scaling a low-`L` run proportionally: doing that once predicted 46 min/sample against an actual
2 min. Note that memory behaves the *opposite* way, tracking the design matrix almost
proportionally, which is why both were measured rather than one inferred from the other.

### Running samples in parallel — and why not five

Estimation is single-threaded (§10), so the only way to go faster is to run **several samples at
once as separate R processes**. Nothing in povmap needs to change for that. The constraint is
memory.

**Measured peak resident memory and wall time — all five rounds, sample 2, cluster arm, `L = 100`,
on one 64 GB Xeon workstation. Nothing here is interpolated.**

| round | census rows | design width | peak RAM | min/sample |
|---|---|---|---|---|
| MEX2010 | 2.90M | 103 | **13.5 GB** | 1.9 |
| MEX2020 | 4.02M | 101 | **18.8 GB** | 2.5 |
| BRA2010 | 6.19M | 78 | **21.4 GB** | 3.3 |
| BRA2000 | 5.30M | 81 | **21.6 GB** | 2.9 |
| MEX2015 | 5.85M | 103 | **27.9 GB** | 3.7 |

**Memory depends on your MODEL as well as your census.** It tracks the size of the census design
matrix — rows times predictor columns — not rows alone. BRA2010 has the largest census of the five
and still uses less memory than MEX2015, because its model is 78 columns wide against 103.

    peak GB  ≈  0.046  ×  (census rows in millions)  ×  (design-matrix columns)

Across the five rounds that coefficient ranges **0.044 to 0.050**, so treat it as ±10%, not as a
precise formula. Use the measured peak for a round you are running as specified; use the
coefficient when you change the specification, since the table above no longer applies then.

**This matters more than it looks.** The predictor set is re-selected on every sample — on MEX2010
the beta list ranges from 89 to 126 terms across the 100 samples — so the peak moves from sample to
sample even within one round. A single per-round number is a planning figure, not a guarantee.

**The cluster-level change itself does not alter the predictor count**, so if you hold the
specification fixed your peaks should land near the table above. If you are an order of magnitude
out, something differs beyond the machine, and that is worth chasing before you run at scale.

**Work out your own worker count; do not copy ours.** It is a property of your machine:

    workers  ≈  (available RAM  −  a few GB of headroom)  /  peak for that round

On a 64 GB machine that is **about two processes** — two large rounds will not fit together, one
small with one large generally will. That takes both arms of all five rounds from roughly **44
hours to roughly 23**: a halving, **not** a fivefold speed-up. Plan on that.

> **A warning about the published driver.** Some of the published ELL/EBP scripts open five
> workers by default:
>
> ```r
> cl <- makeCluster(5); registerDoParallel(cl)
> elllist <- foreach(i = 1:100, .packages = c("haven","povmap")) %dopar% { ... }
> ```
>
> **At these census sizes that default cannot run.** Five concurrent MEX2015 processes would need
> about 140 GB. Anyone reading that script will reasonably infer that five-way parallelism is
> safe, and it is not — so treat the `5` as a number to recompute from the table above, not to
> copy. An over-subscribed `makeCluster` does not always fail cleanly: it can swap, stall, or
> return a worker error that reads as a package problem. See §10 for the separate `R_LIBS` trap
> the same construct triggers.

### A first-run check

On MEX2010 sample 1, cluster-RE against the published municipality-RE ELL:

- **correlation 0.995**, **mean absolute difference 0.020**

Expect something close to that. It is the right shape of answer: clearly different, which is the
point of item 6, but plainly the same quantity. If your correlation is far from this, or the mean
absolute difference is an order of magnitude out, stop and check the setup before running at scale.

### One round has incomplete coverage, and it is not new

**MEX2015 returns 2,446 municipalities, not the 2,457 in its census.** Those same 11 are absent
from the *published* ELL output too, and they are present in the census and in the truth file. It
is a property of that round's data, not of the cluster-level change — the cluster-RE and published
municipality-RE runs agree exactly on coverage. MEX2010 returns all 2,456. Do not spend time
hunting it; raise it with David if it matters for the annex.

---

## 8. Our estimates were produced across two eras

The published estimates were **not** all produced at the same time or with the same build:

- **Mexican rounds — April and May 2024**
- **Brazilian rounds — July 2025**

**A build matching those runs no longer exists.** If you compare your output against published
numbers, do not be surprised by small differences, and do not spend time hunting for a bug in
your setup. Differences of that kind are expected. The comparison that *is* controlled is the one
this code produces: cluster-RE against municipality-RE, both estimated here, on the same build, on
the same day.

That is also why `data_manifest.csv` covers inputs only. A hash mismatch on inputs is a real
problem; a mismatch on results directories would be expected and would tell you nothing.

---

## 9. Verifying provenance

`round_constants.csv` carries each round's threshold, domain and weight variables, sample
directory, and a SHA-256 of the two published scripts they were read from — the EBP script the
constants come from and the ELL script item 6 modifies.

The working copy of `round_config.R` reads those constants directly out of the published scripts
every time it runs, so nothing is transcribed by hand. That design exists because a hand-copied
MEX2015 threshold once reached the MEX2020 slot and survived in seven scripts and 400 completed
sample-arms, producing plausible wrong numbers and no error. The read needs a path that exists on
one machine, so here the **read happens at packaging time** and the result is shipped with hashes.

The generator also cross-checks the threshold it read from each EBP script against the one
hard-coded in the same round's ELL script, and refuses to write the file if they disagree. That
check passed for all five rounds.

**Hashes are taken over line-ending-normalised content (CR stripped), not raw bytes.** The repo
stores LF and the working copies are CRLF, so a raw-byte hash reports every file as differing and
is useless as a check. Data files in `data_manifest.csv` are hashed raw — they are binary `.dta`
and must match exactly.

To verify, strip CR before hashing:

```bash
git show <branch>:Code/Rcode/<path> | tr -d '
' | sha256sum
```

**Measured against this repo on 2026-09-09:**

| branch | scripts matching what the constants were read from |
|---|---|
| `david` | **9 of 10** |
| `master` | 2 of 10 |

The single mismatch on `david` is `MEX/240326_ELL_models_MEX_full_all_2010.R`: the repo version
parallelises its sample loop with `makeCluster(5)` + `foreach %dopar%` where the copy read here
uses a plain `for` loop. The model call itself is unchanged. See §10 for why that matters.

`master` was last touched in September 2024 and is stale in content, not merely in date — which
is why this handoff is branched from `david`.

---

## 10. Two traps that do not apply here, and why

Both are documented because each produces an error that reads as your own mistake, and each would
bite the moment this scope widens.

**`R_LIBS` and parallel workers — read this if you open the published scripts.**
`parallel::makeCluster` workers start fresh R sessions with default library paths; a `.libPaths()`
call in the parent does not reach them. It surfaces as `50 nodes produced errors; no package
called 'BBmisc'`, naming a package you have already installed, so it reads as a broken install of
your own rather than a path problem.

*povmap's ELL internals are single-threaded* — `ell()`, `framework_ell()` and `point_estim_ell()`
contain no parallel constructs and take no `cpus` argument, checked rather than assumed. **But
some of the published DRIVER scripts are parallel.** The copy of
`Code/Rcode/MEX/240326_ELL_models_MEX_full_all_2010.R` on the `david` branch wraps its sample loop
in `makeCluster(5)` + `foreach(..., .packages = c("haven","povmap")) %dopar%`, and both BRA EBP
scripts do the same. If you run one of those, the trap is live and `povmap` must be findable from
a worker's *default* library paths.

**`ell_cluster.R` in this handoff is a serial loop, so the trap does not arise here.** It becomes
live if you parallelise it or add an MSE bootstrap.

**`mata mlib index`.** Stata indexes `.mlib` files from the adopath at startup, so an adopath added
afterwards needs `mata: mata mlib index` or the ado loads and then dies with
`mainFayHerriot() not found`. **No Stata is in scope here**, so it does not arise.

---

## 11. If something goes wrong

- **`SAE_ROOT is not set`** — §3.
- **A named missing input** — `SAE_ROOT` is probably one level too high or too low. The error
  lists the paths it tried.
- **`sample / betavars / alphavars counts disagree`** — the three directories are not aligned;
  do not work around it.
- **`psu_id does not nest inside mun_id`** — stop and raise it. `aggregate_to` would be ambiguous.
- **`there is no package called ...`** — §2, `POVMAP_LIB` may need several paths.
- **Verification failures** — resolve before estimating, not after.
