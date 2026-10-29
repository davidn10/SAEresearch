## verify_manifest.R -- check your copy of the data against the reference copy.
##
## RUN THIS BEFORE ANYTHING ELSE. If the inputs differ, every number downstream differs, and the
## difference will look like a modelling result rather than a data mismatch.
##
## No data moves. This compares SHA-256 hashes recorded in data_manifest.csv against hashes
## computed locally.
##
## Set SAE_ROOT first (environment variable, or a config.local file beside round_config.R).
##
##   Rscript verify_manifest.R              full hash check, ~2-3 min for ~32 GB
##   Rscript verify_manifest.R --quick      size only, seconds -- a first pass, NOT a guarantee
##   Rscript verify_manifest.R --round MEX2010     one round only
##
## Exit status is 0 when everything matches and 1 otherwise, so it can gate a pipeline.

args <- commandArgs(trailingOnly = TRUE)
QUICK <- "--quick" %in% args
ONE <- { i <- match("--round", args); if (is.na(i) || i == length(args)) NULL else args[i + 1] }
local({ L <- Sys.getenv("POVMAP_LIB", "")
  if (nzchar(L)) .libPaths(c(strsplit(L, .Platform$path.sep, fixed = TRUE)[[1]], .libPaths())) })
HERE <- local({ a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd() })
source(file.path(HERE, "round_config.R"))
root <- sae_root()

MP <- file.path(dirname(HERE), "data_manifest.csv")
if (!file.exists(MP)) MP <- file.path(HERE, "data_manifest.csv")
if (!file.exists(MP)) stop("data_manifest.csv not found", call. = FALSE)
M <- read.csv(MP, stringsAsFactors = FALSE)
if (!is.null(ONE)) M <- M[M$round == ONE, ]
if (!nrow(M)) stop("no manifest rows selected", call. = FALSE)
if (!QUICK && !requireNamespace("digest", quietly = TRUE))
  stop("package 'digest' is required for the full check; install it, or use --quick", call. = FALSE)

cat(sprintf("verifying %d files under %s\n%s\n", nrow(M), root,
            if (QUICK) "MODE: --quick, sizes only. A size match is NOT proof of identical content."
            else "MODE: full SHA-256"))
t0 <- Sys.time()
status <- character(nrow(M))
for (i in seq_len(nrow(M))) {
  p <- file.path(root, M$rel_path[i])
  if (!file.exists(p)) { status[i] <- "MISSING"; next }
  if (file.size(p) != M$bytes[i]) { status[i] <- "SIZE DIFFERS"; next }
  if (QUICK) { status[i] <- "size ok"; next }
  status[i] <- if (identical(digest::digest(file = p, algo = "sha256"), M$sha256[i]))
    "match" else "CONTENT DIFFERS"
  if (i %% 100 == 0) { cat(sprintf("  %d/%d\n", i, nrow(M))); flush.console() }
}
M$status <- status
el <- as.numeric(difftime(Sys.time(), t0, units = "mins"))

cat(sprintf("\n== summary (%.1f min) ==\n", el))
print(table(M$round, M$status))
bad <- M[!(M$status %in% c("match", "size ok")), ]
if (nrow(bad)) {
  cat(sprintf("\n%d FILE(S) DO NOT MATCH. Do not run the estimation until these are resolved.\n",
              nrow(bad)))
  print(head(bad[, c("round", "kind", "rel_path", "status")], 40), row.names = FALSE)
  if (nrow(bad) > 40) cat(sprintf("  ... and %d more\n", nrow(bad) - 40))
  cat("\n  A missing file usually means SAE_ROOT points one level too high or too low.\n")
  cat("  A content difference means the copies are genuinely different data.\n")
  quit(status = 1)
}
cat(sprintf("\nALL %d FILES MATCH%s.\n", nrow(M), if (QUICK) " ON SIZE (run without --quick to confirm)" else ""))
quit(status = 0)
