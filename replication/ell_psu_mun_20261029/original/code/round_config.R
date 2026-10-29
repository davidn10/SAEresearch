## round_config.R -- per-round configuration for the item 6 handoff.
##
## PORTABLE VARIANT. The working copy of this module reads every per-round constant directly out
## of the published estimation scripts, so that nothing is transcribed by hand. That design exists
## for a reason: a hand-copied MEX2015 poverty threshold once reached the MEX2020 slot and survived
## in seven scripts and 400 completed sample-arms, producing plausible wrong numbers and no error.
##
## The read requires a path that exists on one machine. Rather than drop the property, the READ
## HAPPENS EARLIER: gen_round_constants.R performs it at packaging time and writes
## round_constants.csv, recording a SHA-256 of every source script it read. This module consumes
## that file and RE-ASSERTS everything it can check locally.
##
## So the guarantee you get is: these constants were read, not typed, and you can verify which
## files they were read from. See "Verifying provenance" in the README.
##
## ROOT RESOLUTION -- the one thing you must set. In order:
##   1. environment variable SAE_ROOT
##   2. a file named config.local beside this script, containing one line: the root path
##   3. otherwise an error that tells you both options
## The root is the directory that contains MEX/ and BRA/.

## WHERE THIS FILE LIVES -- resolved ONCE, AT SOURCE TIME, and relative to round_config.R itself
## rather than to whatever script happens to be running. Doing it lazily and from commandArgs()
## breaks the moment someone sources this from a script of their own in another directory: the
## path resolves to THEIR directory and round_constants.csv is reported missing. `ofile` is only
## present in the source() frame, so it has to be captured here, not inside a function called later.
.ITEM6_DIR <- local({
  d <- NULL
  for (i in seq_len(sys.nframe())) {
    o <- tryCatch(get("ofile", envir = sys.frame(i), inherits = FALSE), error = function(e) NULL)
    if (!is.null(o) && nzchar(o)) { d <- dirname(normalizePath(o, mustWork = FALSE)); break }
  }
  if (is.null(d)) {
    a <- commandArgs(trailingOnly = FALSE)
    f <- sub("^--file=", "", a[grep("^--file=", a)])
    d <- if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd()
  }
  d
})
.item6_here <- function() .ITEM6_DIR

sae_root <- function() {
  r <- Sys.getenv("SAE_ROOT", "")
  if (!nzchar(r)) {
    cl <- file.path(.item6_here(), "config.local")
    if (file.exists(cl)) {
      r <- trimws(readLines(cl, warn = FALSE)[1])
    }
  }
  if (!nzchar(r)) {
    stop(paste0(
      "SAE_ROOT is not set.\n",
      "  Set it one of two ways:\n",
      "    (a) environment variable, e.g.  Sys.setenv(SAE_ROOT = \"D:/sae_data\")\n",
      "    (b) create a file 'config.local' beside round_config.R containing that path\n",
      "  The root is the directory that contains MEX/ and BRA/."), call. = FALSE)
  }
  r <- gsub("\\\\", "/", r)
  if (!dir.exists(r))
    stop(sprintf("SAE_ROOT points at '%s', which does not exist.", r), call. = FALSE)
  if (!dir.exists(file.path(r, "MEX")) && !dir.exists(file.path(r, "BRA")))
    stop(sprintf(paste0("SAE_ROOT '%s' contains neither MEX/ nor BRA/.\n",
                        "  It should be the directory holding the country folders."), r), call. = FALSE)
  r
}

.item6_constants <- function() {
  ## The data files sit at the package root while the scripts sit in code/, so look in both
  ## rather than assuming a layout. Reported with every path tried, so a wrong layout is obvious.
  h <- .item6_here()
  cand <- c(file.path(h, "round_constants.csv"),
            file.path(dirname(h), "round_constants.csv"),
            file.path(dirname(dirname(h)), "round_constants.csv"))
  p <- cand[file.exists(cand)][1]
  if (is.na(p))
    stop(sprintf("round_constants.csv not found. Looked in:
%s",
                 paste("   ", cand, collapse = "
")), call. = FALSE)
  D <- utils::read.csv(p, stringsAsFactors = FALSE, colClasses = "character")
  D$threshold <- as.numeric(D$threshold)
  D$n_samples <- as.integer(D$n_samples)
  ## The check that would have caught the original error, re-run every session.
  if (anyDuplicated(D$threshold))
    stop("round_constants.csv: DUPLICATE THRESHOLD across rounds. Do not proceed.", call. = FALSE)
  D
}

round_config <- function(rnd) {
  D <- .item6_constants()
  i <- match(rnd, D$round)
  if (is.na(i))
    stop(sprintf("round_config: unknown round '%s'. Known: %s", rnd,
                 paste(D$round, collapse = ", ")), call. = FALSE)
  root <- sae_root()
  dir <- file.path(root, D$dir_rel[i])
  cfg <- list(round = rnd, dir = dir, thr = D$threshold[i],
              pop_domains = D$pop_domains[i], smp_domains = D$smp_domains[i],
              pop_weights = D$pop_weights[i], weights = D$weights[i],
              smp = D$smp_dir[i], betavars = D$betavars_dir[i], alphavars = D$alphavars_dir[i],
              truth = file.path(dir, D$truth_rel[i]),
              n_samples_expected = D$n_samples[i],
              ebp_source = D$ebp_source[i], ebp_sha256 = D$ebp_sha256[i],
              ell_source = D$ell_source[i], ell_sha256 = D$ell_sha256[i])

  ## ---- ASSERTIONS. Fail here, with a path, rather than deep inside povmap. ----------------
  if (!is.finite(cfg$thr) || cfg$thr <= 0 || cfg$thr > 20)
    stop(sprintf("round_config[%s]: implausible threshold %s", rnd, cfg$thr), call. = FALSE)
  need <- c(census = file.path(dir, "census/census.dta"),
            samples = file.path(dir, cfg$smp),
            betavars = file.path(dir, cfg$betavars),
            alphavars = file.path(dir, cfg$alphavars),
            truth = cfg$truth)
  miss <- need[!file.exists(need) & !dir.exists(need)]
  if (length(miss))
    stop(sprintf("round_config[%s]: missing input(s) under SAE_ROOT:\n%s", rnd,
                 paste(sprintf("    %-10s %s", names(miss), miss), collapse = "\n")), call. = FALSE)
  n_s <- length(list.files(file.path(dir, cfg$smp),       pattern = "[.]dta$"))
  n_b <- length(list.files(file.path(dir, cfg$betavars),  pattern = "[.]dta$"))
  n_a <- length(list.files(file.path(dir, cfg$alphavars), pattern = "[.]dta$"))
  ## ELL needs beta AND alpha variable lists, one per sample. A short alphavars directory is the
  ## failure that would otherwise appear as an out-of-range subscript at sample 87.
  if (n_s != n_b || n_s != n_a)
    stop(sprintf(paste0("round_config[%s]: sample / betavars / alphavars counts disagree ",
                        "(%d / %d / %d).\n  ELL consumes one beta list and one alpha list per ",
                        "sample; unequal counts mean they are not aligned."),
                 rnd, n_s, n_b, n_a), call. = FALSE)
  if (n_s < cfg$n_samples_expected)
    warning(sprintf("round_config[%s]: found %d samples, packaging recorded %d",
                    rnd, n_s, cfg$n_samples_expected), call. = FALSE)
  cfg$n_samples <- n_s
  cfg
}

## Convenience: assert across rounds, as the working copy does.
assert_thresholds_distinct <- function() {
  D <- .item6_constants()
  invisible(stats::setNames(D$threshold, D$round))
}
