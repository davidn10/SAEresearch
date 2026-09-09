## run_all.R -- driver for item 6. One round, or all five, both arms, then scoring.
##
## Written as R rather than shell so it runs the same on Windows, macOS and Linux.
##
## THE TWO ARMS. Item 6 is a comparison, so both arms are produced by THE SAME script with one
## argument changed:
##   --re psu   random effect at cluster level   (item 6)
##   --re mun   random effect at municipality    (the published specification)
## Running the baseline through this code path rather than reusing the published outputs means the
## two arms differ in the random-effect level and in nothing else -- not in povmap version, not in
## seed, not in how the predictor lists were read. That is what makes the difference attributable.
##
## RESUMABLE. ell_cluster.R skips any sample whose output already exists, so an interrupted run
## costs one sample. Deleting an output file is how you force a recompute.
##
## Usage:
##   Rscript run_all.R                       all five rounds, both arms, L = 100
##   Rscript run_all.R --rounds MEX2010      one round
##   Rscript run_all.R --arms psu            cluster arm only
##   Rscript run_all.R --L 10 --to 5         a short trial: 5 samples at L = 10
##   Rscript run_all.R --score-only          re-score existing outputs, no estimation

args <- commandArgs(trailingOnly = TRUE)
getarg <- function(k, d = NULL) { i <- match(paste0("--", k), args)
  if (is.na(i) || i == length(args)) d else args[i + 1] }
ROUNDS <- strsplit(getarg("rounds", "MEX2010,MEX2015,MEX2020,BRA2000,BRA2010"), ",")[[1]]
ARMS   <- strsplit(getarg("arms", "psu,mun"), ",")[[1]]
LL     <- getarg("L", "100")
FROM   <- getarg("from", "1")
TO     <- getarg("to", "100")
SCOREONLY <- "--score-only" %in% args

HERE <- local({ a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd() })
source(file.path(HERE, "round_config.R"))
RSCRIPT <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")

run <- function(script, a) {
  cat(sprintf("\n>>> %s %s\n", script, paste(a, collapse = " ")))
  st <- system2(RSCRIPT, c(shQuote(file.path(HERE, script)), a))
  if (st != 0) cat(sprintf("*** %s exited %d -- continuing to the next task\n", script, st))
  st
}

cat(sprintf("item 6 driver | rounds: %s | arms: %s | L=%s | samples %s..%s%s\n",
            paste(ROUNDS, collapse = " "), paste(ARMS, collapse = " "), LL, FROM, TO,
            if (SCOREONLY) " | SCORE ONLY" else ""))
cat(sprintf("SAE_ROOT = %s\n", sae_root()))

for (r in ROUNDS) {
  cfg <- round_config(r)   # fails early, with a path, if this round's inputs are not present
  if (!SCOREONLY) for (arm in ARMS)
    run("ell_cluster.R", c("--round", r, "--re", arm, "--from", FROM, "--to", TO, "--L", LL))

  d_psu <- file.path(cfg$dir, "results", "results_ell_psu", "unit", "output")
  d_mun <- file.path(cfg$dir, "results", "results_ell_mun", "unit", "output")
  has <- function(d) dir.exists(d) && length(list.files(d, pattern = "^sim_ebp_.*[.]dta$"))
  if (has(d_psu) && has(d_mun)) {
    run("score_ell.R", c("--round", r, "--dir", shQuote(d_psu), "--label", "cluster-RE",
                         "--compare", shQuote(d_mun), "--compare-label", "municipality-RE"))
  } else if (has(d_psu)) {
    run("score_ell.R", c("--round", r, "--dir", shQuote(d_psu), "--label", "cluster-RE"))
  } else if (has(d_mun)) {
    run("score_ell.R", c("--round", r, "--dir", shQuote(d_mun), "--label", "municipality-RE"))
  } else {
    cat(sprintf("  %s: no estimates found to score\n", r))
  }
}
cat("\nALL DONE\n")
