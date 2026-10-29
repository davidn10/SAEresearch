args <- commandArgs(trailingOnly = TRUE)
flag <- "--plan-only"
if (anyDuplicated(args[grepl("^--", args)])) stop("Repeated option")
pairs <- args[args != flag]
if (length(pairs) %% 2L) stop("Options require values")
allowed <- c("--sae-root", "--out", "--rounds", "--arms", "--samples", "--L")
if (length(pairs) && any(!pairs[seq.int(1L, length(pairs), 2L)] %in% allowed)) stop("Unknown option")
getarg <- function(key, default = NULL) {
  k <- match(paste0("--", key), args)
  if (is.na(k)) default else if (k == length(args)) stop("Missing value for ", key) else args[k + 1L]
}
data_root <- getarg("sae-root", Sys.getenv("SAE_ROOT", ""))
out <- getarg("out", "")
if (!nzchar(data_root) || !nzchar(out)) stop("--sae-root and --out are required")
if (file.exists(out) || dir.exists(out)) stop("--out must be a new directory")
rounds <- strsplit(getarg("rounds", "MEX2010,MEX2015,MEX2020,BRA2000,BRA2010"), ",", fixed = TRUE)[[1]]
arms <- strsplit(getarg("arms", "psu,mun"), ",", fixed = TRUE)[[1]]
if (any(!arms %in% c("psu", "mun")) || anyDuplicated(arms) || anyDuplicated(rounds)) stop("Invalid arms or repeated rounds")
sample_spec <- getarg("samples", "1:100")
if (grepl("^[0-9]+:[0-9]+$", sample_spec)) {
  endpoints <- as.integer(strsplit(sample_spec, ":", fixed = TRUE)[[1]])
  ids <- seq.int(endpoints[1], endpoints[2])
} else if (grepl("^[0-9]+(,[0-9]+)*$", sample_spec)) {
  ids <- as.integer(strsplit(sample_spec, ",", fixed = TRUE)[[1]])
} else stop("--samples must be numeric IDs separated by commas or a range such as 1:100")
L <- suppressWarnings(as.integer(getarg("L", "100")))
if (!length(ids) || anyNA(ids) || any(ids < 1 | ids > 100) || anyDuplicated(ids) || is.na(L) || L < 2L) stop("Invalid sample IDs or L")
script_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)[1]
here <- dirname(normalizePath(sub("^--file=", "", script_arg), winslash = "/", mustWork = TRUE))
package_dir <- dirname(here)
code_dir <- file.path(package_dir, "original", "code")
Sys.setenv(SAE_ROOT = normalizePath(data_root, winslash = "/", mustWork = TRUE))
source(file.path(code_dir, "round_config.R"))

# The original loop uses sorted positions. Resolve numeric IDs and check both predictor lists.
plan <- list()
for (rnd in rounds) {
  cfg <- round_config(rnd)
  samples <- list.files(file.path(cfg$dir, cfg$smp), pattern = "[.]dta$")
  beta <- list.files(file.path(cfg$dir, cfg$betavars), pattern = "[.]dta$")
  alpha <- list.files(file.path(cfg$dir, cfg$alphavars), pattern = "[.]dta$")
  suffix <- function(x) {
    if (any(!grepl("_[0-9]+[.]dta$", x))) stop("Unrecognized numeric suffix in ", rnd)
    as.integer(sub(".*_([0-9]+)[.]dta$", "\\1", x))
  }
  sample_ids <- suffix(samples)
  if (anyDuplicated(sample_ids) || !identical(sample_ids, suffix(beta)) || !identical(sample_ids, suffix(alpha))) {
    stop("Sample/beta/alpha numeric suffixes are not positionally aligned for ", rnd)
  }
  for (arm in arms) for (id in ids) {
    position <- match(id, sample_ids)
    if (is.na(position)) stop("Missing numeric sample ", id, " in ", rnd)
    plan[[length(plan) + 1L]] <- data.frame(round = rnd, arm = arm, sample_id = id,
      original_index = position, input_sample = samples[position], beta_file = beta[position],
      alpha_file = alpha[position], L = L, model_parameters = "fixed", seed = 7L)
  }
}
plan <- do.call(rbind, plan)
if (flag %in% args) {
  cat("PLAN ONLY: no models run and no output directory created.\n")
  cat(nrow(plan), "sample-arm jobs planned.\n")
  print(head(plan, 10), row.names = FALSE)
  quit(status = 0L)
}
stopifnot(dir.create(out, recursive = TRUE))
out <- normalizePath(out, winslash = "/", mustWork = TRUE)
dir.create(file.path(out, "logs"))
write.csv(plan, file.path(out, "run_plan.csv"), row.names = FALSE)
rscript <- file.path(R.home("bin"), if (.Platform$OS.type == "windows") "Rscript.exe" else "Rscript")
statuses <- list()
for (i in seq_len(nrow(plan))) {
  job <- plan[i, ]
  dest <- file.path(out, job$round, job$arm)
  log <- file.path(out, "logs", sprintf("%s_%s_sample_%d.log", job$round, job$arm, job$sample_id))
  child_args <- c(file.path(code_dir, "ell_cluster.R"), "--round", job$round, "--re", job$arm,
    "--model-parameters", "fixed", "--from", job$original_index, "--to", job$original_index,
    "--L", L, "--out", dest)
  cat(sprintf("[%d/%d] %s %s sample_%d (original index %d)\n", i, nrow(plan), job$round, job$arm, job$sample_id, job$original_index))
  started <- Sys.time()
  status <- system2(rscript, args = vapply(child_args, shQuote, character(1)), stdout = log, stderr = log)
  expected <- file.path(dest, c(paste0("sim_ebp_", job$input_sample), paste0("coef_", job$input_sample)))
  success <- status == 0L && all(file.exists(expected))
  statuses[[i]] <- data.frame(job, exit_code = status, exports_present = all(file.exists(expected)),
    elapsed_seconds = as.numeric(difftime(Sys.time(), started, units = "secs")))
  write.csv(do.call(rbind, statuses), file.path(out, "run_status.csv"), row.names = FALSE)
  if (!success) stop("Estimation failed; inspect ", log)
}
cat("All planned original-setting estimates completed. No scoring performed.\n")
