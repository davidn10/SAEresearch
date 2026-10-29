read_ell_outputs <- function(package_dir, round = NULL, arm = NULL, sample_id = NULL) {
  if (!requireNamespace("haven", quietly = TRUE)) stop("Package 'haven' is required")
  index <- read.csv(file.path(package_dir, "output_index.csv"), stringsAsFactors = FALSE)
  if (!is.null(round)) index <- index[index$round %in% round, , drop = FALSE]
  if (!is.null(arm)) index <- index[index$arm %in% arm, , drop = FALSE]
  if (!is.null(sample_id)) index <- index[index$sample_id %in% sample_id, , drop = FALSE]
  if (!nrow(index)) stop("No outputs match the requested filters")
  x <- lapply(seq_len(nrow(index)), function(i) {
    d <- as.data.frame(haven::read_dta(file.path(package_dir, index$path[i])))
    stopifnot(identical(names(d), c("area", "fgt")), !anyDuplicated(d$area))
    data.frame(round = index$round[i], arm = index$arm[i], sample_id = index$sample_id[i],
               area = as.character(d$area), fgt = as.numeric(d$fgt), stringsAsFactors = FALSE)
  })
  do.call(rbind, x)
}
