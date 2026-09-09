## gen_round_constants.R -- GENERATOR, runs on David's machine only. Not shipped to run.
##
## WHY. The working round_config.R READS each per-round constant out of the published estimation
## script rather than carrying a transcribed table, because a transcribed MEX2015 threshold once
## reached the MEX2020 slot and survived in seven scripts and 400 sample-arms. That design is
## right, but it depends on G:/David/SAE_reproductivity_package, which exists on one machine.
##
## So the property is preserved by MOVING WHEN THE READ HAPPENS, not by dropping it. This script
## performs the read HERE, records what it read together with a SHA-256 of every source file, and
## writes round_constants.csv. The shipped round_config.R consumes that file and re-asserts.
##
## THE HASH IS THE POINT. The co-author is unsure the GitHub repo carries the current versions of
## the published scripts. If the repo's copies differ from the ones read here, citing them by PATH
## would be a claim that quietly stops being true. A hash makes the divergence detectable: anyone
## with both copies can compare, and the README says how.
##
## Usage: Rscript gen_round_constants.R

.libPaths(c("D:/sae_work/rlib_repro", "G:/David/R/R-4.4.0", "G:/David/R/R-4.5.3/library"))
source("H:/david/SAE/SAE_research_with_Melany/output/fh_mse/code/round_config.R")
OUT <- "H:/david/SAE/SAE_research_with_Melany/output/handoff_item6/round_constants.csv"
ROUNDS <- c("MEX2010", "MEX2015", "MEX2020", "BRA2000", "BRA2010")

## HASH LINE-ENDING-NORMALISED CONTENT, NOT RAW BYTES.
## Measured against github.com/davidn10/SAEresearch: all ten source scripts hashed DIFFERENT
## from the working copies purely because the repo stores LF and the working copies are CRLF.
## Nine of the ten are byte-identical once CR is stripped. A provenance hash that always reports
## a mismatch is worse than no hash -- it trains the reader to ignore it. So the hash is taken
## over content with CR removed, which is what "is this the same script" actually means here.
## (Data files in data_manifest.csv are hashed RAW: they are binary .dta and must match exactly.)
sha_text <- function(p) {
  x <- readBin(p, "raw", file.size(p))
  x <- x[x != as.raw(13)]
  if (requireNamespace("digest", quietly = TRUE))
    return(digest::digest(x, algo = "sha256", serialize = FALSE))
  NA_character_
}
sha <- function(p) {
  if (requireNamespace("digest", quietly = TRUE)) return(digest::digest(file = p, algo = "sha256"))
  ## no digest package: fall back to certutil, which ships with Windows. Reported either way.
  o <- tryCatch(system2("certutil", c("-hashfile", shQuote(normalizePath(p)), "SHA256"),
                        stdout = TRUE, stderr = FALSE), error = function(z) NULL)
  if (is.null(o) || length(o) < 2) return(NA_character_)
  gsub("[^0-9a-fA-F]", "", o[2])
}

rows <- lapply(ROUNDS, function(r) {
  cfg <- round_config(r)
  ## The ELL scripts are separate files from the EBP ones round_config reads. Both are hashed:
  ## the EBP script is where the constants come from, the ELL script is what item 6 modifies.
  ell_src <- list(
    MEX2010 = "MEX/240326_ELL_models_MEX_full_all_2010.R",
    MEX2015 = "MEX/240326_ELL_models_MEX_full_all_2015.R",
    MEX2020 = "MEX/240326_ELL_models_MEX_full_all_2020.R",
    BRA2000 = "BRA/240605_ELL_models_BRA_full_all_2000.R",
    BRA2010 = "BRA/240608_ELL_models_BRA_full_all_2010.R")[[r]]
  ell_path <- file.path(PKG, ell_src)
  if (!file.exists(ell_path)) stop(sprintf("gen_round_constants[%s]: ELL source missing -- %s", r, ell_path))

  ## CROSS-CHECK. The threshold read from the EBP script must equal the one hard-coded in the ELL
  ## script for the same round, because it is a poverty line and does not depend on the method.
  ## If they disagree, one of them is wrong and this must not silently pick a side.
  et <- readLines(ell_path, warn = FALSE)
  m <- unlist(regmatches(et, gregexpr("threshold[ ]*=[ ]*[0-9][0-9.]*", et)))
  ell_thr <- unique(as.numeric(unlist(regmatches(m, regexpr("[0-9][0-9.]*", m)))))
  if (length(ell_thr) != 1)
    stop(sprintf("gen_round_constants[%s]: ELL script has %d distinct thresholds", r, length(ell_thr)))
  if (!isTRUE(all.equal(ell_thr, cfg$thr, tolerance = 1e-12)))
    stop(sprintf("gen_round_constants[%s]: THRESHOLD DISAGREEMENT -- EBP script %.10f, ELL script %.10f",
                 r, cfg$thr, ell_thr))

  data.frame(round = r, dir_rel = sub("^.*SAE_research_with_Melany/", "", cfg$dir),
             threshold = sprintf("%.10f", cfg$thr),
             pop_domains = cfg$pop_domains, smp_domains = cfg$smp_domains,
             pop_weights = cfg$pop_weights, weights = cfg$weights,
             smp_dir = cfg$smp, betavars_dir = cfg$betavars,
             alphavars_dir = "alphavars_selected",
             truth_rel = "simcensus/true_fg0_full.dta",
             n_samples = cfg$n_samples,
             ebp_source = sub("^.*Rcode/", "", cfg$source), ebp_sha256 = sha_text(cfg$source),
             ell_source = ell_src, ell_sha256 = sha_text(ell_path),
             stringsAsFactors = FALSE)
})
D <- do.call(rbind, rows)

if (anyDuplicated(D$threshold))
  stop("gen_round_constants: DUPLICATE THRESHOLD across rounds -- the MEX2020 error class")
write.csv(D, OUT, row.names = FALSE)
cat(sprintf("wrote %s\n\n", OUT))
print(D[, c("round", "threshold", "smp_dir", "n_samples", "ell_source")], row.names = FALSE)
cat("\nthreshold cross-check EBP script vs ELL script: PASSED for all five rounds\n")
cat(sprintf("hashes recorded: %d of %d source files\n", sum(!is.na(D$ebp_sha256)) + sum(!is.na(D$ell_sha256)),
            2 * nrow(D)))
