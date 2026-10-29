## ell_cluster.R -- ELL with the random effect at CLUSTER level, for item 6.
##
## Usage:
##   Rscript ell_cluster.R --round MEX2010 [--re psu] [--from 1] [--to 100] [--L 100]
##                         [--model-parameters fixed|variable]
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
MODPAR <- getarg("model-parameters", "fixed")

if (is.null(RND)) stop("--round is required (MEX2010 MEX2015 MEX2020 BRA2000 BRA2010)", call. = FALSE)
if (!(RE %in% c("psu", "mun")))
  stop("--re must be 'psu' (cluster, item 6) or 'mun' (published baseline)", call. = FALSE)
if (!(MODPAR %in% c("fixed", "variable")))
  stop("--model-parameters must be 'fixed' or 'variable'", call. = FALSE)

if (nzchar(LIB)) .libPaths(c(strsplit(LIB, .Platform$path.sep, fixed = TRUE)[[1]], .libPaths()))
suppressMessages({ library(haven); library(povmap) })

install_povmap_memory_overrides <- function() {
  ns <- asNamespace("povmap")
  chunk_rows <- as.integer(Sys.getenv("ELL_XPOP_CHUNK_ROWS", "250000"))
  if (is.na(chunk_rows) || chunk_rows < 1L) chunk_rows <- 250000L
  original_monte_carlo_ell <- get("monte_carlo_ell", envir = ns)

  model_par_ell_chunked <- function(framework, re_model, fixed, transformation_par) {
    betas <- re_model$coefficients
    sigmae2est <- re_model$ercomp$sigma2[1]
    sigmau2est <- re_model$ercomp$sigma2[2]
    if (framework$model_parameters != "fixed") {
      varFix <- re_model$vcov
    } else {
      varFix <- NULL
    }
    residuals <- as.vector(re_model$model[, 1] - predict(re_model))
    if (is.null(framework$weights)) {
      weights <- rep(1, framework$N_smp)
    } else {
      weights <- framework$smp_data[, framework$weights]
    }
    mean_residuals <- get("aggregate_weighted_mean", envir = ns)(
      df = residuals,
      by = list(framework$smp_data[, framework$smp_domains]),
      w = weights
    )[, 2]

    framework$pop_data[[paste0(fixed[2])]] <- seq_len(nrow(framework$pop_data))
    mu_fixed <- numeric(nrow(framework$pop_data))
    beta_names <- names(betas)
    starts <- seq.int(1L, nrow(framework$pop_data), by = chunk_rows)
    for (start in starts) {
      end <- min(start + chunk_rows - 1L, nrow(framework$pop_data))
      X_pop <- model.matrix(fixed, framework$pop_data[start:end, , drop = FALSE])
      if (!identical(colnames(X_pop), beta_names)) {
        X_aligned <- matrix(0, nrow = nrow(X_pop), ncol = length(betas),
                            dimnames = list(NULL, beta_names))
        common <- intersect(colnames(X_pop), beta_names)
        X_aligned[, common] <- X_pop[, common, drop = FALSE]
        X_pop <- X_aligned
      } else {
        X_pop <- X_pop[, beta_names, drop = FALSE]
      }
      mu_fixed[start:end] <- as.vector(X_pop %*% betas)
      rm(X_pop)
      invisible(gc())
    }

    list(betas = betas, sigmae2est = sigmae2est, sigmau2est = sigmau2est,
         varFix = varFix, varErr = NULL, residuals = residuals,
         mean_residuals = mean_residuals, mu_fixed = mu_fixed)
  }

  monte_carlo_ell_hcr_rowsum <- function(transformation, L, framework, lambda, shift,
                                         model_par, fixed, Ydump, alpha_model = NULL) {
    if (!is.null(Ydump) ||
        !identical(framework$indicator_names, "Head_Count") ||
        length(framework$threshold) != 1L) {
      return(original_monte_carlo_ell(
        transformation = transformation, L = L, framework = framework,
        lambda = lambda, shift = shift, model_par = model_par, fixed = fixed,
        Ydump = Ydump, alpha_model = alpha_model
      ))
    }

    if (!is.null(framework$aggregate_to_vec)) {
      pop_domains_vec_tmp <- framework$aggregate_to_vec
    } else {
      pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    domains <- unique(pop_domains_vec_tmp)
    if (!is.null(framework$pop_weights)) {
      pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
    } else {
      pop_weights_vec <- rep(1, nrow(framework$pop_data))
    }
    denom <- as.numeric(rowsum(pop_weights_vec, pop_domains_vec_tmp, reorder = FALSE)[, 1])
    ests_mcmc <- matrix(NA_real_, nrow = length(domains), ncol = L)
    betas <- model_par$betas
    message("\r", "Bootstrap started                                            ")
    start_time <- Sys.time()

    for (l in seq_len(L)) {
      if (framework$model_parameters == "variable") {
        R <- chol(model_par$varFix)
        model_par$betas <- t(R) %*% matrix(rnorm(ncol(R)), ncol(R)) + betas
      }
      if (framework$errors != "nonnormal") {
        errors <- get("errors_gen_ell", envir = ns)(
          framework = framework, model_par = model_par, alpha_model = alpha_model
        )
      } else {
        errors <- get("errors_gen_ell_nonp", envir = ns)(
          framework = framework, model_par = model_par, alpha_model = alpha_model
        )
      }
      population_vector <- get("prediction_y_ell", envir = ns)(
        transformation = transformation, lambda = lambda, shift = shift,
        model_par = model_par, errors = errors, framework = framework, fixed = fixed
      )
      poor_weight <- as.numeric(population_vector < framework$threshold) * pop_weights_vec
      ests_mcmc[, l] <- as.numeric(rowsum(poor_weight, pop_domains_vec_tmp,
                                          reorder = FALSE)[, 1]) / denom
      rm(errors, population_vector, poor_weight)
      invisible(gc())

      if (l %% 20 == 0 && l != L) {
        delta <- difftime(Sys.time(), start_time, units = "secs")
        remaining <- unclass((delta / l) * (L - l))
        remaining <- sprintf("%02d:%02d:%02d:%02d", remaining %/% 86400,
                             remaining %% 86400 %/% 3600,
                             remaining %% 3600 %/% 60, remaining %% 60 %/% 1)
        message("\r", l, " of ", L,
                " Bootstrap iterations completed \t\n              Approximately ",
                remaining, " remaining \n")
      }
    }

    point_estimates <- data.frame(Domain = domains,
                                  Head_Count = rowMeans(ests_mcmc),
                                  row.names = NULL)
    var_estimates <- data.frame(Domain = domains,
                                Head_Count = get("rowvar", envir = ns)(ests_mcmc),
                                row.names = NULL)
    list(point_estimates = point_estimates, var_estimates = var_estimates)
  }

  unlockBinding("model_par_ell", ns)
  assign("model_par_ell", model_par_ell_chunked, envir = ns)
  lockBinding("model_par_ell", ns)
  unlockBinding("monte_carlo_ell", ns)
  assign("monte_carlo_ell", monte_carlo_ell_hcr_rowsum, envir = ns)
  lockBinding("monte_carlo_ell", ns)
  cat(sprintf("  using chunked povmap::model_par_ell override (chunk_rows=%d)\n", chunk_rows))
  cat("  using Head_Count rowsum povmap::monte_carlo_ell override\n")
}
install_povmap_memory_overrides()

HERE <- local({
  a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd()
})
source(file.path(HERE, "round_config.R"))
cfg <- round_config(RND)

DOM  <- if (RE == "psu") "psu_id" else "mun_id"
AGG  <- if (RE == "psu") "mun_id" else NULL
suffix <- if (MODPAR == "fixed") RE else paste(RE, MODPAR, sep = "_")
if (is.null(OUT)) OUT <- file.path(cfg$dir, "results", paste0("results_ell_", suffix), "unit", "output")
dir.create(OUT, recursive = TRUE, showWarnings = FALSE)

cat(sprintf("ELL | round %s | random effect at %s | model_parameters=%s | L=%d | samples %d..%d\n",
            RND, if (RE == "psu") "CLUSTER (psu_id)" else "municipality (mun_id)",
            MODPAR, LL, FROM, TO))
cat(sprintf("  threshold %.10f   (provenance: %s, sha256 %s)\n", cfg$thr, cfg$ebp_source,
            substr(cfg$ebp_sha256, 1, 16)))
cat(sprintf("  data root %s\n  output    %s\n", cfg$dir, OUT))

setwd(cfg$dir)
census <- as.data.frame(read_dta("census/census.dta"))
if (!("hhsize2" %in% names(census)) && "hhsize" %in% names(census))
  census$hhsize2 <- census$hhsize^2
for (v in unique(c(DOM, AGG, cfg$pop_weights)))
  if (!(v %in% names(census))) stop(sprintf("census lacks required column '%s'", v), call. = FALSE)

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

failed <- 0L
for (i in seq(FROM, TO)) {
  dest <- file.path(OUT, paste0("sim_ebp_", ms[i]))
  coef_dest <- file.path(OUT, paste0("coef_", ms[i]))
  if (file.exists(dest) && file.exists(coef_dest)) {
    cat(sprintf("  sample %3d  already done, skipping\n", i))
    next
  }
  if (file.exists(dest) || file.exists(coef_dest)) {
    cat(sprintf("  sample %3d  incomplete output, recomputing\n", i))
  }
  t0 <- Sys.time()
  bv <- colnames(as.data.frame(read_dta(file.path(cfg$betavars,  mb[i]))))
  av <- colnames(as.data.frame(read_dta(file.path(cfg$alphavars, ma[i]))))
  smp <- as.data.frame(read_dta(file.path(cfg$smp, ms[i])))
  if (!("hhsize2" %in% names(smp)) && "hhsize" %in% names(smp)) smp$hhsize2 <- smp$hhsize^2
  f_beta  <- as.formula(paste0("ln_pchinc ~ ", paste(bv, collapse = " + ")))
  f_alpha <- as.formula(paste0("~ ", paste(av, collapse = " + ")))

  set.seed(7)
  fit <- tryCatch(
    povmap:::ell(fixed = f_beta, alpha = f_alpha,
                 pop_data = census, pop_domains = DOM, pop_weights = cfg$pop_weights,
                 smp_data = smp, smp_domains = DOM, weights = cfg$weights,
                 aggregate_to = AGG,
                 rescale_weights = TRUE, transformation = "no", errors = "nonnormal",
                 threshold = cfg$thr, na.rm = TRUE, L = LL,
                 model_parameters = MODPAR, indicators = c("Head_Count")),
    error = function(z) {
      failed <<- failed + 1L
      cat(sprintf("  sample %3d  FAILED: %s\n", i, conditionMessage(z)))
      NULL
    })
  if (is.null(fit)) { invisible(gc()); next }

  sim <- data.frame(area = as.character(fit$ind$Domain),
                    fgt = as.numeric(fit$ind$Head_Count), stringsAsFactors = FALSE)
  tmp_dest <- tempfile(pattern = paste0(basename(dest), "."), tmpdir = dirname(dest))
  if (file.exists(dest)) unlink(dest)
  write_dta(sim, tmp_dest)
  file.rename(tmp_dest, dest)
  cf <- as.data.frame(fit$model_par$betas)
  coef <- data.frame(names = rownames(cf), coefficients = as.numeric(cf[, 1]),
                     stringsAsFactors = FALSE)
  tmp_coef_dest <- tempfile(pattern = paste0(basename(coef_dest), "."), tmpdir = dirname(coef_dest))
  if (file.exists(coef_dest)) unlink(coef_dest)
  write_dta(coef, tmp_coef_dest)
  file.rename(tmp_coef_dest, coef_dest)
  cat(sprintf("  sample %3d  %5.1f min | %d areas out\n", i,
              as.numeric(difftime(Sys.time(), t0, units = "mins")), nrow(sim)))
  rm(fit, sim, cf, smp, bv, av, f_beta, f_alpha); invisible(gc())
}
cat("\nDONE\n")
if (failed > 0L) {
  cat(sprintf("FAILED SAMPLES: %d\n", failed))
  quit(status = 1L)
}
