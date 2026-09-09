## probe_cluster_feasible.R -- CAN ELL run with the random effect at CLUSTER level at all?
##
## WHY THIS EXISTS BEFORE ANY DELIVERABLE. Item 6 moves the ELL random effect from municipality
## to cluster. In povmap that means pop_domains/smp_domains = "psu_id" with aggregate_to =
## "mun_id" so results still report at municipality level. Read from the source, that is the
## mechanism. Whether it RUNS, and at what cost, is a hypothesis until measured.
##
## THE REASON TO DOUBT IT. Domain counts change by two orders of magnitude in Mexico:
##
##   round     census PSUs   census municipalities   ratio
##   MEX2010      177,957            2,456           72x
##   MEX2015      273,773            2,457          111x
##   MEX2020      252,558            2,469          102x
##   BRA2000        9,336            5,507          1.7x
##   BRA2010       10,184            5,565          1.8x
##
## povmap builds per-domain structures over pop_domains. At 274,000 domains those may not fit,
## or may take a time that makes 100 samples x 5 rounds impossible. Mexico is the risk; Brazil
## is nearly free. Shipping Minh a script that cannot run on the Mexican rounds would be worse
## than shipping nothing.
##
## WHAT THIS MEASURES, on ONE sample, at a deliberately small L:
##   1. does it run to completion
##   2. peak memory and wall time
##   3. does the output come back at MUNICIPALITY level (the point of aggregate_to)
##   4. how the municipality-level answer compares with the published municipality-RE run,
##      as a sanity check that the two are the same order of thing
##
## L IS SMALL BY DEFAULT. The published ELL uses L = 100. The default here is L = 2 because the
## question is whether the DOMAIN STRUCTURE fits, not what the estimates are.
##
## RUNTIME DOES NOT SCALE LINEARLY IN L, and assuming it does is badly wrong. Measured on
## MEX2010 sample 1: L=2 took 55.2 s and L=10 took 59.1 s. Almost all of the cost is FIXED --
## loading a 2.9 M-row census and building the domain structure over 178 k PSUs -- and only
## ~0.48 s per unit of L is variable. Scaling the L=2 time proportionally predicts 46 min per
## sample at L=100; the truth is closer to 2 min. This script therefore reports the elapsed time
## as measured and does NOT extrapolate. Run it at the L you actually intend to use.
##
## Usage: Rscript probe_cluster_feasible.R <round> [L] [sample]

args <- commandArgs(trailingOnly = TRUE)
RND <- if (length(args) >= 1) args[1] else "MEX2010"
LL  <- if (length(args) >= 2) as.integer(args[2]) else 2L
SMP <- if (length(args) >= 3) as.integer(args[3]) else 1L

## POVMAP_LIB may name SEVERAL library directories, separated by the platform path separator
## (";" on Windows, ":" elsewhere) -- povmap and its dependencies do not always live together.
## If you installed everything into your normal user library, leave POVMAP_LIB unset.
LIB <- Sys.getenv("POVMAP_LIB", "")
if (nzchar(LIB)) .libPaths(c(strsplit(LIB, .Platform$path.sep, fixed = TRUE)[[1]], .libPaths()))
suppressMessages({ library(haven); library(povmap) })
HERE <- local({
  a <- commandArgs(trailingOnly = FALSE); f <- sub("^--file=", "", a[grep("^--file=", a)])
  if (length(f)) dirname(normalizePath(f[1], mustWork = FALSE)) else getwd()
})
source(file.path(HERE, "round_config.R"))
cfg <- round_config(RND)
setwd(cfg$dir)

cat(sprintf("PROBE cluster-level ELL | %s | L=%d | sample %d\n", RND, LL, SMP))
cat(sprintf("  threshold %.7f (from round_config, source %s)\n", cfg$thr, cfg$ebp_source))

census <- as.data.frame(read_dta("census/census.dta"))
if (!("hhsize2" %in% names(census))) census$hhsize2 <- census$hhsize^2
mb <- list.files(cfg$betavars, pattern = "[.]dta$")
ma <- list.files("alphavars_selected", pattern = "[.]dta$")
ms <- list.files(cfg$smp, pattern = "[.]dta$")
stopifnot(length(mb) >= SMP, length(ma) >= SMP, length(ms) >= SMP)

bv <- colnames(as.data.frame(read_dta(file.path(cfg$betavars, mb[SMP]))))
av <- colnames(as.data.frame(read_dta(file.path("alphavars_selected", ma[SMP]))))
f_beta  <- as.formula(paste0("ln_pchinc ~ ", paste(bv, collapse = " + ")))
f_alpha <- as.formula(paste0("~ ", paste(av, collapse = " + ")))
smp <- as.data.frame(read_dta(file.path(cfg$smp, ms[SMP])))
if (!("hhsize2" %in% names(smp))) smp$hhsize2 <- smp$hhsize^2

cat(sprintf("  beta terms %d | alpha terms %d | sample rows %d\n", length(bv), length(av), nrow(smp)))
cat(sprintf("  census: %d hh, %d mun, %d psu\n", nrow(census),
            length(unique(census$mun_id)), length(unique(census$psu_id))))
cat(sprintf("  sample: %d hh, %d mun, %d psu\n", nrow(smp),
            length(unique(smp$mun_id)), length(unique(smp$psu_id))))

## Both id columns must exist on BOTH frames, and PSU must nest inside municipality, or
## aggregate_to is meaningless. Checked rather than assumed.
for (v in c("mun_id", "psu_id")) {
  if (!(v %in% names(census))) stop(sprintf("census lacks %s", v))
  if (!(v %in% names(smp)))    stop(sprintf("sample lacks %s", v))
}
nest <- tapply(census$mun_id, census$psu_id, function(z) length(unique(z)))
cat(sprintf("  NESTING psu -> mun: max municipalities per psu = %d  -> %s\n",
            max(nest), ifelse(max(nest) == 1, "NESTED, aggregate_to is well defined",
                              "NOT NESTED -- aggregate_to would be ambiguous")))
rm(nest); invisible(gc())

t0 <- Sys.time()
res <- tryCatch({
  set.seed(7)
  povmap:::ell(fixed = f_beta, alpha = f_alpha,
               pop_data = census, pop_domains = "psu_id", pop_weights = cfg$pop_weights,
               smp_data = smp, smp_domains = "psu_id", weights = cfg$weights,
               aggregate_to = "mun_id",
               rescale_weights = TRUE, transformation = "no", errors = "nonnormal",
               threshold = cfg$thr, na.rm = TRUE, L = LL,
               model_parameters = "fixed", indicators = c("Head_Count"))
}, error = function(z) { cat(sprintf("\n  FAILED: %s\n", conditionMessage(z))); NULL })
el <- as.numeric(difftime(Sys.time(), t0, units = "mins"))

if (is.null(res)) {
  cat(sprintf("\nPROBE RESULT: cluster-level ELL DID NOT RUN on %s after %.1f min.\n", RND, el))
  quit(status = 0)
}
cat(sprintf("\n  RAN. %.2f min at L=%d, MEASURED -- not extrapolated to any other L.\n", el, LL))
cat(sprintf("  At this L, 100 samples of this round would take about %.1f hours.\n", el * 100 / 60))
cat("  Cost is dominated by fixed overhead, not by L. See the header before assuming otherwise.\n")

ind <- res$ind
nmun <- length(unique(census$mun_id))
nout <- length(unique(ind$Domain))
cat(sprintf("  output rows %d | distinct Domain %d | census municipalities %d\n",
            nrow(ind), nout, nmun))
## The right comparison is against the PUBLISHED municipality-RE output, not the raw census count.
## MEX2015 is the reason: 11 of its 2,457 municipalities appear in the census and in the truth
## file but in NO ELL output, published or new. Checking against the census count alone raises a
## false alarm there. Matching the published coverage is what "aggregate_to worked" really means.
pubdir <- "results/results_ell/unit/output"
pubf <- file.path(pubdir, paste0("sim_ebp_", ms[SMP]))
npub <- if (dir.exists(pubdir) && file.exists(pubf))
  nrow(as.data.frame(read_dta(pubf))) else NA_integer_
if (!is.na(npub)) {
  cat(sprintf("  aggregate_to CHECK: %d domains out vs %d in the published municipality-RE run -> %s\n",
              nout, npub, ifelse(nout == npub, "MATCHES published coverage",
                                 "DOES NOT match published coverage -- investigate")))
  if (nout != nmun)
    cat(sprintf("  note: %d census municipalities are absent from BOTH runs -- a property of this\n        round's data, not of the cluster-level change.\n", nmun - nout))
} else {
  cat(sprintf("  aggregate_to CHECK: %d domains out vs %d census municipalities -> %s\n",
              nout, nmun, ifelse(nout == nmun, "MUNICIPALITY LEVEL, as intended",
                                 "fewer than the census; no published run here to compare against")))
}

## sanity: compare against the published municipality-RE ELL for the same sample
pub <- file.path("results/results_ell/unit/output", paste0("sim_ebp_", ms[SMP]))
if (file.exists(pub)) {
  p <- as.data.frame(read_dta(pub))
  a <- data.frame(d = as.character(p$area), pub = as.numeric(p$fgt), stringsAsFactors = FALSE)
  b <- data.frame(d = as.character(ind$Domain), new = as.numeric(ind$Head_Count), stringsAsFactors = FALSE)
  m <- merge(a, b, by = "d")
  cat(sprintf("  vs published municipality-RE ELL on %d shared areas: mean|diff| %.5f, cor %.4f\n",
              nrow(m), mean(abs(m$pub - m$new), na.rm = TRUE),
              suppressWarnings(cor(m$pub, m$new, use = "complete.obs"))))
  cat("  (a DIFFERENCE is expected -- this is the point of item 6, not an error)\n")
} else {
  cat(sprintf("  no published ELL output at %s for comparison\n", pub))
}
cat("\nPROBE COMPLETE\n")
