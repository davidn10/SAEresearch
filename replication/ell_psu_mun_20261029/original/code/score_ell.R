## score_ell.R -- score ELL estimates against the census truth.
##
## Scores whatever sits in a results directory, so the cluster-level and municipality-level arms
## go through the SAME scorer and differ only in the estimates. Point it at each in turn and the
## comparison is like-for-like by construction.
##
## TRUTH is simcensus/true_fg0_full.dta, variable fgt0_m -- the census poverty rate per
## municipality, the same target the published tables use.
##
## TWO WEIGHTINGS, both reported, because they answer different questions and the paper uses both:
##   eq   every municipality counts once  -- what the published MAE/RMSE tables use
##   pop  municipalities weighted by population -- what a national user experiences
## Population per municipality is computed from the census itself (sum of pop_weights), so this
## script needs no auxiliary file and cannot fall out of step with one.
##
## PAIRED comparison. When --compare is given, the two arms are differenced WITHIN each sample and
## the standard error is sd(difference)/sqrt(n). Unpaired errors would combine two marginal MCSEs
## and badly overstate the uncertainty on what is a highly correlated pair.
##
## Municipalities with a missing truth value are dropped, and the count is reported rather than
## silently absorbed.
##
## Usage:
##   Rscript score_ell.R --round MEX2010 --dir <results dir> [--label cluster]
##                       [--compare <other results dir>] [--compare-label mun] [--out <csv>]

args <- commandArgs(trailingOnly = TRUE)
getarg <- function(k, d = NULL) { i <- match(paste0("--", k), args)
  if (is.na(i) || i == length(args)) d else args[i + 1] }
RND <- getarg("round"); DIR <- getarg("dir")
LAB <- getarg("label", "arm A"); CMP <- getarg("compare"); CLAB <- getarg("compare-label", "arm B")
OUTCSV <- getarg("out", NULL)
if (is.null(RND) || is.null(DIR)) stop("--round and --dir are required", call. = FALSE)

## POVMAP_LIB may name several library directories separated by the platform path separator.
## score_ell.R needs only haven, but it must find it in the same place the estimation did.
local({ L <- Sys.getenv("POVMAP_LIB", "")
  if (nzchar(L)) .libPaths(c(strsplit(L, .Platform$path.sep, fixed = TRUE)[[1]], .libPaths())) })
suppressMessages(library(haven))
HERE <- local({ a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd() })
source(file.path(HERE, "round_config.R"))
cfg <- round_config(RND)
num <- function(z) suppressWarnings(as.numeric(as.character(z)))

tr <- as.data.frame(read_dta(cfg$truth))
truth <- data.frame(mun = as.character(num(tr$mun_id)), true = num(tr$fgt0_m), stringsAsFactors = FALSE)
nd <- sum(is.na(truth$true))
truth <- truth[!is.na(truth$true), ]
cat(sprintf("%s | truth %d municipalities%s\n", RND, nrow(truth),
            if (nd) sprintf(" (%d dropped for missing fgt0_m)", nd) else ""))

ce <- as.data.frame(read_dta(file.path(cfg$dir, "census/census.dta"),
                             col_select = c("mun_id", cfg$pop_weights)))
pop <- stats::aggregate(list(pop = num(ce[[cfg$pop_weights]])),
                        by = list(mun = as.character(num(ce$mun_id))), FUN = sum)
rm(ce); invisible(gc())
truth <- merge(truth, pop, by = "mun")
cat(sprintf("  population attached for %d municipalities\n", nrow(truth)))

score_dir <- function(d, lab) {
  fs <- sort(list.files(d, pattern = "^sim_ebp_.*[.]dta$", full.names = TRUE))
  if (!length(fs)) stop(sprintf("no sim_ebp_*.dta in %s", d), call. = FALSE)
  out <- lapply(seq_along(fs), function(k) {
    e <- as.data.frame(read_dta(fs[k]))
    m <- merge(truth, data.frame(mun = as.character(num(e$area)), est = num(e$fgt),
                                 stringsAsFactors = FALSE), by = "mun")
    m <- m[is.finite(m$est), ]
    err <- m$est - m$true; ae <- abs(err)
    data.frame(round = RND, arm = lab, sim = k, file = basename(fs[k]), n_mun = nrow(m),
               mae_eq = mean(ae), mae_pop = sum(m$pop * ae) / sum(m$pop),
               rmse_eq = sqrt(mean(err^2)), bias_eq = mean(err),
               rankcor = suppressWarnings(cor(m$est, m$true, method = "spearman")),
               stringsAsFactors = FALSE)
  })
  do.call(rbind, out)
}

A <- score_dir(DIR, LAB)
cat(sprintf("\n== %s : %s ==\n", LAB, DIR))
cat(sprintf("  samples scored %d | municipalities per sample %d\n", nrow(A), A$n_mun[1]))
sumline <- function(z) {
  for (v in c("mae_eq", "mae_pop", "rmse_eq", "bias_eq", "rankcor"))
    cat(sprintf("  %-8s mean %10.6f   MCSE %9.6f\n", v, mean(z[[v]]), sd(z[[v]]) / sqrt(nrow(z))))
}
sumline(A)
R <- A

if (!is.null(CMP)) {
  B <- score_dir(CMP, CLAB)
  cat(sprintf("\n== %s : %s ==\n", CLAB, CMP))
  cat(sprintf("  samples scored %d\n", nrow(B)))
  sumline(B)
  R <- rbind(A, B)
  cat(sprintf("\n== PAIRED %s minus %s ==\n", LAB, CLAB))
  k <- intersect(A$sim, B$sim)
  if (length(k) < 2) {
    cat("  fewer than 2 shared samples; no paired comparison\n")
  } else {
    a <- A[match(k, A$sim), ]; b <- B[match(k, B$sim), ]
    cat(sprintf("  paired on %d samples\n", length(k)))
    for (v in c("mae_eq", "mae_pop", "rmse_eq", "rankcor")) {
      d <- a[[v]] - b[[v]]; se <- sd(d) / sqrt(length(d))
      cat(sprintf("  %-8s diff %+10.6f  paired MCSE %9.6f  t %+7.2f  %s\n", v, mean(d), se,
                  mean(d) / se, if (abs(mean(d) / se) < 2) "inside MCSE" else "outside MCSE"))
    }
    cat("  negative mae/rmse favours the FIRST arm; positive rankcor favours the FIRST arm.\n")
  }
}

if (is.null(OUTCSV)) OUTCSV <- file.path(dirname(DIR), sprintf("score_%s.csv", RND))
write.csv(R, OUTCSV, row.names = FALSE)
cat(sprintf("\nwrote %s\n", OUTCSV))
