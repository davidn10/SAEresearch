## ell_cluster.R -- ELL with the random effect at CLUSTER level, for item 6.
##
## WHAT CHANGES relative to the published ELL scripts. They specify the random effect at
## municipality level:
##
##     pop_domains = "mun_id",  smp_domains = "mun_id"
##
## Item 6 moves it to the cluster. In povmap the domain arguments ARE the random-effect level, so
## the change is to point them at the cluster id AND to add aggregate_to, which is population-side
## and controls only the level results are REPORTED at:
##
##     pop_domains = "psu_id",  smp_domains = "psu_id",  aggregate_to = "mun_id"
##
## Without aggregate_to you get PSU-level output, which is not comparable to anything in the
## paper. This was read out of framework_ell() and then verified by running it: output came back
## with exactly one row per municipality.
##
## Everything else is held at the published values -- alpha model, rescale_weights, errors,
## transformation, L, threshold, seed -- so the arms differ in the random-effect level and
## nothing else. Set --re mun to reproduce the published specification through this same script,
## which is the honest way to build the comparison: one code path, one difference.
##
## SCALE WARNING, measured not assumed. Moving to the cluster multiplies the number of domains:
##
##   round     census PSUs   municipalities   ratio
##   MEX2010      177,957          2,456       72x
##   MEX2015      273,773          2,457      111x
##   MEX2020      252,558          2,469      102x
##   BRA2000        9,336          5,507      1.7x
##   BRA2010       10,184          5,565      1.8x
##
## Mexico is where the cost lands. See the README for measured timings before committing to a
## full 100-sample run.
##
## OUTPUT FORMAT matches the published ELL scripts -- one .dta per sample with columns
## area / fgt -- so anything that already reads results_ell/unit/output reads these unchanged.
##
## Usage:
##   Rscript ell_cluster.R --round MEX2010 [--re psu] [--from 1] [--to 100] [--L 100]
##                         [--out <dir>] [--lib <povmap library path>]

args <- commandArgs(trailingOnly = TRUE)
getarg <- function(k, default = NULL) {
  i <- match(paste0("--", k), args)
  if (is.na(i) || i == length(args)) return(default)
  args[i + 1]
}
RND  <- getarg("round")
RE   <- getarg("re", "psu")
FROM <- as.integer(getarg("from", "1"))
TO   <- as.integer(getarg("to", "100"))
LL   <- as.integer(getarg("L", "100"))
OUT  <- getarg("out", NULL)
LIB  <- getarg("lib", Sys.getenv("POVMAP_LIB", ""))

if (is.null(RND)) stop("--round is required (MEX2010 MEX2015 MEX2020 BRA2000 BRA2010)", call. = FALSE)
if (!(RE %in% c("psu", "mun")))
  stop("--re must be 'psu' (cluster, item 6) or 'mun' (published baseline)", call. = FALSE)

## POVMAP_LIB (or --lib) may name SEVERAL library directories separated by the platform path
## separator; povmap and its dependencies do not always live in the same place. Leave it unset if
## everything is in your normal user library.
if (nzchar(LIB)) .libPaths(c(strsplit(LIB, .Platform$path.sep, fixed = TRUE)[[1]], .libPaths()))
suppressMessages({ library(haven); library(povmap) })
HERE <- local({
  a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd()
})
source(file.path(HERE, "round_config.R"))
cfg <- round_config(RND)

DOM  <- if (RE == "psu") "psu_id" else "mun_id"
AGG  <- if (RE == "psu") "mun_id" else NULL
if (is.null(OUT)) OUT <- file.path(cfg$dir, "results", paste0("results_ell_", RE), "unit", "output")
dir.create(OUT, recursive = TRUE, showWarnings = FALSE)

cat(sprintf("ELL | round %s | random effect at %s | L=%d | samples %d..%d\n",
            RND, if (RE == "psu") "CLUSTER (psu_id)" else "municipality (mun_id)", LL, FROM, TO))
cat(sprintf("  threshold %.10f   (provenance: %s, sha256 %s)\n", cfg$thr, cfg$ebp_source,
            substr(cfg$ebp_sha256, 1, 16)))
cat(sprintf("  data root %s\n  output    %s\n", cfg$dir, OUT))

setwd(cfg$dir)
census <- as.data.frame(read_dta("census/census.dta"))
## hhsize2 is used by some rounds' predictor lists but is not always stored in the files.
if (!("hhsize2" %in% names(census)) && "hhsize" %in% names(census))
  census$hhsize2 <- census$hhsize^2
for (v in unique(c(DOM, AGG, cfg$pop_weights)))
  if (!(v %in% names(census))) stop(sprintf("census lacks required column '%s'", v), call. = FALSE)

## PSU must nest inside municipality or aggregate_to is ambiguous. Checked once, here.
if (RE == "psu") {
  mx <- max(tapply(census[[AGG]], census[[DOM]], function(z) length(unique(z))))
  if (mx != 1)
    stop(sprintf(paste0("psu_id does not nest inside mun_id (max %d municipalities per PSU).\n",
                        "  aggregate_to would be ambiguous; stopping rather than guessing."), mx),
         call. = FALSE)
  cat("  nesting check: psu_id nests inside mun_id, aggregate_to well defined\n")
}

mb <- list.files(cfg$betavars,  pattern = "[.]dta$")
ma <- list.files(cfg$alphavars, pattern = "[.]dta$")
ms <- list.files(cfg$smp,       pattern = "[.]dta$")
TO <- min(TO, length(ms))
cat(sprintf("  samples on disk %d | betavars %d | alphavars %d\n\n", length(ms), length(mb), length(ma)))

for (i in seq(FROM, TO)) {
  dest <- file.path(OUT, paste0("sim_ebp_", ms[i]))
  if (file.exists(dest)) { cat(sprintf("  sample %3d  already done, skipping\n", i)); next }
  t0 <- Sys.time()
  bv <- colnames(as.data.frame(read_dta(file.path(cfg$betavars,  mb[i]))))
  av <- colnames(as.data.frame(read_dta(file.path(cfg$alphavars, ma[i]))))
  smp <- as.data.frame(read_dta(file.path(cfg$smp, ms[i])))
  if (!("hhsize2" %in% names(smp)) && "hhsize" %in% names(smp)) smp$hhsize2 <- smp$hhsize^2
  f_beta  <- as.formula(paste0("ln_pchinc ~ ", paste(bv, collapse = " + ")))
  f_alpha <- as.formula(paste0("~ ", paste(av, collapse = " + ")))

  set.seed(7)   # the published scripts set seed 7 once; set per sample so a restart is identical
  fit <- tryCatch(
    povmap:::ell(fixed = f_beta, alpha = f_alpha,
                 pop_data = census, pop_domains = DOM, pop_weights = cfg$pop_weights,
                 smp_data = smp, smp_domains = DOM, weights = cfg$weights,
                 aggregate_to = AGG,
                 rescale_weights = TRUE, transformation = "no", errors = "nonnormal",
                 threshold = cfg$thr, na.rm = TRUE, L = LL,
                 model_parameters = "fixed", indicators = c("Head_Count")),
    error = function(z) { cat(sprintf("  sample %3d  FAILED: %s\n", i, conditionMessage(z))); NULL })
  if (is.null(fit)) next

  sim <- data.frame(area = as.character(fit$ind$Domain),
                    fgt = as.numeric(fit$ind$Head_Count), stringsAsFactors = FALSE)
  write_dta(sim, dest)
  cf <- as.data.frame(fit$model_par$betas)
  write_dta(data.frame(names = rownames(cf), coefficients = as.numeric(cf[, 1]),
                       stringsAsFactors = FALSE),
            file.path(OUT, paste0("coef_", ms[i])))
  cat(sprintf("  sample %3d  %5.1f min | %d areas out\n", i,
              as.numeric(difftime(Sys.time(), t0, units = "mins")), nrow(sim)))
  rm(fit); invisible(gc())
}
cat("\nDONE\n")
