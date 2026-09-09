## make_manifest.R -- GENERATOR. Produces data_manifest.csv: a SHA-256 for every input the
## item 6 ELL path reads. Run on the machine holding the reference copy of the data.
##
## Minh runs verify_manifest.R against her copy. No data is transferred -- only hashes.
##
## SCOPE. Exactly the files ell_cluster.R and score_ell.R open, and nothing else:
##   census/census.dta                the population frame
##   simcensus/true_fg0_full.dta      the scoring target
##   <sample dir>/*.dta               the 100 drawn samples
##   betavars_selected/*.dta          per-sample beta predictor lists
##   alphavars_selected/*.dta         per-sample alpha predictor lists (ELL-specific)
##
## Results directories are deliberately NOT hashed. They are outputs, they differ between the two
## eras the estimates were produced in, and a mismatch there would be expected rather than
## informative. The README explains the era split.
##
## Full SHA-256 throughout, measured at ~226 MB/s on the reference machine, so roughly 2-3 minutes
## for the ~32 GB in scope. Size alone was rejected: two .dta files of equal length with different
## contents is exactly the case this is meant to catch.
##
## Usage: Rscript make_manifest.R

.libPaths(c("D:/sae_work/rlib_repro", "G:/David/R/R-4.4.0", "G:/David/R/R-4.5.3/library"))
if (!requireNamespace("digest", quietly = TRUE)) stop("package 'digest' is required")
HERE <- local({ a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd() })
Sys.setenv(SAE_ROOT = "H:/david/SAE/SAE_research_with_Melany")
source(file.path(dirname(HERE), "round_config.R"))
## HERE is code/provenance/, so the package root is two levels up.
OUT <- file.path(dirname(dirname(HERE)), "data_manifest.csv")
ROUNDS <- c("MEX2010", "MEX2015", "MEX2020", "BRA2000", "BRA2010")
root <- sae_root()

rows <- list(); t0 <- Sys.time(); tot <- 0
add <- function(rnd, kind, abs_path) {
  rel <- sub(paste0("^", gsub("([.|()\\^{}+$*?\\[\\]])", "\\\\\\1", root), "/"), "", gsub("\\\\", "/", abs_path))
  sz <- file.size(abs_path)
  tot <<- tot + sz
  rows[[length(rows) + 1]] <<- data.frame(round = rnd, kind = kind, rel_path = rel,
    bytes = sz, sha256 = digest::digest(file = abs_path, algo = "sha256"), stringsAsFactors = FALSE)
}

for (r in ROUNDS) {
  cfg <- round_config(r)
  cat(sprintf("%s ... ", r)); flush.console()
  add(r, "census", file.path(cfg$dir, "census/census.dta"))
  add(r, "truth",  cfg$truth)
  for (k in c("samples", "betavars", "alphavars")) {
    d <- file.path(cfg$dir, switch(k, samples = cfg$smp, betavars = cfg$betavars, alphavars = cfg$alphavars))
    fs <- sort(list.files(d, pattern = "[.]dta$", full.names = TRUE))
    for (f in fs) add(r, k, f)
  }
  cat(sprintf("%d files\n", sum(vapply(rows, function(z) z$round == r, logical(1)))))
}
M <- do.call(rbind, rows)
write.csv(M, OUT, row.names = FALSE)
el <- as.numeric(difftime(Sys.time(), t0, units = "mins"))
cat(sprintf("\nwrote %s\n  %d files, %.1f GB, %.1f min (%.0f MB/s)\n", OUT, nrow(M),
            tot / 2^30, el, tot / 2^20 / (el * 60)))
print(table(M$round, M$kind))
