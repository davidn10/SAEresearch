AMPL <-
function (interval, direct, x, vardir, areanumber) 
{
    AP <- function(interval, direct, x, vardir, areanumber) {
        psi <- matrix(c(vardir), areanumber, 1)
        Y <- matrix(c(direct), areanumber, 1)
        X <- x
        Z.area <- diag(1, areanumber)
        sigma.u_log <- interval[1]
        I <- diag(1, areanumber)
        V <- sigma.u_log * Z.area %*% t(Z.area) + I * psi[, 1]
        Vi <- solve(V)
        Xt <- t(X)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        ee <- eigen(V)
        log(sigma.u_log) - (areanumber/2) * log(2 * pi) - 0.5 * 
            sum(log(ee$value)) - (0.5) * t(Y) %*% P %*% Y
    }
    ottimo <- optimize(AP, interval, maximum = TRUE, vardir = vardir, 
        areanumber = areanumber, direct = direct, x = x)
    estsigma2u <- ottimo$maximum
    return(sigmau_ampl = estsigma2u)
}
AMPL_YL <-
function (interval, direct, x, vardir, areanumber) 
{
    AP_YL <- function(interval, direct, x, vardir, areanumber) {
        psi <- matrix(c(vardir), areanumber, 1)
        Y <- matrix(c(direct), areanumber, 1)
        X <- x
        Z.area <- diag(1, areanumber)
        sigma.u_log <- interval[1]
        I <- diag(1, areanumber)
        V <- sigma.u_log * Z.area %*% t(Z.area) + I * psi[, 1]
        Vi <- solve(V)
        Xt <- t(X)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        Bd <- diag(vardir/(sigma.u_log + vardir))
        ee <- eigen(V)
        (atan(sum(diag((I - Bd)))))^(1/areanumber) * (2 * pi)^(-(areanumber/2)) * 
            exp(-0.5 * sum(log(ee$value))) * exp(-(0.5) * t(Y) %*% 
            P %*% Y)
    }
    ottimo <- optimize(AP_YL, interval, maximum = TRUE, vardir = vardir, 
        areanumber = areanumber, direct = direct, x = x)
    estsigma2u <- ottimo$maximum
    return(sigmau_ampl_yl = estsigma2u)
}
AMRL <-
function (interval, direct, x, vardir, areanumber) 
{
    AR <- function(interval, direct, x, vardir, areanumber) {
        psi <- matrix(c(vardir), areanumber, 1)
        Y <- matrix(c(direct), areanumber, 1)
        X <- x
        Z.area <- diag(1, areanumber)
        sigma.u_log <- interval[1]
        I <- diag(1, areanumber)
        V <- sigma.u_log * Z.area %*% t(Z.area) + I * psi[, 1]
        Vi <- solve(V)
        Xt <- t(X)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        ee <- eigen(V)
        log(sigma.u_log) - (areanumber/2) * log(2 * pi) - 0.5 * 
            sum(log(ee$value)) - (0.5) * log(det(t(X) %*% Vi %*% 
            X)) - (0.5) * t(Y) %*% P %*% Y
    }
    ottimo <- optimize(AR, interval, maximum = TRUE, vardir = vardir, 
        areanumber = areanumber, direct = direct, x = x)
    estsigma2u <- ottimo$maximum
    return(sigmau_amrl = estsigma2u)
}
AMRL_YL <-
function (interval, direct, x, vardir, areanumber) 
{
    AR_YL <- function(interval, direct, x, vardir, areanumber) {
        psi <- matrix(c(vardir), areanumber, 1)
        Y <- matrix(c(direct), areanumber, 1)
        X <- x
        Z.area <- diag(1, areanumber)
        sigma.u_log <- interval[1]
        I <- diag(1, areanumber)
        V <- sigma.u_log * Z.area %*% t(Z.area) + I * psi[, 1]
        Vi <- solve(V)
        Xt <- t(X)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        Bd <- diag(vardir/(sigma.u_log + vardir))
        ee <- eigen(V)
        atan(sum(diag((I - Bd))))^(1/areanumber) * (2 * pi)^(-(areanumber/2)) * 
            exp(-0.5 * sum(log(ee$value))) * exp(-(0.5) * log(det(t(X) %*% 
            Vi %*% X))) * exp(-(0.5) * t(Y) %*% P %*% Y)
    }
    ottimo <- optimize(AR_YL, interval, maximum = TRUE, vardir = vardir, 
        areanumber = areanumber, direct = direct, x = x)
    estsigma2u <- ottimo$maximum
    return(sigmau_amrl_yl = estsigma2u)
}
MPL <-
function (interval, direct, x, vardir, areanumber) 
{
    ML <- function(interval, direct, x, vardir, areanumber) {
        psi <- matrix(c(vardir), areanumber, 1)
        Y <- matrix(c(direct), areanumber, 1)
        X <- x
        Z.area <- diag(1, areanumber)
        sigma.u_log <- interval[1]
        I <- diag(1, areanumber)
        V <- sigma.u_log * Z.area %*% t(Z.area) + I * psi[, 1]
        Vi <- solve(V)
        Xt <- t(X)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        ee <- eigen(V)
        -(areanumber/2) * log(2 * pi) - 0.5 * sum(log(ee$value)) - 
            (0.5) * t(Y) %*% P %*% Y
    }
    ottimo <- optimize(ML, interval, maximum = TRUE, vardir = vardir, 
        areanumber = areanumber, direct = direct, x = x)
    estsigma2u <- ottimo$maximum
    return(sigmau_mpl = estsigma2u)
}
QRLM <-
function (x, y, case.weights = rep(1, nrow(x)), k = 1.345, var.weights = rep(1, 
    nrow(x)), ..., w = rep(1, nrow(x)), init = "ls", psi = psi.huber, 
    scale.est = c("MAD", "Huber", "proposal 2"), k2 = 1.345, 
    method = c("M", "MM"), maxit = 20, acc = 0.0001, test.vec = "resid", 
    q = 0.5) 
{
    require(MASS)
    irls.delta <- function(old, new) sqrt(sum((old - new)^2)/max(9.9999999999999995e-21, 
        sum(old^2)))
    irls.rrxwr <- function(x, w, r) {
        w <- sqrt(w)
        max(abs((matrix(r * w, 1, length(r)) %*% x)/sqrt(matrix(w, 
            1, length(r)) %*% (x^2))))/sqrt(sum(w * r^2))
    }
    method <- match.arg(method)
    nmx <- deparse(substitute(x))
    if (is.null(dim(x))) {
        x <- as.matrix(x)
        colnames(x) <- nmx
    }
    else x <- as.matrix(x)
    if (is.null(colnames(x))) 
        colnames(x) <- paste("X", seq(ncol(x)), sep = "")
    if (qr(x)$rank < ncol(x)) 
        stop("x is singular: singular fits are not implemented in rlm")
    if (!(any(test.vec == c("resid", "coef", "w", "NULL")) || 
        is.null(test.vec))) 
        stop("invalid testvec")
    if (length(var.weights) != nrow(x)) 
        stop("Length of var.weights must equal number of observations")
    if (any(var.weights < 0)) 
        stop("Negative var.weights value")
    if (length(case.weights) != nrow(x)) 
        stop("Length of case.weights must equal number of observations")
    w <- (w * case.weights)/var.weights
    if (method == "M") {
        scale.est <- match.arg(scale.est)
        if (!is.function(psi)) 
            psi <- get(psi, mode = "function")
        arguments <- list(...)
        if (length(arguments)) {
            pm <- pmatch(names(arguments), names(formals(psi)), 
                nomatch = 0)
            if (any(pm == 0)) 
                warning(paste("some of ... do not match"))
            pm <- names(arguments)[pm > 0]
            formals(psi)[pm] <- unlist(arguments[pm])
        }
        if (is.character(init)) {
            if (init == "ls") 
                temp <- lm.wfit(x, y, w, method = "qr")
            else if (init == "lts") 
                temp <- lqs.default(x, y, intercept = FALSE, 
                  nsamp = 200)
            else stop("init method is unknown")
            coef <- temp$coef
            resid <- temp$resid
        }
        else {
            if (is.list(init)) 
                coef <- init$coef
            else coef <- init
            resid <- y - x %*% coef
        }
    }
    else if (method == "MM") {
        scale.est <- "MM"
        temp <- lqs.default(x, y, intercept = FALSE, method = "S", 
            k0 = 1.548)
        coef <- temp$coef
        resid <- temp$resid
        psi <- psi.bisquare
        if (length(arguments <- list(...))) 
            if (match("c", names(arguments), nomatch = FALSE)) {
                c0 <- arguments$c
                if (c0 > 1.548) {
                  psi$c <- c0
                }
                else warning("c must be at least 1.548 and has been ignored")
            }
        scale <- temp$scale
    }
    else stop("method is unknown")
    done <- FALSE
    conv <- NULL
    n1 <- nrow(x) - ncol(x)
    if (scale.est != "MM") 
        scale <- mad(resid/sqrt(var.weights), 0)
    qest <- matrix(0, nrow = ncol(x), ncol = length(q))
    qwt <- matrix(0, nrow = nrow(x), ncol = length(q))
    qfit <- matrix(0, nrow = nrow(x), ncol = length(q))
    qres <- matrix(0, nrow = nrow(x), ncol = length(q))
    qvar.matrix <- array(rep(0, ncol(x) * ncol(x)), dim = c(ncol(x), 
        ncol(x), length(q)))
    qscale <- NULL
    for (i in 1:length(q)) {
        for (iiter in 1:maxit) {
            if (!is.null(test.vec)) 
                testpv <- get(test.vec)
            if (scale.est != "MM") {
                if (scale.est == "MAD") 
                  scale <- median(abs(resid/sqrt(var.weights)))/0.67449999999999999
                else {
                  gamma <- 4 * k2^2 * (1 - pnorm(k2)) * ((1 - 
                    q[i])^2 + q[i]^2) - 4 * k2 * dnorm(k2) * 
                    ((1 - q[i])^2 + q[i]^2) + 4 * (1 - q[i])^2 * 
                    (pnorm(0) - (1 - pnorm(k2))) + 4 * q[i]^2 * 
                    (pnorm(k2) - pnorm(0))
                  scale <- sqrt(sum(pmin(resid^2/var.weights, 
                    (k2 * scale)^2))/(n1 * gamma))
                }
                if (scale == 0) {
                  done <- TRUE
                  break
                }
            }
            w <- psi(resid/(scale * sqrt(var.weights)), k = k) * 
                case.weights
            ww <- 2 * (1 - q[i]) * w
            ww[resid > 0] <- 2 * q[i] * w[resid > 0]
            w <- ww
            temp <- lm.wfit(x, y, w, method = "qr")
            coef <- temp$coef
            resid <- temp$residuals
            if (!is.null(test.vec)) 
                convi <- irls.delta(testpv, get(test.vec))
            else convi <- irls.rrxwr(x, wmod, resid)
            conv <- c(conv, convi)
            done <- (convi <= acc)
            if (done) 
                break
        }
        if (!done) 
            warning(paste("rlm failed to converge in", maxit, 
                "steps at q = ", q[i]))
        qest[, i] <- coef
        qscale[i] <- scale
        qwt[, i] <- w
        qfit[, i] <- temp$fitted.values
        qres[, i] <- resid
        tmp.res.mq <- qres[, i]/qscale[i]
        Epsi2 <- (sum((qwt[, i] * tmp.res.mq)^2)/(nrow(x) - ncol(x)))
        Epsi <- (1/qscale[i]) * (sum(2 * (q[i] * (0 <= tmp.res.mq & 
            tmp.res.mq <= k) + (1 - q[i]) * (-k <= tmp.res.mq & 
            tmp.res.mq < 0)))/nrow(x))
        qvar.matrix[, , i] <- (((Epsi2)/Epsi^2) * solve(t(x) %*% 
            x))
    }
    list(fitted.values = qfit, residuals = qres, q.values = q, 
        q.weights = qwt, coef = qest, qscale = qscale, var.beta = qvar.matrix)
}
Reml <-
function (interval, direct, x, vardir, areanumber) 
{
    A.reml <- function(interval, direct, x, vardir, areanumber) {
        psi <- matrix(c(vardir), areanumber, 1)
        Y <- matrix(c(direct), areanumber, 1)
        X <- x
        Z.area <- diag(1, areanumber)
        sigma.u_log <- interval[1]
        I <- diag(1, areanumber)
        V <- sigma.u_log * Z.area %*% t(Z.area) + I * psi[, 1]
        Vi <- solve(V)
        Xt <- t(X)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        ee <- eigen(V)
        -(areanumber/2) * log(2 * pi) - 0.5 * sum(log(ee$value)) - 
            (0.5) * log(det(t(X) %*% Vi %*% X)) - (0.5) * t(Y) %*% 
            P %*% Y
    }
    ottimo <- optimize(A.reml, interval, maximum = TRUE, vardir = vardir, 
        areanumber = areanumber, direct = direct, x = x)
    estsigma2u <- ottimo$maximum
    return(sigmau_reml = estsigma2u)
}
SML <-
function (direct, X, vardir, areanumber, W, maxit, tol) 
{
    Xt <- t(X)
    tdirect <- t(direct)
    Wt <- t(W)
    D <- diag(1, areanumber)
    est.param <- matrix(0, 2, 1)
    final.param <- matrix(0, 2, 1)
    score.vec <- matrix(0, 2, 1)
    fisher <- matrix(0, 2, 2)
    est.sigma2 <- 0
    est.rho <- 0
    est.sigma2[1] <- median(vardir)
    est.rho[1] <- 0.5
    iter <- 0
    conv <- tol + 1
    while ((conv > tol) & (iter < maxit)) {
        iter <- iter + 1
        der.sigma <- solve((D - est.rho[iter] * Wt) %*% (D - 
            est.rho[iter] * W))
        der.rho <- 2 * est.rho[iter] * Wt %*% W - W - Wt
        der.vrho <- (-1) * est.sigma2[iter] * (der.sigma %*% 
            der.rho %*% der.sigma)
        V <- est.sigma2[iter] * der.sigma + D * vardir
        Vi <- solve(V)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        P.der.sigma <- P %*% der.sigma
        P.der.rho <- P %*% der.vrho
        P.direct <- P %*% direct
        Vi.der.sigma <- Vi %*% der.sigma
        Vi.der.vrho <- Vi %*% der.vrho
        score.vec[1, 1] <- (-0.5) * sum(diag(Vi.der.sigma)) + 
            (0.5) * (tdirect %*% P.der.sigma %*% P.direct)
        score.vec[2, 1] <- (-0.5) * sum(diag(Vi.der.vrho)) + 
            (0.5) * (tdirect %*% P.der.rho %*% P.direct)
        fisher[1, 1] <- (0.5) * sum(diag(Vi.der.sigma %*% Vi.der.sigma))
        fisher[1, 2] <- (0.5) * sum(diag(Vi.der.sigma %*% Vi.der.vrho))
        fisher[2, 1] <- (0.5) * sum(diag(Vi.der.vrho %*% Vi.der.sigma))
        fisher[2, 2] <- (0.5) * sum(diag(Vi.der.vrho %*% Vi.der.vrho))
        est.param[1, 1] <- est.sigma2[iter]
        est.param[2, 1] <- est.rho[iter]
        final.param <- est.param + solve(fisher) %*% score.vec
        if (final.param[2, 1] <= -1) {
            final.param[2, 1] <- -0.999
        }
        if (final.param[2, 1] >= 1) {
            final.param[2, 1] <- 0.999
        }
        est.sigma2[iter + 1] <- final.param[1, 1]
        est.rho[iter + 1] <- final.param[2, 1]
        conv <- max(abs(final.param - est.param)/est.param)
    }
    if (est.rho[iter + 1] == -0.999) {
        est.rho[iter + 1] <- -1
    }
    else if (est.rho[iter + 1] == 0.999) {
        est.rho[iter + 1] <- 1
    }
    rho <- est.rho[iter + 1]
    est.sigma2[iter + 1] <- max(est.sigma2[iter + 1], 0)
    sigma2u <- est.sigma2[iter + 1]
    if (iter >= maxit && conv >= tol) {
        convergence <- FALSE
    }
    else {
        convergence <- TRUE
    }
    return(list(sigmau2 = sigma2u, rho = rho, convergence = convergence))
}
SREML <-
function (direct, X, vardir, areanumber, W, maxit, tol) 
{
    Xt <- t(X)
    tdirect <- t(direct)
    Wt <- t(W)
    D <- diag(1, areanumber)
    est.param <- matrix(0, 2, 1)
    final.param <- matrix(0, 2, 1)
    score.vec <- matrix(0, 2, 1)
    fisher <- matrix(0, 2, 2)
    est.sigma2 <- 0
    est.rho <- 0
    est.sigma2[1] <- median(vardir)
    est.rho[1] <- 0.5
    iter <- 0
    conv <- tol + 1
    while ((conv > tol) & (iter < maxit)) {
        iter <- iter + 1
        der.sigma <- solve((D - est.rho[iter] * Wt) %*% (D - 
            est.rho[iter] * W))
        der.rho <- 2 * est.rho[iter] * Wt %*% W - W - Wt
        der.vrho <- (-1) * est.sigma2[iter] * (der.sigma %*% 
            der.rho %*% der.sigma)
        V <- est.sigma2[iter] * der.sigma + D * vardir
        Vi <- solve(V)
        XVi <- Xt %*% Vi
        Q <- solve(XVi %*% X)
        P <- Vi - (Vi %*% X %*% Q %*% XVi)
        P.der.sigma <- P %*% der.sigma
        P.der.rho <- P %*% der.vrho
        P.direct <- P %*% direct
        score.vec[1, 1] <- (-0.5) * sum(diag(P.der.sigma)) + 
            (0.5) * (tdirect %*% P.der.sigma %*% P.direct)
        score.vec[2, 1] <- (-0.5) * sum(diag(P.der.rho)) + (0.5) * 
            (tdirect %*% P.der.rho %*% P.direct)
        fisher[1, 1] <- (0.5) * sum(diag((P.der.sigma %*% P.der.sigma)))
        fisher[1, 2] <- (0.5) * sum(diag((P.der.sigma %*% P.der.rho)))
        fisher[2, 1] <- (0.5) * sum(diag((P.der.rho %*% P.der.sigma)))
        fisher[2, 2] <- (0.5) * sum(diag((P.der.rho %*% P.der.rho)))
        est.param[1, 1] <- est.sigma2[iter]
        est.param[2, 1] <- est.rho[iter]
        final.param <- est.param + solve(fisher) %*% score.vec
        if (final.param[2, 1] <= -1) {
            final.param[2, 1] <- -0.999
        }
        if (final.param[2, 1] >= 1) {
            final.param[2, 1] <- 0.999
        }
        est.sigma2[iter + 1] <- final.param[1, 1]
        est.rho[iter + 1] <- final.param[2, 1]
        conv <- max(abs(final.param - est.param)/est.param)
    }
    if (est.rho[iter + 1] == -0.999) {
        est.rho[iter + 1] <- -1
    }
    else if (est.rho[iter + 1] == 0.999) {
        est.rho[iter + 1] <- 1
    }
    rho <- est.rho[iter + 1]
    est.sigma2[iter + 1] <- max(est.sigma2[iter + 1], 0)
    sigma2u <- est.sigma2[iter + 1]
    if (iter >= maxit && conv >= tol) {
        convergence <- FALSE
    }
    else {
        convergence <- TRUE
    }
    return(list(sigmau2 = sigma2u, rho = rho, convergence = convergence))
}
add1.fh <-
function (object, criteria, scope, trace = TRUE, ...) 
{
    if (missing(scope) || is.null(scope)) 
        stop("no terms in scope")
    if (!is.character(scope)) {
        scope <- add.scope(object$fixed, update.formula(object$fixed, 
            scope))
    }
    if (!length(scope)) {
        stop("no terms in scope for adding to object")
    }
    ns <- length(scope)
    ans <- matrix(nrow = ns + 1L, ncol = 2L, dimnames = list(c("<none>", 
        scope), c("df", criteria)))
    ans[1, ] <- c(length(attr(terms(object$fixed), "term.labels")) + 
        1, object$model$model_select[[criteria]])
    n0 <- object$framework$N_dom_smp
    for (i in seq_len(ns)) {
        tt <- scope[i]
        nfit <- object
        nfit$call$fixed <- update(object$fixed, as.formula(paste("~ . +", 
            tt)), evaluate = FALSE)
        nfit$call$formula <- NULL
        catmessage <- capture.output(nfit <- eval(nfit$call))
        ans[i + 1L, ] <- c(length(attr(terms(nfit$fixed), "term.labels")) + 
            1, nfit$model$model_select[[criteria]])
        nnew <- nfit$framework$N_dom_smp
        if (all(is.finite(c(n0, nnew))) && nnew != n0) {
            stop("number of rows in use has changed: remove missing values?")
        }
    }
    dfs <- ans[, 1L] - ans[1L, 1L]
    dfs[1L] <- NA
    aod <- data.frame(Df = dfs, criteria = ans[, 2L])
    head <- c("Single term additions", "\nModel:", deparse(formula(object$fixed)))
    class(aod) <- c("anova", "data.frame")
    attr(aod, "heading") <- head
    aod
}
add_estims <-
function (object, indicator, wb, headlines_cs, MSE, CV) 
{
    addWorksheet(wb, sheetName = "Estimates", gridLines = FALSE)
    data <- estimators(object = object, indicator = indicator, 
        MSE = MSE, CV = CV)$ind
    writeDataTable(x = data, sheet = "Estimates", wb = wb, startRow = 1, 
        startCol = 1, rowNames = FALSE, headerStyle = headlines_cs, 
        tableStyle = "TableStyleMedium2", withFilter = FALSE)
    setColWidths(wb = wb, sheet = "Estimates", cols = seq_len(ncol(data)), 
        widths = "auto")
    freezePane(wb = wb, sheet = "Estimates", firstRow = TRUE, 
        firstCol = TRUE)
    return(wb)
}
add_estims_ods <-
function (object, indicator, wb, headlines_cs, no_file, MSE, 
    CV) 
{
    data <- estimators(object = object, indicator = indicator, 
        MSE = MSE, CV = CV)$ind
    data[, 1] <- iconv(x <- data[, 1], from = "", to = "UTF-8")
    if (no_file == TRUE) {
        readODS::write_ods(x = data, path = paste0(tempdir(), 
            "\\", wb, "_estim", ".ods"))
    }
    else {
        readODS::write_ods(x = data, path = paste0(wb, "_estim", 
            ".ods"))
    }
    return(NULL)
}
add_model <-
function (object, wb) 
{
    model <- ebp_reportcoef_table(object, decimals = 3)
    addWorksheet(wb, sheetName = "Model", gridLines = FALSE)
    headlines_cs <- createStyle(fontColour = "#ffffff", halign = "center", 
        valign = "center", fgFill = NULL, textDecoration = "Bold", 
        border = "Bottom", borderStyle = "medium")
    writeDataTable(x = model, sheet = "Model", wb = wb, startRow = 1, 
        startCol = 1, rowNames = FALSE, headerStyle = headlines_cs, 
        tableStyle = "TableStyleMedium2", withFilter = FALSE)
    return(wb)
}
add_pointests <-
function (object, indicator, wb, headlines_cs) 
{
    addWorksheet(wb, sheetName = "Point Estimators", gridLines = FALSE)
    if (is.null(indicator) || !all(indicator == "all" | indicator == 
        "Quantiles" | indicator == "quantiles" | indicator == 
        "Poverty" | indicator == "poverty" | indicator == "Inequality" | 
        indicator == "inequality" | indicator == "Custom" | indicator == 
        "custom" | indicator %in% names(object$ind[-1]))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The argument indicator is set to ", 
            indicator, ". The\n                        argument only allows to be set to all, a name of\n                        estimated indicators or indicator groups as described\n                        in help(estimators.povmap).")))
    }
    data <- point_povmap(object = object, indicator = indicator)$ind
    writeDataTable(x = data, sheet = "Point Estimators", wb = wb, 
        startRow = 1, startCol = 1, rowNames = FALSE, headerStyle = headlines_cs, 
        tableStyle = "TableStyleMedium2", withFilter = FALSE)
    setColWidths(wb = wb, sheet = "Point Estimators", cols = seq_len(ncol(data)), 
        widths = "auto")
    freezePane(wb = wb, sheet = "Point Estimators", firstRow = TRUE, 
        firstCol = TRUE)
    return(wb)
}
add_pointests_ods <-
function (object, indicator, wb, no_file, headlines_cs) 
{
    if (is.null(indicator) || !all(indicator == "all" | indicator == 
        "Quantiles" | indicator == "quantiles" | indicator == 
        "Poverty" | indicator == "poverty" | indicator == "Inequality" | 
        indicator == "inequality" | indicator == "Custom" | indicator == 
        "custom" | indicator %in% names(object$ind[-1]))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The argument indicator is set to ", 
            indicator, ". The\n                        argument only allows to be set to all, a name of\n                        estimated indicators or indicator groups as described\n                        in help(estimators.emdi).")))
    }
    data <- point_emdi(object = object, indicator = indicator)$ind
    data[, 1] <- iconv(x = data[, 1], from = "", to = "UTF-8")
    if (no_file == TRUE) {
        readODS::write_ods(x = data, path = paste0(tempdir(), 
            "\\", wb, "_pointEstim", ".ods"))
    }
    else {
        readODS::write_ods(x = data, path = paste0(wb, "_pointEstim", 
            ".ods"))
    }
    return(NULL)
}
add_precisions <-
function (object, indicator, MSE, wb, headlines_cs, CV) 
{
    precisions <- mse_emdi(object = object, indicator = indicator, 
        CV = TRUE)
    if (MSE) {
        addWorksheet(wb, sheetName = "MSE Estimators", gridLines = FALSE)
        writeDataTable(x = precisions$ind, sheet = "MSE Estimators", 
            wb = wb, startRow = 1, startCol = 1, rowNames = FALSE, 
            headerStyle = headlines_cs, tableStyle = "TableStyleMedium2", 
            withFilter = FALSE)
        setColWidths(wb = wb, sheet = "MSE Estimators", cols = seq_len(ncol(precisions$ind)), 
            widths = "auto")
        freezePane(wb = wb, sheet = "MSE Estimators", firstRow = TRUE, 
            firstCol = TRUE)
    }
    if (CV) {
        addWorksheet(wb, sheetName = "CV Estimators", gridLines = FALSE)
        writeDataTable(precisions$ind_cv, wb = wb, sheet = "CV Estimators", 
            startRow = 1, startCol = 1, rowNames = FALSE, headerStyle = headlines_cs, 
            tableStyle = "TableStyleMedium2", withFilter = FALSE)
        setColWidths(wb = wb, sheet = "CV Estimators", cols = seq_len(ncol(precisions$ind_cv)), 
            widths = "auto")
        freezePane(wb = wb, sheet = "CV Estimators", firstRow = TRUE, 
            firstCol = TRUE)
    }
    return(wb)
}
add_precisions_ods <-
function (object, indicator, MSE, wb, no_file, headlines_cs, 
    CV) 
{
    precisions <- mse_emdi(object = object, indicator = indicator, 
        CV = TRUE)
    if (MSE) {
        precisions$ind[, 1] <- iconv(x <- precisions$ind[, 1], 
            from = "", to = "UTF-8")
        if (no_file == TRUE) {
            readODS::write_ods(x = precisions$ind, path = paste0(tempdir(), 
                "\\", wb, "_precMSE", ".ods"))
        }
        else {
            readODS::write_ods(x = precisions$ind, path = paste0(wb, 
                "_precMSE", ".ods"))
        }
    }
    if (CV) {
        precisions$ind_cv[, 1] <- iconv(x <- precisions$ind_cv[, 
            1], from = "", to = "UTF-8")
        if (no_file == TRUE) {
            readODS::write_ods(x = precisions$ind_cv, path = paste0(tempdir(), 
                "\\", wb, "_precCV", ".ods"))
        }
        else {
            readODS::write_ods(x = precisions$ind_cv, path = paste0(wb, 
                "_precCV", ".ods"))
        }
    }
    return(NULL)
}
add_summary_direct <-
function (object, wb, headlines_cs) 
{
    su <- summary(object)
    title_cs <- createStyle(fontSize = 14, border = "Bottom", 
        halign = "left", borderStyle = "thick", textDecoration = "bold")
    df_nobs <- data.frame(Count = c(su$in_smp, su$size_smp))
    rownames(df_nobs) <- c("in sample domains", "in sample observations")
    df_size_dom <- as.data.frame(su$size_dom)
    addWorksheet(wb, sheetName = "summary", gridLines = FALSE)
    writeData(wb = wb, sheet = "summary", x = "Direct Estimation", 
        colNames = FALSE)
    addStyle(wb = wb, sheet = "summary", cols = 1, rows = 1, 
        style = title_cs, stack = TRUE)
    starting_row <- 5
    writeDataTable(x = df_nobs, withFilter = FALSE, wb = wb, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_nobs)
    writeDataTable(x = df_size_dom, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_size_dom)
    df_smp_sizes <- as.data.frame(su$smp_size_tab)
    colnames(df_smp_sizes) <- c("Domain", "Frequency")
    writeDataTable(x = df_smp_sizes, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    setColWidths(wb = wb, sheet = "summary", cols = 3:9, widths = "auto")
    return(wb)
}
add_summary_direct_ods <-
function (object, wb, no_file, headlines_cs) 
{
    su <- summary(object)
    df_nobs <- data.frame(Count = c(su$in_smp, su$size_smp))
    rownames(df_nobs) <- c("in sample domains", "in sample observations")
    df_nobs <- cbind.data.frame(rownames(df_nobs), df_nobs)
    if (no_file == TRUE) {
        readODS::write_ods(x = df_nobs, path = paste0(tempdir(), 
            "\\", wb, "_sumObs", ".ods"))
    }
    else {
        readODS::write_ods(x = df_nobs, path = paste0(wb, "_sumObs", 
            ".ods"))
    }
    df_size_dom <- as.data.frame(su$size_dom)
    df_size_dom <- cbind.data.frame(rownames(df_size_dom), df_size_dom)
    if (no_file == TRUE) {
        readODS::write_ods(x = df_size_dom, path = paste0(tempdir(), 
            "\\", wb, "_sumDom", ".ods"))
    }
    else {
        readODS::write_ods(x = df_size_dom, path = paste0(wb, 
            "_sumDom", ".ods"))
    }
    df_smp_sizes <- as.data.frame(su$smp_size_tab)
    colnames(df_smp_sizes) <- c("Domain", "Frequency")
    df_smp_sizes <- cbind.data.frame(rownames(df_smp_sizes), 
        df_smp_sizes)
    if (no_file == TRUE) {
        readODS::write_ods(x = df_smp_sizes, path = paste0(tempdir(), 
            "\\", wb, "_sumSmpsize", ".ods"))
    }
    else {
        readODS::write_ods(x = df_smp_sizes, path = paste0(wb, 
            "_sumSmpsize", ".ods"))
    }
    return(NULL)
}
add_summary_ebp <-
function (object, wb, headlines_cs) 
{
    su <- summary(object)
    title_cs <- createStyle(fontSize = 14, border = "Bottom", 
        halign = "left", borderStyle = "thick", textDecoration = "bold")
    df_nobs <- data.frame(Count = c(su$out_of_smp, su$in_smp, 
        su$size_pop, su$size_smp))
    rownames(df_nobs) <- c("out of sample domains", "in sample domains", 
        "out of sample observations", "in sample observations")
    df_size_dom <- as.data.frame(su$size_dom)
    addWorksheet(wb, sheetName = "summary", gridLines = FALSE)
    writeData(wb = wb, sheet = "summary", x = "Empirical Best Prediction", 
        colNames = FALSE)
    addStyle(wb = wb, sheet = "summary", cols = 1, rows = 1, 
        style = title_cs, stack = TRUE)
    starting_row <- 5
    writeDataTable(x = df_nobs, withFilter = FALSE, wb = wb, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_nobs)
    writeDataTable(x = df_size_dom, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_size_dom)
    if (!is.null(su$transform)) {
        writeDataTable(x = su$transform, wb = wb, withFilter = FALSE, 
            sheet = "summary", startRow = starting_row, startCol = 3, 
            rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
            tableStyle = "TableStyleMedium2")
        starting_row <- starting_row + 2 + nrow(su$transform)
    }
    writeDataTable(x = su$normality, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(su$normality)
    writeDataTable(x = su$variance, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(su$variance)
    writeDataTable(x = su$coeff_determ, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 4, 
        rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(su$coeff_determ)
    writeDataTable(x = su$shrinkage, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    setColWidths(wb = wb, sheet = "summary", cols = 3:9, widths = "auto")
    return(wb)
}
add_summary_ell <-
function (object, wb, headlines_cs) 
{
    su <- summary(object)
    title_cs <- createStyle(fontSize = 14, border = "Bottom", 
        halign = "left", borderStyle = "thick", textDecoration = "bold")
    df_nobs <- data.frame(Count = c(su$out_of_smp, su$in_smp, 
        su$size_pop, su$size_smp))
    rownames(df_nobs) <- c("out of sample domains", "in sample domains", 
        "out of sample observations", "in sample observations")
    df_size_dom <- as.data.frame(su$size_dom)
    addWorksheet(wb, sheetName = "summary", gridLines = FALSE)
    writeData(wb = wb, sheet = "summary", x = "ELL", colNames = FALSE)
    addStyle(wb = wb, sheet = "summary", cols = 1, rows = 1, 
        style = title_cs, stack = TRUE)
    starting_row <- 5
    writeDataTable(x = df_nobs, withFilter = FALSE, wb = wb, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_nobs)
    writeDataTable(x = df_size_dom, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_size_dom)
    if (!is.null(su$transform)) {
        writeDataTable(x = su$transform, wb = wb, withFilter = FALSE, 
            sheet = "summary", startRow = starting_row, startCol = 3, 
            rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
            tableStyle = "TableStyleMedium2")
        starting_row <- starting_row + 2 + nrow(su$transform)
    }
    writeDataTable(x = su$normality, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(su$normality)
    writeDataTable(x = su$coeff_determ, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 4, 
        rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    setColWidths(wb = wb, sheet = "summary", cols = 3:9, widths = "auto")
    return(wb)
}
add_summary_fh <-
function (object, wb, headlines_cs) 
{
    su <- summary(object)
    title_cs <- createStyle(fontSize = 14, border = "Bottom", 
        halign = "left", borderStyle = "thick", textDecoration = "bold")
    df_nobs <- data.frame(Count = c(su$out_of_smp, su$in_smp))
    rownames(df_nobs) <- c("out of sample domains", "in sample domains")
    addWorksheet(wb, sheetName = "summary", gridLines = FALSE)
    writeData(wb = wb, sheet = "summary", x = "Fay-Herriot Approach", 
        colNames = FALSE)
    addStyle(wb = wb, sheet = "summary", cols = 1, rows = 1, 
        style = title_cs, stack = TRUE)
    starting_row <- 5
    writeDataTable(x = df_nobs, withFilter = FALSE, wb = wb, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_nobs)
    if (su$model$correlation == "no") {
        estimMethods <- data.frame(su$method$method, su$model$variance, 
            su$method$MSE_method, row.names = "")
        names(estimMethods) <- c("Variance estimation", "Estimated variance", 
            "MSE estimation")
        if (su$method$method == "reblup") {
            estimMethods$k <- su$model$k
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "MSE estimation")]
        }
        else if (su$method$method == "reblupbc") {
            estimMethods$k <- su$model$k
            estimMethods$mult_constant <- su$model$mult_constant
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "mult_constant", "MSE estimation")]
        }
    }
    else if (su$model$correlation == "spatial") {
        estimMethods <- data.frame(su$method$method, su$model$variance["variance"], 
            su$model$variance["correlation"], su$method$MSE_method, 
            row.names = "")
        names(estimMethods) <- c("Variance estimation", "Estimated variance", 
            "Spatial correlation", "MSE estimation")
        if (su$method$method == "reblup") {
            estimMethods$k <- su$model$k
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "Spatial correlation", 
                "MSE estimation")]
        }
        else if (su$method$method == "reblupbc") {
            estimMethods$k <- su$model$k
            estimMethods$mult_constant <- su$model$mult_constant
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "mult_constant", "Spatial correlation", 
                "MSE estimation")]
        }
    }
    writeDataTable(x = estimMethods, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(estimMethods)
    if (!is.null(su$transform)) {
        writeDataTable(x = su$transform, wb = wb, withFilter = FALSE, 
            sheet = "summary", startRow = starting_row, startCol = 3, 
            rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
            tableStyle = "TableStyleMedium2")
        starting_row <- starting_row + 2 + nrow(su$transform)
    }
    writeDataTable(x = su$normality, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(su$normality)
    if (su$model$correlation == "no" && !(su$method$method %in% 
        c("reblup", "reblupbc") | su$method$method == "me")) {
        writeDataTable(x = su$model$model_select, wb = wb, withFilter = FALSE, 
            sheet = "summary", startRow = starting_row, startCol = 3, 
            rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
            tableStyle = "TableStyleMedium2")
    }
    setColWidths(wb = wb, sheet = "summary", cols = 3:9, widths = "auto")
    return(wb)
}
add_summary_hdp <-
function (object, wb, headlines_cs) 
{
    su <- summary(object)
    title_cs <- createStyle(fontSize = 14, border = "Bottom", 
        halign = "left", borderStyle = "thick", textDecoration = "bold")
    df_nobs <- data.frame(Count = c(su$out_of_smp, su$in_smp, 
        su$size_pop, su$size_smp))
    rownames(df_nobs) <- c("out of sample domains", "in sample domains", 
        "out of sample observations", "in sample observations")
    df_size_dom <- as.data.frame(su$size_dom)
    addWorksheet(wb, sheetName = "summary", gridLines = FALSE)
    writeData(wb = wb, sheet = "summary", x = "Empirical Best Prediction", 
        colNames = FALSE)
    addStyle(wb = wb, sheet = "summary", cols = 1, rows = 1, 
        style = title_cs, stack = TRUE)
    starting_row <- 5
    writeDataTable(x = df_nobs, withFilter = FALSE, wb = wb, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_nobs)
    writeDataTable(x = df_size_dom, wb = wb, withFilter = FALSE, 
        sheet = "summary", startRow = starting_row, startCol = 3, 
        rowNames = TRUE, headerStyle = headlines_cs, colNames = TRUE, 
        tableStyle = "TableStyleMedium2")
    starting_row <- starting_row + 2 + nrow(df_size_dom)
    if (!is.null(su$transform)) {
        writeDataTable(x = su$transform, wb = wb, withFilter = FALSE, 
            sheet = "summary", startRow = starting_row, startCol = 3, 
            rowNames = FALSE, headerStyle = headlines_cs, colNames = TRUE, 
            tableStyle = "TableStyleMedium2")
        starting_row <- starting_row + 2 + nrow(su$transform)
    }
    setColWidths(wb = wb, sheet = "summary", cols = 3:9, widths = "auto")
    return(wb)
}
add_summary_ods_ebp <-
function (object, wb, no_file, headlines_cs) 
{
    su <- summary(object)
    df_nobs <- data.frame(Count = c(su$out_of_smp, su$in_smp, 
        su$size_pop, su$size_smp))
    rownames(df_nobs) <- c("out of sample domains", "in sample domains", 
        "out of sample observations", "in sample observations")
    df_nobs <- cbind.data.frame(rownames(df_nobs), df_nobs)
    if (no_file == TRUE) {
        readODS::write_ods(x = df_nobs, path = paste0(tempdir(), 
            "\\", wb, "_sumObs", ".ods"))
    }
    else {
        readODS::write_ods(x = df_nobs, path = paste0(wb, "_sumObs", 
            ".ods"))
    }
    df_size_dom <- as.data.frame(su$size_dom)
    df_size_dom <- cbind.data.frame(rownames(df_size_dom), df_size_dom)
    if (no_file == TRUE) {
        readODS::write_ods(x = df_size_dom, path = paste0(tempdir(), 
            "\\", wb, "_sumDom", ".ods"))
    }
    else {
        readODS::write_ods(x = df_size_dom, path = paste0(wb, 
            "_sumDom", ".ods"))
    }
    if (!is.null(su$transform)) {
        if (no_file == TRUE) {
            readODS::write_ods(x = su$transform, path = paste0(tempdir(), 
                "\\", wb, "_sumTrafo", ".ods"))
        }
        else {
            readODS::write_ods(x = su$transform, path = paste0(wb, 
                "_sumTrafo", ".ods"))
        }
    }
    su$normality <- cbind.data.frame(rownames(su$normality), 
        su$normality)
    readODS::write_ods(x = su$normality, path = paste0(tempdir(), 
        "\\", wb, "_sumNorm", ".ods"))
    su$coeff_determ <- cbind.data.frame("Coefficients of determination", 
        su$coeff_determ)
    if (no_file == TRUE) {
        readODS::write_ods(x = su$coeff_determ, path = paste0(tempdir(), 
            "\\", wb, "_sumCoefDet", ".ods"))
    }
    else {
        readODS::write_ods(x = su$coeff_determ, path = paste0(wb, 
            "_sumCoefDet", ".ods"))
    }
    return(NULL)
}
add_summary_ods_fh <-
function (object, wb, no_file, headlines_cs) 
{
    su <- summary(object)
    df_nobs <- data.frame(Count = c(su$out_of_smp, su$in_smp))
    rownames(df_nobs) <- c("out of sample domains", "in sample domains")
    df_nobs <- cbind.data.frame(rownames(df_nobs), df_nobs)
    if (no_file == TRUE) {
        readODS::write_ods(x = df_nobs, path = paste0(tempdir(), 
            "\\", wb, "_sumObs", ".ods"))
    }
    else {
        readODS::write_ods(x = df_nobs, path = paste0(wb, "_sumObs", 
            ".ods"))
    }
    if (su$model$correlation == "no") {
        estimMethods <- data.frame(su$method$method, su$model$variance, 
            su$method$MSE_method, row.names = "")
        names(estimMethods) <- c("Variance estimation", "Estimated variance", 
            "MSE estimation")
        if (su$method$method == "reblup") {
            estimMethods$k <- su$model$k
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "MSE estimation")]
        }
        else if (su$method$method == "reblupbc") {
            estimMethods$k <- su$model$k
            estimMethods$c <- su$model$c
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "c", "MSE estimation")]
        }
    }
    else if (su$model$correlation == "spatial") {
        estimMethods <- data.frame(su$method$method, su$model$variance["variance"], 
            su$model$variance["correlation"], su$method$MSE_method, 
            row.names = "")
        names(estimMethods) <- c("Variance estimation", "Estimated variance", 
            "Spatial correlation", "MSE estimation")
        if (su$method$method == "reblup") {
            estimMethods$k <- su$model$k
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "Spatial correlation", 
                "MSE estimation")]
        }
        else if (su$method$method == "reblupbc") {
            estimMethods$k <- su$model$k
            estimMethods$mult_constant <- su$model$mult_constant
            estimMethods <- estimMethods[, c("Variance estimation", 
                "Estimated variance", "k", "mult_constant", "Spatial correlation", 
                "MSE estimation")]
        }
    }
    if (no_file == TRUE) {
        readODS::write_ods(x = estimMethods, path = paste0(tempdir(), 
            "\\", wb, "_sumEstimMethods", ".ods"))
    }
    else {
        readODS::write_ods(x = estimMethods, path = paste0(wb, 
            "_sumEstimMethods", ".ods"))
    }
    if (!is.null(su$transform)) {
        if (no_file == TRUE) {
            readODS::write_ods(x = su$transform, path = paste0(tempdir(), 
                "\\", wb, "_sumTrafo", ".ods"))
        }
        else {
            readODS::write_ods(x = su$transform, path = paste0(wb, 
                "_sumTrafo", ".ods"))
        }
    }
    su$normality <- cbind.data.frame(rownames(su$normality), 
        su$normality)
    if (no_file == TRUE) {
        readODS::write_ods(x = su$normality, path = paste0(tempdir(), 
            "\\", wb, "_sumNorm", ".ods"))
    }
    else {
        readODS::write_ods(x = su$normality, path = paste0(wb, 
            "_sumNorm", ".ods"))
    }
    if (su$model$correlation == "no" && !(su$method$method %in% 
        c("reblup", "reblupbc") | su$method$method == "me")) {
        if (no_file == TRUE) {
            readODS::write_ods(x = su$model$model_select, path = paste0(tempdir(), 
                "\\", wb, "_sumModelSelect", ".ods"))
        }
        else {
            readODS::write_ods(x = su$model$model_select, path = paste0(wb, 
                "_sumModelSelect", ".ods"))
        }
    }
    return(NULL)
}
aggregate_weighted_mean <-
function (df, by, w) 
{
    wdf <- cbind(df * w, w)
    wdf_sum <- aggregate(wdf, by = by, FUN = sum)
    aggregate_weighted_mean <- cbind(Domain = wdf_sum[, 1], wdf_sum[, 
        -1]/wdf_sum$w)
    aggregate_weighted_mean <- within(aggregate_weighted_mean, 
        rm(w))
    return(aggregate_weighted_mean)
}
aggregate_weighted_quantile <-
function (df, by, w, q) 
{
    aggregate_weighted_quantile <- mapply(FUN = wtd.quantile, 
        x = split(df, by), weight = split(w, pop_domains_vec_tmp), 
        probs = q)
}
alphamodel <-
function (residuals, alpha, framework) 
{
    if (is.null(framework$weights)) {
        weight_smp <- rep(1, framework$N_smp)
    }
    else {
        weight_smp <- framework$smp_data[[as.character(framework$weights)]]
    }
    mean_resid <- aggregate_weighted_mean(df = residuals, by = list(framework$smp_data[, 
        framework$smp_domains]), w = weight_smp)
    dev_resid <- residuals - rep(mean_resid$V1, framework$n_smp)
    eps_squared <- dev_resid^2
    A <- 1.05 * max(eps_squared)
    framework$smp_data$transformed_eps_squared <- log(eps_squared/(A - 
        eps_squared))
    framework$smp_data$transformed_eps_squared[eps_squared == 
        0] <- 0
    model <- reformulate(response = "transformed_eps_squared", 
        as.character(alpha[-1]))
    alpha_model <- lm(model, data = framework$smp_data, weights = weight_smp)
    B_smp <- exp(predict(alpha_model))
    var_r <- summary(alpha_model)$sigma^2
    sigmae2est_smp <- (A * B_smp/(1 + B_smp)) + 0.5 * var_r * 
        (A * B_smp * (1 - B_smp)/(1 + B_smp)^3)
    dev_resid_std <- dev_resid/sigmae2est_smp^0.5
    dev_resid_std <- dev_resid_std - ave(dev_resid_std, by = framework$smp_data[, 
        framework$smp_domains])
    alpha_X_vars <- alpha_model$terms
    framework$pop_data[[paste0(alpha_X_vars[[2]])]] <- seq_len(nrow(framework$pop_data))
    X_pop <- model.matrix(alpha_X_vars, framework$pop_data)
    B_pop <- exp(X_pop %*% alpha_model$coefficients)
    sigmae2est_pop <- (A * B_pop/(1 + B_pop)) + 0.5 * var_r * 
        (A * B_pop * (1 - B_pop)/(1 + B_pop)^3)
    sigmae2est_pop[sigmae2est_pop < min(sigmae2est_smp)] <- min(sigmae2est_smp)
    sigmae2est_pop[sigmae2est_pop > max(sigmae2est_smp)] <- max(sigmae2est_smp)
    return(list(alpha_model = alpha_model, sigmae2est_smp = sigmae2est_smp, 
        sigmae2est_pop = sigmae2est_pop, dev_resid_std = dev_resid_std, 
        mean_resid = mean_resid$V1))
}
analytic <-
function (transformation, framework, lambda, shift, model_par, 
    gen_model, fixed, Ydump) 
{
    if (!is.null(framework$aggregate_to_vec)) {
        N_dom_pop_tmp <- framework$N_dom_pop_agg
        pop_domains_vec_tmp <- framework$aggregate_to_vec
    }
    else {
        N_dom_pop_tmp <- framework$N_dom_pop
        pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    if (!is.null(framework$pop_weights)) {
        pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
    }
    else {
        pop_weights_vec <- rep(1, framework$N_pop)
    }
    sigma2vu <- vector(length = framework$N_pop)
    sigma2vu[!framework$obs_dom] <- model_par$sigmau2est
    sigma2vu[framework$obs_dom] <- rep(gen_model$sigmav2est, 
        framework$n_pop[framework$dist_obs_dom])
    if (model_par$sigmah2est == 0) {
        sigma2eta <- 0
    }
    else {
        sigma2eta <- vector(length = framework$N_pop)
        sigma2eta[!framework$obs_subdom] <- model_par$sigmah2est
        sigma2eta[framework$obs_subdom] <- rep(gen_model$sigmai2est, 
            framework$n_pop_subdom[framework$dist_obs_subdom])
    }
    var <- sigma2vu + sigma2eta + model_par$sigmae2est
    indicators <- matrix(ncol = length(framework$indicator_names), 
        nrow = framework$N_pop)
    colnames(indicators) <- framework$indicator_names
    if ("Mean" %in% framework$indicator_names) {
        indicators[, "Mean"] <- expected_untransformed_mean(gen_model$mu, 
            var = var, transformation = transformation, lambda = lambda)
    }
    if ("Head_Count" %in% framework$indicator_names) {
        indicators[, "Head_Count"] <- expected_head_count(mu = gen_model$mu, 
            var = var, transformation = transformation, lambda = lambda, 
            threshold = framework$threshold, shift = shift)
    }
    if ("Poverty_Gap" %in% framework$indicator_names) {
        if ("Head_Count" %in% framework$indicator_names) {
            Head_Count_temp <- indicators[, "Head_Count"]
        }
        else {
            Head_Count_temp <- matrix(ncol = 1, nrow = framework$N_pop)
            Head_Count_temp <- expected_head_count(mu = gen_model$mu, 
                var = var, transformation = transformation, lambda = lambda, 
                threshold = framework$threshold, shift = shift)
        }
        conditional_mean <- conditional_untransformed_mean(Head_Count = Head_Count_temp, 
            mu = gen_model$mu, var = var, transformation = transformation, 
            lambda = lambda, threshold = framework$threshold, 
            shift = shift)
        if (!is.null(conditional_mean)) {
            indicators[, "Poverty_Gap"] <- Head_Count_temp * 
                (1 - conditional_mean/framework$threshold)
        }
    }
    if ("Gini" %in% framework$indicator_names) {
        indicators[, "Gini"] <- expected_gini(mu = gen_model$mu, 
            var = var, transformation = transformation, lambda = lambda, 
            popwt = pop_weights_vec, pop_domains = framework$pop_data[, 
                framework$pop_domains])
    }
    if (!is.null(Ydump)) {
        rand_eff_pop <- rep(model_par$rand_eff, framework$n_pop)
        Ydumpdf <- data.frame(framework$pop_domains_vec, indicators, 
            gen_model$mu, var, sigma2vu, sigma2eta, model_par$sigmae2est, 
            framework$pop_data[, framework$pop_weights], framework$obs_dom, 
            rand_eff_pop, gen_model$mu_fixed)
        colnames(Ydumpdf) <- c("Domain", framework$indicator_names, 
            "Mu", "Variance", "Var_vu", "Var_eta", "Var_eps", 
            "pop_weight", "Observed_dom", "Area_reffect", "Xbhat")
        write.table(Ydumpdf, file = Ydump, row.names = FALSE, 
            append = FALSE, col.names = T, sep = ",")
    }
    point_estimates <- aggregate_weighted_mean(indicators, by = list(Domain = pop_domains_vec_tmp), 
        w = pop_weights_vec)
    colnames(point_estimates) <- c("Domain", framework$indicator_names)
    return(point_estimates)
}
analytical_mse <-
function (framework, sigmau2, combined_data, method) 
{
    if (framework$correlation == "spatial") {
        mse_data <- prasad_rao_spatial(framework = framework, 
            sigmau2, combined_data, method)
        MSE_method <- "prasad-rao-Singh"
    }
    else if (method == "reml") {
        mse_data <- prasad_rao(framework = framework, sigmau2 = sigmau2, 
            combined_data = combined_data)
        MSE_method <- "prasad-rao"
    }
    else if (method == "amrl" || method == "ampl") {
        mse_data <- li_lahiri(framework = framework, sigmau2, 
            combined_data, method = method)
        MSE_method <- "li-lahiri"
    }
    else if (method == "ampl_yl") {
        mse_data <- yoshimori_lahiri(framework = framework, sigmau2, 
            combined_data, method = method)
        MSE_method <- "yoshimori-lahiri"
    }
    else if (method == "amrl_yl") {
        mse_data <- yoshimori_lahiri(framework = framework, sigmau2, 
            combined_data, method = method)
        MSE_method <- "prasad-rao"
    }
    else if (method == "ml") {
        mse_data <- datta_lahiri(framework = framework, sigmau2, 
            combined_data)
        MSE_method <- "datta-lahiri"
    }
    mse_out <- list(mse_data = mse_data, MSE_method = MSE_method)
    return(mse_out)
}
arcsin_bc <-
function (framework, mu, var) 
{
    int_value <- NULL
    for (i in seq_len(framework$M)) {
        if (framework$obs_dom[i] == TRUE) {
            mu_dri <- mu[i]
            var_dri <- as.numeric(var[i])
            int_value <- c(int_value, integrate(integrand, lower = 0, 
                upper = pi/2, mu_dri, sqrt(var_dri))$value)
        }
        else {
            int_value <- c(int_value, (sin(mu[i]))^2)
        }
    }
    return(int_value)
}
arcsin_bt <-
function (sigmau2 = sigmau2, combined_data = combined_data, framework = framework, 
    eblup = eblup, vardir = vardir, mse_type = mse_type, method = method, 
    interval = interval, MSE = MSE, B = B, backtransformation = backtransformation) 
{
    point_backtransformed <- arcsin_point(framework, sigmau2, 
        eblup, backtransformation)
    if (MSE == TRUE) {
        mse_backtransformed <- arcsin_mse(sigmau2 = sigmau2, 
            combined_data = combined_data, framework = framework, 
            eblup = eblup, vardir = vardir, eblup_corr = point_backtransformed, 
            mse_type = mse_type, method = method, interval = interval, 
            B = B, backtransformation = backtransformation)
        mse_method <- mse_backtransformed$mse_method
    }
    else {
        mse_backtransformed <- NULL
        mse_method <- "no mse estimated"
    }
    arcsin_bt_out <- list(point_backtransformed = point_backtransformed, 
        mse_backtransformed = mse_backtransformed$mse_backtransformed, 
        mse_method = mse_method)
    return(arcsin_bt_out)
}
arcsin_mse <-
function (sigmau2 = sigmau2, combined_data = combined_data, framework = framework, 
    eblup = eblup, vardir = vardir, eblup_corr = eblup_corr, 
    mse_type = mse_type, method = method, interval = interval, 
    B = B, backtransformation = backtransformation) 
{
    if (mse_type == "boot") {
        mse_backtransformed <- boot_arcsin_2(sigmau2 = sigmau2, 
            combined_data = combined_data, framework = framework, 
            eblup = eblup, eblup_corr = eblup_corr, method = method, 
            interval = interval, B = B, backtransformation = backtransformation)
        mse_backtransformed <- mse_backtransformed[[2]]$MSE
        mse_method <- "bootstrap"
    }
    else if (mse_type == "jackknife" || mse_type == "weighted_jackknife") {
        transformation <- "arcsin"
        jack_mse <- wrapper_MSE(framework = framework, combined_data = combined_data, 
            sigmau2 = sigmau2, vardir = vardir, eblup = eblup, 
            transformation = transformation, method = method, 
            interval = interval, mse_type = mse_type)
        mse_backtransformed <- rep(NA, framework$M)
        mse_backtransformed[framework$obs_dom] <- 2 * sin(eblup$eblup_data$FH[framework$obs_dom]) * 
            cos(eblup$eblup_data$FH[framework$obs_dom]) * jack_mse$mse_data$FH[framework$obs_dom]
        mse_method <- jack_mse$MSE_method
    }
    arcsin_mse_out <- list(mse_backtransformed = mse_backtransformed, 
        mse_method = mse_method)
    return(arcsin_mse_out)
}
arcsin_naive <-
function (eblup) 
{
    point_backtransformed <- eblup$eblup_data$FH
    point_backtransformed[point_backtransformed < 0] <- 0
    point_backtransformed[point_backtransformed > (pi/2)] <- (pi/2)
    point_backtransformed <- (sin(point_backtransformed))^2
    return(point_backtransformed)
}
arcsin_point <-
function (framework, sigmau2, eblup, backtransformation) 
{
    point_backtransformed <- if (backtransformation == "naive") {
        arcsin_naive(eblup)
    }
    else if (backtransformation == "bc") {
        var <- rep(NA, framework$M)
        var[framework$obs_dom] <- sigmau2 * (1 - eblup$gamma)
        mu <- eblup$eblup_data$FH
        arcsin_bc(framework, mu, var)
    }
    return(point_backtransformed)
}
arcsin_transform <-
function (y, shift = NULL) 
{
    y <- asin(sqrt(y))
    return(list(y = y, shift = shift))
}
arcsin_transform_back <-
function (y, shift = NULL) 
{
    y <- sin(y)^2
    return(y = y)
}
as.data.frame.estimators.povmap <-
function (x, ...) 
{
    as.data.frame(x$ind, ...)
}
as.matrix.estimators.povmap <-
function (x, ...) 
{
    as.matrix(x$ind[, -1])
}
back_transformation <-
function (y, transformation, lambda, shift, framework, fixed) 
{
    back_transformed <- if (transformation == "no") {
        no_transform_back(y = y)
    }
    else if (transformation == "log") {
        log_transform_back(y = y, shift = shift)
    }
    else if (transformation == "box.cox") {
        box_cox_back(y = y, lambda = lambda, shift = shift)
    }
    else if (transformation == "dual") {
        dual_back(y = y, lambda = lambda, shift = shift)
    }
    else if (transformation == "log.shift") {
        log_shift_opt_back(y = y, lambda = lambda)
    }
    else if (transformation == "arcsin") {
        arcsin_transform_back(y = y, shift = shift)
    }
    else if (transformation == "ordernorm") {
        ordernorm_back(y = y, shift = shift, framework = framework, 
            fixed = fixed)
    }
    else if (transformation == "logit") {
        logit_transform_back(y = y, shift = shift)
    }
    return(y = back_transformed)
}
backtransformed <-
function (framework, sigmau2, eblup, transformation, backtransformation, 
    combined_data, method, vardir, interval, B, MSE, mse_type) 
{
    backtransformed_estims <- if (transformation == "log") {
        log_bt(framework, sigmau2, combined_data, eblup = eblup, 
            method, MSE, backtransformation)
    }
    else if (transformation == "arcsin") {
        arcsin_bt(sigmau2 = sigmau2, combined_data = combined_data, 
            framework = framework, eblup = eblup, vardir = vardir, 
            mse_type = mse_type, method = method, interval = interval, 
            MSE = MSE, B = B, backtransformation = backtransformation)
    }
    eblup_data <- data.frame(Domain = combined_data[[framework$domains]])
    eblup_data$Direct <- NA
    eblup_data$Direct[framework$obs_dom] <- framework$direct_orig
    mse_data <- data.frame(Domain = combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom] <- framework$vardir_orig
    eblup_data$FH <- backtransformed_estims$point_backtransformed
    mse_data$FH <- backtransformed_estims$mse_backtransformed
    eblup_data$Out <- 1
    eblup_data$Out[framework$obs_dom] <- 0
    if (MSE == TRUE) {
        mse_data$Out <- 1
        mse_data$Out[framework$obs_dom] <- 0
    }
    back_out <- list(eblup_data = eblup_data, mse_data = mse_data, 
        MSE_method = backtransformed_estims$mse_method)
    return(back_out)
}
bc_crude <-
function (framework, sigmau2, combined_data, eblup = eblup, method, 
    MSE) 
{
    estim_mse <- analytical_mse(framework = framework, sigmau2 = sigmau2, 
        combined_data = combined_data, method = method)
    point_backtransformed <- exp(eblup$eblup_data$FH + 0.5 * 
        estim_mse$mse_data$FH)
    if (MSE == TRUE) {
        mse_backtransformed <- exp(eblup$eblup_data$FH + 0.5 * 
            estim_mse$mse_data$FH)^2 * estim_mse$mse_data$FH
        mse_method <- estim_mse$MSE_method
    }
    else {
        mse_backtransformed <- NULL
        mse_method <- "no mse estimated"
    }
    bc_crude_out <- list(point_backtransformed = point_backtransformed, 
        mse_backtransformed = mse_backtransformed, mse_method = mse_method)
    return(bc_crude_out)
}
bc_sm <-
function (framework, sigmau2, combined_data, eblup = eblup, method, 
    MSE) 
{
    point_backtransformed <- rep(NA, framework$M)
    point_backtransformed[framework$obs_dom == TRUE] <- exp(eblup$eblup_data$FH[framework$obs_dom == 
        TRUE] + (0.5 * sigmau2 * (1 - eblup$gamma)))
    if (MSE == TRUE) {
        mse_backtransformed <- slud_maiti(framework = framework, 
            sigmau2 = sigmau2, eblup = eblup, combined_data = combined_data)$FH
        mse_method <- "slud-maiti"
    }
    else {
        mse_backtransformed <- NULL
        mse_method <- "no mse estimated"
    }
    bc_sm_out <- list(point_backtransformed = point_backtransformed, 
        mse_backtransformed = mse_backtransformed, mse_method = mse_method)
    return(bc_sm_out)
}
benchmark <-
function (object, benchmark, share, type = "raking", overwrite = FALSE) 
{
    check_benchmark_arguments(object = object, benchmark = benchmark, 
        share = share, type = type, overwrite = overwrite)
    estim <- object$ind$FH
    FH_bench <- rep(NA, length(object$ind$FH))
    if (type == "raking") {
        FH_bench <- estim + benchmark - sum(share * estim)
    }
    else if (type == "ratio") {
        phi <- share/object$ind$FH
        FH_bench <- estim + (1/(sum(share^2/phi))) * (benchmark - 
            sum(share * estim)) * (share/phi)
    }
    else if (type == "MSE_adj") {
        phi <- share/object$MSE$FH
        FH_bench <- estim + (1/(sum(share^2/phi))) * (benchmark - 
            sum(share * estim)) * (share/phi)
    }
    if (overwrite == FALSE) {
        eblup_data_bench <- data.frame(Domain = object$ind$Domain)
        eblup_data_bench$Direct <- object$ind$Direct
        eblup_data_bench$FH <- object$ind$FH
        eblup_data_bench$FH_Bench <- FH_bench
        eblup_data_bench$Out <- object$ind$Out
        result <- eblup_data_bench
    }
    else {
        object$ind$FH_Bench <- FH_bench
        object$ind <- object$ind[, c("Domain", "Direct", "FH", 
            "FH_Bench", "Out")]
        object["MSE"] <- list(NULL)
        message(strwrap(prefix = " ", initial = "", "Please note that only point estimates are benchmarked.\n                    Thus, the MSE element in the new emdi object is NULL."))
        result <- object
    }
    return(result)
}
benchmark_ebp_level <-
function (point_estim, framework, fixed, benchmark, benchmark_type, 
    benchmark_level) 
{
    if (!(is.numeric(benchmark) || is.data.frame(benchmark))) {
        benchmark_ <- data.frame(unique(framework$pop_data[[benchmark_level]]), 
            as.data.frame(matrix(nrow = length(unique(framework$pop_data[[benchmark_level]])), 
                ncol = length(benchmark))))
        names(benchmark_) <- c(benchmark_level, benchmark)
        if (is.list(point_estim)) {
            estim <- as.list(point_estim$ind[benchmark])
            for (i in benchmark) {
                for (j in benchmark_[[benchmark_level]]) {
                  if (i == "Mean") {
                    benchmark_[which(benchmark_[benchmark_level] == 
                      j), i] <- weighted.mean(framework$smp_data[framework$smp_data[benchmark_level] == 
                      j, paste0(fixed[2])], framework$smp_data[framework$smp_data[benchmark_level] == 
                      j, framework$benchmark_weights])
                  }
                  else if (i == "Head_Count") {
                    benchmark_[which(benchmark_[benchmark_level] == 
                      j), i] <- weighted.mean(framework$smp_data[framework$smp_data[benchmark_level] == 
                      j, paste0(fixed[2])] < framework$threshold, 
                      framework$smp_data[framework$smp_data[benchmark_level] == 
                        j, framework$benchmark_weights])
                  }
                }
            }
        }
        else {
            estim <- as.list(as.data.frame(point_estim)[benchmark])
            for (i in benchmark) {
                for (j in benchmark_[[benchmark_level]]) {
                  if (i == "Mean") {
                    benchmark_[which(benchmark_[benchmark_level] == 
                      j), i] <- weighted.mean(framework$smp_data[framework$smp_data[benchmark_level] == 
                      j, paste0(fixed[2])], framework$smp_data[framework$smp_data[benchmark_level] == 
                      j, framework$benchmark_weights])
                  }
                  else if (i == "Head_Count") {
                    benchmark_[which(benchmark_[benchmark_level] == 
                      j), i] <- weighted.mean(framework$smp_data[framework$smp_data[benchmark_level] == 
                      j, paste0(fixed[2])] < framework$threshold, 
                      framework$smp_data[framework$smp_data[benchmark_level] == 
                        j, framework$benchmark_weights])
                  }
                }
            }
        }
        benchmark <- benchmark_
    }
    else {
        if (is.list(point_estim)) {
            if (is.numeric(benchmark)) {
                estim <- as.list(point_estim$ind[names(benchmark)])
            }
            else {
                estim <- as.list(point_estim$ind[names(benchmark)[-1]])
            }
        }
        else {
            if (is.numeric(benchmark)) {
                estim <- as.list(as.data.frame(point_estim)[names(benchmark)])
            }
            else {
                estim <- as.list(as.data.frame(point_estim)[names(benchmark)[-1]])
            }
        }
    }
    EBP_bench <- as.list(as.data.frame(matrix(NA, nrow = length(estim[[1]]), 
        ncol = length(benchmark) - 1)))
    names(EBP_bench) <- names(benchmark)[-1]
    for (j in benchmark[[benchmark_level]]) {
        pop_tmp <- framework$pop_data[framework$pop_data[[benchmark_level]] == 
            j, ]
        if (is.null(framework$pop_weights)) {
            if (is.null(framework$aggregate_to)) {
                share <- table(as.character(pop_tmp[[framework$smp_domains]]))/nrow(pop_tmp)
                estim_levels_num <- pmatch(names(share), unique(framework$pop_domains_vec))
            }
            else {
                share <- table(as.character(pop_tmp[[framework$aggregate_to]]))/nrow(pop_tmp)
                estim_levels_num <- pmatch(names(share), unique(framework$aggregate_to_vec))
            }
        }
        else {
            if (is.null(framework$aggregate_to)) {
                share <- tapply(X = pop_tmp[[framework$pop_weights]], 
                  INDEX = pop_tmp[[framework$smp_domains]], FUN = sum)/sum(pop_tmp[[framework$pop_weights]])
                share <- share[!is.na(share)]
                estim_levels_num <- pmatch(names(share), unique(framework$pop_domains_vec))
            }
            else {
                share <- tapply(X = pop_tmp[[framework$pop_weights]], 
                  INDEX = pop_tmp[[framework$aggregate_to]], 
                  FUN = sum)/sum(pop_tmp[[framework$pop_weights]])
                share <- share[!is.na(share)]
                estim_levels_num <- pmatch(names(share), unique(framework$aggregate_to_vec))
            }
        }
        for (i in names(benchmark)[-1]) {
            if (benchmark_type == "raking") {
                EBP_bench[[i]][estim_levels_num] <- estim[[i]][estim_levels_num] + 
                  benchmark[[i]][benchmark[[benchmark_level]] == 
                    j] - sum(share * estim[[i]][estim_levels_num])
            }
            else if (benchmark_type == "ratio") {
                EBP_bench[[i]][estim_levels_num] <- estim[[i]][estim_levels_num] * 
                  (benchmark[[i]][benchmark[[benchmark_level]] == 
                    j]/sum(share * estim[[i]][estim_levels_num]))
            }
            else if (benchmark_type == "ratio_complement" && 
                i == "Head_Count") {
                EBP_bench[[i]][estim_levels_num] <- 1 - ((1 - 
                  estim[[i]][estim_levels_num]) * (1 - benchmark[[i]][benchmark[[benchmark_level]] == 
                  j])/sum(share * (1 - estim[[i]][estim_levels_num])))
            }
        }
    }
    names(EBP_bench) <- c(paste0(names(benchmark)[-1], "_bench"))
    if (is.list(point_estim)) {
        point_estim_bench <- data.frame(point_estim$ind, EBP_bench)
    }
    else {
        point_estim_bench <- as.matrix(data.frame(point_estim, 
            EBP_bench))
    }
    return(point_estim_bench)
}
benchmark_ebp_national <-
function (point_estim, framework, fixed, benchmark, benchmark_type) 
{
    if (!is.numeric(benchmark)) {
        benchmark_ <- rep(NA, length(benchmark))
        names(benchmark_) <- benchmark
        if (is.list(point_estim)) {
            estim <- as.list(point_estim$ind[benchmark])
            for (i in benchmark) {
                if (i == "Mean") {
                  benchmark_[i] <- weighted.mean(framework$smp_data[[paste0(fixed[2])]], 
                    framework$smp_data[[framework$benchmark_weights]])
                }
                else if (i == "Head_Count") {
                  benchmark_[i] <- weighted.mean(framework$smp_data[[paste0(fixed[2])]] < 
                    framework$threshold, framework$smp_data[[framework$benchmark_weights]])
                }
            }
        }
        else {
            estim <- as.list(as.data.frame(point_estim)[benchmark])
            for (i in benchmark) {
                if (i == "Mean") {
                  benchmark_[i] <- mean(framework$smp_data[[paste0(fixed[2])]])
                }
                else if (i == "Head_Count") {
                  benchmark_[i] <- mean(framework$smp_data[[paste0(fixed[2])]] < 
                    framework$threshold)
                }
            }
        }
        benchmark <- benchmark_
    }
    else {
        if (is.list(point_estim)) {
            estim <- as.list(point_estim$ind[names(benchmark)])
        }
        else {
            estim <- as.list(as.data.frame(point_estim)[names(benchmark)])
        }
    }
    EBP_bench <- as.list(as.data.frame(matrix(NA, nrow = length(estim[[1]]), 
        ncol = length(benchmark))))
    names(EBP_bench) <- names(benchmark)
    if (is.null(framework$pop_weights)) {
        if (is.null(framework$aggregate_to)) {
            share <- framework$n_pop/framework$N_pop
        }
        else {
            share <- as.numeric(table(framework$aggregate_to_vec))/framework$N_pop
        }
    }
    else {
        if (is.null(framework$aggregate_to)) {
            share <- tapply(X = framework$pop_data[[framework$pop_weights]], 
                INDEX = framework$pop_data[[framework$smp_domains]], 
                FUN = sum)/sum(framework$pop_data[[framework$pop_weights]])
        }
        else {
            share <- tapply(X = framework$pop_data[[framework$pop_weights]], 
                INDEX = framework$aggregate_to_vec, FUN = sum)/sum(framework$pop_data[[framework$pop_weights]])
        }
    }
    for (i in names(benchmark)) {
        if (benchmark_type == "raking") {
            EBP_bench[[i]] <- estim[[i]] + benchmark[[i]] - sum(share * 
                estim[[i]])
        }
        else if (benchmark_type == "ratio") {
            phi <- share/estim[[i]]
            EBP_bench[[i]] <- estim[[i]] + (1/(sum(share^2/phi))) * 
                (benchmark[[i]] - sum(share * estim[[i]])) * 
                (share/phi)
        }
        else if (benchmark_type == "ratio_complement" && i == 
            "Head_Count") {
            estim_complement[[i]] <- 1 - estim[[i]]
            benchmark_complement[[i]] <- 1 - benchmark[[i]]
            EBP_bench_complement[[i]] <- estim[[i]] + (1/(sum(share^2/phi))) * 
                (benchmark_complement[[i]] - sum(share * estim[[i]])) * 
                (share/phi)
            EBP_bench[[i]] <- 1 - EBP_bench_complement
        }
    }
    names(EBP_bench) <- c(paste0(names(benchmark), "_bench"))
    if (is.list(point_estim)) {
        point_estim_bench <- data.frame(point_estim$ind, EBP_bench)
    }
    else {
        point_estim_bench <- as.matrix(data.frame(point_estim, 
            EBP_bench))
    }
    return(point_estim_bench)
}
boot_arcsin_2 <-
function (sigmau2, vardir, combined_data, framework, eblup, eblup_corr, 
    B, method, interval, backtransformation) 
{
    M <- framework$M
    m <- framework$m
    vardir <- framework$vardir
    eff_smpsize <- framework$eff_smpsize
    x <- framework$model_X
    in_sample <- framework$obs_dom == TRUE
    out_sample <- framework$obs_dom == FALSE
    true_value_boot <- matrix(NA, ncol = B, nrow = M)
    est_value_boot <- matrix(NA, ncol = B, nrow = M)
    for (b in seq_len(B)) {
        v_boot <- rnorm(M, 0, sqrt(sigmau2))
        e_boot <- rnorm(m, 0, sqrt(vardir))
        pred_data_tmp <- framework$combined_data
        pred_data_tmp <- data.frame(pred_data_tmp, helper = rnorm(1, 
            0, 1))
        formula.tools::lhs(framework$formula) <- quote(helper)
        pred_data <- makeXY(formula = framework$formula, data = pred_data_tmp)
        pred_X <- pred_data$x
        Xbeta_boot <- pred_X %*% eblup$coefficients$coefficients
        true_value_boot_trans <- Xbeta_boot + v_boot
        true_value_boot_trans[true_value_boot_trans < 0] <- 0
        true_value_boot_trans[true_value_boot_trans > (pi/2)] <- (pi/2)
        true_value_boot[, b] <- (sin(true_value_boot_trans))^2
        ystar_trans <- Xbeta_boot[in_sample] + v_boot[in_sample] + 
            e_boot
        framework2 <- framework
        framework2$direct <- ystar_trans
        sigmau2_boot <- wrapper_estsigmau2(framework = framework2, 
            method = method, interval = interval)
        D <- diag(1, m)
        V <- sigmau2_boot * D %*% t(D) + diag(as.numeric(vardir))
        Vi <- solve(V)
        Q <- solve(t(x) %*% Vi %*% x)
        Beta.hat_boot <- Q %*% t(x) %*% Vi %*% ystar_trans
        res <- ystar_trans - c(x %*% Beta.hat_boot)
        Sigma.u <- sigmau2_boot * D
        u.hat <- Sigma.u %*% t(D) %*% Vi %*% res
        est_mean_boot_trans <- x %*% Beta.hat_boot + D %*% u.hat
        pred_out_boot_trans <- pred_X %*% Beta.hat_boot
        est_value_boot_trans <- rep(NA, M)
        est_value_boot_trans[in_sample] <- est_mean_boot_trans
        est_value_boot_trans[out_sample] <- pred_out_boot_trans[out_sample]
        gamma_trans <- as.numeric(vardir)/(sigmau2_boot + as.numeric(vardir))
        est_value_boot_trans_var <- sigmau2_boot * gamma_trans
        est_value_boot_trans_var_ <- rep(0, M)
        est_value_boot_trans_var_[in_sample] <- est_value_boot_trans_var
        if (backtransformation == "bc") {
            int_value <- NULL
            for (i in seq_len(M)) {
                if (in_sample[i] == T) {
                  mu_dri <- est_value_boot_trans
                  mu_dri <- mu_dri[i]
                  Var_dri <- est_value_boot_trans_var_
                  Var_dri <- as.numeric(Var_dri[i])
                  integrand <- function(x, mean, sd) {
                    sin(x)^2 * dnorm(x, mean = mu_dri, sd = sqrt(Var_dri))
                  }
                  upper_bound <- min(mean(framework$direct) + 
                    10 * sd(framework$direct), mu_dri + 100 * 
                    sqrt(Var_dri))
                  lower_bound <- max(mean(framework$direct) - 
                    10 * sd(framework$direct), mu_dri - 100 * 
                    sqrt(Var_dri))
                  int_value <- c(int_value, integrate(integrand, 
                    lower = 0, upper = pi/2)$value)
                }
                else {
                  int_value <- c(int_value, (sin(est_value_boot_trans[i]))^2)
                }
            }
        }
        else if (backtransformation == "naive") {
            int_value <- NULL
            for (i in seq_len(M)) {
                int_value <- c(int_value, (sin(est_value_boot_trans[i]))^2)
            }
        }
        est_value_boot[, b] <- int_value
        message("b =", b, "\n")
    }
    Li <- rep(NA, M)
    Ui <- rep(NA, M)
    for (ii in seq_len(M)) {
        Li[ii] <- eblup_corr[ii] + quantile(est_value_boot[ii, 
            ] - true_value_boot[ii, ], 0.025000000000000001)
        Ui[ii] <- eblup_corr[ii] + quantile(est_value_boot[ii, 
            ] - true_value_boot[ii, ], 0.97499999999999998)
    }
    conf_int <- data.frame(Li = Li, Ui = Ui)
    Quality_MSE <- function(estimator, TrueVal, B) {
        RMSE <- rep(NA, dim(estimator)[1])
        for (ii in seq_len(dim(estimator)[1])) {
            RMSE[ii] <- (1/B * sum(((estimator[ii, ] - TrueVal[ii, 
                ]))^2))
        }
        RMSE
    }
    mse <- Quality_MSE(est_value_boot, true_value_boot, B)
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$MSE <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    mse_data$Out[framework$obs_dom == FALSE] <- 1
    return(list(conf_int, mse_data))
}
bootstrap_par <-
function (fixed, transformation, framework, model_par, lambda, 
    shift, vu_tmp) 
{
    eps <- rnorm(framework$N_smp, 0, sqrt(model_par$sigmae2est))
    vu_smp <- rep(vu_tmp[framework$dist_obs_dom], framework$n_smp)
    X_smp <- model.matrix(fixed, framework$smp_data)
    mu_smp <- X_smp %*% model_par$betas
    Y_smp_b <- mu_smp + eps + vu_smp
    Y_smp_b <- back_transformation(y = Y_smp_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_smp_b[!is.finite(Y_smp_b)] <- 0
    bootstrap_smp <- framework$smp_data
    bootstrap_smp[paste(fixed[2])] <- Y_smp_b
    return(bootstrap_sample = bootstrap_smp)
}
bootstrap_par_hdp <-
function (fixed, transformation, framework, model_par, lambda, 
    shift, vu_tmp) 
{
    eps <- rnorm(framework$N_smp, 0, rep(sqrt(model_par$sigmae2est), 
        framework$n_smp))
    vu_smp <- rep(vu_tmp[framework$dist_obs_dom], framework$n_smp)
    X_smp <- model.matrix(fixed, framework$smp_data)
    betas_in <- apply(model_par$betas, 1, rep, framework$n_smp)
    mu_smp <- diag(X_smp %*% t(betas_in))
    Y_smp_b <- mu_smp + eps + vu_smp
    Y_smp_b <- back_transformation(y = Y_smp_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_smp_b[!is.finite(Y_smp_b)] <- 0
    bootstrap_smp <- framework$smp_data
    bootstrap_smp[paste(fixed[2])] <- Y_smp_b
    return(bootstrap_sample = bootstrap_smp)
}
bootstrap_par_wild <-
function (fixed, transformation, framework, model_par, lambda, 
    shift, vu_tmp, res_s, fitted_s) 
{
    res_s <- sqrt(model_par$sigmae2est) * (res_s - mean(res_s))/sd(res_s)
    ws <- sample(c(-1, 1), size = length(res_s), replace = TRUE)
    eps <- abs(res_s) * ws
    vu_smp <- rep(vu_tmp[framework$dist_obs_dom], framework$n_smp)
    X_smp <- model.matrix(fixed, framework$smp_data)
    Y_smp_b <- X_smp %*% model_par$betas + eps + vu_smp
    Y_smp_b <- back_transformation(y = Y_smp_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_smp_b[!is.finite(Y_smp_b)] <- 0
    bootstrap_smp <- framework$smp_data
    bootstrap_smp[paste(fixed[2])] <- Y_smp_b
    return(bootstrap_sample = bootstrap_smp)
}
box_cox <-
function (y, lambda = lambda, shift = 0) 
{
    with_shift <- function(y, shift) {
        min <- min(y)
        if (min <= 0) {
            shift <- shift + abs(min(y)) + 1
        }
        else {
            shift <- shift
        }
        return(shift)
    }
    shift <- with_shift(y = y, shift = shift)
    lambda_cases <- function(y, lambda = lambda) {
        lambda_absolute <- abs(lambda)
        if (lambda_absolute <= 9.9999999999999998e-13) {
            y <- log(y + shift)
        }
        else {
            y <- ((y + shift)^lambda - 1)/lambda
        }
        return(y)
    }
    y <- lambda_cases(y = y, lambda = lambda)
    return(list(y = y, shift = shift))
}
box_cox_back <-
function (y, lambda, shift = 0) 
{
    lambda_cases_back <- function(y, lambda = lambda, shift) {
        if (abs(lambda) <= 9.9999999999999998e-13) {
            y <- exp(y) - shift
        }
        else {
            y <- (lambda * y + 1)^(1/lambda) - shift
        }
        return(y = y)
    }
    y <- lambda_cases_back(y = y, lambda = lambda, shift = shift)
    return(y = y)
}
box_cox_std <-
function (y, lambda) 
{
    min <- min(y)
    if (min <= 0) {
        y <- y - min + 1
    }
    gm <- geometric.mean(y)
    y <- if (abs(lambda) > 9.9999999999999998e-13) {
        y <- (y^lambda - 1)/(lambda * ((gm)^(lambda - 1)))
    }
    else {
        y <- gm * log(y)
    }
    return(y)
}
calculate_sumj <-
function (data = data, var = var) 
{
    data <- matrix(data, ncol = 3)
    term2 <- sapply(1:nrow(data), function(i) innersum(i, mu = data[, 
        1], var = data[, 3], popwt = data[, 2]))
    return(term2)
}
calibWeights <-
function (X_calib, d, totals, q = NULL, method = c("raking", 
    "linear", "logit"), bounds = c(0, 10), maxit = 500, tol = 9.9999999999999995e-07, 
    eps = .Machine$double.eps, domain = NULL) 
{
    X_calib <- as.matrix(X_calib)
    d <- as.numeric(d)
    totals <- as.numeric(totals)
    haveNA <- c(any(is.na(X_calib)), any(is.na(d)), any(is.na(totals)), 
        !is.null(q) && any(is.na(q)))
    if (any(haveNA)) {
        argsNA <- c("'X_calib'", "'d'", "'totals'", "'q'")[haveNA]
        stop("missing values in the following arguments", paste(argsNA, 
            collapse = ", "))
    }
    n <- nrow(X_calib)
    if (length(d) != n) 
        stop("length of 'd' not equal to number of rows in 'X_calib'")
    p <- ncol(X_calib)
    if (length(totals) != p) {
        stop("length of 'totals' not equal to number of columns in 'X_calib'")
    }
    if (is.null(q)) 
        q <- rep.int(1, n)
    else {
        q <- as.numeric(q)
        if (length(q) != n) {
            stop("length of 'q' not equal to number of rows in 'X_calib'")
        }
        if (any(is.infinite(q))) 
            stop("infinite values in 'q'")
    }
    method <- match.arg(method)
    if (method == "linear") {
        lambda <- ginv(t(X_calib * d * q) %*% X_calib, tol = eps) %*% 
            (totals - as.vector(t(d) %*% X_calib))
        g <- 1 + q * as.vector(X_calib %*% lambda)
    }
    else {
        lambda <- matrix(0, nrow = p)
        tolNotReached <- function(X_calib, w, totals, tol) {
            max(abs(crossprod(X_calib, w) - totals)/totals) >= 
                tol
        }
        if (method == "raking") {
            g <- rep.int(1, n)
            w <- d
            i <- 1
            while (!any(is.na(g)) && tolNotReached(X_calib, w, 
                totals, tol) && i <= maxit) {
                phi <- t(X_calib) %*% w - totals
                Tmat <- t(X_calib * w)
                dphi <- Tmat %*% X_calib
                lambda <- lambda - ginv(dphi, tol = eps) %*% 
                  phi
                g <- exp(as.vector(X_calib %*% lambda) * q)
                w <- g * d
                i <- i + 1
            }
            if (any(is.na(g)) || i > maxit) {
                warning("no convergence")
                g <- NULL
            }
        }
        else {
            if (length(bounds) < 2) 
                stop("'bounds' must be a vector of length 2")
            else bounds <- bounds[seq_len(2)]
            if (bounds[1] >= 1) 
                stop("the lower bound must be smaller than 1")
            if (bounds[2] <= 1) 
                stop("the lower bound must be larger than 1")
            A <- diff(bounds)/((1 - bounds[1]) * (bounds[2] - 
                1))
            getG <- function(u, bounds) {
                (bounds[1] * (bounds[2] - 1) + bounds[2] * (1 - 
                  bounds[1]) * u)/(bounds[2] - 1 + (1 - bounds[1]) * 
                  u)
            }
            g <- getG(rep.int(1, n), bounds)
            X1 <- X_calib
            d1 <- d
            totals1 <- totals
            q1 <- q
            g1 <- g
            indices <- seq_len(n)
            anyOutOfBounds <- function(g, bounds) {
                any(g < bounds[1]) || any(g > bounds[2])
            }
            i <- 1
            while (!any(is.na(g)) && (tolNotReached(X_calib, 
                g * d, totals, tol) || anyOutOfBounds(g, bounds)) && 
                i <= maxit) {
                if (anyOutOfBounds(g, bounds)) {
                  g[g < bounds[1]] <- bounds[1]
                  g[g > bounds[2]] <- bounds[2]
                  tmp <- which(g > bounds[1] & g < bounds[2])
                  if (length(tmp) > 0) {
                    indices <- tmp
                    X1 <- X_calib[indices, ]
                    d1 <- d[indices]
                    if (length(indices) < n) {
                      totals1 <- totals - as.vector(t(g[-indices] * 
                        d[-indices]) %*% X_calib[-indices, , 
                        drop = FALSE])
                    }
                    q1 <- q[indices]
                    g1 <- g[indices]
                  }
                }
                w1 <- g1 * d1
                phi <- t(X1) %*% w1 - totals1
                Tmat <- t(X1 * w1)
                dphi <- Tmat %*% X1
                lambda <- lambda - ginv(dphi, tol = eps) %*% 
                  phi
                u <- exp(A * as.vector(X1 %*% lambda) * q1)
                g1 <- getG(u, bounds)
                g[indices] <- g1
                i <- i + 1
            }
            if (any(is.na(g)) || i > maxit) {
                warning("no convergence")
                g <- NULL
            }
        }
    }
    return(g)
}
check_benchmark_arguments <-
function (object, benchmark, share, type, overwrite) 
{
    if (!inherits(object, "fh")) {
        stop("Object needs to be fh object.")
    }
    throw_class_error(object, "fh")
    if ((any(is.na(object$ind$FH)))) {
        stop(strwrap(prefix = " ", initial = "", "If no predictions for out-of-sample domains are available,\n                the benchmarking algorithm does not work."))
    }
    if (is.null(type) || !(is.character(type)) || !(type == "raking" || 
        type == "ratio" || type == "MSE_adj")) {
        stop(strwrap(prefix = " ", initial = "", "Type must be a character. The three options for types are\n                 ''raking'', ''ratio'' and ''MSE_adj''."))
    }
    if ((is.null(object$MSE)) && type == "MSE_adj") {
        stop(strwrap(prefix = " ", initial = "", "If no MSE estimates are available, ''MSE_adj'' benchmarking\n                 does not work. The fh object has to contain MSE estimates.\n                 Therefore set the MSE argument of the fh function to TRUE."))
    }
    if ((any(is.na(object$MSE$FH))) && type == "MSE_adj") {
        stop(strwrap(prefix = " ", initial = "", "For the benchmarking type ''MSE_adj'' the MSE estimates of\n                 the fh object must not contain NAs. If no MSE estimates for\n                 out-of-sample domains are available,''MSE_adj'' benchmarking\n                 does not work."))
    }
    if (is.null(benchmark) || !(is.numeric(benchmark) && length(benchmark) == 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "benchmark needs to be a single numeric value. See also\n                 help(benchmark)."))
    }
    if (!is.vector(share) || length(share) != length(object$ind$Domain)) {
        stop(strwrap(prefix = " ", initial = "", "share must be a vector with length equal to the number of\n                 domains. See also help(benchmark)."))
    }
    if (any(is.na(share))) {
        stop("share must not contain NAs.")
    }
    if (!is.logical(overwrite) || length(overwrite) != 1) {
        stop(strwrap(prefix = " ", initial = "", "overwrite must be a logical value. Set overwrite to TRUE or\n                 FALSE. The default is set to FALSE. See also\n                 help(benchmark)."))
    }
}
chen_weighted_jackknife <-
function (framework, combined_data, sigmau2, eblup, transformation, 
    vardir, method, interval) 
{
    m <- framework$m
    jack_sigmau2 <- vector(length = m)
    diff_jack_eblups <- data.frame(row.names = seq_len(m))
    diff_jack_g1 <- data.frame(row.names = seq_len(m))
    diff_jack_g2 <- data.frame(row.names = seq_len(m))
    g1 <- rep(0, framework$m)
    jack_mse <- rep(0, framework$m)
    jack_mse_weighted <- rep(0, framework$m)
    Vi <- 1/(sigmau2 + framework$vardir)
    Bd <- framework$vardir/(sigmau2 + framework$vardir)
    for (d in seq_len(framework$m)) {
        g1[d] <- framework$vardir[d] * (1 - Bd[d])
    }
    Nenner <- rep(0, framework$m)
    for (d in seq_len(framework$m)) {
        Nenner[d] <- (framework$model_X[d, ] %*% framework$model_X[d, 
            ])/(framework$vardir[d] + sigmau2)
    }
    g2 <- rep(0, framework$m)
    for (d in seq_len(framework$m)) {
        g2[d] <- (Bd[d])^2 * framework$model_X[d, ] %*% framework$model_X[d, 
            ] * (sum(Nenner))^(-1)
    }
    for (domain in seq_len(m)) {
        message("domain =", domain, "\n")
        data_insample <- combined_data[framework$obs_dom, ]
        data_tmp <- data_insample[-domain, ]
        framework_tmp <- framework_FH(combined_data = data_tmp, 
            fixed = framework$formula, vardir = vardir, domains = framework$domains, 
            transformation = transformation, correlation = framework$correlation, 
            corMatrix = framework$corMatrix, eff_smpsize = framework$eff_smpsize, 
            Ci = NULL, tol = NULL, maxit = NULL)
        sigmau2_tmp <- wrapper_estsigmau2(framework = framework_tmp, 
            method = method, interval = interval)
        jack_sigmau2[domain] <- sigmau2_tmp
        Vi_tmp <- 1/(sigmau2_tmp + framework$vardir)
        Bd_tmp <- framework$vardir/(sigmau2_tmp + framework$vardir)
        g1_tmp <- rep(0, framework$m)
        for (d_tmp in seq_len(framework$m)) {
            g1_tmp[d_tmp] <- framework$vardir[d_tmp] * (1 - Bd_tmp[d_tmp])
        }
        Nenner_tmp <- rep(0, framework$m)
        for (d_tmp in seq_len(framework$m)) {
            Nenner_tmp[d_tmp] <- (framework$model_X[d_tmp, ] %*% 
                framework$model_X[d_tmp, ])/(framework$vardir[d_tmp] + 
                sigmau2_tmp)
        }
        g2_tmp <- rep(0, framework$m)
        for (d_tmp in seq_len(framework$m)) {
            g2_tmp[d_tmp] <- (Bd_tmp[d_tmp])^2 * framework$model_X[d_tmp, 
                ] %*% framework$model_X[d_tmp, ] * (sum(Nenner_tmp))^(-1)
        }
        diff_jack_g1[, paste0(domain)] <- g1_tmp - g1
        diff_jack_g2[, paste0(domain)] <- g1_tmp + g2_tmp - (g1 + 
            g2)
        framework_insample <- framework_FH(combined_data = data_insample, 
            fixed = framework$formula, vardir = vardir, domains = framework$domains, 
            transformation = transformation, eff_smpsize = framework$eff_smpsize, 
            correlation = framework$correlation, corMatrix = framework$corMatrix, 
            Ci = NULL, tol = NULL, maxit = NULL)
        eblup_tmp <- eblup_FH(framework = framework_insample, 
            sigmau2 = sigmau2_tmp, combined_data = data_insample)
        diff_jack_eblups[, paste0(domain)] <- eblup_tmp$eblup_data$FH - 
            eblup$eblup_data$FH[eblup$eblup_data$Out == 0]
    }
    w_u <- c()
    v_wj <- c()
    for (i in seq_len(nrow(framework$model_X))) {
        w_u[i] <- 1 - t(framework$model_X[i, ]) %*% solve(t(framework$model_X) %*% 
            framework$model_X) %*% framework$model_X[i, ]
        v_wj[i] <- w_u[i] * (jack_sigmau2[i] - sigmau2) * (jack_sigmau2[i] - 
            sigmau2)
    }
    jack_mse <- g1 - ((m - 1)/m) * rowSums(diff_jack_g1) + ((m - 
        1)/m) * rowSums(diff_jack_eblups^2)
    jack_mse_weighted <- g1 + g2 - ((m - 1)/m) * rowSums(diff_jack_g2) + 
        ((m - 1)/m) * rowSums(diff_jack_eblups^2)
    jack_mse <- g1 - w_u * rowSums(diff_jack_g1) + w_u * rowSums(diff_jack_eblups^2)
    jack_mse_weighted <- g1 + g2 - w_u * rowSums(diff_jack_g2) + 
        w_u * rowSums(diff_jack_eblups^2)
    neg_values <- which(jack_mse_weighted < 0)
    jack_mse_weighted_neg <- c()
    if (length(neg_values) > 0) {
        Sig_d <- (sigmau2 + framework$vardir) * diag(m)
        Sig_d_inv <- solve(Sig_d)
        L_d <- framework$vardir/((sigmau2 + framework$vardir)^2) * 
            diag(m)
        b_wj <- w_u * (jack_sigmau2 - sigmau2)
        app_bias_correction <- sum(b_wj) * (framework$vardir^2/(framework$vardir + 
            sigmau2)^2) - diag(L_d %*% Sig_d %*% t(L_d) * sum(v_wj))
        jack_mse_weighted_neg <- g1 + g2 + w_u * rowSums(diff_jack_eblups^2) - 
            app_bias_correction
    }
    for (i in seq_len(m)) {
        if (i %in% neg_values) {
            jack_mse_weighted[i] <- jack_mse_weighted_neg[i]
        }
    }
    jack_mse_weighted
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- jack_mse_weighted
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that the jackknife MSE is only available for\n                    in-sample domains."))
    }
    mse_out <- list(mse_data = mse_data, MSE_method = "weighted jackknife")
    return(mse_out)
}
clusterBoot2 <-
function (data, statistic, ..., domain, threshold, cluster = NULL, 
    envir, indicator_name) 
{
    if (is.null(cluster)) {
        boot(data, statistic, threshold = threshold, ..., domain = domain, 
            envir = envir, indicator_name = indicator_name)
    }
    else {
        fun <- function(cluster, i, ..., .data, .statistic) {
            i <- do.call(c, split(seq_len(nrow(.data)), .data$cluster)[i])
            .statistic(.data, i, ...)
        }
        keep <- !duplicated(cluster)
        boot(cluster[keep], fun, ..., domain = domain[keep], 
            threshold = threshold, .data = data, .statistic = statistic, 
            envir = envir, indicator_name)
    }
}
coef.ebp <-
function (object, weights = FALSE, ...) 
{
    throw_class_error(object, "ebp")
    if (isFALSE(weights)) {
        coef(object$model)
    }
    else {
        object$model$coefficients_weighted
    }
}
coef.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    fixed_effects <- object$model$coefficients$coefficients
    names(fixed_effects) <- row.names(object$model$coefficients)
    fixed_effects
}
combine_data <-
function (pop_data, pop_domains, smp_data, smp_domains) 
{
    smp_domains_vec <- smp_data[, smp_domains]
    pop_domains_vec <- pop_data[, pop_domains]
    if (all(smp_domains_vec %in% pop_domains_vec) == FALSE) {
        stop(strwrap(prefix = " ", initial = "", "All sample domains need to be available in population\n                 domains."))
    }
    if (all(pop_domains_vec %in% smp_domains_vec) == FALSE) {
        message(strwrap(prefix = " ", initial = "", "Non-sampled domains exist."))
    }
    data <- merge(smp_data, pop_data, by.x = smp_domains, by.y = pop_domains, 
        all = TRUE)
    return(data)
}
combine_data_check <-
function (pop_data, pop_domains, smp_data, smp_domains, vardir) 
{
    if (!is.data.frame(pop_data)) {
        stop(strwrap(prefix = " ", initial = "", "Pop_data must be a data frame containing population data.\n                 See also help(combine_data)."))
    }
    if (!is.character(pop_domains) || length(pop_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Pop_domains must be a vector of length 1 and of class\n                 character specifying the variable name of a numeric or factor\n                 variable indicating domains in the population data. See also\n                 help(combine_data)."))
    }
    if (!is.data.frame(smp_data)) {
        stop(strwrap(prefix = " ", initial = "", "Smp_data must be a data frame containing sample data. See\n                 also help(combine_data)."))
    }
    if (!is.character(smp_domains) || length(smp_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Smp_domains must be a vector of length 1 and of class\n                 character specifying the variable (name)  of a numeric or\n                 factor variable indicating domains in the sample data. See\n                 also help(combine_data)."))
    }
    if (!is.character(vardir) || length(vardir) != 1) {
        stop(strwrap(prefix = " ", initial = "", "vardir must be a vector of length 1 and of class character\n                 specifying the variable (name)  of a numeric or factor\n                 variable indicating the direct variances in the sample data.\n                 See also help(combine_data)."))
    }
    if (!(pop_domains %in% colnames(pop_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            pop_domains, " is not contained\n                        in pop_data. Please provide valid variable name for\n                        pop_domains.")))
    }
    if (!(smp_domains %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            smp_domains, " is not contained\n                        in smp_data. Please provide valid variable name for\n                        smp_domains.")))
    }
    if (!(vardir %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The variable ", 
            vardir, " is not contained in\n                        smp_data. Please provide valid variable name for the\n                        direct variances.")))
    }
    if (!all(unique(as.character(smp_data[[smp_domains]])) %in% 
        unique(as.character(pop_data[[pop_domains]])))) {
        stop(strwrap(prefix = " ", initial = "", "The sample data contains domains that are not contained in\n                 the population data."))
    }
    if (dim(pop_data)[1] < dim(smp_data)[1]) {
        stop(strwrap(prefix = " ", initial = "", "\n                 The population data set cannot have less observations than the\n                 sample data set."))
    }
}
compare <-
function (object, ...) 
UseMethod("compare")
compare.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    if (is.null(object$MSE$FH)) {
        testresults <- NULL
        message(strwrap(prefix = " ", initial = "", "The fh object does not contain MSE estimates. The Brown\n                    test statistic cannot be computed."))
    }
    else {
        W_BL <- sum((object$ind$Direct[object$ind$Out == 0] - 
            object$ind$FH[object$ind$Out == 0])^2/(object$MSE$Direct[object$MSE$Out == 
            0] + object$MSE$FH[object$MSE$Out == 0]))
        df_BL <- object$framework$N_dom_smp
        p_value_BL <- 1 - pchisq(W_BL, df_BL)
        testresults <- data.frame(W.value = W_BL, Df = df_BL, 
            p.value = p_value_BL)
    }
    if (!is.null(object$model$gamma)) {
        xb <- (object$ind$FH[object$ind$Out == 0] - object$model$gamma$Gamma[object$ind$Out == 
            0] * object$ind$Direct[object$ind$Out == 0])/(1 - 
            object$model$gamma$Gamma[object$ind$Out == 0])
    }
    if (is.null(object$model$gamma)) {
        xb <- object$ind$FH[object$ind$Out == 0] - object$model$random_effects
    }
    direct_insample <- object$ind$Direct[object$ind$Out == 0]
    syndircor <- cor(xb, direct_insample)
    results <- list(Brown = testresults, syndir = syndircor)
    class(results) <- "compare.fh"
    if (object$framework$N_dom_unobs > 0) {
        message(strwrap(prefix = " ", initial = "", "Please note that the computation of both test statistics\n                    is only based on in-sample domains."))
    }
    return(results)
}
compare_plot <-
function (model, direct, indicator = "all", MSE = FALSE, CV = FALSE, 
    label = "orig", color = c("blue", "lightblue3"), shape = c(16, 
        16), line_type = c("solid", "solid"), gg_theme = NULL, 
    ...) 
{
    UseMethod("compare_plot")
}
compare_plot.direct <-
function (model = NULL, direct = NULL, indicator = "all", MSE = FALSE, 
    CV = FALSE, label = "orig", color = c("blue", "lightblue3"), 
    shape = c(16, 16), line_type = c("solid", "solid"), gg_theme = NULL, 
    ...) 
{
    compare_plot_check(model = model, indicator = indicator, 
        label = label, color = color, shape = shape, line_type = line_type, 
        gg_theme = gg_theme)
    if (inherits(direct, "ebp") || inherits(direct, "fh")) {
        warning(strwrap(prefix = " ", initial = "", "Wrong use of the compare plot interface. Model needs to be\n                    either ", 
            "of class ebp or fh. compare_plot is now called\n                    with the arguments swapped."))
        compare_plot(model = direct, direct = model, indicator = indicator, 
            MSE = MSE, CV = CV, label = label, color = color, 
            shape = shape, line_type = line_type, gg_theme = gg_theme, 
            ... = ...)
    }
    else {
        stop(strwrap(prefix = " ", initial = "", "model needs to be either an ebp or a fh type model."))
    }
}
compare_plot.ebp <-
function (model = NULL, direct = NULL, indicator = "all", MSE = FALSE, 
    CV = FALSE, label = "orig", color = c("blue", "lightblue3"), 
    shape = c(16, 16), line_type = c("solid", "solid"), gg_theme = NULL, 
    ...) 
{
    compare_plot_check(model = model, indicator = indicator, 
        label = label, color = color, shape = shape, line_type = line_type, 
        gg_theme = gg_theme)
    if (inherits(direct, "fh")) {
        stop(strwrap(prefix = " ", initial = "", paste0("It is not possible to compare the point and MSE\n                        estimates of a model of type 'fh', to the point and MSE\n                        estimates of an 'ebp' object.")))
    }
    if ((inherits(model, "ebp") && is.null(direct)) | (inherits(direct, 
        "ebp") && is.null(model))) {
        stop(strwrap(prefix = " ", initial = "", paste0("If the model is of type 'ebp', the input argument\n                        direct is required.")))
    }
    else if (inherits(model, "ebp") && inherits(direct, "direct")) {
        compare_plot_ebp(model = model, direct = direct, indicator = indicator, 
            MSE = MSE, CV = CV, label = label, color = color, 
            shape = shape, line_type = line_type, gg_theme = gg_theme)
    }
}
compare_plot.fh <-
function (model = NULL, direct = NULL, indicator = "all", MSE = FALSE, 
    CV = FALSE, label = "orig", color = c("blue", "lightblue3"), 
    shape = c(16, 16), line_type = c("solid", "solid"), gg_theme = NULL, 
    ...) 
{
    compare_plot_check(model = model, indicator = indicator, 
        label = label, color = color, shape = shape, line_type = line_type, 
        gg_theme = gg_theme)
    if (inherits(direct, "ebp")) {
        stop(strwrap(prefix = " ", initial = "", paste0("It is not possible to compare the point and MSE\n                        estimates of a model of type 'fh', to the point and MSE\n                        estimates of an 'ebp' object.")))
    }
    if (inherits(model, "fh") && inherits(direct, "direct")) {
        warning(strwrap(prefix = " ", initial = "", paste0("fh models are only compared to their own inherrent\n                           direct estimates. Hence, the argument direct is\n                           ignored.")))
    }
    compare_plot_fh(model = model, direct = model, indicator = indicator, 
        MSE = MSE, CV = CV, label = label, color = color, shape = shape, 
        line_type = line_type, gg_theme = gg_theme)
}
compare_plot_check <-
function (model, indicator, label, color, shape, line_type, gg_theme) 
{
    if (is.null(indicator) || !all(indicator == "all" | indicator == 
        "Quantiles" | indicator == "quantiles" | indicator == 
        "Poverty" | indicator == "poverty" | indicator == "Inequality" | 
        indicator == "inequality" | indicator == "Custom" | indicator == 
        "custom" | indicator %in% names(model$ind[-1]))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The argument indicator is set to ", 
            indicator, ". The\n                        argument only allows to be set to all, a name of\n                        estimated indicators or indicator groups as described\n                        in help(estimators.emdi).")))
    }
    if (is.null(label) || (!(label == "orig" || label == "no_title" || 
        label == "blank"))) {
        stop(strwrap(prefix = " ", initial = "", "label can be one of the following characters 'orig',\n                 'no_title' or 'blank'."))
    }
    if (length(color) != 2 || !is.vector(color)) {
        stop(strwrap(prefix = " ", initial = "", "color needs to be a vector of length 2 defining the two\n                 colors for the scatter and line plot. See also\n                 help(compare_plot)."))
    }
    if (length(shape) != 2 || !is.vector(shape)) {
        stop(strwrap(prefix = " ", initial = "", "shape needs to be a vector of length 2 defining the two\n                 shapes for the estimates in the line plots. See also\n                 help(compare_plot)."))
    }
    if (length(line_type) != 2 || !is.vector(shape)) {
        stop(strwrap(prefix = " ", initial = "", "line_type needs to be a vector of length 2 defining the types\n                 for the lines in the line plots. See also\n                 help(compare_plot)."))
    }
    if (!all(line_type %in% c("twodash", "solid", "longdash", 
        "dotted", "dotdash", "dashed", "blank"))) {
        stop(strwrap(prefix = " ", initial = "", "An element in argument line_type is not a valid option.\n                 See help(compare_plot) for valid options."))
    }
}
compare_plot_check2 <-
function (ind_direct, ind_model) 
{
    if (!any(ind_direct$Domain %in% ind_model$Domain)) {
        stop(strwrap(prefix = " ", initial = "", "Domain identifiers between direct and model estimates never\n                 match. Please verify you are comparing estimates obtained on\n                 the same sample."))
    }
    if (!all(ind_direct$Domain %in% ind_model$Domain)) {
        warning(strwrap(prefix = " ", initial = "", "Not all domains contained in the direct\n                    estimation have been found in the model estimation.\n                    Following plots will only contain results for estimates\n                    available in both objects."))
    }
    if (!all(ind_model$Domain %in% ind_direct$Domain)) {
        message(strwrap(prefix = " ", initial = "", "Not all domains contained in the model estimation have\n                    been found in the direct estimation. Following plots will\n                    only contain results for estimates available\n                    in both objects."))
    }
}
compare_plot_ebp <-
function (model, direct, indicator = "all", MSE = FALSE, CV = FALSE, 
    label = "orig", color = c("blue", "lightblue3"), shape = c(16, 
        16), line_type = c("solid", "solid"), gg_theme = NULL) 
{
    Model_based <- NULL
    Direct <- NULL
    ID <- NULL
    value <- NULL
    Method <- NULL
    ind_direct <- point_emdi(object = direct, indicator = indicator)$ind
    selected_direct <- colnames(ind_direct)[-1]
    colnames(ind_direct) <- c("Domain", paste0(colnames(ind_direct)[-1], 
        "_Direct"))
    ind_model <- point_emdi(object = model, indicator = indicator)$ind
    selected_model <- colnames(ind_model)[-1]
    colnames(ind_model) <- c("Domain", paste0(colnames(ind_model)[-1], 
        "_Model"))
    smp_size <- (table(direct$framework$smp_domains_vec))
    compare_plot_check2(ind_direct, ind_model)
    Data <- merge(ind_direct, ind_model, by = "Domain")
    matcher <- match(Data$Domain, names(smp_size))
    Data$smp_size <- as.numeric(smp_size)[matcher]
    if (MSE == TRUE || CV == TRUE) {
        precisions_direct <- mse_emdi(object = direct, indicator = indicator, 
            CV = TRUE)
        colnames(precisions_direct$ind) <- c("Domain", paste0(colnames(precisions_direct$ind)[-1], 
            "_Direct_MSE"))
        colnames(precisions_direct$ind_cv) <- c("Domain", paste0(colnames(precisions_direct$ind_cv)[-1], 
            "_Direct_CV"))
        precisions_model <- mse_emdi(object = model, indicator = indicator, 
            CV = TRUE)
        colnames(precisions_model$ind) <- c("Domain", paste0(colnames(precisions_model$ind)[-1], 
            "_Model_MSE"))
        colnames(precisions_model$ind_cv) <- c("Domain", paste0(colnames(precisions_model$ind_cv)[-1], 
            "_Model_CV"))
        if (MSE == TRUE) {
            Data <- merge(Data, precisions_direct$ind, id = "Domain")
            Data <- merge(Data, precisions_model$ind, id = "Domain")
        }
        if (CV == TRUE) {
            Data <- merge(Data, precisions_direct$ind_cv, id = "Domain")
            Data <- merge(Data, precisions_model$ind_cv, id = "Domain")
            Data$smp_size2 <- Data$smp_size
        }
    }
    selected_indicators <- selected_model[selected_model %in% 
        selected_direct]
    compare_plots(object = Data, type = "unit", selected_indicators = selected_indicators, 
        MSE = MSE, CV = CV, label = label, color = color, shape = shape, 
        line_type = line_type, gg_theme = gg_theme)
}
compare_plot_fh <-
function (model, direct, indicator = "all", MSE = FALSE, CV = FALSE, 
    label = "orig", color = c("blue", "lightblue3"), shape = c(16, 
        16), line_type = c("solid", "solid"), gg_theme = NULL) 
{
    Model_based <- NULL
    Direct <- NULL
    ID <- NULL
    value <- NULL
    Method <- NULL
    Data <- point_povmap(object = model, indicator = "all")$ind
    Data <- Data[!is.na(Data$Direct), ]
    selected_indicators <- colnames(Data)[!(colnames(Data) %in% 
        c("Domain", "Direct"))]
    colnames(Data) <- c("Domain", "FH_Direct", paste0(colnames(Data)[!(colnames(Data) %in% 
        c("Domain", "Direct"))], "_Model"))
    if ("FH_Bench" %in% selected_indicators) {
        Data$FH_Bench_Direct <- Data$FH_Direct
    }
    if ("FH_Bench" %in% indicator && !("FH_Bench" %in% selected_indicators)) {
        message(strwrap(prefix = " ", initial = "", "povmap object does not contain benchmarked fh estimates.\n                   Only FH estimates are compared with direct. See also\n                   help(benchmark)."))
    }
    if (!(any(indicator == "all") || any(indicator == "direct") || 
        any(indicator == "Direct"))) {
        selected_indicators <- selected_indicators[selected_indicators %in% 
            indicator]
    }
    if (is.null(model$MSE)) {
        Data$smp_size <- NULL
    }
    if (MSE == TRUE || CV == TRUE) {
        all_precisions <- mse_povmap(object = model, indicator = "all", 
            CV = TRUE)
        colnames(all_precisions$ind) <- c("Domain", paste0(c("FH_Direct", 
            "FH_Model"), "_MSE"))
        colnames(all_precisions$ind_cv) <- c("Domain", paste0(c("FH_Direct", 
            "FH_Model"), "_CV"))
        combined <- merge(all_precisions$ind, all_precisions$ind_cv, 
            id = "Domain")
        combined <- combined[!is.na(combined$FH_Direct_MSE), 
            ]
        Data <- merge(Data, combined, id = "Domain")
        Data$smp_size <- -Data$FH_Direct_MSE
        Data$smp_size2 <- -Data$FH_Direct_CV
    }
    if (model$framework$N_dom_unobs > 0) {
        message(strwrap(prefix = " ", initial = "", "Please note that since all of the comparisons need a direct\n                   estimator, the plots are only created for in-sample\n                   domains."))
    }
    compare_plots(object = Data, type = "area", selected_indicators = selected_indicators, 
        MSE = MSE, CV = CV, label = label, color = color, shape = shape, 
        line_type = line_type, gg_theme = gg_theme)
}
compare_plots <-
function (object, type, selected_indicators, MSE, CV, label, 
    color, shape, line_type, gg_theme, ...) 
{
    Model_based <- NULL
    Direct <- NULL
    ID <- NULL
    value <- NULL
    Method <- NULL
    slope <- NULL
    intercept <- NULL
    area <- NULL
    if (MSE == FALSE && CV == FALSE) {
        plotList <- vector(mode = "list", length = length(selected_indicators) * 
            2)
        names(plotList) <- paste(rep(c("scatter", "line"), length(selected_indicators)), 
            rep(selected_indicators, each = 2), sep = "_")
    }
    else if ((MSE == TRUE || CV == TRUE) && !(MSE == TRUE && 
        CV == TRUE)) {
        plotList <- vector(mode = "list", length = length(selected_indicators) * 
            4)
        names(plotList) <- paste(rep(c("scatter", "line"), length(selected_indicators)), 
            rep(selected_indicators, each = 4), sep = "_")
    }
    else if (MSE == TRUE && CV == TRUE) {
        plotList <- vector(mode = "list", length = length(selected_indicators) * 
            6)
        names(plotList) <- paste(rep(c("scatter", "line"), length(selected_indicators)), 
            rep(selected_indicators, each = 6), sep = "_")
    }
    for (ind in selected_indicators) {
        label_ind <- define_evallabel(type = type, label = label, 
            indi = ind)
        if (is.null(object$smp_size)) {
            data_tmp <- data.frame(Direct = object[, paste0(ind, 
                "_Direct")], Model_based = object[, paste0(ind, 
                "_Model")])
            label_ind$line["x_lab"] <- "Domains (unordered)"
        }
        else {
            data_tmp <- data.frame(Direct = object[, paste0(ind, 
                "_Direct")], Model_based = object[, paste0(ind, 
                "_Model")], smp_size = object$smp_size)
            data_tmp <- data_tmp[order(data_tmp$smp_size), ]
            data_tmp$smp_size <- NULL
        }
        data_tmp$ID <- seq_along(object$Domain)
        data_shaped <- reshape2::melt(data_tmp, id.vars = "ID")
        names(data_shaped) <- c("ID", "Method", "value")
        print((plotList[[paste("scatter", ind, sep = "_")]] <- ggplot(data_tmp, 
            aes(x = Direct, y = Model_based)) + geom_point(shape = shape[1]) + 
            geom_smooth(method = lm, formula = y ~ x, se = FALSE, 
                inherit.aes = FALSE, lty = line_type[1], aes(colour = "Reg. line", 
                  x = Direct, y = Model_based)) + geom_abline(mapping = aes(colour = "Intersection", 
            slope = slope, intercept = intercept), data.frame(slope = 1, 
            intercept = 0), lty = line_type[2]) + xlim(min(min(data_tmp$Direct), 
            min(data_tmp$Model_based)), max(max(data_tmp$Direct), 
            max(data_tmp$Model_based))) + ylim(min(min(data_tmp$Direct), 
            min(data_tmp$Model_based)), max(max(data_tmp$Direct), 
            max(data_tmp$Model_based))) + ggtitle(label_ind$scatter["title"]) + 
            ylab(label_ind$scatter["y_lab"]) + xlab(label_ind$scatter["x_lab"]) + 
            scale_color_manual(name = "", values = c(Intersection = color[2], 
                `Reg. line` = color[1])) + gg_theme))
        cat("Press [enter] to continue")
        line <- readline()
        print((plotList[[paste("line", ind, sep = "_")]] <- ggplot(data = data_shaped, 
            aes(x = ID, y = value, group = Method, colour = Method)) + 
            geom_line(aes(linetype = Method), size = 0.69999999999999996) + 
            geom_point(aes(color = Method, shape = Method), size = 2) + 
            scale_shape_manual(values = c(shape[1], shape[2]), 
                breaks = c("Direct", "Model_based"), labels = c("Direct", 
                  "Model-based")) + scale_linetype_manual(values = c(line_type[1], 
            line_type[2]), breaks = c("Direct", "Model_based"), 
            labels = c("Direct", "Model-based")) + scale_color_manual(values = c(color[1], 
            color[2]), breaks = c("Direct", "Model_based"), labels = c("Direct", 
            "Model-based")) + scale_fill_manual(name = "Method", 
            breaks = c("Direct", "Model_based"), labels = c("Direct", 
                "Model-based")) + xlab(label_ind$line["x_lab"]) + 
            ylab(label_ind$line["y_lab"]) + ggtitle(label_ind$line["title"]) + 
            gg_theme))
        if (MSE == TRUE) {
            data_tmp2 <- data.frame(Direct = object[, paste0(ind, 
                "_Direct_MSE")], Model_based = object[, paste0(ind, 
                "_Model_MSE")], smp_size = object$smp_size)
            data_tmp2 <- data_tmp2[order(data_tmp2$smp_size, 
                decreasing = TRUE), ]
            data_tmp2$smp_size <- NULL
            data_tmp2$ID <- seq_along(object$Domain)
            data_shaped <- reshape2::melt(data_tmp2, id.vars = "ID")
            names(data_shaped) <- c("ID", "Method", "value")
            data_shaped$area <- rep(seq_len(NROW(data_tmp2$Direct)), 
                2)
            cat("Press [enter] to continue")
            line <- readline()
            print((plotList[[paste("boxplot", "MSE", ind, sep = "_")]] <- ggplot(data_shaped, 
                aes(x = Method, y = value, fill = Method)) + 
                geom_boxplot() + coord_flip() + labs(title = label_ind$boxplot_MSE["title"], 
                x = label_ind$boxplot_MSE["x_lab"], y = label_ind$boxplot_MSE["y_lab"]) + 
                scale_fill_manual(name = "Method", values = color) + 
                gg_theme))
            cat("Press [enter] to continue")
            line <- readline()
            print((plotList[[paste("ordered", "MSE", ind, sep = "_")]] <- ggplot(data_shaped, 
                aes(x = area, y = value, colour = Method)) + 
                geom_point(aes(color = Method, shape = Method)) + 
                labs(title = label_ind$ordered_MSE["title"], 
                  x = label_ind$ordered_MSE["x_lab"], y = label_ind$ordered_MSE["y_lab"]) + 
                scale_color_manual(values = color)) + scale_shape_manual(values = c(shape[1], 
                shape[2])) + gg_theme)
        }
        if (CV == TRUE) {
            data_tmp3 <- data.frame(Direct = object[, paste0(ind, 
                "_Direct_CV")], Model_based = object[, paste0(ind, 
                "_Model_CV")], smp_size = object$smp_size2)
            data_tmp3 <- data_tmp3[order(data_tmp3$smp_size, 
                decreasing = TRUE), ]
            data_tmp3$smp_size <- NULL
            data_tmp3$ID <- seq_along(object$Domain)
            data_shaped <- reshape2::melt(data_tmp3, id.vars = "ID")
            names(data_shaped) <- c("ID", "Method", "value")
            data_shaped$area <- rep(seq_len(NROW(data_tmp3$Direct)), 
                2)
            cat("Press [enter] to continue")
            line <- readline()
            print((plotList[[paste("boxplot", "CV", ind, sep = "_")]] <- ggplot(data_shaped, 
                aes(x = Method, y = value, fill = Method)) + 
                geom_boxplot() + coord_flip() + labs(title = label_ind$boxplot_CV["title"], 
                x = label_ind$boxplot_CV["x_lab"], y = label_ind$boxplot_CV["y_lab"]) + 
                scale_fill_manual(name = "Method", values = color)) + 
                gg_theme)
            cat("Press [enter] to continue")
            line <- readline()
            data_shaped
            print((plotList[[paste("ordered", "CV", ind, sep = "_")]] <- ggplot(data_shaped, 
                aes(x = area, y = value, colour = Method)) + 
                geom_point(aes(color = Method, shape = Method)) + 
                labs(title = label_ind$ordered_CV["title"], x = label_ind$ordered_CV["x_lab"], 
                  y = label_ind$ordered_CV["y_lab"]) + scale_color_manual(values = color)) + 
                scale_shape_manual(values = c(shape[1], shape[2])) + 
                gg_theme)
        }
        if (!ind == tail(selected_indicators, 1)) {
            cat("Press [enter] to continue")
            line <- readline()
        }
    }
    invisible(plotList)
}
compare_pred <-
function (object1, object2, MSE = FALSE, ...) 
{
    UseMethod("compare_pred")
}
compare_pred.emdi <-
function (object1, object2, MSE = FALSE, ...) 
{
    if (!inherits(object1, "emdi") || !inherits(object2, "emdi")) {
        stop("Both objects need to be of class emdi.")
    }
    if ((length(object1$ind$Domain) == length(object2$ind$Domain)) && 
        (!all(as.character(object1$ind$Domain) %in% as.character(object2$ind$Domain)))) {
        stop(strwrap(prefix = " ", initial = "", "It is only possible to compare emdi objects with the same\n                 domains."))
    }
    if ((length(object1$ind$Domain) < length(object2$ind$Domain)) && 
        !all(as.character(object1$ind$Domain) %in% as.character(object2$ind$Domain))) {
        stop(strwrap(prefix = " ", initial = "", "The first object contains domains that are not contained in\n                 the second object. It is only possible to compare emdi objects\n                 with the same domains."))
    }
    if ((length(object2$ind$Domain) < length(object1$ind$Domain)) && 
        !all(as.character(object2$ind$Domain) %in% as.character(object1$ind$Domain))) {
        stop(strwrap(prefix = " ", initial = "", "The second object contains domains that are not contained in\n                 the first object. It is only possible to compare emdi objects\n                 with the same domains."))
    }
    if ((MSE == TRUE) && (is.null(object1$MSE) || is.null(object2$MSE))) {
        stop(strwrap(prefix = " ", initial = "", "If MSE is set to TRUE, both emdi objects need to contain MSE\n                 estimates."))
    }
    if (MSE == FALSE) {
        object1data <- get("ind", object1)
        object2data <- get("ind", object2)
    }
    else if (MSE == TRUE) {
        object1data <- get("MSE", object1)
        object2data <- get("MSE", object2)
    }
    if (inherits(object1, "fh")) {
        object1data <- object1data[, -4]
    }
    if (inherits(object2, "fh")) {
        object2data <- object2data[, -4]
    }
    order_direct_ebp <- c("Domain", "Mean_1", "Mean_2", "Head_Count_1", 
        "Head_Count_2", "Poverty_Gap_1", "Poverty_Gap_2", "Gini_1", 
        "Gini_2", "Quintile_Share_1", "Quintile_Share_2", "Quantile_10_1", 
        "Quantile_10_2", "Quantile_25_1", "Quantile_25_2", "Median_1", 
        "Median_2", "Quantile_75_1", "Quantile_75_2", "Quantile_90_1", 
        "Quantile_90_2")
    if ((inherits(object1, "ebp") && inherits(object2, "ebp")) || 
        (inherits(object1, "direct") && inherits(object2, "direct")) || 
        (inherits(object1, "direct") && inherits(object2, "ebp")) || 
        (inherits(object1, "ebp") && inherits(object2, "direct"))) {
        if (dim(object1data)[2] > 11) {
            colnames(object1data)[12:dim(object1data)[2]] <- paste0(names(object1data[12:dim(object1data)[2]]), 
                "_1")
        }
        if (dim(object2data)[2] > 11) {
            colnames(object2data)[12:dim(object2data)[2]] <- paste0(names(object2data[12:dim(object2data)[2]]), 
                "_2")
        }
        data <- merge(object1data, object2data, by.x = "Domain", 
            by.y = "Domain", suffixes = c("_1", "_2"))
        if (dim(data)[2] == 21) {
            data <- data[, order_direct_ebp]
        }
        else if (dim(data)[2] > 21) {
            custom_indicators <- colnames(data)[(which(!colnames(data) %in% 
                order_direct_ebp))]
            data <- data[, c(order_direct_ebp, custom_indicators)]
        }
    }
    else if (inherits(object1, "fh") && inherits(object2, "fh")) {
        data <- merge(object1data, object2data, by.x = "Domain", 
            by.y = "Domain", suffixes = c("_1", "_2"))
        data <- data[, c("Domain", "Direct_1", "Direct_2", "FH_1", 
            "FH_2")]
    }
    else if ((inherits(object1, "direct") && inherits(object2, 
        "fh")) || (inherits(object1, "fh") && inherits(object2, 
        "direct"))) {
        data <- merge(object1data, object2data, by.x = "Domain", 
            by.y = "Domain", all = TRUE, suffixes = c("_1", "_2"))
    }
    else if ((inherits(object1, "fh") && inherits(object2, "ebp")) || 
        (inherits(object1, "ebp") && inherits(object2, "fh"))) {
        data <- merge(object1data, object2data, by.x = "Domain", 
            by.y = "Domain", all = TRUE, suffixes = c("_1", "_2"))
    }
    data
}
conditional_untransformed_mean <-
function (Head_Count = Head_Count, mu = mu, var = var, transformation = transformation, 
    lambda = lambda, threshold = threshold, shift = shift) 
{
    conditional_untransformed_mean <- NULL
    if (transformation == "no") {
        q_p <- mu + sqrt(var) * dnorm(qnorm(Head_Count, 0, 1))/(1 - 
            Head_Count)
        conditional_untransformed_mean <- (mu - (1 - Head_Count) * 
            q_p)/Head_Count
    }
    else if (transformation == "log" | transformation == "log.shift") {
        q_p <- 0.5 * exp(mu + (var/2)) * (1 + erf(sqrt(var/2) - 
            erfinv(2 * Head_Count - 1)))/(1 - Head_Count)
        conditional_untransformed_mean <- (exp(mu + var/2) - 
            (1 - Head_Count) * q_p)/Head_Count
        if (is.null(lambda)) {
            lambda <- 0
        }
        conditional_untransformed_mean <- conditional_untransformed_mean - 
            lambda
    }
    return(conditional_untransformed_mean)
}
confint.ebp <-
function (object, parm = NULL, level = 0.94999999999999996, ...) 
{
    throw_class_error(object, "ebp")
    if (!is.null(parm)) {
        confidence_intervals <- intervals(object$model, level = level)$fixed
        subset(confidence_intervals, rownames(confidence_intervals) %in% 
            parm)
    }
    else {
        intervals(object$model, level = level)$fixed
    }
}
confint.fh <-
function (object, parm = NULL, level = 0.94999999999999996, ...) 
{
    throw_class_error(object, "fh")
    coefmat <- object$model$coefficients
    coefs <- coefmat[, 1]
    stds <- coefmat[, 2]
    dist <- qnorm(p = (1 - level)/2, 0, stds)
    ret_value <- data.frame(lower = coefs + dist, est. = coefs, 
        upper = coefs + abs(dist), row.names = row.names(coefmat))
    if (is.null(parm)) {
        as.matrix(ret_value)
    }
    else {
        as.matrix(ret_value[parm, ])
    }
}
create_calibmatrix <-
function (x) 
{
    unique_obs <- unique(x)
    result <- lapply(unique_obs, function(y) {
        z <- as.integer(y == x)
        return(z)
    })
    result <- do.call(cbind, result)
    colnames(result) <- unique_obs
    return(result)
}
data_transformation <-
function (fixed, smp_data, transformation, lambda) 
{
    y_vector <- as.matrix(smp_data[paste(fixed[[2]])])
    transformed <- if (transformation == "no") {
        no_transform(y = y_vector, shift = NULL)
    }
    else if (transformation == "log") {
        log_transform(y = y_vector, shift = 0)
    }
    else if (transformation == "box.cox") {
        box_cox(y = y_vector, lambda = lambda, shift = 0)
    }
    else if (transformation == "dual") {
        dual(y = y_vector, lambda = lambda, shift = 0)
    }
    else if (transformation == "log.shift") {
        log_shift_opt(y = y_vector, lambda = lambda, shift = NULL)
    }
    else if (transformation == "arcsin") {
        arcsin_transform(y = y_vector, shift = NULL)
    }
    else if (transformation == "ordernorm") {
        ordernorm(y = y_vector, shift = NULL)
    }
    else if (transformation == "logit") {
        logit_transform(y = y_vector, shift = NULL)
    }
    smp_data[paste(fixed[[2]])] <- transformed$y
    return(list(transformed_data = smp_data, shift = transformed$shift))
}
datta_lahiri <-
function (framework, sigmau2, combined_data) 
{
    g1 <- rep(0, framework$m)
    g2 <- rep(0, framework$m)
    g3 <- rep(0, framework$m)
    mse <- rep(0, framework$m)
    Vi <- 1/(sigmau2 + framework$vardir)
    Bd <- framework$vardir/(sigmau2 + framework$vardir)
    SumAD2 <- sum(Vi^2)
    XtVi <- t(Vi * framework$model_X)
    Q <- solve(XtVi %*% framework$model_X)
    VarA <- 2/SumAD2
    b <- (-1) * sum(diag(Q %*% (t((Vi^2) * framework$model_X) %*% 
        framework$model_X)))/SumAD2
    for (d in seq_len(framework$m)) {
        g1[d] <- framework$vardir[d] * (1 - Bd[d])
        xd <- matrix(framework$model_X[d, ], nrow = 1, ncol = framework$p)
        g2[d] <- (Bd[d]^2) * xd %*% Q %*% t(xd)
        g3[d] <- (Bd[d]^2) * VarA/(sigmau2 + framework$vardir[d])
        mse[d] <- g1[d] + g2[d] + 2 * g3[d] - b * (Bd[d]^2)
    }
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        h <- rep(0, framework$M - framework$m)
        mse_out <- rep(0, framework$M - framework$m)
        pred_data_tmp <- combined_data[framework$obs_dom == FALSE, 
            ]
        pred_data_tmp <- data.frame(pred_data_tmp, helper = rnorm(1, 
            0, 1))
        formula.tools::lhs(framework$formula) <- quote(helper)
        pred_data <- makeXY(formula = framework$formula, data = pred_data_tmp)
        pred_X <- pred_data$x
        for (d_out in seq_len((framework$M - framework$m))) {
            xd_out <- matrix(pred_X[d_out, ], nrow = 1, ncol = framework$p)
            h[d_out] <- xd_out %*% Q %*% t(xd_out)
            mse_out[d_out] <- sigmau2 + b + h[d_out]
        }
        mse_data$FH[framework$obs_dom == FALSE] <- mse_out
        mse_data$Out[framework$obs_dom == FALSE] <- 1
    }
    return(mse_data)
}
define_evallabel <-
function (type, label, indi) 
{
    if (!inherits(label, "list")) {
        if (label == "orig") {
            if (type == "unit") {
                label <- list(scatter = c(title = indi, y_lab = "Model-based", 
                  x_lab = "Direct"), line = c(title = indi, y_lab = "Value", 
                  x_lab = "Domain (ordered by sample size)"), 
                  boxplot_MSE = c(title = indi, y_lab = "MSE", 
                    x_lab = ""), ordered_MSE = c(title = indi, 
                    y_lab = "MSE", x_lab = "Domain (ordered by\n                                      sample size)"), 
                  boxplot_CV = c(title = indi, y_lab = "CV", 
                    x_lab = ""), ordered_CV = c(title = indi, 
                    y_lab = "CV", x_lab = "Domain (ordered by sample size)"))
            }
            else if (type == "area") {
                label <- list(scatter = c(title = indi, y_lab = "Model-based", 
                  x_lab = "Direct"), line = c(title = indi, y_lab = "Value", 
                  x_lab = "Domain (ordered by decreasing MSE\n                               of Direct)"), 
                  boxplot_MSE = c(title = indi, y_lab = "", x_lab = "MSE"), 
                  ordered_MSE = c(title = indi, y_lab = "MSE", 
                    x_lab = "Domain (ordered by increasing\n                                      MSE of Direct)"), 
                  boxplot_CV = c(title = indi, y_lab = "CV", 
                    x_lab = ""), ordered_CV = c(title = indi, 
                    y_lab = "CV", x_lab = "Domain (ordered by increasing CV\n                                     of Direct)"))
            }
        }
        else if (label == "blank") {
            label <- list(scatter = c(title = "", y_lab = "", 
                x_lab = ""), line = c(title = "", y_lab = "", 
                x_lab = ""), boxplot_MSE = c(title = "", y_lab = "", 
                x_lab = ""), ordered_MSE = c(title = "", y_lab = "", 
                x_lab = ""), boxplot_CV = c(title = "", y_lab = "", 
                x_lab = ""), ordered_CV = c(title = "", y_lab = "", 
                x_lab = ""))
        }
        else if (label == "no_title") {
            if (type == "unit") {
                label <- list(scatter = c(title = "", y_lab = "Model-based", 
                  x_lab = "Direct"), line = c(title = "", y_lab = "Value", 
                  x_lab = "Domain (ordered by sample size)"), 
                  boxplot_MSE = c(title = "", y_lab = "MSE", 
                    x_lab = ""), ordered_MSE = c(title = "", 
                    y_lab = "MSE", x_lab = "Domain (ordered by sample\n                                      size)"), 
                  boxplot_CV = c(title = "", y_lab = "CV", x_lab = ""), 
                  ordered_CV = c(title = "", y_lab = "CV", x_lab = "Domain (ordered by sample size)"))
            }
            else if (type == "area") {
                label <- list(scatter = c(title = "", y_lab = "Model-based", 
                  x_lab = "Direct"), line = c(title = "", y_lab = "Value", 
                  x_lab = "Domain (ordered by decreasing MSE of\n                               Direct)"), 
                  boxplot_MSE = c(title = "", y_lab = "", x_lab = "MSE"), 
                  ordered_MSE = c(title = "", y_lab = "MSE", 
                    x_lab = "Domain (ordered by increasing MSE\n                                      of Direct)"), 
                  boxplot_CV = c(title = "", y_lab = "CV", x_lab = ""), 
                  ordered_CV = c(title = "", y_lab = "CV", x_lab = "Domain (ordered by increasing CV\n                                     of Direct)"))
            }
        }
    }
    return(label)
}
define_label <-
function (x, label) 
{
    if (!inherits(label, "list")) {
        if (label == "orig") {
            if (inherits(x, "ebp")) {
                label <- list(qq_res = c(title = "Error term", 
                  y_lab = "Quantiles of pearson residuals", x_lab = "Theoretical quantiles"), 
                  qq_ran = c(title = "Random effect", y_lab = "Quantiles of random effects", 
                    x_lab = "Theoretical quantiles"), d_res = c(title = "Density - Pearson residuals", 
                    y_lab = "Density", x_lab = "Pearson residuals"), 
                  d_ran = c(title = "Density - Standardized random effects", 
                    y_lab = "Density", x_lab = "Standardized random effects"), 
                  cooks = c(title = "Cook's Distance Plot", y_lab = "Cook's Distance", 
                    x_lab = "Index"), opt_lambda = c(title = paste0(str_to_title(gsub("\\.", 
                    "-", x$transformation)), " - REML"), y_lab = "Log-Likelihood", 
                    x_lab = "expression(lambda)"))
            }
            else if (inherits(x, "fh")) {
                label <- list(qq_res = c(title = "Realized residuals", 
                  y_lab = "Quantiles of std. residuals/sqrt(direct var.)", 
                  x_lab = "Theoretical quantiles"), qq_ran = c(title = "Random effect", 
                  y_lab = "Quantiles of std. random effects", 
                  x_lab = "Theoretical quantiles"), d_res = c(title = "Density - Std. residuals/sqrt(direct var.)", 
                  y_lab = "Density", x_lab = "Std. real. residuals"), 
                  d_ran = c(title = "Density - Random effects", 
                    y_lab = "Density", x_lab = "Std. random effects"), 
                  cooks = c(title = "", y_lab = "", x_lab = ""), 
                  opt_lambda = c(title = "", y_lab = "", x_lab = ""))
            }
        }
        else if (label == "blank") {
            label <- list(qq_res = c(title = "", y_lab = "", 
                x_lab = ""), qq_ran = c(title = "", y_lab = "", 
                x_lab = ""), d_res = c(title = "", y_lab = "", 
                x_lab = ""), d_ran = c(title = "", y_lab = "", 
                x_lab = ""), cooks = c(title = "", y_lab = "", 
                x_lab = ""), opt_lambda = c(title = "", y_lab = "", 
                x_lab = ""))
        }
        else if (label == "no_title") {
            if (inherits(x, "ebp")) {
                label <- list(qq_res = c(title = "", y_lab = "Quantiles of pearson residuals", 
                  x_lab = "Theoretical quantiles"), qq_ran = c(title = "", 
                  y_lab = "Quantiles of random effects", x_lab = "Theoretical quantiles"), 
                  d_res = c(title = "", y_lab = "Density", x_lab = "Pearson residuals"), 
                  d_ran = c(title = "", y_lab = "Density", x_lab = "Standardized random effects"), 
                  cooks = c(title = "", y_lab = "Cook's Distance", 
                    x_lab = "Index"), opt_lambda = c(title = "", 
                    y_lab = "Log-Likelihood", x_lab = "expression(lambda)"))
            }
            else if (inherits(x, "fh")) {
                label <- list(qq_res = c(title = "", y_lab = "Quantiles of std. residuals/sqrt(direct var.)", 
                  x_lab = "Theoretical quantiles"), qq_ran = c(title = "", 
                  y_lab = "Quantiles of std. random effects", 
                  x_lab = "Theoretical quantiles"), d_res = c(title = "", 
                  y_lab = "Density", x_lab = "Std. real. residuals"), 
                  d_ran = c(title = "", y_lab = "Density", x_lab = "Std. random effects"), 
                  cooks = c(title = "", y_lab = "", x_lab = ""), 
                  opt_lambda = c(title = "", y_lab = "", x_lab = ""))
            }
        }
    }
    else if (inherits(label, "list")) {
        if (any(names(label) == "box_cox")) {
            warning(strwrap(prefix = " ", initial = "", "In following versions of package emdi, the list element\n                      box_cox will be renamed into opt_lambda."))
        }
        if (!any(names(label) %in% c("qq_res", "qq_ran", "d_res", 
            "d_ran", "cooks", "opt_lambda")) || !any(names(label) %in% 
            c("qq_res", "qq_ran", "d_res", "d_ran", "cooks", 
                "box_cox"))) {
            stop(strwrap(prefix = " ", initial = "", "List elements must have following names even though not\n                   all must be included: qq_res, qq_ran, d_res, d_ran, cooks,\n                   opt_lambda. Every list element must have the elements title,\n                   y_lab and x_lab. See also help(plot.povmap)."))
        }
        for (i in names(label)) {
            if (!all(names(label[[i]]) == c("title", "y_lab", 
                "x_lab"))) {
                stop(strwrap(prefix = " ", initial = "", "Every list element must have the elements title, y_lab\n                     and x_lab in this order. See also help(plot.povmap)."))
            }
        }
        orig_label <- list(qq_res = c(title = "Error term", y_lab = "Quantiles of pearson residuals", 
            x_lab = "Theoretical quantiles"), qq_ran = c(title = "Random effect", 
            y_lab = "Quantiles of random effects", x_lab = "Theoretical quantiles"), 
            d_res = c(title = "Density - Pearson residuals", 
                y_lab = "Density", x_lab = "Pearson residuals"), 
            d_ran = c(title = "Density - Standardized random effects", 
                y_lab = "Density", x_lab = "Standardized random effects"), 
            cooks = c(title = "Cook's Distance Plot", y_lab = "Cook's Distance", 
                x_lab = "Index"), opt_lambda = c(title = paste0(str_to_title(gsub("\\.", 
                "-", x$transformation)), " - REML"), y_lab = "Log-Likelihood", 
                x_lab = "expression(lambda)"))
        if (any(names(label) == "qq_res")) {
            label$qq_res <- label$qq_res
        }
        else {
            label$qq_res <- orig_label$qq_res
        }
        if (any(names(label) == "qq_ran")) {
            label$qq_ran <- label$qq_ran
        }
        else {
            label$qq_ran <- orig_label$qq_ran
        }
        if (any(names(label) == "d_res")) {
            label$d_res <- label$d_res
        }
        else {
            label$d_res <- orig_label$d_res
        }
        if (any(names(label) == "d_ran")) {
            label$d_ran <- label$d_ran
        }
        else {
            label$d_ran <- orig_label$d_ran
        }
        if (any(names(label) == "cooks")) {
            label$cooks <- label$cooks
        }
        else {
            label$cooks <- orig_label$cooks
        }
        if (any(names(label) == "opt_lambda") || any(names(label) == 
            "box_cox")) {
            if (any(names(label) == "opt_lambda")) {
                label$opt_lambda <- label$opt_lambda
            }
            else if (any(names(label) == "box_cox")) {
                label$opt_lambda <- label$box_cox
            }
        }
        else {
            label$opt_lambda <- orig_label$opt_lambda
        }
    }
    if (any(!(names(label) %in% c("qq_res", "qq_ran", "d_res", 
        "d_ran", "cooks", "opt_lambda", "box_cox")))) {
        warning(strwrap(prefix = " ", initial = "", "One or more list elements are not called qq_res, qq_ran,\n                    d_res, d_ran, cooks or opt_lambda. The changes are for\n                    this/these element(s) is/are not done. Instead the original\n                    labels are used."))
    }
    return(label)
}
direct <-
function (y, smp_data, smp_domains, weights = NULL, design = NULL, 
    threshold = NULL, var = FALSE, boot_type = "naive", B = 50, 
    seed = 123, X_calib = NULL, totals = NULL, custom_indicator = NULL, 
    na.rm = FALSE, HT = FALSE, HTmethod = "Simple") 
{
    smp_data <- as.data.frame(smp_data)
    direct_check(y = y, smp_data = smp_data, smp_domains = smp_domains, 
        weights = weights, design = design, threshold = threshold, 
        var = var, boot_type = boot_type, B = B, seed = seed, 
        X_calib = X_calib, totals = totals, na.rm = na.rm, custom_indicator = custom_indicator, 
        HT = HT)
    call <- match.call()
    framework <- framework_dir(y = y, smp_data = smp_data, smp_domains = smp_domains, 
        weights = weights, threshold = threshold, custom_indicator = custom_indicator, 
        na.rm = na.rm)
    result_point <- mapply(FUN = point_estim_direct, direct_estimator = framework$indicator_list, 
        indicator_name = framework$indicator_names, MoreArgs = list(framework = framework, 
            boot_type = boot_type, B = B, seed = seed, X_calib = X_calib, 
            totals = totals), SIMPLIFY = F)
    warnlist <- character()
    if (var == TRUE) {
        envir <- environment()
        res <- mapply(FUN = direct_variance, direct_estimator = framework$indicator_list, 
            indicator_name = framework$indicator_names, indicator = result_point, 
            MoreArgs = list(y = framework$y, weights = framework$weights, 
                smp_data = framework$smp_data, smp_domains = framework$smp_domains_vec, 
                design = design, HT = HT, HTmethod = HTmethod, 
                bootType = boot_type, B = B, seed = seed, X_calib = X_calib, 
                totals = totals, threshold = framework$threshold, 
                envir = envir), SIMPLIFY = F)
        if (length(warnlist) > 0) {
            warning(paste0("For the following domains at least one bootstrap failed ", 
                ", this may be due to a very small sample size. For these domains ", 
                "the variance estimation is based on a reduced number of ", 
                "bootstrap iteration. To see the number of successful", 
                " bootstrap iterations for each domain and indicator, have a look at", 
                " the value successful_bootstraps in the returned object."))
        }
    }
    else {
        res <- result_point
    }
    ind <- cbind(res[[1]]$valueByDomain$Domain, as.data.frame(lapply(res, 
        function(erg) {
            erg$valueByDomain[, 2]
        })))
    if (!var) {
        MSE <- NULL
        colnames(ind) <- c("Domain", framework$indicator_names)
    }
    else {
        MSE <- cbind(res[[1]]$varByDomain$Domain, as.data.frame(lapply(res, 
            function(erg) {
                erg$varByDomain[, 2]
            })))
        colnames(MSE) <- colnames(ind) <- c("Domain", framework$indicator_names)
    }
    if (length(warnlist) > 0) {
        failed_BS <- do.call(rbind, lapply(strsplit(warnlist, 
            split = ":_:"), t))
        colnames(failed_BS) <- c("Domain", "Indicator")
        failed_BS <- as.data.frame(failed_BS)
        failed_BS$Domain <- factor(failed_BS$Domain, levels = levels(framework$smp_domains_vec))
        failed_BS$Indicator <- factor(failed_BS$Indicator, levels = framework$indicator_names)
        sucInd <- B - table(failed_BS$Domain, failed_BS$Indicator)
    }
    else {
        failed_BS <- matrix(data = 0, nrow = length(levels(framework$smp_domains_vec)), 
            ncol = length(framework$indicator_names), dimnames = list(levels(framework$smp_domains_vec), 
                framework$indicator_names))
        sucInd <- B - failed_BS
    }
    direct_out <- list(ind = ind, MSE = MSE, framework = framework[c("N_dom_smp", 
        "N_smp", "smp_domains", "smp_data", "smp_domains_vec")], 
        call = call, successful_bootstraps = sucInd)
    class(direct_out) <- c("direct", "povmap")
    return(direct_out)
}
direct_check <-
function (y, smp_data, smp_domains = NULL, weights = NULL, design = NULL, 
    threshold = NULL, var = FALSE, boot_type = "naive", B = NULL, 
    seed, X_calib = NULL, totals = NULL, na.rm, custom_indicator, 
    HT = FALSE) 
{
    if (is.null(y) || !(inherits(y, "character") && length(y) == 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "y must be a vector of length 1 and of class character\n                 specifying the variable (name) that is used for estimating the\n                 indicators. The variable needs to be contained in smp_data.\n                 See also help(direct)."))
    }
    if (HT == TRUE & min(smp_data[, weights]) < 1) {
        stop(strwrap(prefix = " ", initial = "", "Weights must all be greater than one when using the Horvitz-Thompson approximation"))
    }
    if (!(y %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0(y, " is not contained in smp_data. Please provide valid\n                        variable name for y.")))
    }
    if (!inherits(smp_data, "data.frame")) {
        stop(strwrap(prefix = " ", initial = "", "Smp_data must be a data frame containing the variable y.\n                 See also help(direct)."))
    }
    if (!inherits(smp_domains, "character") || length(smp_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Smp_domains must be a vector of length 1 and of class\n                 character specifying the variable (name) indicating domains in\n                 the sample data. The variable needs to be contained in\n                 smp_data. See also help(direct)."))
    }
    if (!(smp_domains %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0(smp_domains, 
            " is not contained in smp_data.\n                        Please provide valid variable name for smp_domains.")))
    }
    if ((!(is.null(weights) || (inherits(weights, "character") && 
        length(weights) == 1)))) {
        stop(strwrap(prefix = " ", initial = "", "Weights must be a vector of length 1 and of class character\n                 specifying the variable (name) of the sampling weights in the\n                 sample data.  The variable needs to be contained in smp_data.\n                 See also help(direct)."))
    }
    if (!(is.null(weights) || weights %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0(weights, 
            " is not contained in smp_data.\n                        Please provide valid variable name for weights.")))
    }
    if (!(is.null(weights) || is.numeric(smp_data[[weights]]))) {
        stop(strwrap(prefix = " ", initial = "", paste0(weights, 
            " must be the name of a variable that is a\n                        numeric vector.")))
    }
    if (var == TRUE && boot_type != "naive" && is.null(weights)) {
        stop(strwrap(prefix = " ", initial = "", "If boot_type is set to 'calibrate' weights must be chosen.\n                 Weights must be a vector of length 1 and of class character\n                 specifying the variable (name) of the sampling weights in the\n                 sample data. See also help(direct)."))
    }
    if (!(is.null(design) || (inherits(design, "character") && 
        length(design) == 1))) {
        stop(strwrap(prefix = " ", initial = "", "Design must be a vector of length 1 and of class character\n                 specifying the variable (name) of the sampling design in the\n                 sample data. See also help(direct)."))
    }
    if (!is.null(threshold) && !(is.numeric(threshold) && length(threshold) == 
        1) && !inherits(threshold, "function")) {
        stop(strwrap(prefix = " ", initial = "", "threshold must be a single numeric value or a function of y\n                 and weights. If it is NULL 60% of the median of the target\n                 variable is selected as threshold. See also help(direct)."))
    }
    if (inherits(threshold, "function") && !all(names(formals(threshold)) == 
        c("y", "weights"))) {
        stop(strwrap(prefix = " ", initial = "", "If threshold is a function the arguments need to be y and\n                 weights in this order. Also a single numeric value is possible\n                 as threshold. If it is NULL 60% of the median of the target\n                 variable is selected as threshold. See also help(direct)."))
    }
    if (inherits(threshold, "function") && (!is.numeric(threshold(smp_data[[y]], 
        smp_data[[weights]])) || length(threshold(smp_data[[y]], 
        smp_data[[weights]])) != 1)) {
        stop(strwrap(prefix = " ", initial = "", "The threshold function must return a single numeric value\n                 when evaluated with the dependent variable and the weights,\n                 if present."))
    }
    if (!is.logical(var) || length(var) != 1) {
        stop(strwrap(prefix = " ", initial = "", "Var must be a logical value. Set Var to TRUE or FALSE. See\n                 also help(direct)."))
    }
    if (var == TRUE && !(boot_type == "naive" || boot_type == 
        "calibrate")) {
        stop(strwrap(prefix = " ", initial = "", "If var is set to TRUE, boot_type ''naive'' or ''calibrate''\n                 needs to be selected. See also help(direct)."))
    }
    if (var == TRUE && !(is.numeric(B) && length(B) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "If var is set to TRUE, a single value, interpreted as an\n                 integer, for the number of bootstrap sample needs to be chosen.\n                 See also help(direct)."))
    }
    if (!is.null(seed) && (!is.numeric(seed) || !(is.numeric(seed) && 
        length(seed) == 1))) {
        stop(strwrap(prefix = " ", initial = "", "The seed must be a single value, interpreted as an integer,\n                 or NULL. See also help(direct)."))
    }
    if (var == TRUE && boot_type == "calibrate" && !(inherits(X_calib, 
        c("matrix")) && is.numeric(X_calib) && (dim(X_calib)[1] == 
        dim(smp_data)[1]))) {
        stop(strwrap(prefix = " ", initial = "", "If boot_type is set to 'calibrate', X_calib must be a numeric\n                 matrix which colums have the same length as the colums in the\n                 sample data. See also help(direct)."))
    }
    if (var == TRUE && boot_type == "calibrate" && !(is.null(totals) || 
        (is.numeric(totals) && (length(totals) == dim(X_calib)[2])))) {
        stop(strwrap(prefix = " ", initial = "", "If boot_type is set to 'calibrate', totals can be NULL or\n                 must be a numeric vector which length equals to the number of\n                 colums in X_calib. See also help(direct)."))
    }
    if (!(inherits(na.rm, "logical") && length(na.rm) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "na.rm must be a logical value. Set na.rm to TRUE or FALSE.\n                 See also help(direct)."))
    }
    if (!is.null(custom_indicator)) {
        if (!inherits(custom_indicator, "list")) {
            stop(strwrap(prefix = " ", initial = "", "Additional indicators need to be added in argument\n                   custom_indicator as a list of functions. For help, see\n                   Example 3 in help(direct)."))
        }
        N_custom <- length(custom_indicator)
        for (i in seq_len(N_custom)) {
            if (!inherits(custom_indicator[[i]], "function")) {
                stop(strwrap(prefix = " ", initial = "", "The elements of the list need to be functions. These\n                     Functions for custom indicators need to have exactly the\n                     following three arguments: y, weights, threshold; even\n                     though weights might not be needed and a threshold might\n                     not be included in the indicator. For help, see Example 3\n                     in help(direct)."))
            }
            else if (inherits(custom_indicator[[i]], "function") && 
                !all(names(formals(custom_indicator[[i]])) %in% 
                  c("y", "weights", "threshold"))) {
                stop(strwrap(prefix = " ", initial = "", "Functions for custom indicators need to have the argument\n                     y and optional the argument weights and threshold. For\n                     help, see Example 3 in help(direct)."))
            }
            else if (inherits(custom_indicator[[i]], "function") && 
                !("y" %in% names(formals(custom_indicator[[i]])))) {
                stop(strwrap(prefix = " ", initial = "", "Functions for custom indicators need to have the argument\n                     y and optional the argument weights and threshold. For\n                     help, see Example 3 in help(direct)."))
            }
        }
    }
}
direct_variance <-
function (direct_estimator, indicator_name, y, weights, smp_data, 
    smp_domains, design, indicator, HT, HTmethod, bootType, B = B, 
    seed, X_calib, totals, threshold, envir) 
{
    rs <- indicator$domain
    byDomain <- !is.null(rs)
    y <- smp_data[, y]
    y <- as.numeric(as.integer(y))
    n <- length(y)
    haveWeights <- !is.null(weights)
    if (!is.null(weights)) 
        weights_vec <- smp_data[, weights]
    if (is.null(weights)) {
        weights_vec <- rep.int(1, n)
    }
    haveDesign <- !is.null(design)
    if (haveDesign) {
        design <- smp_data[, design]
    }
    if (!haveDesign) {
        design <- rep.int(1, n)
    }
    if (!is.numeric(B) || length(B) == 0) {
        stop("'B' must be numeric")
    }
    else {
        B <- as.integer(B[1])
    }
    bootType
    calibrate <- haveWeights && bootType == "calibrate"
    if (calibrate) {
        X_calib <- as.matrix(X_calib)
        if (!is.numeric(X_calib)) 
            stop("'X_calib' must be a numeric matrix")
        if (is.null(totals)) {
            totals <- apply(X_calib, 2, function(i) sum(i * weights_vec))
        }
        if (!is.numeric(totals)) 
            stop("'totals' must be of type numeric")
    }
    else {
        X_calib <- NULL
        totals <- NULL
    }
    smp_data <- data.frame(y = y)
    smp_data$weight <- weights_vec
    smp_data$Domain <- smp_domains
    if (HT == TRUE) {
        domain_var <- function(df) {
            tosum <- df[, 2] * (df[, 2] - 1) * df[, 1]^2
            return(sum(df[, 2])^-2 * sum(tosum))
        }
        approx_var_est_wrapper <- function(y, pik, method, data) {
            var <- suppressMessages(approx_var_est(y = y, pik = pik, 
                method = method))
            return(var)
        }
        if (indicator_name == "Mean") {
            smp_data$indicator <- smp_data$y
        }
        else if (indicator_name == "Head_Count") {
            smp_data$indicator <- as.integer(smp_data$y < threshold)
        }
        else if (indicator_name == "Poverty_Gap") {
            smp_data$indicator <- ((threshold - smp_data$y)/threshold) * 
                (smp_data$y < threshold)
        }
        else if (indicator_name == "Gini") {
            sumweight <- sum(smp_data$weight)
            sumwy <- sum(smp_data$weight * smp_data$y)
            smp_data$indicator <- ((2 * smp_data$y * sumweight - 
                smp_data$y * smp_data$weight)/sumwy) - 1
        }
        else {
            smp_data$indicator <- NA
        }
        if (HTmethod == "Simple" & min(is.na(smp_data$indicator) == 
            0)) {
            var <- as.vector(by(data = smp_data[c("indicator", 
                "weight")], INDICES = smp_data$Domain, FUN = domain_var))
        }
        else if (min(is.na(smp_data$indicator) == 0)) {
            pik <- 1/weights_vec
            var <- as.vector(by(data = smp_data[c("indicator")], 
                INDICES = smp_data$Domain, FUN = approx_var_est_wrapper, 
                y = smp_data$indicator, pik = pik, method = HTmethod))
            sumwbydomain <- by(data = smp_data[, "weight"], INDICES = smp_data$Domain, 
                FUN = sum)
            var <- var/(sumwbydomain^2)
        }
        else {
            var <- rep(NA, length(unique(smp_data$Domain)))
        }
        varByDomain <- data.frame(Domain = rs, var = var)
        indicator$varMethod <- paste0("HT_", HTmethod)
    }
    else {
        if (!is.null(seed)) {
            set.seed(seed)
        }
        if (!exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) 
            runif(1)
        seed <- get(".Random.seed")
        fun <- getFun2(byDomain, direct_estimator)
        bootFun <- getBootFun2(calibrate, fun)
        b <- clusterBoot2(smp_data, bootFun, B, domain = design, 
            threshold = threshold, aux = X_calib, totals = totals, 
            rs = rs, envir = envir, indicator_name = indicator_name)
        if (byDomain) {
            var <- apply(b$t, 2, var, na.rm = TRUE)
            varByDomain <- data.frame(Domain = rs, var = var[-1])
            var <- var[1]
        }
        else {
            var <- var(b$t[, 1], na.rm = TRUE)
        }
        indicator$varMethod <- "bootstrap"
    }
    indicator$var <- var
    if (byDomain) {
        indicator$varByDomain <- varByDomain
    }
    indicator$seed <- seed
    return(indicator)
}
drop1.fh <-
function (object, criteria, scope, ...) 
{
    tl <- attr(terms(object$fixed), "term.labels")
    if (missing(scope)) {
        scope <- drop.scope(object$fixed)
    }
    else {
        if (!is.character(scope)) {
            scope <- attr(terms(update.formula(object$fixed, 
                scope)), "term.labels")
        }
        if (!all(match(scope, tl, 0L) > 0L)) {
            stop("scope is not a subset of term labels")
        }
    }
    ns <- length(scope)
    ans <- matrix(nrow = ns + 1L, ncol = 2L, dimnames = list(c("<none>", 
        scope), c("df", "criteria")))
    ans[1, ] <- c(length(attr(terms(object$fixed), "term.labels")) + 
        1, object$model$model_select[[criteria]])
    n0 <- object$framework$N_dom_smp
    for (i in seq_len(ns)) {
        tt <- scope[i]
        nfit <- object
        nfit$call$fixed <- update(object$fixed, as.formula(paste("~ . -", 
            tt)), evaluate = FALSE)
        nfit$call$formula <- NULL
        catmessage <- capture.output(nfit <- eval(nfit$call))
        ans[i + 1, ] <- c(length(attr(terms(nfit$fixed), "term.labels")) + 
            1, nfit$model$model_select[[criteria]])
        nnew <- nfit$framework$N_dom_smp
        if (all(is.finite(c(n0, nnew))) && nnew != n0) {
            stop(strwrap(prefix = " ", initial = "", "number of rows in use has changed: remove missing values?"))
        }
    }
    dfs <- ans[1L, 1L] - ans[, 1L]
    dfs[1L] <- NA
    aod <- data.frame(Df = dfs, criteria = ans[, 2])
    head <- c("Single term deletions", "\nModel:", deparse(formula(object$fixed)))
    class(aod) <- c("anova", "data.frame")
    attr(aod, "heading") <- head
    aod
}
dual <-
function (y, lambda = lambda, shift = 0) 
{
    with_shift <- function(y, shift) {
        min <- min(y)
        if (min <= 0) {
            shift <- shift + abs(min(y)) + 1
        }
        else {
            shift <- shift
        }
        return(shift)
    }
    shift <- with_shift(y = y, shift = shift)
    lambda_absolute <- abs(lambda)
    if (lambda_absolute <= 9.9999999999999998e-13) {
        yt <- log(y + shift)
    }
    else if (lambda > 9.9999999999999998e-13) {
        yt <- ((y + shift)^(lambda) - (y + shift)^(-lambda))/(2 * 
            lambda)
    }
    else {
        stop(strwrap(prefix = " ", initial = "", "lambda cannot be negative for the dual transformation"))
    }
    return(list(y = yt, shift = shift))
}
dual_back <-
function (y, lambda = lambda, shift) 
{
    lambda_absolute <- abs(lambda)
    if (lambda_absolute <= 9.9999999999999998e-13) {
        y <- exp(y) - shift
    }
    else {
        y <- (lambda * y + sqrt(lambda^2 * y^2 + 1))^(1/lambda) - 
            shift
    }
    return(y = y)
}
dual_std <-
function (y, lambda) 
{
    min <- min(y)
    if (min <= 0) {
        y <- y - min + 1
    }
    yt <- dual(y, lambda)$y
    zt <- if (abs(lambda) > 9.9999999999999998e-13) {
        geo <- geometric.mean(y^(lambda - 1) + y^(-lambda - 1))
        zt <- yt * 2/geo
    }
    else {
        zt <- geometric.mean(y) * log(y)
    }
    y <- zt
    return(y)
}
eblup_FH <-
function (framework, sigmau2, combined_data) 
{
    D <- diag(1, framework$m)
    V <- sigmau2 * D %*% t(D) + diag(as.numeric(framework$vardir))
    Vi <- solve(V)
    Q <- solve(t(framework$model_X) %*% Vi %*% framework$model_X)
    beta_hat <- Q %*% t(framework$model_X) %*% Vi %*% framework$direct
    std_errorbeta <- sqrt(diag(Q))
    tvalue <- beta_hat/std_errorbeta
    pvalue <- 2 * pnorm(abs(tvalue), lower.tail = FALSE)
    eblup_coef <- data.frame(coefficients = beta_hat, std.error = std_errorbeta, 
        t.value = tvalue, p.value = pvalue)
    res <- framework$direct - c(framework$model_X %*% beta_hat)
    sigmau2Diag <- sigmau2 * D
    u_hat <- sigmau2Diag %*% t(D) %*% Vi %*% res
    gamma <- sigmau2/(sigmau2 + framework$vardir)
    real_res <- framework$direct - (framework$model_X %*% beta_hat + 
        D %*% u_hat)
    std_real_res <- real_res/sqrt(framework$vardir)
    fitted <- as.vector(framework$model_X %*% beta_hat)
    eblup_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    eblup_data$Direct <- NA
    eblup_data$Direct[framework$obs_dom == TRUE] <- framework$direct
    if (all(framework$obs_dom == TRUE)) {
        eblup_data$FH[framework$obs_dom == TRUE] <- framework$model_X %*% 
            beta_hat + D %*% u_hat
        eblup_data$Out[framework$obs_dom == TRUE] <- 0
    }
    else {
        pred_data_tmp <- combined_data[framework$obs_dom == FALSE, 
            ]
        pred_data_tmp <- data.frame(pred_data_tmp, helper = rnorm(1, 
            0, 1))
        formula.tools::lhs(framework$formula) <- quote(helper)
        pred_data <- makeXY(formula = framework$formula, data = pred_data_tmp)
        pred_X <- pred_data$x
        pred_y <- pred_X %*% beta_hat
        eblup_data$FH[framework$obs_dom == TRUE] <- framework$model_X %*% 
            beta_hat + D %*% u_hat
        eblup_data$FH[framework$obs_dom == FALSE] <- pred_y
        eblup_data$Out[framework$obs_dom == TRUE] <- 0
        eblup_data$Out[framework$obs_dom == FALSE] <- 1
    }
    eblup_out <- list(eblup_data = eblup_data, fitted = fitted, 
        gamma = gamma, coefficients = eblup_coef, real_res = real_res, 
        std_real_res = std_real_res, random_effects = u_hat, 
        beta_vcov = Q)
    return(eblup_out)
}
eblup_SFH <-
function (framework, sigmau2, combined_data) 
{
    D <- diag(1, framework$m)
    Wt <- t(framework$W)
    A <- solve((D - sigmau2$rho * Wt) %*% (D - sigmau2$rho * 
        framework$W))
    G <- sigmau2$sigmau2 * A
    V <- G + D * framework$vardir
    Vi <- solve(V)
    Q <- solve(t(framework$model_X) %*% Vi %*% framework$model_X)
    beta_hat <- Q %*% t(framework$model_X) %*% Vi %*% framework$direct
    std_errorbeta <- sqrt(diag(Q))
    tvalue <- beta_hat/std_errorbeta
    pvalue <- 2 * pnorm(abs(tvalue), lower.tail = FALSE)
    eblup_coef <- data.frame(coefficients = beta_hat, std.error = std_errorbeta, 
        t.value = tvalue, p.value = pvalue)
    res <- framework$direct - c(framework$model_X %*% beta_hat)
    u_hat <- G %*% Vi %*% res
    real_res <- framework$direct - (framework$model_X %*% beta_hat + 
        G %*% Vi %*% res)
    std_real_res <- real_res/sqrt(framework$vardir)
    fitted <- as.vector(framework$model_X %*% beta_hat)
    eblup_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    eblup_data$Direct <- NA
    eblup_data$Direct[framework$obs_dom == TRUE] <- framework$direct
    if (all(framework$obs_dom == TRUE)) {
        eblup_data$FH[framework$obs_dom == TRUE] <- (framework$model_X %*% 
            beta_hat + G %*% Vi %*% res)
        eblup_data$Out[framework$obs_dom == TRUE] <- 0
    }
    else {
        pred_data_tmp <- combined_data[framework$obs_dom == FALSE, 
            ]
        pred_data_tmp <- data.frame(pred_data_tmp, helper = rnorm(1, 
            0, 1))
        formula.tools::lhs(framework$formula) <- quote(helper)
        pred_data <- makeXY(formula = framework$formula, data = pred_data_tmp)
        pred_X <- pred_data$x
        pred_y <- pred_X %*% beta_hat
        eblup_data$FH[framework$obs_dom == TRUE] <- (framework$model_X %*% 
            beta_hat + G %*% Vi %*% res)
        eblup_data$FH[framework$obs_dom == FALSE] <- pred_y
        eblup_data$Out[framework$obs_dom == TRUE] <- 0
        eblup_data$Out[framework$obs_dom == FALSE] <- 1
    }
    eblup_out <- list(eblup_data = eblup_data, fitted = fitted, 
        coefficients = eblup_coef, real_res = real_res, V = V, 
        std_real_res = std_real_res, random_effects = u_hat, 
        beta_vcov = Q)
    return(eblup_out)
}
eblup_YL <-
function (framework, sigmau2, combined_data) 
{
    D <- diag(1, framework$m)
    beta_hat_tCi_beta_hat <- NULL
    for (i in seq_len(framework$m)) {
        beta_hat_tCi_beta_hat[i] <- t(sigmau2$betahatw) %*% framework$Ci[, 
            , i] %*% sigmau2$betahatw
    }
    V <- sigmau2$sigmau_YL * D %*% t(D) + diag(as.numeric(framework$vardir)) + 
        diag(as.numeric(beta_hat_tCi_beta_hat))
    Vi <- solve(V)
    Q <- solve(t(framework$model_X) %*% Vi %*% framework$model_X)
    std_errorbeta <- sqrt(diag(Q))
    tvalue <- sigmau2$betahatw/std_errorbeta
    pvalue <- 2 * pnorm(abs(tvalue), lower.tail = FALSE)
    eblup_coef <- data.frame(coefficients = sigmau2$betahatw, 
        std.error = std_errorbeta, t.value = tvalue, p.value = pvalue)
    gamma <- (sigmau2$sigmau_YL + beta_hat_tCi_beta_hat)/(sigmau2$sigmau_YL + 
        beta_hat_tCi_beta_hat + framework$vardir)
    res <- framework$direct - c(framework$model_X %*% sigmau2$betahatw)
    u_hat <- gamma * res
    real_res <- framework$direct - (framework$model_X %*% sigmau2$betahatw + 
        u_hat)
    std_real_res <- real_res/sqrt(framework$vardir)
    fitted <- as.vector(framework$model_X %*% sigmau2$betahatw[, 
        1])
    eblup_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    eblup_data$Direct <- NA
    eblup_data$Direct[framework$obs_dom == TRUE] <- framework$direct
    if (all(framework$obs_dom == TRUE)) {
        eblup_data$FH[framework$obs_dom == TRUE] <- gamma * framework$direct + 
            (1 - gamma) * framework$model_X %*% sigmau2$betahatw[, 
                1]
        eblup_data$Out[framework$obs_dom == TRUE] <- 0
    }
    else {
        pred_data_tmp <- combined_data[framework$obs_dom == FALSE, 
            ]
        pred_data_tmp <- data.frame(pred_data_tmp, helper = rnorm(1, 
            0, 1))
        formula.tools::lhs(framework$formula) <- quote(helper)
        pred_data <- makeXY(formula = framework$formula, data = pred_data_tmp)
        pred_X <- pred_data$x
        pred_y <- pred_X %*% sigmau2$betahatw
        eblup_data$FH[framework$obs_dom == TRUE] <- gamma * framework$direct + 
            (1 - gamma) * framework$model_X %*% sigmau2$betahatw[, 
                1]
        eblup_data$FH[framework$obs_dom == FALSE] <- pred_y
        eblup_data$Out[framework$obs_dom == TRUE] <- 0
        eblup_data$Out[framework$obs_dom == FALSE] <- 1
    }
    eblup_out <- list(eblup_data = eblup_data, fitted = fitted, 
        gamma = gamma, coefficients = eblup_coef, real_res = real_res, 
        std_real_res = std_real_res, random_effects = u_hat, 
        beta_vcov = Q)
    return(eblup_out)
}
eblup_robust <-
function (framework, combined_data, method, k = 1.345, vardir, 
    mult_constant, correlation, corMatrix) 
{
    if (correlation == "no") {
        eblupobject <- saeRobust::rfh(framework$formula, data = framework$data, 
            samplingVar = vardir, tol = framework$tol, maxIter = framework$maxit)
        D <- diag(1, framework$m)
        model_X <- as.matrix(eblupobject$x)
        V <- eblupobject$variance * D %*% t(D) + diag(as.numeric(framework$vardir))
        Vi <- solve(V)
        Q <- solve(t(model_X) %*% Vi %*% model_X)
        std.errorbeta <- sqrt(diag(Q))
        tvalue <- eblupobject$coefficients/std.errorbeta
        pvalue <- 2 * pnorm(abs(tvalue), lower.tail = FALSE)
        eblup_coef <- data.frame(coefficients = eblupobject$coefficients, 
            std.error = std.errorbeta, t.value = tvalue, p.value = pvalue)
    }
    else if (correlation == "spatial") {
        if (is.matrix(corMatrix) == FALSE) {
            corMatrix <- as.matrix(corMatrix)
        }
        eblupobject <- saeRobust::rfh(framework$formula, data = framework$data, 
            samplingVar = vardir, saeRobust::corSAR1(corMatrix), 
            k = k, tol = framework$tol, maxIter = framework$maxit)
        D <- diag(1, framework$m)
        model_X <- as.matrix(eblupobject$x)
        Wt <- t(framework$W)
        A <- solve((D - eblupobject$variance[1] * Wt) %*% (D - 
            eblupobject$variance[1] * framework$W))
        G <- eblupobject$variance[2] * A
        V <- G + D * framework$vardir
        Vi <- solve(V)
        Q <- solve(t(model_X) %*% Vi %*% model_X)
        std.errorbeta <- sqrt(diag(Q))
        tvalue <- eblupobject$coefficients/std.errorbeta
        pvalue <- 2 * pnorm(abs(tvalue), lower.tail = FALSE)
        eblup_coef <- data.frame(coefficients = eblupobject$coefficients, 
            std.error = std.errorbeta, t.value = tvalue, p.value = pvalue)
    }
    eblupobject$linear <- stats::predict(eblupobject, type = "linear")$linear
    eblupobject$reblupbc <- stats::predict(eblupobject, type = "reblupbc", 
        c = mult_constant)$reblupbc
    eblup_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    eblup_data$Direct <- NA
    eblup_data$Direct[framework$obs_dom == TRUE] <- framework$direct
    if (is.element("linear", method)) {
        eblup_data$FH[framework$obs_dom == TRUE] <- eblupobject$linear
    }
    if (is.element("reblup", method)) {
        eblup_data$FH[framework$obs_dom == TRUE] <- eblupobject$reblup
    }
    if (is.element("reblupbc", method)) {
        eblup_data$FH[framework$obs_dom == TRUE] <- eblupobject$reblupbc
    }
    eblup_data$Out[framework$obs_dom == TRUE] <- 0
    eblup_data$Out[framework$obs_dom == FALSE] <- 1
    if (!all(framework$obs_dom == TRUE)) {
        message(strwrap(prefix = " ", initial = "", "Please note that the results are only returned for\n                   in-sample domains. For more information see help(fh)."))
    }
    eblup_out <- list(eblup_data = eblup_data, fitted = eblupobject$fitted, 
        coefficients = eblup_coef, real_res = eblupobject$residuals, 
        std_real_res = eblupobject$residuals/sqrt(eblupobject$samplingVar), 
        random_effects = eblupobject$re, eblupobject = eblupobject, 
        variance = eblupobject$variance, beta_vcov = Q)
    return(eblup_out)
}
ebp <-
function (fixed, pop_data, pop_domains, pop_subdomains = NULL, 
    smp_data, smp_domains, smp_subdomains = NULL, L = 0, threshold = NULL, 
    transformation = "log.shift", interval = "default", MSE = FALSE, 
    B = 100, seed = 123, boot_type = "parametric", parallel_mode = ifelse(grepl("windows", 
        .Platform$OS.type), "socket", "multicore"), cpus = 1, 
    custom_indicator = NULL, na.rm = FALSE, weights = NULL, pop_weights = NULL, 
    MSE_pop_weights = NULL, aggregate_to = NULL, weights_type = NULL, 
    nlme_update_re = FALSE, benchmark = NULL, benchmark_type = "ratio", 
    benchmark_level = NULL, benchmark_weights = NULL, nlme_maxiter = 1000, 
    nlme_tolerance = 9.9999999999999995e-07, nlme_opt = "nlminb", 
    nlme_optimmethod = "BFGS", nlme_method = "REML", nlme_mstol = 9.9999999999999995e-08, 
    nlme_msmaxiter = 1000, nlme_returnobject = FALSE, rescale_weights = FALSE, 
    Ydump = NULL, model_parameters = "fixed", data.table = FALSE, 
    indicators = NULL) 
{
    start.time <- Sys.time()
    ebp_check1(fixed = fixed, pop_data = pop_data, pop_domains = pop_domains, 
        smp_data = smp_data, smp_domains = smp_domains, L = L)
    ebp_check2(threshold = threshold, transformation = transformation, 
        interval = interval, MSE = MSE, boot_type = boot_type, 
        B = B, L = L, custom_indicator = custom_indicator, cpus = cpus, 
        seed = seed, na.rm = na.rm, weights = weights, pop_weights = pop_weights, 
        weights_type = weights_type, benchmark = benchmark, benchmark_type = benchmark_type, 
        benchmark_level = benchmark_level, benchmark_weights = benchmark_weights, 
        MSE_pop_weights = MSE_pop_weights, smp_subdomains = smp_subdomains, 
        pop_subdomains = pop_subdomains)
    call <- match.call()
    if (inherits(call$fixed, "name")) {
        call$fixed <- fixed
    }
    if (!is.null(seed)) {
        if (cpus > 1 && parallel_mode != "socket") {
            RNG_kind <- RNGkind()
            set.seed(seed, kind = "L'Ecuyer")
        }
        else {
            set.seed(seed)
        }
    }
    if (is.null(weights_type) & !is.null(weights)) {
        weights_type <- "nlme"
    }
    if (is.null(benchmark_weights) & !is.null(weights)) {
        benchmark_weights <- weights
    }
    if (L == 0 && is.null(indicators)) {
        indicators <- c("Mean", "Head_Count", "Poverty_Gap")
    }
    framework <- framework_ebp(pop_data = pop_data, pop_domains = pop_domains, 
        pop_subdomains = pop_subdomains, smp_data = smp_data, 
        smp_domains = smp_domains, smp_subdomains = smp_subdomains, 
        aggregate_to = aggregate_to, custom_indicator = custom_indicator, 
        fixed = fixed, threshold = threshold, na.rm = na.rm, 
        weights = weights, pop_weights = pop_weights, MSE_pop_weights = MSE_pop_weights, 
        weights_type = weights_type, benchmark_level = benchmark_level, 
        benchmark_weights = benchmark_weights, nlme_maxiter = nlme_maxiter, 
        nlme_tolerance = nlme_tolerance, nlme_opt = nlme_opt, 
        nlme_optimmethod = nlme_optimmethod, nlme_method = nlme_method, 
        nlme_mstol = nlme_mstol, nlme_msmaxiter = nlme_msmaxiter, 
        nlme_returnobject = nlme_returnobject, rescale_weights = rescale_weights, 
        model_parameters = model_parameters, data.table = data.table, 
        indicators = indicators)
    point_estim <- point_estim(framework = framework, fixed = fixed, 
        transformation = transformation, interval = interval, 
        L = L, keep_data = TRUE, Ydump = Ydump)
    if (!is.null(benchmark)) {
        if (is.null(benchmark_level)) {
            point_estim$ind <- benchmark_ebp_national(point_estim = point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type)
        }
        else {
            point_estim$ind <- benchmark_ebp_level(point_estim = point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        }
        if (any(names(point_estim$ind) %in% c("Mean_bench"))) {
            if (any(is.na(point_estim$ind$Mean_bench))) {
                message(strwrap(prefix = " ", initial = "", "Benchmark point estimates for\n                          Mean contain missing values. Please check source data"))
            }
        }
        if (any(names(point_estim$ind) %in% c("Head_Count_bench"))) {
            if (any(is.na(point_estim$ind$Head_Count_bench))) {
                message(strwrap(prefix = " ", initial = "", "Benchmark point estimates for\n                          Head_Count contain missing values. Please check source data"))
            }
            else if (!all(point_estim$ind$Head_Count_bench >= 
                0 & point_estim$ind$Head_Count_bench <= 1)) {
                message(strwrap(prefix = " ", initial = "", "Please note that benchmark point estimates for\n                          Head_Count are outside the expected range [0,1]."))
            }
        }
    }
    if (MSE == TRUE) {
        mse_estimates <- parametric_bootstrap(framework = framework, 
            point_estim = point_estim, fixed = fixed, transformation = transformation, 
            interval = interval, L = L, B = B, boot_type = boot_type, 
            parallel_mode = parallel_mode, cpus = cpus, benchmark = benchmark, 
            benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        ebp_out <- list(ind = point_estim$ind, MSE = mse_estimates, 
            transform_param = point_estim[c("optimal_lambda", 
                "shift_par")], model = point_estim$model, model_par = point_estim$model_par, 
            framework = framework[c("N_dom_unobs", "N_dom_smp", 
                "N_subdom_unobs", "N_subdom_smp", "N_smp", "N_pop", 
                "smp_domains", "smp_data", "smp_subdomains", 
                "smp_domains_vec", "smp_subdomains_vec", "pop_domains_vec", 
                "pop_subdomains_vec", "weights", "weights_type", 
                "pop_weights")], transformation = transformation, 
            method = "reml", fixed = fixed, call = call, successful_bootstraps = NULL)
    }
    else {
        ebp_out <- list(ind = point_estim$ind, MSE = NULL, transform_param = point_estim[c("optimal_lambda", 
            "shift_par")], model = point_estim$model, model_par = point_estim$model_par, 
            framework = framework[c("N_dom_unobs", "N_subdom_unobs", 
                "N_dom_smp", "N_subdom_smp", "N_smp", "N_pop", 
                "smp_domains", "smp_data", "smp_subdomains", 
                "smp_domains_vec", "smp_subdomains_vec", "pop_domains_vec", 
                "pop_subdomains_vec", "weights", "weights_type", 
                "pop_weights", "response", "indicator_names")], 
            transformation = transformation, method = "reml", 
            fixed = fixed, call = call, successful_bootstraps = NULL)
    }
    end.time <- Sys.time()
    print(round(end.time - start.time, 2))
    if (cpus > 1 && parallel_mode != "socket") {
        RNGkind(RNG_kind[1])
    }
    class(ebp_out) <- c("ebp", "povmap")
    return(ebp_out)
}
ebp_check1 <-
function (fixed, pop_data, pop_domains, smp_data, smp_domains, 
    L) 
{
    if (is.null(fixed) || !inherits(fixed, "formula")) {
        stop("Fixed must be a formula object. See also help(ebp).")
    }
    if (!is.data.frame(pop_data)) {
        stop(strwrap(prefix = " ", initial = "", "Pop_data must be a data frame containing population data.\n                 See also help(ebp)."))
    }
    if (!is.character(pop_domains) || length(pop_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Pop_domains must be a vector of lenght 1 and of class\n                 character specifying the variable name of a numeric or factor\n                 variable indicating domains in the population data. See also\n                 help(ebp)."))
    }
    if (!is.data.frame(smp_data)) {
        stop(strwrap(prefix = " ", initial = "", "Smp_data must be a data frame containing sample data.\n                 See also help(ebp)."))
    }
    if (!is.character(smp_domains) || length(smp_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Smp_domains must be a vector of lenght 1 and of class\n                 character specifying the variable (name)  of a numeric or\n                 factor variable indicating domains in the sample data. See\n                 also help(ebp)."))
    }
    if (!is.numeric(L) || length(L) != 1 || L < 0) {
        stop(strwrap(prefix = " ", initial = "", "L needs to be a single value, interpreted as an integer,\n                 determining the number of Monte-Carlo simulations. The value\n                 must be at least 0. See also help(ebp)."))
    }
    if (!all(unique(as.character(smp_data[[smp_domains]])) %in% 
        unique(as.character(pop_data[[pop_domains]])))) {
        stop(strwrap(prefix = " ", initial = "", "The sample data contains domains that are not contained in the\n                population data."))
    }
}
ebp_check2 <-
function (threshold, transformation, interval, MSE, boot_type, 
    B, L, custom_indicator, cpus, seed, na.rm, weights, pop_weights, 
    weights_type, benchmark, benchmark_type, benchmark_level, 
    benchmark_weights, MSE_pop_weights, smp_subdomains = NULL, 
    pop_subdomains = NULL) 
{
    if (!is.null(threshold) && !(is.numeric(threshold) && length(threshold) == 
        1) && !inherits(threshold, "function")) {
        stop(strwrap(prefix = " ", initial = "", "threshold needs to be a single numeric value or a function\n                 of y. If it is NULL 60% of the median is selected as threshold.\n                 See also help(ebp)."))
    }
    if (inherits(threshold, "function") && !all(attributes(formals(threshold))$names == 
        c("y"))) {
        stop(strwrap(prefix = " ", initial = "", "If threshold is a function the argument needs to be y and\n                 only y. Also a single numeric value is possible as threshold.\n                 If it is NULL 60% of the median of the target variable is\n                 selected as threshold. See also help(ebp)."))
    }
    if (is.null(transformation) || !(transformation == "box.cox" || 
        transformation == "log" || transformation == "dual" || 
        transformation == "log.shift" || transformation == "no" || 
        transformation == "ordernorm" || transformation == "arcsin")) {
        stop(strwrap(prefix = " ", initial = "", "The seven options for transformation are no', log,\n                 'box.cox', dual', log.shift', 'ordernorm', and\n                 'arcsin'."))
    }
    if (L == 0 && !(transformation == "no" || transformation == 
        "arcsin" | transformation == "log" | transformation == 
        "log.shift")) {
        stop(strwrap(prefix = " ", initial = "", "Analytic calculations not supported with transformations other than log, log shift, and arcsin at this time"))
    }
    if (!is.null(MSE_pop_weights) && !(transformation == "no" || 
        transformation == "arcsin" | transformation == "log" | 
        transformation == "log.shift")) {
        stop(strwrap(prefix = " ", initial = "", "MSE population weights not supported with transformations other than log, log shift, and arcsin at this time"))
    }
    if (any(interval != "default") & (!is.vector(interval, mode = "numeric") || 
        length(interval) != 2 || !(interval[1] < interval[2]))) {
        stop(strwrap(prefix = " ", initial = "", "interval needs to be a numeric vector of length 2 defining a\n                 lower and upper limit for the estimation of the optimal\n                 transformation parameter. The value of the lower limit needs\n                 to be smaller than the upper limit. You can also choose\n                 'default'. See also help(ebp)."))
    }
    if (transformation == "dual" & any(interval < 0)) {
        stop(strwrap(prefix = " ", initial = "", "For the dual transformation, lambda needs to be positive, so\n                 the lower limit of the interval cannot be negative. See also\n                 help(ebp)."))
    }
    if (!is.logical(MSE) || length(MSE) != 1) {
        stop(strwrap(prefix = " ", initial = "", "MSE must be a logical value. Set MSE to TRUE or FALSE. See\n                 also help(ebp)."))
    }
    if (is.null(boot_type) || !(length(boot_type) == 1 && (boot_type == 
        "parametric" || boot_type == "wild"))) {
        stop("The two bootstrap procedures are ''parametric'' or ''wild''.")
    }
    if (MSE == TRUE && !(is.numeric(B) && length(B) == 1 && B > 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "If MSE is set to TRUE, a single numeric value for the number\n                 of bootstrap sample needs to be chosen that is greater than 1.\n                 See also help(ebp)."))
    }
    if (!is.numeric(cpus) || !(is.numeric(cpus) && length(cpus) == 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "Cpus must be a single number determining the number of\n                 kernels for the parallelization."))
    }
    if (!is.null(seed) && (!is.numeric(seed) || !(is.numeric(seed) && 
        length(seed) == 1))) {
        stop(strwrap(prefix = " ", initial = "", "The seed must be a single value, interpreted as an integer,\n                 or NULL See also help(ebp)."))
    }
    if (!is.null(custom_indicator)) {
        if (!inherits(custom_indicator, "list")) {
            stop(strwrap(prefix = " ", initial = "", "Additional indicators need to be added in argument\n                   custom_indicator as a list of functions. For help see\n                   Example 2 in help(ebp)."))
        }
        N_custom <- length(custom_indicator)
        for (i in seq_len(N_custom)) {
            if (!is.null(pop_weights)) {
                if (!all(c("y", "pop_weights") %in% names(formals(custom_indicator[[i]])))) {
                  stop(strwrap(prefix = " ", initial = "", "Please provide the argument pop_weights to the your\n                     custom_indicator. All other indicators will be\n                     calculated using population weights."))
                }
            }
            if (!inherits(custom_indicator[[i]], "function")) {
                stop(strwrap(prefix = " ", initial = "", "The elements of the list need to be functions. These\n                     functions for custom indicators need to have the\n                     argument y and optional the agruments pop_weights and\n                     threshold. For help see Example 2 in help(ebp)."))
            }
            else if (inherits(custom_indicator[[i]], "function") && 
                !all(names(formals(custom_indicator[[i]])) %in% 
                  c("y", "pop_weights", "threshold"))) {
                stop(strwrap(prefix = " ", initial = "", "Functions for custom indicators need to have exactly the\n                     following argument y and optional the arguments\n                     pop_weights, threshold. For help see Example 2 in\n                     help(ebp)."))
            }
        }
    }
    if (!(inherits(na.rm, "logical") && length(na.rm) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "na.rm needs to be a logical value. Set na.rm to TRUE or FALSE.\n                 See also help(ebp)."))
    }
    if (is.character(weights) && length(weights) != 1 || !is.character(weights) && 
        !is.null(weights)) {
        stop(strwrap(prefix = " ", initial = "", "Weights must be a vector of length 1 and of class character\n                 specifying the variable name of a numeric variable indicating\n                 weights in the sample data. See also help(ebp)."))
    }
    if (is.null(weights_type)) {
        weights_type <- "Guadarrama-Null"
    }
    if (!is.null(weights) && (weights_type == "Guadarrama" | 
        weights_type == "Guadarrama-Null") && !(transformation == 
        "log" || transformation == "no" || transformation == 
        "ordernorm")) {
        stop(strwrap(prefix = " ", initial = "", "Weighted ebp with weights_type == 'Guadarrama' can only be\n                 used without transformation or the log-transformation."))
    }
    if (!is.null(weights) && (weights_type == "Guadarrama" | 
        weights_type == "Guadarrama-Null") && (!is.null(smp_subdomains) && 
        (!is.null(pop_subdomains)))) {
        stop(strwrap(prefix = " ", initial = "", "Two-fold nested error model may only only be used with nlme or hybrid weights"))
    }
    if (weights_type == "Guadarrama-Null") {
        weights_type <- NULL
    }
    if (is.null(weights) & !is.null(weights_type)) {
        stop(strwrap(prefix = " ", initial = "", paste0("If you want to use the survey weights with weighting\n                         type ", 
            weights_type, " please provide the name of a\n                         numeric variable indicating weights in the sample data\n                         to the argument weights.")))
    }
    if (!is.null(weights_type)) {
        if (!weights_type %in% c("nlme", "Guadarrama", "nlme_lambda", 
            "hybrid", "hybrid2")) {
            stop(strwrap(prefix = " ", initial = "", "The five options for types of survey weights are\n                 ''hybrid'',''hybrid2'', Guadarrama'', ''nlme'', and ''nlme_lambda''"))
        }
        if (transformation %in% c("no", "log", "ordernorm") && 
            weights_type == "nlme_lambda") {
            stop(strwrap(prefix = " ", initial = "", paste0("If you want to use the survey weights with weighting\n                        type ", 
                weights_type, " please choose a data-driven\n                        transformation ('box.cox', 'dual', 'log.shift') in\n                        agrument transformation or use weights_type = 'nlme'\n                        to use nlme weights for the estimation.")))
        }
    }
    if (is.character(pop_weights) && length(pop_weights) != 1 || 
        !is.character(pop_weights) && !is.null(pop_weights)) {
        stop(strwrap(prefix = " ", initial = "", "Pop_weights must be a vector of length 1 and of class\n                 character specifying the variable name of a numeric variable\n                 indicating weights in the population data. See also\n                 help(ebp)."))
    }
    if (!is.null(benchmark)) {
        if (!(is.numeric(benchmark) || is.character(benchmark) || 
            is.data.frame(benchmark))) {
            stop(strwrap(prefix = " ", initial = "", "For fixed value: Benchmark must be a named vector\n                   containing the numeric benchmark value(s) and is of class\n                   numeric. The names of the vector matchs to the chosen\n                   indicators. \n For survey values: Benchmark must be a\n                   vector of class character containing the names of the chosen\n                   indicators."))
        }
        if (is.numeric(benchmark)) {
            if (!length(benchmark) %in% 1:2) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the length of benchmark must be 1 or 2. The names of this\n                     vector indicates whether the Mean, the Head_Count, or\n                     both in which order are supplied."))
            }
            if (is.null(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Please provide\n                     names."))
            }
            if (!length(benchmark) == length(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Each numeric must\n                     be labeled. Therefore, benchmark and names(benchmark) have\n                     the same length."))
            }
            if (!all(names(benchmark) %in% c("Mean", "Head_Count"))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names must match with 'Mean' and 'Head_Count'."))
            }
            if (!is.null(benchmark_weights)) {
                stop(strwrap(prefix = " ", initial = "", "For external benchmarking no benchmark weights can be\n                     used."))
            }
        }
        if (is.character(benchmark)) {
            if (!length(benchmark) %in% 1:2) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a vector of class character containing\n                     the names of the chosen indicators. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the length of benchmark must be 1 or 2. The vector\n                     indicates whether the Mean, the Head_Count, or both in\n                     which order are supplied."))
            }
            if (!all(benchmark %in% c("Mean", "Head_Count"))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a vector of class character containing\n                     the names of the chosen indicators. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     it must match with 'Mean' and 'Head_Count'."))
            }
            if (is.null(weights)) {
                stop(strwrap(prefix = " ", initial = "", "The argument benchmark indicates that it is benchmarked\n                     with the survey data. Please provide weights through the\n                     argument weights."))
            }
        }
        if (is.data.frame(benchmark)) {
            if (is.null(benchmark_level)) {
                stop(strwrap(prefix = " ", initial = "", "As the input in benchmark is a data.frame. Fixed benchmark\n                     values are used at a lower level. Please give the name\n                     of this variable in the sample and population data\n                     by the argument benchmark_level."))
            }
            if (!length(benchmark) %in% 2:3) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count."))
            }
            if (is.null(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. Please provide names."))
            }
            if (!length(benchmark) == length(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. Each variable in the data.frame must\n                     be labeled."))
            }
            if (!all(names(benchmark)[-1] %in% c("Mean", "Head_Count"))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. No other names are possible."))
            }
            if (names(benchmark)[1] != benchmark_level) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. The name of the first variable indicataing\n                     the domains of the benchmark_level does not match to the\n                     argument benchmark_level."))
            }
            if (!is.null(benchmark_weights)) {
                stop(strwrap(prefix = " ", initial = "", "For external benchmarking no benchmark weights can be\n                     used."))
            }
        }
    }
    if (benchmark_type != "ratio" && benchmark_type != "raking" && 
        benchmark_type != "ratio_complement") {
        stop(strwrap(prefix = " ", initial = "", "The benchmark version of ebp is only available with\n                   'raking', 'ratio', and 'ratio_complement'."))
    }
    if (benchmark_type == "ratio_complement" && (names(benchmark)[-1] %in% 
        "Head_Count") && max(benchmark[["Head_Count"]]) > 1) {
        stop(strwrap(prefix = " ", initial = "", "When benchmarking the headcount rate with ratio_complement, the target values must lie between 0 and 1."))
    }
    if (is.null(benchmark) && benchmark_type != "ratio") {
        stop(strwrap(prefix = " ", initial = "", "A benchmark type is provided, but no benchmark value.\n                   Please provide the argument 'benchmark' within the\n                   function."))
    }
}
ebp_compute_cv <-
function (model, calibvar = NULL, boot_type = "calibrate", designvar = NULL, 
    threshold = NULL, B = model$call$B) 
{
    if (is.null(model$call$weights)) {
        model$framework$smp_data$weights <- rep(1, nrow(model$framework$smp_data))
        model$call$weights <- "weights"
    }
    if (is.null(threshold)) {
        threshold <- 0.59999999999999998 * median(model$framework$smp_data[[paste(model$fixed[2])]])
        message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is\n                          automatically set to 60% of the median of the\n                          dependent variable and equals ", 
            threshold)))
    }
    if (!is.null(calibvar)) {
        calibmatrix <- create_calibmatrix(model$framework$smp_data[[calibvar]])
        direct_calib <- povmap::direct(y = as.character(model$fixed[[2]]), 
            smp_data = model$framework$smp_data, smp_domains = model$framework$smp_domains, 
            weights = model$call$weights, design = designvar, 
            threshold = threshold, var = TRUE, boot_type = boot_type, 
            X_calib = calibmatrix, totals = NULL, na.rm = TRUE, 
            B = B)
        direct_calib <- data.frame(Domain = direct_calib$ind$Domain, 
            CB_Head_Count_CV = sqrt(direct_calib$MSE$Head_Count)/direct_calib$ind$Head_Count)
    }
    direct_ht <- povmap::direct(y = as.character(model$fixed[[2]]), 
        smp_data = model$framework$smp_data, smp_domains = model$framework$smp_domains, 
        weights = model$call$weights, threshold = threshold, 
        var = TRUE, na.rm = TRUE, HT = T)
    direct_ht <- data.frame(Domain = direct_ht$ind$Domain, Direct_Head_Count = direct_ht$ind$Head_Count, 
        HT_Head_Count_CV = sqrt(direct_ht$MSE$Head_Count)/direct_ht$ind$Head_Count)
    model$framework$smp_data$poor <- as.integer(model$framework$smp_data[[as.character(model$fixed[[2]])]] < 
        threshold)
    model$framework$smp_data$weights <- model$framework$smp_data[[model$call$weights]]
    if (is.null(designvar)) {
        ebpobj_svy <- survey::svydesign(ids = ~1, weights = ~weights, 
            strata = NULL, survey.lonely.psu = "adjust", data = model$framework$smp_data)
    }
    else {
        model$framework$smp_data$designvar <- model$framework$smp_data[[designvar]]
        ebpobj_svy <- survey::svydesign(ids = ~1, weights = ~weights, 
            strata = ~designvar, survey.lonely.psu = "adjust", 
            data = model$framework$smp_data)
    }
    deff_adjust <- survey::svymean(x = ~poor, ebpobj_svy, na = TRUE, 
        deff = TRUE)
    deff_adjust <- attr(deff_adjust, "deff")[1, 1]
    direct_naive <- povmap::direct(y = as.character(model$fixed[[2]]), 
        smp_data = model$framework$smp_data, smp_domains = model$framework$smp_domains, 
        design = designvar, weights = model$call$weights, threshold = threshold, 
        var = TRUE, B = B)
    direct_naive <- data.frame(Domain = direct_naive$ind$Domain, 
        DesignEffect_CV = sqrt(direct_naive$MSE$Head_Count)/direct_naive$ind$Head_Count)
    emdi_dt <- povmap::estimators(object = model, indicator = "Head_Count", 
        MSE = FALSE, CV = TRUE)
    result_dt <- emdi_dt$ind
    colnames(result_dt) <- c("Domain", "EBP_Head_Count", "EBP_Head_Count_CV")
    if (!is.null(calibvar)) {
        result_dt <- merge(result_dt, direct_calib, by = "Domain")
    }
    result_dt <- merge(result_dt, direct_ht, by = "Domain")
    result_dt <- merge(result_dt, direct_naive, by = "Domain")
    if (is.null(calibvar)) {
        result_dt <- result_dt[, c("Domain", "Direct_Head_Count", 
            "EBP_Head_Count", "HT_Head_Count_CV", "DesignEffect_CV", 
            "EBP_Head_Count_CV")]
    }
    else {
        result_dt <- result_dt[, c("Domain", "Direct_Head_Count", 
            "EBP_Head_Count", "HT_Head_Count_CV", "CB_Head_Count_CV", 
            "DesignEffect_CV", "EBP_Head_Count_CV")]
    }
    return(result_dt)
}
ebp_normalityfit <-
function (model) 
{
    rsq_model <- model$model
    rsq_model$call$fixed <- model$fixed
    rsq <- suppressWarnings(MuMIn::r.squaredGLMM(rsq_model))
    if (is.matrix(rsq)) {
        r_marginal <- rsq[1, 1]
        r_conditional <- rsq[1, 2]
    }
    else {
        r_marginal <- rsq[1]
        r_conditional <- rsq[2]
    }
    skewness_res <- moments::skewness(residuals(model$model, 
        level = 0, type = "pearson"))
    kurtosis_res <- moments::kurtosis(residuals(model$model, 
        level = 0, type = "pearson"))
    skewness_ran <- moments::skewness(ranef(model$model)$"(Intercept)")
    kurtosis_ran <- moments::kurtosis(ranef(model$model)$"(Intercept)")
    df <- data.frame(indicator = c("rsq_marginal", "rsq_conditional", 
        "epsilon_skewness", "epsilon_kurtosis", "random_skewness", 
        "random_kurtosis"), value = c(r_marginal, r_conditional, 
        skewness_res, kurtosis_res, skewness_ran, kurtosis_ran))
    rownames(df) <- NULL
    return(df)
}
ebp_report_byrank <-
function (model, pop_data, pop_domains, pop_weights = NULL, byrank_indicator = "count", 
    number_to_list = NULL, head = TRUE, indicator = "Head_Count") 
{
    pop_data <- pop_data[, c(pop_domains, pop_weights)]
    result_dt <- tapply(X = pop_data[[pop_weights]], INDEX = pop_data[[pop_domains]], 
        FUN = sum, na.rm = TRUE)
    result_dt <- as.data.frame(result_dt)
    result_dt <- data.frame(domain = rownames(result_dt), population = result_dt[[1]])
    pop_data[[pop_domains]] <- as.character(pop_data[[pop_domains]])
    result_dt <- merge(x = result_dt, y = model$ind[, c("Domain", 
        indicator)], by.x = "domain", by.y = "Domain")
    result_dt$poor_count <- result_dt[, indicator] * result_dt$population
    if (byrank_indicator == "count") {
        result_dt <- result_dt[order(-result_dt$poor_count), 
            ]
    }
    else {
        result_dt <- result_dt[order(-result_dt[, indicator]), 
            ]
    }
    if (is.null(number_to_list)) {
        number_to_list <- nrow(result_dt)
    }
    if (head == TRUE) {
        result_dt <- head(result_dt, number_to_list)
    }
    else if (head == FALSE) {
        result_dt <- tail(result_dt, number_to_list)
    }
    return(result_dt)
}
ebp_reportcoef_table <-
function (model, decimals = 3) 
{
    options(scipen = 999)
    varname_dt <- as.data.frame(rownames(coef(summary(model$model))))
    colnames(varname_dt) <- "Variable"
    coef_dt <- as.data.frame(coef(summary(model$model)))
    if (!is.null(model$call$weights_type)) {
        if (model$call$weights_type == "Guadarrama" | model$call$weights_type == 
            "hybrid") {
            updated_betas <- as.data.frame(model$model_par$betas)
            coef_dt[, 1] <- updated_betas
        }
    }
    coef_dt <- cbind(varname_dt, coef_dt)
    coef_dt$Sig <- ifelse(coef_dt$`p-value` < 0.001, "***", ifelse(coef_dt$`p-value` < 
        0.050000000000000003 & coef_dt$`p-value` >= 0.001, "**", 
        ifelse(coef_dt$`p-value` < 0.01 & coef_dt$`p-value` >= 
            0.050000000000000003, "*", "")))
    coef_dt$Value <- ifelse(coef_dt$Value < abs(0.00049999989999999998), 
        signif(coef_dt$Value, 2), specify_decimal(coef_dt$Value, 
            decimals))
    coef_dt$StdError <- ifelse(coef_dt$Std.Error < abs(0.00049999989999999998), 
        signif(coef_dt$Std.Error, 2), specify_decimal(coef_dt$Std.Error, 
            decimals))
    if (!is.null(model$call$weights_type)) {
        if (model$call$weights_type != "Guadarrama" & model$call$weights_type != 
            "hybrid") {
            coef_dt$Value <- paste0(coef_dt$Value, coef_dt$Sig)
        }
    }
    colnames(coef_dt)[colnames(coef_dt) %in% c("Value", "StdError")] <- c("coeff", 
        "std_error")
    rownames(coef_dt) <- seq(nrow(coef_dt))
    if (!is.null(model$call$weights_type)) {
        if (model$call$weights_type != "Guadarrama" & model$call$weights_type != 
            "hybrid") {
            return(coef_dt[, c("Variable", "coeff", "std_error")])
        }
        else {
            return(coef_dt[, c("Variable", "coeff")])
        }
    }
    else {
        return(coef_dt[, c("Variable", "coeff")])
    }
}
ebp_reportdescriptives <-
function (model, direct, pop_data, pop_domains, smp_data, threshold = NULL, 
    weights = NULL, pop_weights = NULL, CV_level, indicator = "Head_Count") 
{
    if (is.null(threshold)) {
        threshold <- 0.59999999999999998 * median(model$framework$smp_data[[paste(model$fixed[2])]])
        message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is\n                          automatically set to 60% of the median of the\n                          dependent variable and equals ", 
            threshold)))
    }
    hh_varlist <- colnames(model$framework$smp_data)
    if ("benchmark_weights" %in% hh_varlist) {
        hh_varlist <- hh_varlist[-which(hh_varlist == "benchmark_weights")]
    }
    pop_varlist <- hh_varlist[!(hh_varlist %in% c(paste(model$fixed[2]), 
        weights))]
    smp_df <- smp_data[complete.cases(smp_data[, hh_varlist]), 
        c(hh_varlist, CV_level, weights)]
    pop_df <- pop_data[complete.cases(pop_data[, pop_varlist]), 
        c(pop_varlist, CV_level, pop_weights)]
    colnames(model$MSE)[-1] <- paste0("MSE_", colnames(model$MSE)[-1])
    df <- merge(x = model$MSE[, c("Domain", paste("MSE_", indicator, 
        sep = ""))], y = model$ind[, c("Domain", indicator)], 
        by = "Domain")
    add_df <- data.frame(Domain = names(tapply(smp_df[[weights]], 
        smp_df[[model$framework$smp_domains]], sum, na.rm = TRUE)), 
        weights = tapply(smp_df[[weights]], smp_df[[model$framework$smp_domains]], 
            sum, na.rm = TRUE))
    df <- merge(x = df, y = add_df, by = "Domain")
    add_df <- data.frame(Domain = names(tapply(pop_df[[pop_weights]], 
        pop_df[[pop_domains]], sum, na.rm = TRUE)), pop_weights = tapply(pop_df[[pop_weights]], 
        pop_df[[pop_domains]], sum, na.rm = TRUE))
    df <- merge(x = df, y = add_df, by = "Domain")
    pop_df$Domain <- pop_df[[pop_domains]]
    add_df <- unique(pop_df[, c("Domain", CV_level)])
    df <- merge(x = df, y = add_df[, c("Domain", CV_level)], 
        by = "Domain")
    df$CV <- df[, paste("MSE_", indicator, sep = "")]/df[, indicator]
    naivevar_dt <- direct
    naivevar_dt$MSE$Head_Count_bench <- naivevar_dt$MSE$Head_Count
    naivevar_dt$ind$Head_Count_bench <- naivevar_dt$ind$Head_Count
    naivevar_dt$ind[, paste("Direct_", indicator, "_CV", sep = "")] <- sqrt(naivevar_dt$MSE[, 
        indicator])/naivevar_dt$ind[, indicator]
    add_df <- data.frame(unique(df[[CV_level]]))
    colnames(add_df) <- CV_level
    add_df$sum_weights <- tapply(X = df$weights, INDEX = df[[CV_level]], 
        FUN = sum, na.rm = TRUE)
    add_df$sum_pop_weights <- tapply(X = df$pop_weights, INDEX = df[[CV_level]], 
        FUN = sum, na.rm = TRUE)
    df <- merge(x = df, y = add_df, by = CV_level)
    povrate <- weighted.mean(x = df[, indicator], w = df$weights, 
        na.rm = TRUE)
    df$weights <- df$weights/df$sum_weights
    df$pop_weights <- df$pop_weights/df$sum_pop_weights
    df <- merge(x = df, y = naivevar_dt$ind[, c("Domain", paste("Direct_", 
        indicator, "_CV", sep = ""))], by = "Domain")
    cv_df <- data.frame(indicator = paste0("CV for Area: ", unique(df[[CV_level]])), 
        ebp_cv = tapply(X = df$CV * df$pop_weights, INDEX = df[[CV_level]], 
            FUN = sum, na.rm = TRUE), direct_cv = tapply(X = df[, 
            paste("Direct_", indicator, "_CV", sep = "")] * df$weights, 
            INDEX = df[[CV_level]], FUN = sum, na.rm = TRUE))
    basic_df <- data.frame(indicator = c("Number of Units", "Number of Regions", 
        "Number of Target Areas"), census = c(model$framework$N_pop, 
        length(unique(pop_df[[CV_level]][is.na(pop_df[[CV_level]]) == 
            FALSE])), length(unique(pop_df[[pop_domains]][is.na(pop_df[[model$framework$smp_domains]]) == 
            FALSE]))), survey = c(model$framework$N_smp, length(unique(smp_df[[CV_level]][is.na(smp_df[[CV_level]]) == 
        FALSE])), length(unique(smp_df[[model$framework$smp_domains]][is.na(smp_df[[model$framework$smp_domains]]) == 
        FALSE]))))
    basic_df$census <- as.integer(basic_df$census)
    basic_df$survey <- as.integer(basic_df$survey)
    smp_data$poor <- ifelse(model$framework$smp_data[[paste(model$fixed[2])]] < 
        threshold, 1, 0)
    smp_data[[weights]] <- smp_data[[weights]]/sum(smp_data[[weights]], 
        na.rm = TRUE)
    pov_df <- data.frame(indicator = c("National Poverty Rate", 
        "National Poverty Line"), model = c(povrate, threshold), 
        survey = c(sum(smp_data$poor * smp_data[[weights]]), 
            threshold))
    row.names(cv_df) <- NULL
    return(list(cv_table = cv_df, basicinfo_df = basic_df, poverty_df = format(pov_df, 
        scientific = FALSE)))
}
ebp_test_means <-
function (varlist, smp_data, pop_data, weights = NULL, pop_weights = NULL) 
{
    if (is.null(weights)) {
        smp_data$weights <- rep(1, nrow(smp_data))
        weights <- "weights"
    }
    if (is.null(pop_weights)) {
        pop_data$pop_weights <- rep(1, nrow(pop_data))
        pop_weights <- "pop_weights"
    }
    smp_df <- smp_data[complete.cases(smp_data[, c(varlist, weights)]), 
        c(varlist, weights)]
    pop_df <- pop_data[complete.cases(pop_data[, c(varlist, pop_weights)]), 
        c(varlist, pop_weights)]
    smp_df <- data.frame(lapply(smp_df, as.numeric))
    pop_df <- data.frame(lapply(pop_df, as.numeric))
    smp_means_df <- data.frame(smp_means = apply(X = smp_df[, 
        varlist], MARGIN = 2, FUN = weighted.mean, w = smp_df[[weights]]), 
        smp_sd = apply(X = smp_df[, varlist], MARGIN = 2, FUN = weighted.sd, 
            w = smp_df[[weights]]), variable = varlist)
    pop_means_df <- data.frame(pop_means = apply(X = pop_df[, 
        varlist], MARGIN = 2, FUN = weighted.mean, w = pop_df[[pop_weights]]), 
        pop_sd = apply(X = pop_df[, varlist], MARGIN = 2, FUN = weighted.sd, 
            w = pop_df[[pop_weights]]), variable = varlist)
    means_df <- merge(smp_means_df, pop_means_df, by = "variable")
    means_df$diff_sd <- sqrt((means_df$smp_sd)^2 + (means_df$pop_sd)^2)
    means_df$diff <- means_df$pop_means - means_df$smp_means
    means_df$zscore <- means_df$diff/means_df$diff_sd
    means_df$pvalue <- 2 * (1 - pnorm(abs(means_df$zscore)))
    return(means_df[, c("variable", "smp_means", "pop_means", 
        "diff", "pvalue")])
}
ell <-
function (fixed, alpha = NULL, pop_data, pop_domains, pop_subdomains = NULL, 
    smp_data, smp_domains, smp_subdomains = NULL, L = 100, threshold = NULL, 
    transformation = "log.shift", interval = "default", seed = 123, 
    custom_indicator = NULL, na.rm = FALSE, weights = NULL, weights_type = NULL, 
    pop_weights = NULL, aggregate_to = NULL, benchmark = NULL, 
    benchmark_type = "ratio", benchmark_level = NULL, benchmark_weights = NULL, 
    rescale_weights = FALSE, random_method = NULL, Ydump = NULL, 
    errors = "normal", model_parameters = "variable", indicators = NULL) 
{
    start.time <- Sys.time()
    ebp_check1(fixed = fixed, pop_data = pop_data, pop_domains = pop_domains, 
        smp_data = smp_data, smp_domains = smp_domains, L = L)
    ebp_check2(threshold = threshold, transformation = transformation, 
        interval = interval, MSE = F, boot_type = "parametric", 
        B = 50, L = L, custom_indicator = custom_indicator, cpus = 1, 
        seed = seed, na.rm = na.rm, weights = weights, pop_weights = pop_weights, 
        weights_type = weights_type, benchmark = benchmark, benchmark_type = benchmark_type, 
        benchmark_level = benchmark_level, benchmark_weights = benchmark_weights, 
        MSE_pop_weights = NULL)
    if (!is.null(alpha) & transformation != "log" & transformation != 
        "log.shift" & transformation != "no") {
        stop(strwrap(prefix = " ", initial = "", "Must use log or log shift transformation when using alpha model."))
    }
    call <- match.call()
    if (inherits(call$fixed, "name")) {
        call$fixed <- fixed
    }
    set.seed(seed)
    if (is.null(benchmark_weights) & !is.null(weights)) {
        benchmark_weights <- weights
    }
    framework <- framework_ell(pop_data = pop_data, pop_domains = pop_domains, 
        pop_subdomains = pop_subdomains, smp_data = smp_data, 
        smp_domains = smp_domains, smp_subdomains = smp_subdomains, 
        aggregate_to = aggregate_to, custom_indicator = custom_indicator, 
        fixed = fixed, alpha = alpha, threshold = threshold, 
        na.rm = na.rm, weights = weights, pop_weights = pop_weights, 
        benchmark_level = benchmark_level, benchmark_weights = benchmark_weights, 
        rescale_weights = rescale_weights, errors = errors, indicators = indicators, 
        random_method = random_method, model_parameters = model_parameters)
    point_estim <- point_estim_ell(framework = framework, fixed = fixed, 
        alpha = alpha, transformation = transformation, interval = interval, 
        L = L, keep_data = TRUE, Ydump = Ydump)
    if (!is.null(benchmark)) {
        if (is.null(benchmark_level)) {
            point_estim$ind <- benchmark_ebp_national(point_estim = point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type)
        }
        else {
            point_estim$ind <- benchmark_ebp_level(point_estim = point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        }
        if (any(names(point_estim$ind) %in% c("Mean_bench"))) {
            if (any(is.na(point_estim$ind$Mean_bench))) {
                message(strwrap(prefix = " ", initial = "", "Benchmark point estimates for\n                          Mean contain missing values. Please check source data"))
            }
        }
        if (any(names(point_estim$ind) %in% c("Head_Count_bench"))) {
            if (any(is.na(point_estim$ind$Head_Count_bench))) {
                message(strwrap(prefix = " ", initial = "", "Benchmark point estimates for\n                          Head_Count contain missing values. Please check source data"))
            }
            else if (!all(point_estim$ind$Head_Count_bench >= 
                0 & point_estim$ind$Head_Count_bench <= 1)) {
                message(strwrap(prefix = " ", initial = "", "Please note that benchmark point estimates for\n                          Head_Count are outside the expected range [0,1]."))
            }
        }
    }
    ell_out <- list(ind = point_estim$ind, var = point_estim$var, 
        transform_param = point_estim[c("optimal_lambda", "shift_par")], 
        model = point_estim$model, alpha_model = point_estim$alpha_model, 
        model_par = point_estim$model_par, framework = framework[c("N_dom_unobs", 
            "N_dom_smp", "N_smp", "N_pop", "smp_domains", "smp_data", 
            "smp_domains_vec", "pop_domains_vec", "n_smp", "n_pop", 
            "response")], transformation = transformation, method = "reml", 
        fixed = fixed, alpha = alpha, call = call, successful_bootstraps = NULL)
    end.time <- Sys.time()
    print(round(end.time - start.time, 2))
    class(ell_out) <- c("ell", "povmap")
    return(ell_out)
}
errors_gen <-
function (framework, model_par, gen_model) 
{
    epsilon <- rnorm(framework$N_pop, 0, sqrt(model_par$sigmae2est))
    vu <- vector(length = framework$N_pop)
    vu[!framework$obs_dom] <- rep(rnorm(framework$N_dom_unobs, 
        0, sqrt(model_par$sigmau2est)), framework$n_pop[!framework$dist_obs_dom])
    vu[framework$obs_dom] <- rep(rnorm(rep(1, framework$N_dom_smp), 
        0, sqrt(gen_model$sigmav2est)), framework$n_pop[framework$dist_obs_dom])
    eta <- NULL
    if (!is.null(model_par$sigmah2est)) {
        eta <- vector(length = framework$N_pop)
        eta[!framework$obs_subdom] <- rep(rnorm(framework$N_subdom_unobs, 
            0, sqrt(model_par$sigmah2est)), framework$n_pop_subdom[!framework$dist_obs_subdom])
        eta[framework$obs_subdom] <- rep(rnorm(rep(1, framework$N_subdom_smp), 
            0, sqrt(gen_model$sigmai2est)), framework$n_pop_subdom[framework$dist_obs_subdom])
    }
    return(list(epsilon = epsilon, vu = vu, eta = eta))
}
errors_gen_ell <-
function (framework, model_par, alpha_model = NULL) 
{
    if (is.null(alpha_model)) {
        epsilon <- rnorm(framework$N_pop, 0, sqrt(model_par$sigmae2est))
    }
    else {
        epsilon <- rnorm(framework$N_pop, 0, sqrt(alpha_model$sigmae2est_pop))
    }
    vu <- vector(length = framework$N_pop)
    vu <- rep(rnorm(framework$N_dom_pop, 0, sqrt(model_par$sigmau2est)), 
        framework$n_pop)
    return(list(epsilon = epsilon, vu = vu))
}
errors_gen_ell_nonp <-
function (framework, model_par, alpha_model) 
{
    if (!is.null(alpha_model)) {
        epsilon_std <- sample(alpha_model$dev_resid_std, replace = TRUE, 
            size = framework$N_pop)
        epsilon <- as.vector(epsilon_std * alpha_model$sigmae2est_pop^0.5)
        vu <- rep(sample(alpha_model$mean_resid, replace = TRUE, 
            size = framework$N_dom_pop), framework$n_pop)
    }
    else {
        weights <- framework$smp_data[, framework$weights]
        residuals <- model_par$residuals
        mean_resid <- aggregate_weighted_mean(df = residuals, 
            by = list(framework$smp_data[, framework$smp_domains]), 
            w = weights)
        dev_resid <- residuals - rep(mean_resid$V1, framework$n_smp)
        epsilon <- sample(dev_resid, replace = TRUE, size = framework$N_pop)
        vu <- rep(sample(mean_resid$V1, replace = TRUE, size = framework$N_dom_pop), 
            framework$n_pop)
    }
    return(list(epsilon = epsilon, vu = vu))
}
errors_gen_hdp <-
function (framework, model_par, gen_model) 
{
    epsilon <- rep(0, framework$N_pop)
    epsilon[framework$obs_dom] <- rnorm(sum(framework$n_pop[framework$dist_obs_dom]), 
        0, rep(sqrt(model_par$sigmae2est), framework$n_pop[framework$dist_obs_dom]))
    if (framework$N_dom_unobs > 0) {
        epsilon[!framework$obs_dom] <- rnorm(sum(framework$n_pop[!framework$dist_obs_dom]), 
            0, rep(sqrt(model_par$sigma2e.out), framework$n_pop[!framework$dist_obs_dom]))
    }
    vu <- vector(length = framework$N_pop)
    vu[!framework$obs_dom] <- rep(rnorm(framework$N_dom_unobs, 
        0, sqrt(model_par$sigmau2est)), framework$n_pop[!framework$dist_obs_dom])
    vu[framework$obs_dom] <- rep(rnorm(rep(1, framework$N_dom_smp), 
        0, sqrt(gen_model$sigmav2est)), framework$n_pop[framework$dist_obs_dom])
    return(list(epsilon = epsilon, vu = vu))
}
errors_gen_mat <-
function (framework, model_par, gen_model, L) 
{
    epsilon <- matrix(rnorm(framework$N_pop * L, 0, sqrt(model_par$sigmae2est)), 
        ncol = L)
    vu <- matrix(nrow = framework$N_pop, ncol = L)
    vu[!framework$obs_dom, ] <- matrix(rep(rnorm(framework$N_dom_unobs * 
        L, 0, sqrt(model_par$sigmau2est)), rep(framework$n_pop[!framework$dist_obs_dom], 
        L)), ncol = L)
    vu[framework$obs_dom, ] <- matrix(rep(rnorm(framework$N_dom_smp * 
        L, 0, sqrt(gen_model$sigmav2est)), rep(framework$n_pop[framework$dist_obs_dom], 
        L)), ncol = L)
    return(list(epsilon = epsilon, vu = vu))
}
estimators <-
function (object, indicator, MSE, var, CV, ...) 
UseMethod("estimators")
estimators.povmap <-
function (object, indicator = "all", MSE = FALSE, var = FALSE, 
    CV = FALSE, ...) 
{
    estimators_check(object = object, indicator = indicator, 
        MSE = MSE, var = var, CV = CV)
    all_ind <- point_povmap(object = object, indicator = indicator)
    selected <- colnames(all_ind$ind)[-1]
    if (MSE == TRUE || var == TRUE || CV == TRUE) {
        all_precisions <- mse_povmap(object = object, indicator = indicator, 
            CV = TRUE)
        if (inherits(object, "ell")) {
            suffix <- "_Var"
        }
        else {
            suffix <- "_MSE"
        }
        colnames(all_precisions$ind) <- paste0(colnames(all_precisions$ind), 
            suffix)
        colnames(all_precisions$ind_cv) <- paste0(colnames(all_precisions$ind_cv), 
            "_CV")
        combined <- data.frame(all_ind$ind, all_precisions$ind, 
            all_precisions$ind_cv)
        endings <- c("", suffix, "_CV")[c(TRUE, (MSE | var), 
            CV)]
        combined <- combined[, c("Domain", paste0(rep(selected, 
            each = length(endings)), endings))]
    }
    else {
        combined <- all_ind$ind
    }
    estimators_povmap <- list(ind = combined, ind_name = all_ind$ind_name)
    class(estimators_povmap) <- "estimators.povmap"
    return(estimators_povmap)
}
estimators_check <-
function (object, indicator, MSE, var, CV) 
{
    if (is.null(object$MSE) && is.null(object$var) & (MSE == 
        TRUE || var == TRUE || CV == TRUE)) {
        stop(strwrap(prefix = " ", initial = "", "No MSE estimates in povmap object: arguments MSE and CV have to\n                 be FALSE or a new povmap object with variance/MSE needs to be\n                 generated."))
    }
    if (!(inherits(MSE, "logical") && length(MSE) == 1)) {
        stop("MSE must be a logical value. Set MSE to TRUE or FALSE.")
    }
    if (!(inherits(CV, "logical") && length(CV) == 1)) {
        stop("CV must be a logical value. Set CV to TRUE or FALSE.")
    }
    if (inherits(object, "fh")) {
        if (is.null(indicator) || !all(indicator == "all" | indicator == 
            "All" | indicator == "FH" | indicator == "FH_Bench" | 
            indicator == "Direct")) {
            stop(strwrap(prefix = " ", initial = "", paste0("The argument indicator is set to ", 
                indicator, ".\n                   The argument only allows to be set to all, FH, Direct or\n                   FH_Bench (if benchmark function is used before).")))
        }
    }
    else {
        if (is.null(indicator) || !all(indicator == "all" | indicator == 
            "All" | indicator == "Quantiles" | indicator == "quantiles" | 
            indicator == "Poverty" | indicator == "poverty" | 
            indicator == "Inequality" | indicator == "inequality" | 
            indicator == "Custom" | indicator == "custom" | indicator %in% 
            names(object$ind[-1]))) {
            stop(strwrap(prefix = " ", initial = "", paste0("The argument indicator is set to ", 
                indicator, ".\n                          The argument only allows to be set to all, a name of\n                          estimated indicators or indicator groups as described\n                          in help(estimators.emdi).")))
        }
    }
}
expected_gini <-
function (mu = mu, var = var, lambda = lambda, transformation = transformation, 
    popwt = popwt, pop_domains = pop_domains) 
{
    expected_gini <- NULL
    if (transformation == "log" | transformation == "log.shift") {
        if (is.null(lambda)) {
            lambda <- 0
        }
        Y = exp(mu + 0.5 * var)
        data <- c(mu, popwt, var)
        sumj <- ave(x = data, by = pop_domains, FUN = calculate_sumj)[1:length(mu)]
        Ybar <- ave(x = Y * popwt, group = pop_domains, FUN = sum)/ave(x = popwt, 
            group = pop_domains, FUN = sum)
        expected_gini <- 2 * (Y/Ybar) * popwt * sumj
        if (lambda != 0) 
            expected_gini <- expected_gini * Ybar/(Ybar - lambda)
    }
    return(expected_gini)
}
expected_head_count <-
function (mu = mu, threshold = threshold, var = var, transformation = transformation, 
    lambda = lambda, shift = shift) 
{
    transformed_threshold <- transformation(y = threshold, transformation = transformation, 
        lambda = lambda, shift = shift)
    expected_head_count <- pnorm(transformed_threshold$y - mu, 
        sd = var^0.5)
    return(expected_head_count)
}
expected_untransformed_mean <-
function (mu = mu, var = var, transformation = transformation, 
    lambda = lambda) 
{
    if (transformation == "no") {
        expected_mean <- mu
    }
    else if (transformation == "arcsin") {
        term1 <- arcsin_transform_back(mu)
        dy2dx <- -2 * sin(mu)^2 + 2 * cos(mu)^2
        expected_mean <- term1 + 0.5 * dy2dx * (var) - (1/24) * 
            -4 * dy2dx * 3 * (var^2) + (1/720) * -16 * dy2dx * 
            (var^3) + (1/40320) * -64 * dy2dx * (var^4)
    }
    else if (transformation == "log") {
        expected_mean <- exp(mu + (0.5 * var))
    }
    else if (transformation == "log.shift") {
        expected_mean <- exp(mu + (0.5 * var)) - lambda
    }
    return(expected_mean)
}
extractAIC.fh <-
function (fit, ...) 
{
    throw_class_error(fit, "fh")
    if (!is.null(fit$model$model_select$AIC)) {
        message(strwrap(prefix = " ", initial = "", paste0("Estimation approach used is ", 
            fit$method$method, ": ", round(fit$model$model_select$AIC, 
                5))))
        invisible(fit$model$model_select$AIC)
    }
    else {
        message(strwrap(prefix = " ", initial = "", paste0("No AIC is returned for estimation approach ", 
            fit$method$method, ".")))
    }
}
family.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    gaussian(link = "identity")
}
family.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    gaussian(link = "identity")
}
fh <-
function (fixed, vardir, combined_data, domains = NULL, method = "reml", 
    interval = NULL, k = 1.345, mult_constant = 1, transformation = "no", 
    backtransformation = NULL, eff_smpsize = NULL, correlation = "no", 
    corMatrix = NULL, Ci = NULL, tol = 0.0001, maxit = 100, MSE = FALSE, 
    mse_type = "analytical", B = c(50, 0), seed = 123) 
{
    fh_combinations(fixed = fixed, vardir = vardir, combined_data = combined_data, 
        domains = domains, method = method, interval = interval, 
        k = k, mult_constant = mult_constant, transformation = transformation, 
        backtransformation = backtransformation, eff_smpsize = eff_smpsize, 
        correlation = correlation, corMatrix = corMatrix, Ci = Ci, 
        tol = tol, maxit = maxit, MSE = MSE, mse_type = mse_type, 
        B = B, seed = seed)
    fh_check(fixed = fixed, vardir = vardir, combined_data = combined_data, 
        domains = domains, method = method, interval = interval, 
        k = k, mult_constant = mult_constant, transformation = transformation, 
        backtransformation = backtransformation, eff_smpsize = eff_smpsize, 
        correlation = correlation, corMatrix = corMatrix, Ci = Ci, 
        tol = tol, maxit = maxit, MSE = MSE, mse_type = mse_type, 
        B = B, seed = seed)
    call <- match.call()
    if (!is.null(seed)) {
        set.seed(seed)
    }
    framework <- framework_FH(combined_data = combined_data, 
        fixed = fixed, vardir = vardir, domains = domains, transformation = transformation, 
        eff_smpsize = eff_smpsize, correlation = correlation, 
        corMatrix = corMatrix, Ci = Ci, tol = tol, maxit = maxit)
    if (is.null(interval)) {
        upper <- var(framework$direct)
        interval <- c(0, upper)
    }
    if (length(B) == 1) {
        B <- c(B, 0)
    }
    if (!(method == "reblup" || method == "reblupbc")) {
        sigmau2 <- wrapper_estsigmau2(framework = framework, 
            method = method, interval = interval)
        if (method != "me") {
            if (correlation == "no") {
                eblup <- eblup_FH(framework = framework, sigmau2 = sigmau2, 
                  combined_data = combined_data)
                Gamma <- data.frame(Domain = framework$combined_data[[framework$domains]])
                Gamma$Gamma <- NA
                Gamma$Gamma[framework$obs_dom == TRUE] <- as.numeric(eblup$gamma)
                criteria <- model_select(framework = framework, 
                  sigmau2 = sigmau2, method = method, interval = interval, 
                  eblup = eblup, B = B[2], vardir = vardir, transformation = transformation, 
                  combined_data = framework$combined_data)
            }
            if ((method == "ml" || method == "reml") && correlation == 
                "spatial") {
                eblup <- eblup_SFH(framework = framework, sigmau2 = sigmau2, 
                  combined_data = combined_data)
                criteria <- model_select(framework = framework, 
                  sigmau2 = sigmau2, method = method, interval = interval, 
                  eblup = eblup, B = B[2], vardir = vardir, transformation = transformation, 
                  combined_data = framework$combined_data)
            }
        }
        else if (method == "me") {
            eblup <- eblup_YL(framework = framework, sigmau2 = sigmau2, 
                combined_data = combined_data)
            Gamma <- data.frame(Domain = framework$combined_data[[framework$domains]])
            Gamma$Gamma <- NA
            Gamma$Gamma[framework$obs_dom == TRUE] <- as.numeric(eblup$gamma)
            criteria <- model_select(framework = framework, sigmau2 = sigmau2, 
                method = method, interval = interval, eblup = eblup, 
                B = B[2], vardir = vardir, transformation = transformation, 
                combined_data = framework$combined_data)
        }
        if (transformation == "no") {
            if (MSE == TRUE) {
                mse_data <- wrapper_MSE(framework = framework, 
                  combined_data = framework$combined_data, sigmau2 = sigmau2, 
                  vardir = vardir, Ci = Ci, eblup = eblup, transformation = transformation, 
                  method = method, interval = interval, mse_type = mse_type, 
                  B = B[1])
                MSE <- mse_data$mse_data
                MSE_method <- mse_data$MSE_method
                if (mse_type == "spatialnonparboot" || mse_type == 
                  "spatialnonparbootbc" || mse_type == "spatialparboot" || 
                  mse_type == "spatialparbootbc") {
                  successful_bootstraps <- mse_data$successful_bootstraps
                }
            }
            else {
                MSE <- NULL
                MSE_method <- "no mse estimated"
            }
            if (method != "me") {
                if (!is.null(MSE) && (mse_type == "spatialnonparboot" || 
                  mse_type == "spatialnonparbootbc" || mse_type == 
                  "spatialparboot" || mse_type == "spatialparbootbc")) {
                  sigmau2 <- data.frame(correlation = sigmau2$rho, 
                    variance = sigmau2$sigmau2, convergence = sigmau2$convergence)
                  row.names(sigmau2) <- ""
                  out <- list(ind = eblup$eblup_data, MSE = MSE, 
                    transform_param = NULL, model = list(coefficients = eblup$coefficients, 
                      variance = sigmau2, random_effects = eblup$random_effects, 
                      fitted = eblup$fitted, real_residuals = eblup$real_res, 
                      std_real_residuals = eblup$std_real_res, 
                      model_select = criteria, correlation = correlation, 
                      seed = seed, beta_vcov = eblup$beta_vcov), 
                    framework = framework[c("direct", "vardir", 
                      "N_dom_smp", "N_dom_unobs", "combined_data", 
                      "domains")], transformation = list(transformation = transformation, 
                      backtransformation = backtransformation), 
                    method = list(method = method, MSE_method = MSE_method), 
                    fixed = fixed, call = call, successful_bootstraps = successful_bootstraps)
                }
                else if (correlation == "spatial") {
                  sigmau2 <- data.frame(correlation = sigmau2$rho, 
                    variance = sigmau2$sigmau2, convergence = sigmau2$convergence)
                  row.names(sigmau2) <- ""
                  out <- list(ind = eblup$eblup_data, MSE = MSE, 
                    transform_param = NULL, model = list(coefficients = eblup$coefficients, 
                      variance = sigmau2, random_effects = eblup$random_effects, 
                      fitted = eblup$fitted, real_residuals = eblup$real_res, 
                      std_real_residuals = eblup$std_real_res, 
                      model_select = criteria, correlation = correlation, 
                      seed = seed, beta_vcov = eblup$beta_vcov), 
                    framework = framework[c("direct", "vardir", 
                      "N_dom_smp", "N_dom_unobs", "combined_data", 
                      "domains", "W")], transformation = list(transformation = transformation, 
                      backtransformation = backtransformation), 
                    method = list(method = method, MSE_method = MSE_method), 
                    fixed = fixed, call = call, successful_bootstraps = NULL)
                }
                else {
                  if ((isTRUE(all.equal(round(sigmau2, 3), interval[1]))) || 
                    (isTRUE(all.equal(round(sigmau2, 3), interval[2])))) {
                    warning(strwrap(prefix = " ", initial = "", 
                      "The estimate of the variance of the random effects\n                            falls at the interval limit. It is recommended to\n                            choose a larger interval for the estimation of the\n                            variance of the random effects (specify interval\n                            input argument)."))
                  }
                  out <- list(ind = eblup$eblup_data, MSE = MSE, 
                    transform_param = NULL, model = list(coefficients = eblup$coefficients, 
                      variance = sigmau2, random_effects = eblup$random_effects, 
                      fitted = eblup$fitted, real_residuals = eblup$real_res, 
                      std_real_residuals = eblup$std_real_res, 
                      gamma = Gamma, model_select = criteria, 
                      correlation = correlation, seed = seed, 
                      beta_vcov = eblup$beta_vcov), framework = framework[c("direct", 
                      "vardir", "N_dom_smp", "N_dom_unobs", "combined_data", 
                      "domains")], transformation = list(transformation = transformation, 
                      backtransformation = backtransformation), 
                    method = list(method = method, MSE_method = MSE_method), 
                    fixed = fixed, call = call, successful_bootstraps = NULL)
                }
            }
            else if (method == "me") {
                out <- list(ind = eblup$eblup_data, MSE = MSE, 
                  transform_param = NULL, model = list(coefficients = eblup$coefficients, 
                    variance = sigmau2$sigmau_YL, random_effects = as.matrix(eblup$random_effects), 
                    fitted = eblup$fitted, real_residuals = eblup$real_res, 
                    std_real_residuals = eblup$std_real_res, 
                    gamma = Gamma, model_select = criteria, correlation = correlation, 
                    beta_vcov = eblup$beta_vcov), framework = framework[c("direct", 
                    "vardir", "N_dom_smp", "N_dom_unobs", "combined_data", 
                    "domains", "Ci")], transformation = list(transformation = transformation, 
                    backtransformation = backtransformation), 
                  method = list(method = method, MSE_method = MSE_method), 
                  fixed = fixed, call = call, successful_bootstraps = NULL)
            }
        }
        else if (transformation != "no") {
            if ((isTRUE(all.equal(sigmau2, interval[1]))) || 
                (isTRUE(all.equal(sigmau2, interval[2])))) {
                warning(strwrap(prefix = " ", initial = "", "The estimate of the variance of the random effects\n                        falls at the interval limit. It is recommended to\n                        choose a larger interval for the estimation of the\n                        variance of the random effects (specify interval input\n                        argument)."))
            }
            Gamma <- data.frame(Domain = framework$combined_data[[framework$domains]])
            Gamma$Gamma <- NA
            Gamma$Gamma[framework$obs_dom == TRUE] <- as.numeric(eblup$gamma)
            result_data <- backtransformed(framework = framework, 
                sigmau2 = sigmau2, vardir = vardir, eblup = eblup, 
                transformation = transformation, backtransformation = backtransformation, 
                combined_data = framework$combined_data, method = method, 
                interval = interval, MSE = MSE, mse_type = mse_type, 
                B = B[1])
            out <- list(ind = result_data$eblup_data, MSE = result_data$mse_data, 
                transform_param = NULL, model = list(coefficients = eblup$coefficients, 
                  variance = sigmau2, random_effects = as.matrix(eblup$random_effects[, 
                    1]), fitted = eblup$fitted, real_residuals = eblup$real_res[, 
                    1], std_real_residuals = eblup$std_real_res[, 
                    1], gamma = Gamma, model_select = criteria, 
                  correlation = correlation, seed = seed, beta_vcov = eblup$beta_vcov), 
                framework = framework[c("direct", "vardir", "N_dom_smp", 
                  "N_dom_unobs", "combined_data", "domains")], 
                transformation = list(transformation = transformation, 
                  backtransformation = backtransformation), method = list(method = method, 
                  MSE_method = result_data$MSE_method), fixed = fixed, 
                call = call, successful_bootstraps = NULL)
        }
    }
    else if (method == "reblup" || method == "reblupbc") {
        eblup <- eblup_robust(framework = framework, vardir = vardir, 
            combined_data = combined_data, method = method, k = k, 
            mult_constant = mult_constant, correlation = correlation, 
            corMatrix = corMatrix)
        if (MSE == TRUE) {
            mse_data <- wrapper_MSE(framework = framework, combined_data = framework$combined_data, 
                vardir = vardir, eblup = eblup, mse_type = mse_type, 
                method = method, B = B[1])
            MSE <- mse_data$mse_data
            MSE_method <- mse_data$MSE_method
        }
        else {
            MSE <- NULL
            MSE_method <- "no mse estimated"
        }
        if (correlation == "spatial") {
            sigmau2 <- data.frame(correlation = unname(eblup$variance[1]), 
                variance = unname(eblup$variance[2]))
            row.names(sigmau2) <- ""
        }
        else if (correlation == "no") {
            sigmau2 <- unname(eblup$variance[1])
        }
        out <- list(ind = eblup$eblup_data, MSE = MSE, transform_param = NULL, 
            model = list(coefficients = eblup$coefficients, variance = sigmau2, 
                random_effects = as.matrix(eblup$random_effects), 
                fitted = eblup$fitted, real_residuals = as.matrix(eblup$real_res), 
                std_real_residuals = as.matrix(eblup$std_real_res), 
                correlation = correlation, k = k, mult_constant = mult_constant, 
                seed = seed, beta_vcov = eblup$beta_vcov), framework = framework[c("direct", 
                "vardir", "N_dom_smp", "N_dom_unobs", "combined_data", 
                "domains", "W")], transformation = list(transformation = transformation, 
                backtransformation = backtransformation), method = list(method = method, 
                MSE_method = MSE_method), fixed = fixed, call = call, 
            successful_bootstraps = NULL)
    }
    class(out) <- c("fh", "povmap")
    return(out)
}
fh_check <-
function (fixed, vardir, combined_data, domains, method, interval, 
    k, mult_constant, transformation, backtransformation, eff_smpsize, 
    correlation, corMatrix, Ci, tol, maxit, MSE, mse_type, B, 
    seed) 
{
    if (is.null(fixed) || !inherits(fixed, "formula")) {
        stop("Fixed must be a formula object. See also help(fh).")
    }
    if (!all(!is.na(combined_data[all.vars(fixed)[-1]]))) {
        stop(paste0("The auxiliary variables must not contain NAs."))
    }
    if (is.null(vardir) || !(vardir %in% colnames(combined_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The sampling variances variable ", 
            vardir, " is not\n                 contained in combined_data. Please provide valid variable name\n                 for the sampling variances.")))
    }
    if (is.null(combined_data) || !is.data.frame(combined_data)) {
        stop(strwrap(prefix = " ", initial = "", "combined_data must be a data frame containing the direct\n                 estimates, the sampling variances, the explanatory variables\n                 and the domains. If the arcsin transformation in combination\n                 with bootstrap mse is chosen, also eff_smpsize needs to be\n                 included. See also help(fh)."))
    }
    if (!is.null(domains) && (!is.character(domains) || length(domains) != 
        1 || !(domains %in% colnames(combined_data)))) {
        stop(strwrap(prefix = " ", initial = "", "domains must be a vector of length 1 and of class character\n                 specifying the variable name of a numeric or factor variable\n                 indicating domains in the combined_data dataframe. See also\n                 help(fh)."))
    }
    if (is.null(method) || !(method == "reml" || method == "amrl" || 
        method == "amrl_yl" || method == "ampl" || method == 
        "ampl_yl" || method == "ml" || method == "me" || method == 
        "reblup" || method == "reblupbc")) {
        stop(strwrap(prefix = " ", initial = "", "The nine options for method are ''reml'', ''amrl'',\n                 ''amrl_yl'', ''ampl'', ''ampl_yl'', ''ml'', ''me'',''reblup''\n                 or ''reblupbc''."))
    }
    if (!is.null(interval) && (length(interval) != 2 || !is.vector(interval, 
        mode = "numeric") || !(interval[1] < interval[2]))) {
        stop(strwrap(prefix = " ", initial = "", "interval needs to be a numeric vector of length 2\n                 defining a lower and upper limit for the estimation of the\n                 variance of the random effect. The value of the lower limit\n                 needs to be smaller than the upper limit. See also\n                 help(fh)."))
    }
    if (is.null(k) || !(is.numeric(k) && length(k) == 1)) {
        stop("k needs to be a single numeric value. See also help(fh).")
    }
    if (is.null(mult_constant) || !(is.numeric(mult_constant) && 
        length(mult_constant) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "mult_constant needs to be a single numeric value. See also\n                 help(fh)."))
    }
    if (is.null(transformation) || !is.character(transformation) || 
        !(transformation == "arcsin" || transformation == "log" || 
            transformation == "no")) {
        stop(strwrap(prefix = " ", initial = "", "transformation must be a character. The three options are\n                 ''no'', ''log'' or ''arcsin''."))
    }
    if (!is.null(backtransformation) && !(backtransformation == 
        "naive" || backtransformation == "bc_crude" || backtransformation == 
        "bc_sm" || backtransformation == "bc")) {
        stop(strwrap(prefix = " ", initial = "", "The four options for backtransformation are ''bc_crude'',\n                 ''bc_sm'', ''naive'' or ''bc''."))
    }
    if (!is.null(eff_smpsize) && !(eff_smpsize %in% colnames(combined_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The effective sample size variable ", 
            eff_smpsize, " is not contained in combined_data. Please provide valid\n                 variable name for the effective sample size.")))
    }
    if (is.null(correlation) || !(correlation == "no" || correlation == 
        "spatial")) {
        stop("The options for correlation are ''no'' or ''spatial''.")
    }
    if (correlation == "spatial" && (!(is.matrix(corMatrix) || 
        is.data.frame(corMatrix)))) {
        stop(strwrap(prefix = " ", initial = "", "corMatrix must be a data frame or matrix containing the\n                 row-standardised proximity matrix. See also help(fh). A\n                 description how a proximity matrix can be computed can be\n                 found in the vignette."))
    }
    if (correlation == "spatial" && (dim(corMatrix)[1] != dim(corMatrix)[2])) {
        stop(strwrap(prefix = " ", initial = "", "The columns and rows of corMatrix must have the same lengths.\n                 See also help(fh). A description how a proximity matrix can be\n                 computed can be found in the vignette."))
    }
    direct <- makeXY(fixed, combined_data)$y
    if (correlation == "spatial" && (dim(corMatrix)[1] != length(direct))) {
        stop(strwrap(prefix = " ", initial = "", "The columns and rows of corMatrix must have the same lengths\n                 like the number of areas. If out-of-sample areas exist, the\n                 columns and rows of corMatrix must have the same lengths like\n                 the number of in-sample areas. See also help(fh). A description\n                 how a proximity matrix can be computed can be found in the\n                 vignette."))
    }
    if (correlation == "spatial" && (all(corMatrix == 0))) {
        stop(strwrap(prefix = " ", initial = "", "The elements of corMatrix are all equal to 0. No\n                 neighbourhood structure can be identified. It is suggested to\n                 apply a standard Fay-Herriot model."))
    }
    estcoef <- makeXY(formula = fixed, data = combined_data)
    if (method == "me" && !is.null(Ci) && (!(dim(Ci)[1] == dim(estcoef$x)[2]) || 
        !(dim(Ci)[2] == dim(estcoef$x)[2]) || !(dim(Ci)[3] == 
        dim(combined_data)[1]))) {
        stop(strwrap(prefix = " ", initial = "", "Ci must be an array with dimension number of estimated\n                 regression coefficients times number of estimated regression\n                 coefficients times number of areas containing the\n                 variance-covariance matrix of the explanatory variables for\n                 each area. The areas should be sorted like in combined_data.\n                 See also help(fh). For an example how to create the array\n                 please refer to the Vignette."))
    }
    if ((method == "me") && (!is.numeric(tol) || !(is.numeric(tol) && 
        length(tol) == 1))) {
        stop(strwrap(prefix = " ", initial = "", "tol must be a single number determining the tolerance value\n                 for the convergence of weights for the estimation of the\n                 variance of the random effects and the beta coefficients.\n                 See help(fh)."))
    }
    if ((method == "me") && (!is.numeric(maxit) || !(is.numeric(maxit) && 
        length(maxit) == 1))) {
        stop(strwrap(prefix = " ", initial = "", "maxit must be a single number determining the tolerance value\n                 for the convergence of weights for the estimation of the\n                 variance of the random effects and the beta coefficients.\n                 See help(fh)."))
    }
    if (!is.logical(MSE) || length(MSE) != 1) {
        stop(strwrap(prefix = " ", initial = "", "MSE must be a logical value. Set MSE to TRUE or FALSE. The\n                 default is set to FALSE. See also help(fh)."))
    }
    if (MSE == TRUE && (is.null(mse_type) || !(length(mse_type) == 
        1 && (mse_type == "analytical" || mse_type == "boot" || 
        mse_type == "pseudo" || mse_type == "jackknife" || mse_type == 
        "weighted_jackknife" || mse_type == "spatialnonparboot" || 
        mse_type == "spatialnonparbootbc" || mse_type == "spatialparboot" || 
        mse_type == "spatialparbootbc")))) {
        stop(strwrap(prefix = " ", initial = "", "The nine mse types are ''analytical'', ''boot'', ''pseudo'',\n                 ''jackknife'', ''weighted_jackknife'', ''spatialnonparboot'',\n                 ''spatialnonparbootbc'', ''spatialparboot'' or\n                 ''spatialparbootbc''."))
    }
    if (MSE == TRUE && (mse_type == "boot" || mse_type == "spatialparboot" || 
        mse_type == "spatialparbootbc" || mse_type == "spatialnonparboot" || 
        mse_type == "spatialnonparbootbc") && is.null(B)) {
        stop(strwrap(prefix = " ", initial = "", "If MSE is set to TRUE and a bootstrap MSE estimation method\n                 is chosen, the argument B is required and cannot be NULL. See\n                 also help(fh)."))
    }
    if (!(is.numeric(B) && (length(B) == 1 || length(B) == 2))) {
        stop(strwrap(prefix = " ", initial = "", "B needs to be either a single number or a numeric vector of\n                 length 2 defining the number of bootstrap iterations. The\n                 first element defines the number of bootstrap iterations for\n                 the MSE estimation. The second element determines the number\n                 of bootstrap iterations for the information criteria by\n                 Marhuenda et al. (2014). See also help(fh)."))
    }
    if (MSE == TRUE && (mse_type == "boot" || mse_type == "spatialparboot" || 
        mse_type == "spatialparbootbc" || mse_type == "spatialnonparboot" || 
        mse_type == "spatialnonparbootbc") && !(B[1] > 1)) {
        stop(strwrap(prefix = " ", initial = "", "If MSE is set to TRUE and a bootstrap MSE estimation method\n                 is chosen, the number of bootstrap samples (B) needs to be\n                 greater than 1. See also help(fh)."))
    }
    if (!is.null(seed) && (!is.numeric(seed) || !(is.numeric(seed) && 
        length(seed) == 1))) {
        stop(strwrap(prefix = " ", initial = "", "The seed must be a single value, interpreted as an integer,\n                 or NULL See also help(fh)."))
    }
}
fh_combinations <-
function (fixed, vardir, combined_data, domains, method, interval, 
    k, mult_constant, transformation, backtransformation, eff_smpsize, 
    correlation, corMatrix, Ci, tol, maxit, MSE, mse_type, B, 
    seed) 
{
    if (is.null(transformation) || !is.character(transformation) || 
        !(transformation == "arcsin" || transformation == "log" || 
            transformation == "no")) {
        stop(strwrap(prefix = " ", initial = "", "transformation must be a character. The three options are\n                 ''no'',''log'' or ''arcsin''."))
    }
    if ((method == "reml" || method == "ml") && correlation == 
        "no" && transformation == "no" && MSE == TRUE && mse_type != 
        "analytical") {
        stop(strwrap(prefix = " ", initial = "", "For the ''reml'' and ''ml'' variance estimation methods\n                 without incorporating a correlation structure\n                 (correlation = ''no'') and without applying a transformation\n                 (transformation = ''no''), the mse_type must be set to\n                 ''analytical''. See also help(fh)."))
    }
    if ((method == "amrl" || method == "ampl" || method == "amrl_yl" || 
        method == "ampl_yl") && MSE == TRUE && mse_type != "analytical") {
        stop(strwrap(prefix = " ", initial = "", "For the adjusted variance estimation methods, the mse_type\n                 must be set to ''analytical''. See also help(fh)."))
    }
    if ((method == "amrl" || method == "ampl" || method == "amrl_yl" || 
        method == "ampl_yl") && transformation != "no") {
        stop(strwrap(prefix = " ", initial = "", "For the adjusted variance estimation methods, it is not\n                 possible to apply a transformation. Transformation must be\n                 set to ''no''. See also help(fh)."))
    }
    if ((method == "amrl" || method == "ampl" || method == "amrl_yl" || 
        method == "ampl_yl") && correlation != "no") {
        stop(strwrap(prefix = " ", initial = "", "For the adjusted variance estimation methods, it is not\n                 possible to incorporate a correlation structure. Correlation\n                 must be set to ''no''. If correlation is set to ''spatial''\n                 only ''reml'' and ''ml'' variance estimation methods are\n                 allowed. See also help(fh)."))
    }
    if ((method == "me") && (is.null(Ci) || is.null(tol) || is.null(maxit))) {
        stop(strwrap(prefix = " ", initial = "", "For the measurement error model (method = ''me''), the\n                 arguments Ci, tol and maxit are required and cannot be\n                 ''NULL''. See also help(fh)."))
    }
    if ((method == "me") && correlation != "no") {
        stop(strwrap(prefix = " ", initial = "", "For the measurement error model (method = ''me''), it is not\n                 possible to incorporate a correlation structure. Correlation\n                 must be set to ''no''. See also help(fh)."))
    }
    if ((method == "me") && transformation != "no") {
        stop(strwrap(prefix = " ", initial = "", "For the measurement error model (method = ''me''), it is not\n                 possible to apply a transformation. Transformation must be set\n                 to ''no''. See also help(fh)."))
    }
    if ((method == "me") && MSE == TRUE && mse_type != "jackknife") {
        stop(strwrap(prefix = " ", initial = "", "For the measurement error model (method = ''me''), mse_type\n                 must be set to ''jackknife''. See also help(fh)."))
    }
    if ((method == "reblup" || method == "reblupbc") && MSE == 
        TRUE && !(mse_type == "boot" || mse_type == "pseudo")) {
        stop(strwrap(prefix = " ", initial = "", "For the robust estimation methods\n                 (method = ''reblup''/''reblupbc''), possible mse_types are\n                 ''boot'' and ''pseudo''. See also help(fh)."))
    }
    if ((method == "reblup" || method == "reblupbc") && transformation != 
        "no") {
        stop(strwrap(prefix = " ", initial = "", "For the robust estimation methods\n                 (method = ''reblup''/''reblupbc''), it is not possible to\n                 apply a transformation. Transformation must be set to ''no''.\n                 See also help(fh)."))
    }
    if ((method == "reblup" || method == "reblupbc") && (is.null(k) || 
        is.null(tol) || is.null(maxit))) {
        stop(strwrap(prefix = " ", initial = "", "For the robust estimation methods\n                 (method = ''reblup''/''reblupbc''), the arguments k, tol and\n                 maxit are required and cannot be ''NULL''. See also\n                 help(fh)."))
    }
    if ((method == "reblupbc") && is.null(mult_constant)) {
        stop(strwrap(prefix = " ", initial = "", "For the bias corrected robust estimation method\n                 (method = ''reblupbc''), the argument mult_constant is\n                 required and cannot be ''NULL''. See also help(fh)."))
    }
    if ((correlation == "spatial") && (is.null(corMatrix) || 
        is.null(tol) || is.null(maxit))) {
        stop(strwrap(prefix = " ", initial = "", "If correlation is set to ''spatial'' the arguments corMatrix,\n                 tol and maxit are required and cannot be ''NULL''. See also\n                 help(fh)."))
    }
    if ((correlation == "spatial") && (transformation != "no")) {
        stop(strwrap(prefix = " ", initial = "", "If correlation is set to ''spatial'', it is not possible to\n                 apply a transformation. Transformation must be set to ''no''.\n                 See also help(fh)."))
    }
    if ((correlation == "spatial") && method == "reml" && MSE == 
        TRUE && !(mse_type == "analytical" || mse_type == "spatialparboot" || 
        mse_type == "spatialparbootbc" || mse_type == "spatialnonparboot" || 
        mse_type == "spatialnonparbootbc")) {
        stop(strwrap(prefix = " ", initial = "", "If correlation is set to ''spatial'' and ''reml'' variance\n                 estimation method is chosen, possible mse_types are\n                 ''analytical'', ''spatialparboot'', ''spatialparbootbc'',\n                 ''spatialnonparboot'' and ''spatialnonparbootbc''. See also\n                 help(fh)."))
    }
    if ((correlation == "spatial") && method == "ml" && MSE == 
        TRUE && !(mse_type == "analytical" || mse_type == "spatialparboot" || 
        mse_type == "spatialparbootbc")) {
        stop(strwrap(prefix = " ", initial = "", "If correlation is set to ''spatial'' and ''ml'' variance\n                 estimation method is chosen, possible mse_types are\n                 ''analytical'', ''spatialparboot'' and ''spatialparbootbc''.\n                 See also help(fh)."))
    }
    if ((transformation != "no") && is.null(backtransformation)) {
        stop(strwrap(prefix = " ", initial = "", "If a transformation is chosen, the argument\n                 backtransformation is required and cannot be NULL. See also\n                 help(fh)."))
    }
    if ((transformation == "log") && !(backtransformation == 
        "bc_crude" || backtransformation == "bc_sm")) {
        stop(strwrap(prefix = " ", initial = "", "If transformation is set to ''log'', possible\n                 backtransformations are ''bc_crude'' and ''bc_sm''. See also\n                 help(fh)."))
    }
    if ((transformation == "log") && (MSE == TRUE) && mse_type != 
        "analytical") {
        stop(strwrap(prefix = " ", initial = "", "If transformation is set to ''log'', the mse_type must be set\n                 to ''analytical''. See also help(fh)."))
    }
    if ((transformation != "no") && (backtransformation == "bc_sm") && 
        method != "ml") {
        stop(strwrap(prefix = " ", initial = "", "If backtransformation is set to ''bc_sm'', only ''ml''\n                 variance estimation is possible. See also help(fh)."))
    }
    if ((transformation == "arcsin") && is.null(eff_smpsize)) {
        stop(strwrap(prefix = " ", initial = "", "If transformation is set to ''arcsin'', the argument\n                 eff_smpsize is required and cannot be NULL. See also\n                 help(fh)."))
    }
    if ((transformation == "arcsin") && !(backtransformation == 
        "naive" || backtransformation == "bc")) {
        stop(strwrap(prefix = " ", initial = "", "If transformation is set to ''arcsin'', possible\n                 backtransformations are ''naive'' and ''bc''. See also\n                 help(fh)."))
    }
    if ((transformation == "arcsin") && (backtransformation == 
        "naive") && (MSE == TRUE) && !(mse_type == "boot" || 
        mse_type == "jackknife" || mse_type == "weighted_jackknife")) {
        stop(strwrap(prefix = " ", initial = "", "If transformation is set to ''arcsin'' and backtransformation\n                 to ''naive'', the mse_type must be set to ''boot'',\n                 ''jackknife'' or ''weighted_jackknife''. See also help(fh)."))
    }
    if ((transformation == "arcsin") && (backtransformation == 
        "bc") && (MSE == TRUE) && !(mse_type == "boot")) {
        stop(strwrap(prefix = " ", initial = "", "If transformation is set to ''arcsin'' and backtransformation\n                 to ''bc'', the mse_type must be set to ''boot''. See also\n                 help(fh)."))
    }
}
fh_fw_check1 <-
function (fixed, vardir, combined_data, domains, eff_smpsize = NULL, 
    Ci = NULL) 
{
    if (!(domains %in% colnames(combined_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            domains, " is not contained in\n                 combined_data. Please provide valid variable name for\n                        domains.")))
    }
    if (!(vardir %in% colnames(combined_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The sampling variances variable ", 
            vardir, " is not\n                        contained in combined_data. Please provide valid\n                        variable name for vardir.")))
    }
    if (!(eff_smpsize %in% colnames(combined_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The effective sample size variable ", 
            eff_smpsize, "\n                        is not contained in combined_data. Please provide valid\n                        variable name for eff_smpsize.")))
    }
    if (!(as.character(lhs(fixed))) %in% colnames(combined_data)) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            as.character(lhs(fixed)), " is not\n                        contained in combined_data. Please provide valid\n                        variable name for the dependent variable.")))
    }
    mod_vars <- all.vars(fixed)
    mod_vars <- mod_vars[mod_vars != as.character(fixed[2])]
    if (!all(mod_vars %in% colnames(combined_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            mod_vars[which(!(mod_vars %in% colnames(combined_data)))], 
            " is not contained in combined_data. Please provide\n                        valid variables names for the explanatory\n                        variables.")))
    }
    if (!is.numeric(combined_data[[paste(fixed[2])]])) {
        stop(strwrap(prefix = " ", initial = "", paste0(as.character(fixed[2]), 
            " must be the name of a\n                        variable that is a numeric vector.")))
    }
}
fitted.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    fitted(object$model, ...)
}
fitted.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    object$model$fitted
}
fixed.effects.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    object$model$coefficients$fixed
}
fixed.effects.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    fixed_effects <- object$model$coefficients$coefficients
    names(fixed_effects) <- row.names(object$model$coefficients)
    fixed_effects
}
fixef.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    object$model$coefficients$fixed
}
fixef.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    fixed_effects <- object$model$coefficients$coefficients
    names(fixed_effects) <- row.names(object$model$coefficients)
    fixed_effects
}
formula.ebp <-
function (x, ...) 
{
    throw_class_error(x, "ebp")
    x$fixed
}
formula.fh <-
function (x, ...) 
{
    throw_class_error(x, "fh")
    x$fixed
}
framework_FH <-
function (combined_data, fixed, vardir, domains, transformation, 
    eff_smpsize, correlation, corMatrix, Ci, tol, maxit) 
{
    obs_dom <- !is.na(combined_data[[paste(lhs(fixed))]])
    data <- combined_data[obs_dom == TRUE, ]
    direct <- makeXY(fixed, data)$y
    model_X <- makeXY(fixed, data)$x
    vardirname <- vardir
    vardir <- data[, vardir]
    direct_orig <- NULL
    vardir_orig <- NULL
    if (!all(is.na(vardir) == is.na(direct))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Except for out-of-sample domains the variable ", 
            vardirname, " containing the domain-specific sampling\n                        variances must not have NAs.")))
    }
    if (transformation == "log") {
        direct_orig <- direct
        vardir_orig <- vardir
        vardir <- (1/direct)^2 * vardir
        direct <- log(direct)
    }
    else if (transformation == "arcsin") {
        direct_orig <- direct
        vardir_orig <- vardir
        direct <- asin(sqrt(direct))
        vardir <- 1/(4 * data[, eff_smpsize])
    }
    if (is.null(domains)) {
        combined_data$Domain <- seq_len(nrow(combined_data))
        domains <- "Domain"
    }
    m <- length(direct)
    M <- length(combined_data[[paste(lhs(fixed))]])
    N_dom_unobs <- M - m
    p <- ncol(model_X)
    if (!is.null(corMatrix)) {
        corMatrix <- corMatrix
        if (is.matrix(corMatrix) == FALSE) {
            corMatrix <- as.matrix(corMatrix)
        }
    }
    if (!is.null(Ci)) {
        Ci <- Ci
    }
    framework_out <- list(obs_dom = obs_dom, N_dom_smp = m, N_dom_unobs = N_dom_unobs, 
        data = data, combined_data = combined_data, formula = fixed, 
        direct = direct, direct_orig = direct_orig, model_X = model_X, 
        vardir = vardir, vardir_orig = vardir_orig, eff_smpsize = eff_smpsize, 
        domains = domains, m = m, M = M, p = p, correlation = correlation, 
        W = corMatrix, Ci = Ci, tol = tol, maxit = maxit)
    return(framework_out)
}
framework_dir <-
function (y, smp_data, smp_domains, weights, threshold, custom_indicator, 
    na.rm) 
{
    if (isTRUE(na.rm)) {
        indices <- !is.na(smp_data[y])
        if (!is.null(weights)) {
            indices <- indices & !is.na(smp_data[weights])
        }
        smp_data <- smp_data[indices, ]
    }
    else if (any(is.na(smp_data[y]))) {
        warning(strwrap(prefix = " ", initial = "", "There are NA-Values in the target variable and na.rm is\n                    set FALSE. Therefore, only quantiles are estimated"))
    }
    else if (!is.null(weights) && any(is.na(smp_data[weights]))) {
        warning(strwrap(prefix = " ", initial = "", "There are NA-Values in the weights variable and na.rm is\n                    set FALSE. Therefore, only quantiles are estimated"))
    }
    y_vec <- smp_data[, y]
    N_smp <- length(y_vec)
    if (!is.null(weights)) {
        weights_vec <- smp_data[, weights]
    }
    else if (is.null(weights)) {
        weights_vec <- rep.int(1, N_smp)
    }
    byDomain <- !is.null(smp_domains)
    if (byDomain) {
        smp_domains_vec <- as.factor(as.character(smp_data[, 
            smp_domains]))
        smp_domains_vec <- droplevels(smp_domains_vec)
        rs <- levels(smp_domains_vec)
        N_dom_smp <- length(unique(smp_domains_vec))
        smp_domains_vec_tmp <- as.numeric(smp_domains_vec)
        n_smp <- as.vector(table(smp_domains_vec_tmp))
    }
    if (is.null(threshold)) {
        if (is.null(weights)) {
            threshold <- 0.59999999999999998 * median(y_vec)
            message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is automatically\n                      set to 60% of the median of the dependent variable and\n                      equals ", 
                threshold)))
        }
        else if (!is.null(weights)) {
            threshold <- 0.59999999999999998 * wtd.quantile(x = y_vec, 
                weights = weights_vec, probs = 0.5)
            message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is\n                      automatically set to 60% of the weighted median of the\n                      dependent variable and equals ", 
                threshold)))
        }
    }
    indicator_list <- getIndicatorList_fixed()
    indicator_names <- c("Mean", "Head_Count", "Poverty_Gap", 
        "Gini", "Quintile_Share", "Quantile_10", "Quantile_25", 
        "Median", "Quantile_75", "Quantile_90")
    if (!is.null(custom_indicator) && length(custom_indicator) > 
        0) {
        for (i in 1:length(custom_indicator)) {
            formals(custom_indicator[[i]]) <- alist(y = , weights = , 
                threshold = )
        }
        indicator_list <- c(indicator_list, custom_indicator)
        indicator_names <- c(indicator_names, names(custom_indicator))
    }
    return(list(smp_data = smp_data, y = y, y_vec = y_vec, weights = weights, 
        weights_vec = weights_vec, smp_domains_vec = smp_domains_vec, 
        smp_domains = smp_domains, byDomain = byDomain, rs = rs, 
        N_smp = N_smp, N_dom_smp = N_dom_smp, n_smp = n_smp, 
        indicator_list = indicator_list, indicator_names = indicator_names, 
        threshold = threshold))
}
framework_ebp <-
function (fixed, pop_data, pop_domains, pop_subdomains, smp_data, 
    smp_domains, smp_subdomains, threshold, custom_indicator = NULL, 
    na.rm, aggregate_to = NULL, weights, pop_weights, MSE_pop_weights, 
    weights_type, benchmark_level, benchmark_weights, nlme_maxiter, 
    nlme_tolerance, nlme_opt, nlme_optimmethod, nlme_method, 
    nlme_mstol, nlme_returnobject, nlme_msmaxiter, rescale_weights, 
    model_parameters, data.table, indicators) 
{
    mod_vars <- all.vars(fixed)
    mod_vars <- mod_vars[mod_vars != as.character(fixed[2])]
    if (!is.null(weights) && benchmark_weights == weights) {
        smp_vars <- c(as.character(fixed[2]), mod_vars, smp_domains, 
            weights, benchmark_level)
        if (!is.null(smp_subdomains)) {
            smp_vars <- c(smp_vars, smp_subdomains)
        }
    }
    else {
        smp_vars <- c(as.character(fixed[2]), mod_vars, smp_domains, 
            weights, benchmark_level, benchmark_weights)
        if (!is.null(smp_subdomains)) {
            smp_vars <- c(smp_vars, smp_subdomains)
        }
    }
    pop_vars <- c(mod_vars, pop_domains, pop_subdomains, aggregate_to, 
        pop_weights, benchmark_level)
    if (!is.null(MSE_pop_weights)) {
        pop_vars <- c(pop_vars, MSE_pop_weights)
    }
    if (min(smp_vars %in% colnames(smp_data)) == 0) {
        stop(strwrap(prefix = " ", initial = "", paste0(smp_vars[smp_vars %in% 
            colnames(smp_data) == F])), " are not in the sample dataset")
    }
    smp_data <- smp_data[, smp_vars]
    weights <- weights
    pop_weights <- pop_weights
    fw_check1(pop_data = pop_data, mod_vars = mod_vars, pop_domains = pop_domains, 
        pop_subdomains = pop_subdomains, smp_data = smp_data, 
        aggregate_to = aggregate_to, fixed = fixed, smp_domains = smp_domains, 
        smp_subdomains = smp_subdomains, threshold = threshold, 
        weights = weights, pop_weights = pop_weights, benchmark_level = benchmark_level, 
        benchmark_weights = benchmark_weights, weights_type = weights_type, 
        rescale_weights = rescale_weights)
    if (min(pop_vars %in% colnames(pop_data)) == 0) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_vars[pop_vars %in% 
            colnames(pop_data) == F])), " are not in the population dataset")
    }
    pop_data <- pop_data[, pop_vars]
    if ("tbl_df" %in% class(pop_data)) {
        pop_data <- as.data.frame(pop_data)
    }
    if ("tbl_df" %in% class(smp_data)) {
        smp_data <- as.data.frame(smp_data)
    }
    if (na.rm == TRUE) {
        pop_data <- na.omit(pop_data)
        smp_data <- na.omit(smp_data)
    }
    else if (any(is.na(pop_data)) || any(is.na(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", "EBP does not work with missing values. Set na.rm = TRUE in\n                 function ebp."))
    }
    if (isTRUE(rescale_weights) && !is.null(weights)) {
        smp_data[, weights] <- smp_data[, weights]/ave(smp_data[, 
            weights], smp_data[, smp_domains])
    }
    else if (!is.null(weights)) {
        smp_data[, weights] <- smp_data[, weights]/mean(smp_data[, 
            weights])
    }
    pop_data <- pop_data[order(pop_data[[pop_domains]]), ]
    levels_tmp <- unique(pop_data[[pop_domains]])
    pop_data[[pop_domains]] <- factor(pop_data[[pop_domains]], 
        levels = levels_tmp)
    pop_domains_vec <- pop_data[[pop_domains]]
    smp_data[[smp_domains]] <- factor(smp_data[[smp_domains]], 
        levels = levels_tmp)
    if (!is.null(pop_subdomains)) {
        pop_data <- pop_data[order(pop_data[[pop_subdomains]]), 
            ]
        levels_subdom_tmp <- unique(pop_data[[pop_subdomains]])
        pop_data[[pop_subdomains]] <- factor(pop_data[[pop_subdomains]], 
            levels = levels_subdom_tmp)
        pop_subdomains_vec <- pop_data[[pop_subdomains]]
        smp_data[[smp_subdomains]] <- factor(smp_data[[smp_subdomains]])
    }
    if (is.null(aggregate_to)) {
        aggregate_to_vec <- NULL
    }
    else {
        levels_tmp <- unique(pop_data[[aggregate_to]])
        pop_data[[aggregate_to]] <- factor(pop_data[[aggregate_to]], 
            levels = levels_tmp)
        aggregate_to_vec <- pop_data[[aggregate_to]]
    }
    rm(levels_tmp)
    smp_data <- smp_data[order(smp_data[[smp_domains]]), ]
    smp_domains_vec <- smp_data[[smp_domains]]
    smp_domains_vec <- droplevels(smp_domains_vec)
    smp_subdomains_vec <- NULL
    pop_subdomains_vec <- NULL
    both_subdomains_vec <- NULL
    if (!is.null(smp_subdomains) && !is.null(pop_subdomains)) {
        pop_subdomains_vec <- pop_data[[pop_subdomains]]
        smp_subdomains_vec <- smp_data[[smp_subdomains]]
        both_subdomains_vec <- smp_subdomains_vec[smp_subdomains_vec %in% 
            pop_subdomains_vec]
    }
    fw_check2(pop_domains = pop_domains, pop_domains_vec = pop_domains_vec, 
        smp_domains = smp_domains, smp_domains_vec = smp_domains_vec, 
        aggregate_to = aggregate_to, aggregate_to_vec = aggregate_to_vec)
    N_pop <- length(pop_domains_vec)
    N_smp <- length(smp_domains_vec)
    N_unobs <- N_pop - N_smp
    N_dom_pop <- length(unique(pop_domains_vec))
    N_subdom_pop <- length(unique(pop_subdomains_vec))
    N_dom_pop_agg <- length(unique(aggregate_to_vec))
    N_dom_smp <- length(unique(smp_domains_vec))
    N_dom_unobs <- N_dom_pop - N_dom_smp
    N_subdom_smp <- length(unique(both_subdomains_vec))
    N_subdom_unobs <- N_subdom_pop - N_subdom_smp
    n_pop <- as.vector(table(pop_domains_vec))
    n_pop_subdom <- as.vector(table(pop_subdomains_vec))
    smp_domains_vec_tmp <- as.numeric(smp_domains_vec)
    n_smp <- as.vector(table(smp_domains_vec_tmp))
    smp_subdomains_vec_tmp <- as.numeric(smp_subdomains_vec)
    n_smp_subdom <- as.vector(table(smp_subdomains_vec_tmp))
    obs_dom <- pop_domains_vec %in% unique(smp_domains_vec)
    dist_obs_dom <- unique(pop_domains_vec) %in% unique(smp_domains_vec)
    obs_subdom <- pop_subdomains_vec %in% unique(smp_subdomains_vec)
    dist_obs_subdom <- unique(pop_subdomains_vec) %in% unique(smp_subdomains_vec)
    obs_smp_dom <- smp_domains_vec %in% unique(pop_domains_vec)
    dist_obs_smp_dom <- unique(smp_domains_vec) %in% unique(pop_domains_vec)
    obs_smp_subdom <- smp_subdomains_vec %in% unique(pop_subdomains_vec)
    dist_obs_smp_subdom <- unique(smp_subdomains_vec) %in% unique(pop_subdomains_vec)
    fw_check3(obs_dom = obs_dom, dist_obs_dom = dist_obs_dom, 
        pop_domains = pop_domains, smp_domains = smp_domains)
    indicator_list <- list(Mean = function(y, pop_weights, threshold) {
        t(weighted.mean(y, pop_weights))
    }, Head_Count = function(y, pop_weights, threshold) {
        t(weighted.mean(y < threshold, pop_weights))
    }, Poverty_Gap = function(y, pop_weights, threshold) {
        sum((1 - (y[y < threshold]/threshold)) * pop_weights[y < 
            threshold])/sum(pop_weights)
    }, Poverty_Severity = function(y, pop_weights, threshold) {
        sum((1 - y[y < threshold]/threshold)^2 * pop_weights[y < 
            threshold])/sum(pop_weights)
    }, Gini = function(y, pop_weights, threshold) {
        n <- length(y)
        pop_weights <- pop_weights[order(y)]
        y <- sort(y)
        auc <- sum((cumsum(c(0, (y * pop_weights)[1:(n - 1)])) + 
            ((y * pop_weights)/2)) * pop_weights)
        auc <- (auc/sum(pop_weights))/sum((y * pop_weights))
        G <- 1 - (2 * auc)
        return(G)
    }, Quintile_Share = function(y, pop_weights, threshold) {
        quant14 <- wtd.quantile(x = y, weights = pop_weights, 
            probs = c(0.20000000000000001, 0.80000000000000004))
        iq1 <- y <= quant14[1]
        iq4 <- y > quant14[2]
        t((sum(pop_weights[iq4] * y[iq4])/sum(pop_weights[iq4]))/(sum(pop_weights[iq1] * 
            y[iq1])/sum(pop_weights[iq1])))
    }, Quantiles = function(y, pop_weights, threshold) {
        if (length(unique(pop_weights)) == 1 & 1 %in% unique(pop_weights)) {
            t(quantile(x = y, probs = c(0.10000000000000001, 
                0.25, 0.5, 0.75, 0.90000000000000002)))
        } else {
            t(wtd.quantile(x = y, weights = pop_weights, probs = c(0.10000000000000001, 
                0.25, 0.5, 0.75, 0.90000000000000002)))
        }
    })
    if (data.table == TRUE) {
        indicator_list[["Mean"]] <- function(y, pop_weights, 
            threshold = NULL) {
            weighted.mean(x = y, w = pop_weights)
        }
        indicator_list[["Head_Count"]] <- function(y, threshold, 
            pop_weights) {
            weighted.mean(y < threshold, w = pop_weights)
        }
        indicator_list[["Quintile_Share"]] <- function(y, pop_weights, 
            threshold) {
            quant14 <- wtd.quantile(x = y, weights = pop_weights, 
                probs = c(0.20000000000000001, 0.80000000000000004))
            iq1 <- y <= quant14[1]
            iq4 <- y > quant14[2]
            (sum(pop_weights[iq4] * y[iq4])/sum(pop_weights[iq4]))/(sum(pop_weights[iq1] * 
                y[iq1])/sum(pop_weights[iq1]))
        }
        indicator_list[["Quantiles"]] <- function(y, pop_weights, 
            threshold) {
            if (length(unique(pop_weights)) == 1 & 1 %in% unique(pop_weights)) {
                quantile(x = y, probs = c(0.10000000000000001, 
                  0.25, 0.5, 0.75, 0.90000000000000002))
            }
            else {
                wtd.quantile(x = y, weights = pop_weights, probs = c(0.10000000000000001, 
                  0.25, 0.5, 0.75, 0.90000000000000002))
            }
        }
    }
    indicator_names <- c("Mean", "Head_Count", "Poverty_Gap", 
        "Poverty_Severity", "Gini", "Quintile_Share", "Quantile_10", 
        "Quantile_25", "Median", "Quantile_75", "Quantile_90")
    function_names <- c("Mean", "Head_Count", "Poverty_Gap", 
        "Poverty_Severity", "Gini", "Quintile_Share", "Quantiles")
    if (!is.null(indicators)) {
        keepthese <- which(function_names %in% indicators)
        indicator_list <- indicator_list[keepthese]
        if (7 %in% keepthese) {
            keepthese <- c(keepthese, 8, 9, 10, 11)
        }
        indicator_names <- indicator_names[keepthese]
    }
    if (!is.null(custom_indicator) && length(custom_indicator) > 
        0) {
        for (i in 1:length(custom_indicator)) {
            formals(custom_indicator[[i]]) <- alist(y = , pop_weights = , 
                threshold = )
        }
        indicator_list <- c(indicator_list, custom_indicator)
        indicator_names <- c(indicator_names, names(custom_indicator))
    }
    if (is.null(threshold)) {
        threshold <- 0.59999999999999998 * median(smp_data[[paste(fixed[2])]])
        message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is\n                          automatically set to 60% of the median of the\n                          dependent variable and equals ", 
            threshold)))
    }
    return(list(pop_data = pop_data, pop_domains_vec = pop_domains_vec, 
        pop_domains = pop_domains, pop_subdomains = pop_subdomains, 
        pop_subdomains_vec = pop_subdomains_vec, smp_data = smp_data, 
        smp_domains_vec = smp_domains_vec, smp_domains = smp_domains, 
        smp_subdomains = smp_subdomains, smp_subdomains_vec = smp_subdomains_vec, 
        both_subdomains_vec = both_subdomains_vec, aggregate_to = aggregate_to, 
        aggregate_to_vec = aggregate_to_vec, N_pop = N_pop, N_smp = N_smp, 
        N_unobs = N_unobs, N_dom_pop = N_dom_pop, N_dom_pop_agg = N_dom_pop_agg, 
        N_subdom_pop = N_subdom_pop, N_dom_smp = N_dom_smp, N_dom_unobs = N_dom_unobs, 
        N_subdom_smp = N_subdom_smp, N_subdom_unobs = N_subdom_unobs, 
        n_pop = n_pop, n_smp = n_smp, n_pop_subdom = n_pop_subdom, 
        n_smp_subdom = n_smp_subdom, obs_dom = obs_dom, obs_subdom = obs_subdom, 
        dist_obs_dom = dist_obs_dom, dist_obs_subdom = dist_obs_subdom, 
        obs_smp_dom = obs_smp_dom, dist_obs_smp_dom = dist_obs_smp_dom, 
        obs_smp_subdom = obs_smp_subdom, dist_obs_smp_subdom = dist_obs_smp_subdom, 
        indicator_list = indicator_list, indicator_names = indicator_names, 
        threshold = threshold, weights = weights, benchmark_weights = benchmark_weights, 
        pop_weights = pop_weights, MSE_pop_weights = MSE_pop_weights, 
        weights_type = weights_type, nlme_maxiter = nlme_maxiter, 
        nlme_tolerance = nlme_tolerance, nlme_opt = nlme_opt, 
        nlme_optimmethod = nlme_optimmethod, nlme_msmaxiter = nlme_msmaxiter, 
        nlme_mstol = nlme_mstol, nlme_returnobject = nlme_returnobject, 
        nlme_method = nlme_method, model_parameters = model_parameters, 
        data.table = data.table, indicators = indicators))
}
framework_ell <-
function (fixed, alpha, pop_data, pop_domains, pop_subdomains, 
    smp_data, smp_domains, smp_subdomains, threshold, custom_indicator = NULL, 
    na.rm, aggregate_to = NULL, weights, pop_weights, benchmark_level, 
    benchmark_weights, rescale_weights, errors, random_method, 
    model_parameters, indicators) 
{
    mod_vars <- all.vars(nlme::asOneFormula(fixed, alpha))
    mod_vars <- mod_vars[mod_vars != as.character(fixed[2])]
    if (!is.null(weights) && benchmark_weights == weights) {
        smp_vars <- c(as.character(fixed[2]), mod_vars, smp_domains, 
            smp_subdomains, weights, benchmark_level)
    }
    else {
        smp_vars <- c(as.character(fixed[2]), mod_vars, smp_domains, 
            smp_subdomains, weights, benchmark_level, benchmark_weights)
    }
    pop_vars <- c(mod_vars, pop_domains, pop_subdomains, aggregate_to, 
        pop_weights, benchmark_level)
    smp_data <- smp_data[, smp_vars]
    weights <- weights
    pop_weights <- pop_weights
    fw_check1(pop_data = pop_data, mod_vars = mod_vars, pop_domains = pop_domains, 
        smp_data = smp_data, aggregate_to = aggregate_to, fixed = fixed, 
        smp_domains = smp_domains, threshold = threshold, weights = weights, 
        pop_weights = pop_weights, benchmark_level = benchmark_level, 
        benchmark_weights = benchmark_weights, weights_type = weights_type, 
        rescale_weights = rescale_weights)
    pop_data <- pop_data[, pop_vars]
    if ("tbl_df" %in% class(pop_data)) {
        pop_data <- as.data.frame(pop_data)
    }
    if ("tbl_df" %in% class(smp_data)) {
        smp_data <- as.data.frame(smp_data)
    }
    if (na.rm == TRUE) {
        pop_data <- na.omit(pop_data)
        smp_data <- na.omit(smp_data)
    }
    else if (any(is.na(pop_data)) || any(is.na(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", "EBP does not work with missing values. Set na.rm = TRUE in\n                 function ebp."))
    }
    if (isTRUE(rescale_weights) && !is.null(weights)) {
        smp_data[, weights] <- smp_data[, weights]/ave(smp_data[, 
            weights], smp_data[, smp_domains])
    }
    pop_data <- pop_data[order(pop_data[[pop_domains]]), ]
    levels_tmp <- unique(pop_data[[pop_domains]])
    pop_data[[pop_domains]] <- factor(pop_data[[pop_domains]], 
        levels = levels_tmp)
    pop_domains_vec <- pop_data[[pop_domains]]
    smp_data[[smp_domains]] <- factor(smp_data[[smp_domains]], 
        levels = levels_tmp)
    if (is.null(aggregate_to)) {
        aggregate_to_vec <- NULL
    }
    else {
        levels_tmp <- unique(pop_data[[aggregate_to]])
        pop_data[[aggregate_to]] <- factor(pop_data[[aggregate_to]], 
            levels = levels_tmp)
        aggregate_to_vec <- pop_data[[aggregate_to]]
    }
    rm(levels_tmp)
    smp_data <- smp_data[order(smp_data[[smp_domains]]), ]
    smp_domains_vec <- smp_data[[smp_domains]]
    smp_domains_vec <- droplevels(smp_domains_vec)
    smp_subdomains_vec <- NULL
    pop_subdomains_vec <- NULL
    if (!is.null(smp_subdomains) && !is.null(pop_subdomains)) {
        smp_subdomains_vec <- smp_data[[smp_subdomains]]
        smp_subdomains_vec <- droplevels(as.factor(smp_subdomains_vec))
        pop_subdomains_vec <- pop_data[[pop_subdomains]]
    }
    fw_check2(pop_domains = pop_domains, pop_domains_vec = pop_domains_vec, 
        smp_domains = smp_domains, smp_domains_vec = smp_domains_vec, 
        aggregate_to = aggregate_to, aggregate_to_vec = aggregate_to_vec)
    N_pop <- length(pop_domains_vec)
    N_smp <- length(smp_domains_vec)
    N_unobs <- N_pop - N_smp
    N_dom_pop <- length(unique(pop_domains_vec))
    N_subdom_pop <- length(unique(pop_subdomains_vec))
    N_dom_pop_agg <- length(unique(aggregate_to_vec))
    N_dom_smp <- length(unique(smp_domains_vec))
    N_dom_unobs <- N_dom_pop - N_dom_smp
    n_pop <- as.vector(table(pop_domains_vec))
    n_pop_subdom <- as.vector(table(pop_subdomains_vec))
    smp_domains_vec_tmp <- as.numeric(smp_domains_vec)
    n_smp <- as.vector(table(smp_domains_vec_tmp))
    smp_subdomains_vec_tmp <- as.numeric(smp_subdomains_vec)
    n_smp_subdom <- as.vector(table(smp_subdomains_vec_tmp))
    obs_dom <- pop_domains_vec %in% unique(smp_domains_vec)
    dist_obs_dom <- unique(pop_domains_vec) %in% unique(smp_domains_vec)
    obs_subdom <- pop_subdomains_vec %in% unique(smp_subdomains_vec)
    fw_check3(obs_dom = obs_dom, dist_obs_dom = dist_obs_dom, 
        pop_domains = pop_domains, smp_domains = smp_domains)
    indicator_list <- list(fast_mean = function(y, pop_weights, 
        threshold) {
        t(weighted.mean(y, pop_weights))
    }, hcr = function(y, pop_weights, threshold) {
        t(weighted.mean(y < threshold, pop_weights))
    }, pgap = function(y, pop_weights, threshold) {
        sum((1 - (y[y < threshold]/threshold)) * pop_weights[y < 
            threshold])/sum(pop_weights)
    }, psev = function(y, pop_weights, threshold) {
        sum((1 - (y[y < threshold]/threshold)^2) * pop_weights[y < 
            threshold])/sum(pop_weights)
    }, gini = function(y, pop_weights, threshold) {
        n <- length(y)
        pop_weights <- pop_weights[order(y)]
        y <- sort(y)
        auc <- sum((cumsum(c(0, (y * pop_weights)[1:(n - 1)])) + 
            ((y * pop_weights)/2)) * pop_weights)
        auc <- (auc/sum(pop_weights))/sum((y * pop_weights))
        G <- 1 - (2 * auc)
        return(G)
    }, qsr = function(y, pop_weights, threshold) {
        quant14 <- wtd.quantile(x = y, weights = pop_weights, 
            probs = c(0.20000000000000001, 0.80000000000000004))
        iq1 <- y <= quant14[1]
        iq4 <- y > quant14[2]
        t((sum(pop_weights[iq4] * y[iq4])/sum(pop_weights[iq4]))/(sum(pop_weights[iq1] * 
            y[iq1])/sum(pop_weights[iq1])))
    }, quants = function(y, pop_weights, threshold) {
        if (length(unique(pop_weights)) == 1 & 1 %in% unique(pop_weights)) {
            t(quantile(x = y, probs = c(0.10000000000000001, 
                0.25, 0.5, 0.75, 0.90000000000000002)))
        } else {
            t(wtd.quantile(x = y, weights = pop_weights, probs = c(0.10000000000000001, 
                0.25, 0.5, 0.75, 0.90000000000000002)))
        }
    })
    indicator_names <- c("Mean", "Head_Count", "Poverty_Gap", 
        "Poverty_Severity", "Gini", "Quintile_Share", "Quantile_10", 
        "Quantile_25", "Median", "Quantile_75", "Quantile_90")
    function_names <- c("Mean", "Head_Count", "Poverty_Gap", 
        "Poverty_Severity", "Gini", "Quintile_Share", "Quantiles")
    if (!is.null(indicators)) {
        keepthese <- which(function_names %in% indicators)
        indicator_list <- indicator_list[keepthese]
        if (7 %in% keepthese) {
            keepthese <- c(keepthese, 8, 9, 10, 11)
        }
        indicator_names <- indicator_names[keepthese]
    }
    if (!is.null(custom_indicator) && length(custom_indicator) > 
        0) {
        for (i in 1:length(custom_indicator)) {
            formals(custom_indicator[[i]]) <- alist(y = , pop_weights = , 
                threshold = )
        }
        indicator_list <- c(indicator_list, custom_indicator)
        indicator_names <- c(indicator_names, names(custom_indicator))
    }
    if (is.null(threshold)) {
        threshold <- 0.59999999999999998 * median(smp_data[[paste(fixed[2])]])
        message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is\n                          automatically set to 60% of the median of the\n                          dependent variable and equals ", 
            threshold)))
    }
    return(list(pop_data = pop_data, pop_domains_vec = pop_domains_vec, 
        pop_subdomains = pop_subdomains, smp_data = smp_data, 
        smp_domains_vec = smp_domains_vec, smp_domains = smp_domains, 
        smp_subdomains = smp_subdomains, aggregate_to = aggregate_to, 
        aggregate_to_vec = aggregate_to_vec, N_pop = N_pop, N_smp = N_smp, 
        N_unobs = N_unobs, N_dom_pop = N_dom_pop, N_dom_pop_agg = N_dom_pop_agg, 
        N_subdom_pop = N_subdom_pop, N_dom_smp = N_dom_smp, N_dom_unobs = N_dom_unobs, 
        n_pop = n_pop, n_smp = n_smp, n_pop_subdom = n_pop_subdom, 
        obs_dom = obs_dom, obs_subdom = obs_subdom, dist_obs_dom = dist_obs_dom, 
        indicator_list = indicator_list, indicator_names = indicator_names, 
        threshold = threshold, weights = weights, benchmark_weights = benchmark_weights, 
        pop_weights = pop_weights, errors = errors, random_method = random_method, 
        model_parameters = model_parameters))
}
framework_hdp <-
function (fixed, pop_data, pop_domains, smp_data, smp_domains, 
    threshold, na.rm, aggregate_to, weights, pop_weights, custom_indicator, 
    Q, method, tol, maxit, k_b, k_sigma_u, k_sigma_e) 
{
    mod_vars <- all.vars(fixed)
    mod_vars <- mod_vars[mod_vars != as.character(fixed[2])]
    smp_vars <- c(as.character(fixed[2]), mod_vars, smp_domains, 
        weights)
    pop_vars <- c(mod_vars, pop_domains, aggregate_to, pop_weights)
    smp_data <- smp_data[, smp_vars]
    weights <- weights
    pop_weights <- pop_weights
    fw_hdp_check1(fixed = fixed, mod_vars = mod_vars, pop_data = pop_data, 
        pop_domains = pop_domains, smp_data = smp_data, smp_domains = smp_domains, 
        aggregate_to = aggregate_to, threshold = threshold, weights = weights, 
        pop_weights = pop_weights)
    pop_data <- pop_data[, pop_vars]
    if (na.rm == TRUE) {
        pop_data <- na.omit(pop_data)
        smp_data <- na.omit(smp_data)
    }
    else if (any(is.na(pop_data)) || any(is.na(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", "EBP does not work with missing values. Set na.rm = TRUE in\n                 function ebp."))
    }
    pop_data <- pop_data[order(pop_data[[pop_domains]]), ]
    levels_tmp <- unique(pop_data[[pop_domains]])
    pop_data[[pop_domains]] <- factor(pop_data[[pop_domains]], 
        levels = levels_tmp)
    pop_domains_vec <- pop_data[[pop_domains]]
    smp_data[[smp_domains]] <- factor(smp_data[[smp_domains]], 
        levels = levels_tmp)
    if (is.null(aggregate_to)) {
        aggregate_to_vec <- NULL
    }
    else {
        levels_tmp <- unique(pop_data[[aggregate_to]])
        pop_data[[aggregate_to]] <- factor(pop_data[[aggregate_to]], 
            levels = levels_tmp)
        aggregate_to_vec <- pop_data[[aggregate_to]]
    }
    rm(levels_tmp)
    smp_data <- smp_data[order(smp_data[[smp_domains]]), ]
    smp_domains_vec <- smp_data[[smp_domains]]
    smp_domains_vec <- droplevels(smp_domains_vec)
    fw_hdp_check2(pop_domains = pop_domains, pop_domains_vec = pop_domains_vec, 
        smp_domains = smp_domains, smp_domains_vec = smp_domains_vec, 
        aggregate_to = aggregate_to, aggregate_to_vec = aggregate_to_vec)
    N_pop <- length(pop_domains_vec)
    N_smp <- length(smp_domains_vec)
    N_unobs <- N_pop - N_smp
    N_dom_pop <- length(unique(pop_domains_vec))
    N_dom_pop_agg <- length(unique(aggregate_to_vec))
    N_dom_smp <- length(unique(smp_domains_vec))
    N_dom_unobs <- N_dom_pop - N_dom_smp
    n_pop <- as.vector(table(pop_domains_vec))
    smp_domains_vec_tmp <- as.numeric(smp_domains_vec)
    n_smp <- as.vector(table(smp_domains_vec_tmp))
    obs_dom <- pop_domains_vec %in% unique(smp_domains_vec)
    dist_obs_dom <- unique(pop_domains_vec) %in% unique(smp_domains_vec)
    fw_hdp_check3(obs_dom = obs_dom, dist_obs_dom = dist_obs_dom, 
        pop_domains = pop_domains, smp_domains = smp_domains)
    indicator_list <- list(fast_mean = function(y, pop_weights, 
        threshold) {
        t(weighted.mean(y, pop_weights))
    }, hcr = function(y, pop_weights, threshold) {
        t(weighted.mean(y < threshold, pop_weights))
    }, pgap = function(y, pop_weights, threshold) {
        sum((1 - (y[y < threshold]/threshold)) * pop_weights[y < 
            threshold])/sum(pop_weights)
    }, psev = function(y, pop_weights, threshold) {
        sum((1 - (y[y < threshold]/threshold))^2 * pop_weights[y < 
            threshold])/sum(pop_weights)
    }, gini = function(y, pop_weights, threshold) {
        n <- length(y)
        pop_weights <- pop_weights[order(y)]
        y <- sort(y)
        auc <- sum((cumsum(c(0, (y * pop_weights)[1:(n - 1)])) + 
            ((y * pop_weights)/2)) * pop_weights)
        auc <- (auc/sum(pop_weights))/sum((y * pop_weights))
        G <- 1 - (2 * auc)
        return(G)
    }, qsr = function(y, pop_weights, threshold) {
        quant14 <- wtd.quantile(x = y, weights = pop_weights, 
            probs = c(0.20000000000000001, 0.80000000000000004))
        iq1 <- y <= quant14[1]
        iq4 <- y > quant14[2]
        t((sum(pop_weights[iq4] * y[iq4])/sum(pop_weights[iq4]))/(sum(pop_weights[iq1] * 
            y[iq1])/sum(pop_weights[iq1])))
    }, quants = function(y, pop_weights, threshold) {
        if (length(unique(pop_weights)) == 1 & 1 %in% unique(pop_weights)) {
            t(quantile(x = y, probs = c(0.10000000000000001, 
                0.25, 0.5, 0.75, 0.90000000000000002)))
        } else {
            t(wtd.quantile(x = y, weights = pop_weights, probs = c(0.10000000000000001, 
                0.25, 0.5, 0.75, 0.90000000000000002)))
        }
    })
    indicator_names <- c("Mean", "Head_Count", "Poverty_Gap", 
        "Poverty_Severity", "Gini", "Quintile_Share", "Quantile_10", 
        "Quantile_25", "Median", "Quantile_75", "Quantile_90")
    if (!is.null(custom_indicator) && length(custom_indicator) > 
        0) {
        for (i in 1:length(custom_indicator)) {
            formals(custom_indicator[[i]]) <- alist(y = , pop_weights = , 
                threshold = )
        }
        indicator_list <- c(indicator_list, custom_indicator)
        indicator_names <- c(indicator_names, names(custom_indicator))
    }
    if (is.null(threshold)) {
        threshold <- 0.59999999999999998 * median(smp_data[[paste(fixed[2])]])
        message(strwrap(prefix = " ", initial = "", paste0("The threshold for the HCR and the PG is\n                          automatically set to 60% of the median of the\n                          dependent variable and equals ", 
            threshold)))
    }
    return(list(pop_data = pop_data, pop_domains_vec = pop_domains_vec, 
        smp_data = smp_data, smp_domains_vec = smp_domains_vec, 
        smp_domains = smp_domains, aggregate_to = aggregate_to, 
        aggregate_to_vec = aggregate_to_vec, N_pop = N_pop, N_smp = N_smp, 
        N_unobs = N_unobs, N_dom_pop = N_dom_pop, N_dom_pop_agg = N_dom_pop_agg, 
        N_dom_smp = N_dom_smp, N_dom_unobs = N_dom_unobs, n_pop = n_pop, 
        n_smp = n_smp, obs_dom = obs_dom, dist_obs_dom = dist_obs_dom, 
        indicator_list = indicator_list, indicator_names = indicator_names, 
        threshold = threshold, weights = weights, pop_weights = pop_weights, 
        Q = Q, method = method, tol = tol, maxit = maxit, k_b = k_b, 
        k_sigma_u = k_sigma_u, k_sigma_e = k_sigma_e))
}
fw_check1 <-
function (pop_data, mod_vars, pop_domains, pop_subdomains = pop_subdomains, 
    smp_data, fixed, smp_domains, smp_subdomains = NULL, aggregate_to, 
    threshold, weights, pop_weights, benchmark_level, benchmark_weights, 
    weights_type, rescale_weights) 
{
    if (!all(mod_vars %in% colnames(pop_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            mod_vars[(which(!mod_vars %in% colnames(pop_data)))], 
            " is not contained in pop_data. Please provide valid\n                        variable names for the explanatory variables.")))
    }
    if (!(pop_domains %in% colnames(pop_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            pop_domains, " is not contained\n                        in pop_data. Please provide valid variable name for\n                        pop_domains.")))
    }
    if (!all(mod_vars %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            mod_vars[which(!(mod_vars %in% colnames(smp_data)))], 
            " is not contained in smp_data. Please provide valid\n                        variable names for the explanatory variables.")))
    }
    if (!(smp_domains %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            smp_domains, " is not contained\n                        in smp_data. Please provide valid variable name for\n                        smp_domains.")))
    }
    if (!is.null(smp_subdomains)) {
        if (length(unique(smp_data[, smp_subdomains])) != nrow(unique(smp_data[c(smp_subdomains, 
            smp_domains)]))) {
            stop(strwrap(prefix = " ", initial = "", paste0("The subdomain identifier ", 
                smp_subdomains, " cannot refer to multiple domains ", 
                smp_domains, " in smp_data.\n                         Please provide a subdomain identifier that takes on different values for each domain. ")))
        }
    }
    if (!((as.character(fixed[2])) %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            as.character(fixed[2]), " is not contained\n                        in smp_data. Please provide valid variable name for the\n                        dependent variable.")))
    }
    if (!is.numeric(smp_data[[paste(fixed[2])]])) {
        stop(strwrap(prefix = " ", initial = "", paste0(as.character(fixed[2]), 
            " must be the name of a\n                        variable that is a numeric vector.")))
    }
    if (is.character(weights)) {
        if (!(weights %in% colnames(smp_data))) {
            stop(strwrap(prefix = " ", initial = "", paste0("The weights variable ", 
                weights, " is not contained\n                          in smp_data. Please provide a valid variable name for\n                          the weights variable.")))
        }
    }
    if (is.character(weights)) {
        if (!is.numeric(smp_data[[weights]])) {
            stop(strwrap(prefix = " ", initial = "", paste0("The variable ", 
                weights, " must be the name of a\n                          variable that is a numeric vector.")))
        }
    }
    if (is.character(weights)) {
        if (!all(smp_data[[weights]] >= 0)) {
            stop(strwrap(prefix = " ", initial = "", paste0("Negative or zero weights are included in ", 
                weights, " Please remove obersvations with weight values\n                          less than or equal to zero.")))
        }
    }
    if (!is.null(aggregate_to)) {
        if (!(aggregate_to %in% colnames(pop_data))) {
            stop(paste0("The domain variable ", aggregate_to, 
                " is not contained in\n                  pop_data. Please provide valid variable name for the\n                  aggregation."))
        }
    }
    if (!is.null(benchmark_level)) {
        if (!(benchmark_level %in% colnames(pop_data))) {
            stop(paste0("The benchmark_level variable ", benchmark_level, 
                " is not\n                  contained in pop_data. Please provide valid variable name for\n                  the benchmark level."))
        }
    }
    if (!is.null(benchmark_level)) {
        if (!(benchmark_level %in% colnames(smp_data))) {
            stop(paste0("The benchmark_level variable ", benchmark_level, 
                " is not\n                  contained in smp_data. Please provide valid variable name for\n                  the benchmark level."))
        }
    }
    if (is.character(benchmark_weights)) {
        if (!is.numeric(smp_data[[benchmark_weights]])) {
            stop(strwrap(prefix = " ", initial = "", paste0("The variable ", 
                benchmark_weights, " must be the name\n                   of a variable that is a numeric vector.")))
        }
    }
    if (is.character(pop_weights)) {
        if (!is.numeric(pop_data[[pop_weights]])) {
            stop(strwrap(prefix = " ", initial = "", paste0("The variable ", 
                pop_weights, " must be numeric.")))
        }
    }
    if (is.character(pop_weights)) {
        if (!all(pop_data[[pop_weights]] > 0)) {
            stop(strwrap(prefix = " ", initial = "", paste0("Negative or zero weights are included in ", 
                pop_weights, " Please remove obersvations with weight\n                          values less than or equal to zero.")))
        }
    }
    if (is.null(pop_weights)) {
        if (dim(pop_data)[1] < dim(smp_data)[1]) {
            stop(strwrap(prefix = " ", initial = "", "The population data set cannot have less observations than\n                 the sample data set."))
        }
    }
    if (inherits(threshold, "function") && (!is.numeric(threshold(smp_data[[paste(fixed[2])]])) || 
        length(threshold(smp_data[[paste(fixed[2])]])) != 1)) {
        stop(strwrap(prefix = " ", initial = "", "The threshold function must return a single numeric value\n                 when evaluated with the dependent variable."))
    }
}
fw_check2 <-
function (pop_domains, pop_domains_vec, smp_domains, smp_domains_vec, 
    aggregate_to, aggregate_to_vec) 
{
    if (!(is.numeric(pop_domains_vec) || any(inherits(pop_domains_vec, 
        "factor")))) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_domains, 
            " needs to be the name of a variable that\n                        is numeric or a (ordered) factor.")))
    }
    if (!(is.numeric(smp_domains_vec) || any(inherits(smp_domains_vec, 
        "factor")))) {
        stop(strwrap(prefix = " ", initial = "", paste0(smp_domains, 
            " needs to be the name of a variable that\n                        is numeric or a (ordered) factor.")))
    }
    if (is.null(aggregate_to) != TRUE) {
        if (!(is.numeric(aggregate_to_vec) || any(inherits(aggregate_to_vec, 
            "factor")))) {
            stop(paste0(aggregate_to, " needs to be the name of a variable that is\n                  numeric or a (ordered) factor."))
        }
    }
    if ((is.numeric(pop_domains_vec) && any(inherits(smp_domains_vec, 
        "factor"))) || (is.numeric(smp_domains_vec) && any(inherits(pop_domains_vec, 
        "factor")))) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_domains, 
            " and ", smp_domains, " need to be names\n                        of variables that are of the same class (factor and\n                        ordered factor are considered to be the same class).\n                        See also help(ebp).")))
    }
}
fw_check3 <-
function (obs_dom, dist_obs_dom, pop_domains, smp_domains) 
{
    if (sum(obs_dom) == 0 || sum(dist_obs_dom) == 0) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_domains, 
            " and ", smp_domains, " do not have any\n                        value in common. Do really both variables indicate the\n                        same domains in population data and sample data,\n                        respectively?")))
    }
}
fw_hdp_check1 <-
function (fixed, mod_vars, pop_data, pop_domains, smp_data, smp_domains, 
    aggregate_to, threshold, weights, pop_weights) 
{
    if (!all(mod_vars %in% colnames(pop_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            mod_vars[which(!(mod_vars %in% colnames(smp_data)))], 
            " is not contained in pop_data. Please provide valid\n                        variable names for the explanatory variables.")))
    }
    if (!(pop_domains %in% colnames(pop_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            pop_domains, " is not contained\n                        in pop_data. Please provide valid variable name for\n                        pop_domains.")))
    }
    if (!all(mod_vars %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            mod_vars[which(!(mod_vars %in% colnames(smp_data)))], 
            " is not contained in smp_data. Please provide valid\n                        variable names for the explanatory variables.")))
    }
    if (!(smp_domains %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("The domain variable ", 
            smp_domains, " is not contained\n                        in smp_data. Please provide valid variable name for\n                        smp_domains.")))
    }
    if (!((as.character(fixed[2])) %in% colnames(smp_data))) {
        stop(strwrap(prefix = " ", initial = "", paste0("Variable ", 
            as.character(fixed[2]), " is not contained\n                        in smp_data. Please provide valid variable name for the\n                        dependent variable.")))
    }
    if (!is.numeric(smp_data[[paste(fixed[2])]])) {
        stop(strwrap(prefix = " ", initial = "", paste0(as.character(fixed[2]), 
            " must be the name of a\n                        variable that is a numeric vector.")))
    }
    if (is.character(weights)) {
        if (!(weights %in% colnames(smp_data))) {
            stop(strwrap(prefix = " ", initial = "", paste0("The weights variable ", 
                weights, " is not contained\n                          in smp_data. Please provide a valid variable name for\n                          the weights variable.")))
        }
    }
    if (is.character(weights)) {
        if (!is.numeric(smp_data[[weights]])) {
            stop(strwrap(prefix = " ", initial = "", paste0("The variable ", 
                weights, " must be the name of a\n                          variable that is a numeric vector.")))
        }
    }
    if (is.character(weights)) {
        if (!all(smp_data[[weights]] >= 0)) {
            stop(strwrap(prefix = " ", initial = "", paste0("Negative or zero weights are included in ", 
                weights, " Please remove obersvations with weight values\n                          less than or equal to zero.")))
        }
    }
    if (!is.null(aggregate_to)) {
        if (!(aggregate_to %in% colnames(pop_data))) {
            stop(paste0("The domain variable ", aggregate_to, 
                " is not contained in\n                  pop_data. Please provide valid variable name for the\n                  aggregation."))
        }
    }
    if (is.character(pop_weights)) {
        if (!is.numeric(pop_data[[pop_weights]])) {
            stop(strwrap(prefix = " ", initial = "", paste0("The variable ", 
                pop_weights, " must be numeric.")))
        }
    }
    if (is.character(pop_weights)) {
        if (!all(pop_data[[pop_weights]] > 0)) {
            stop(strwrap(prefix = " ", initial = "", paste0("Negative or zero weights are included in ", 
                pop_weights, " Please remove obersvations with weight\n                          values less than or equal to zero.")))
        }
    }
    if (is.null(pop_weights)) {
        if (dim(pop_data)[1] < dim(smp_data)[1]) {
            stop(strwrap(prefix = " ", initial = "", "The population data set cannot have less observations than\n                 the sample data set."))
        }
    }
    if (inherits(threshold, "function") && (!is.numeric(threshold(smp_data[[paste(fixed[2])]])) || 
        length(threshold(smp_data[[paste(fixed[2])]])) != 1)) {
        stop(strwrap(prefix = " ", initial = "", "The threshold function must return a single numeric value\n                 when evaluated with the dependent variable."))
    }
}
fw_hdp_check2 <-
function (pop_domains, pop_domains_vec, smp_domains, smp_domains_vec, 
    aggregate_to, aggregate_to_vec) 
{
    if (!(is.numeric(pop_domains_vec) || any(inherits(pop_domains_vec, 
        "factor")))) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_domains, 
            " needs to be the name of a variable that\n                        is numeric or a (ordered) factor.")))
    }
    if (!(is.numeric(smp_domains_vec) || any(inherits(smp_domains_vec, 
        "factor")))) {
        stop(strwrap(prefix = " ", initial = "", paste0(smp_domains, 
            " needs to be the name of a variable that\n                        is numeric or a (ordered) factor.")))
    }
    if (is.null(aggregate_to) != TRUE) {
        if (!(is.numeric(aggregate_to_vec) || any(inherits(aggregate_to_vec, 
            "factor")))) {
            stop(paste0(aggregate_to, " needs to be the name of a variable that is\n                  numeric or a (ordered) factor."))
        }
    }
    if ((is.numeric(pop_domains_vec) && any(inherits(smp_domains_vec, 
        "factor"))) || (is.numeric(smp_domains_vec) && any(inherits(pop_domains_vec, 
        "factor")))) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_domains, 
            " and ", smp_domains, " need to be names\n                        of variables that are of the same class (factor and\n                        ordered factor are considered to be the same class).\n                        See also help(ebp).")))
    }
}
fw_hdp_check3 <-
function (obs_dom, dist_obs_dom, pop_domains, smp_domains) 
{
    if (sum(obs_dom) == 0 || sum(dist_obs_dom) == 0) {
        stop(strwrap(prefix = " ", initial = "", paste0(pop_domains, 
            " and ", smp_domains, " do not have any\n                        value in common. Do really both variables indicate the\n                        same domains in population data and sample data,\n                        respectively?")))
    }
}
gen_model <-
function (fixed, framework, model_par, dep_var) 
{
    if (is.null(framework$weights)) {
        weight_smp <- rep(1, framework$N_smp)
    }
    else {
        weight_smp <- framework$smp_data[[as.character(framework$weights)]]
    }
    betas <- model_par$betas
    sigmae2est <- model_par$sigmae2est
    sigmau2est <- model_par$sigmau2est
    rand_eff <- model_par$rand_eff
    rand_eff_h <- model_par$rand_eff_h
    gamma_sub <- NULL
    if (any(framework$weights_type %in% c("nlme", "nlme_lambda", 
        "hybrid2", NULL)) | is.null(framework$weights)) {
        weight_sum <- rep(0, framework$N_dom_smp)
        sums <- aggregate(data.frame(weight_smp, weight_smp^2), 
            by = list(framework$smp_domains_vec), FUN = sum)
        delta2 <- sums[, 3]/sums[, 2]^2
        gamma <- model_par$sigmau2est/(model_par$sigmau2est + 
            ((model_par$sigmae2est + model_par$sigmah2est) * 
                delta2))
        if (model_par$sigmah2est > 0) {
            sums_sub <- aggregate(data.frame(weight_smp, weight_smp^2)[framework$smp_subdomains_vec, 
                ], by = list(framework$smp_subdomains_vec), FUN = sum)
            sums_sub <- sums_sub[framework$dist_obs_smp_subdom, 
                ]
            delta2_sub <- sums_sub[, 3]/sums_sub[, 2]^2
            gamma_sub <- model_par$sigmah2est/(model_par$sigmah2est + 
                model_par$sigmae2est * delta2_sub)
        }
        if (!is.null(framework$weights_type)) {
            if (framework$weights_type == "hybrid2") {
                newbetas <- update_beta_re(model_par = model_par, 
                  weight_smp = weight_smp, framework = framework, 
                  dep_var = dep_var, fixed = fixed)
                betas <- newbetas$betas
                gamma <- newbetas$gamma
                rand_eff <- newbetas$rand_eff
                rand_eff_h <- newbetas$rand_eff_h
                updated_sigma2 <- update_sigma2(dep_var = dep_var, 
                  betas = betas, weight_smp = weight_smp, framework = framework, 
                  rand_eff = rand_eff, fixed = fixed)
                sigmau2est <- updated_sigma2$sigmau2est
                sigmae2est <- updated_sigma2$sigmae2est
            }
        }
    }
    else if (!is.null(framework$weights_type)) {
        if (framework$weights_type == "hybrid") {
            newbetas <- update_beta_re(model_par = model_par, 
                weight_smp = weight_smp, framework = framework, 
                dep_var = dep_var, fixed = fixed)
            betas <- newbetas$betas
            gamma <- newbetas$gamma
            rand_eff <- newbetas$rand_eff
            rand_eff_h <- newbetas$rand_eff_h
            updated_sigma2 <- update_sigma2(dep_var = dep_var, 
                betas = betas, weight_smp = weight_smp, framework = framework, 
                rand_eff = rand_eff, fixed = fixed)
            sigmau2est <- updated_sigma2$sigmau2est
            sigmae2est <- updated_sigma2$sigmae2est
        }
        else if (framework$weights_type == "Guadarrama") {
            weight_sum <- rep(0, framework$N_dom_smp)
            mean_dep <- rep(0, framework$N_dom_smp)
            mean_indep <- matrix(0, nrow = framework$N_dom_smp, 
                ncol = length(betas))
            delta2 <- rep(0, framework$N_dom_smp)
            gamma <- rep(0, framework$N_dom_smp)
            num <- matrix(0, nrow = length(betas), ncol = 1)
            den <- matrix(0, nrow = length(betas), ncol = length(betas))
            for (d in 1:framework$N_dom_smp) {
                domain <- names(table(framework$smp_domains_vec)[d])
                dep_smp <- dep_var[framework$smp_domains_vec == 
                  domain]
                weight_smp <- framework$smp_data[[as.character(framework$weights)]][framework$smp_domains_vec == 
                  domain]
                weight_sum[d] <- sum(weight_smp)
                if (length(weight_smp) == 1) {
                  indep_smp <- matrix(model.matrix(fixed, framework$smp_data)[framework$smp_domains_vec == 
                    domain, ], ncol = length(betas), nrow = 1)
                }
                else {
                  indep_smp <- model.matrix(fixed, framework$smp_data)[framework$smp_domains_vec == 
                    domain, ]
                }
                mean_dep[d] <- sum(weight_smp * dep_smp)/weight_sum[d]
                for (k in 1:length(betas)) {
                  mean_indep[d, k] <- sum(weight_smp * indep_smp[, 
                    k])/weight_sum[d]
                }
                delta2[d] <- sum(weight_smp^2)/(weight_sum[d]^2)
                gamma[d] <- model_par$sigmau2est/(model_par$sigmau2est + 
                  model_par$sigmae2est * delta2[d])
                weight_smp_diag <- diag(x = weight_smp, nrow = length(weight_smp), 
                  ncol = length(weight_smp))
                dep_var_ast <- dep_smp - gamma[d] * mean_dep[d]
                indep_weight <- t(indep_smp) %*% weight_smp_diag
                a <- matrix(rep(gamma[d] * mean_indep[d, ], framework$n_smp[d]), 
                  nrow = framework$n_smp[d], byrow = TRUE)
                indep_var_ast <- indep_smp - matrix(rep(gamma[d] * 
                  mean_indep[d, ], framework$n_smp[d]), nrow = framework$n_smp[d], 
                  byrow = TRUE)
                num <- num + (indep_weight %*% dep_var_ast)
                den <- den + (indep_weight %*% indep_var_ast)
            }
            betas <- solve(den) %*% num
            rand_eff <- rep(0, framework$N_dom_pop)
            rand_eff[framework$dist_obs_dom] <- gamma * (mean_dep - 
                mean_indep %*% betas)
        }
    }
    framework$pop_data[[paste0(fixed[2])]] <- seq_len(nrow(framework$pop_data))
    X_pop <- model.matrix(fixed, framework$pop_data)
    mu_fixed <- X_pop %*% betas
    sigmav2est <- sigmau2est * (1 - gamma)
    rand_eff_pop <- rep(rand_eff, framework$n_pop)
    X_smp <- model.matrix(fixed, framework$smp_data)
    e0 <- dep_var - X_smp %*% betas
    e2 <- NULL
    if (model_par$sigmah2est == 0) {
        mu <- mu_fixed + rand_eff_pop
        sigmai2est <- 0
        e1 <- e0 - rep(rand_eff[framework$dist_obs_dom], framework$n_smp)
    }
    else {
        sigmai2est <- model_par$sigmah2est * (1 - gamma_sub)
        rand_eff_h_pop <- rep(rand_eff_h, framework$n_pop_subdom)
        mu <- mu_fixed + rand_eff_pop + rand_eff_h_pop
        e1 <- e0 - rep(rand_eff[framework$dist_obs_dom], framework$n_smp)
        e2 <- e1 - rep(model_par$rand_eff_h_smp, framework$n_smp_subdom)
    }
    return(list(betas = betas, sigmau2est = sigmau2est, sigmae2est = sigmae2est, 
        sigmav2est = sigmav2est, sigmai2est = sigmai2est, mu = mu, 
        mu_fixed = mu_fixed, rand_eff = rand_eff, gamma = gamma, 
        gamma_sub = gamma_sub, e0 = e0, e1 = e1, e2 = e2))
}
gen_model_hdp <-
function (fixed, framework, model_par) 
{
    gamma <- model_par$sigmau2est/(model_par$sigmau2est + model_par$sigmae2est/framework$n_smp)
    sigmav2est <- model_par$sigmau2est * (1 - gamma)
    rand_eff_pop <- rep(model_par$rand_eff, framework$n_pop)
    framework$pop_data[[paste0(fixed[2])]] <- seq_len(nrow(framework$pop_data))
    X_pop <- model.matrix(fixed, framework$pop_data)
    mu_fixed <- vector(length = framework$N_pop)
    betas_in <- apply(model_par$betas, 1, rep, framework$n_pop[framework$dist_obs_dom])
    mu_fixed[framework$obs_dom] <- diag(X_pop[framework$obs_dom, 
        ] %*% t(betas_in))
    if (framework$N_dom_unobs > 0) {
        betas_out <- apply(model_par$betas.out, 1, rep, framework$n_pop[!framework$dist_obs_dom])
        mu_fixed[!framework$obs_dom] <- diag(X_pop[!framework$obs_dom, 
            ] %*% t(betas_out))
    }
    mu <- mu_fixed + rand_eff_pop
    return(list(sigmav2est = sigmav2est, mu = mu, mu_fixed = mu_fixed))
}
generic_opt <-
function (lambda, fixed, smp_data, smp_domains, transformation, 
    framework) 
{
    optimization <- if (TRUE) {
        reml(fixed = fixed, smp_data = smp_data, smp_domains = smp_domains, 
            transformation = transformation, lambda = lambda, 
            framework = framework)
    }
    return(optimization)
}
generic_opt_ell <-
function (lambda, fixed, smp_data, smp_domains, transformation, 
    framework) 
{
    optimization <- if (TRUE) {
        ml_plm(fixed = fixed, smp_data = smp_data, smp_domains = smp_domains, 
            transformation = transformation, lambda = lambda, 
            framework = framework)
    }
    return(optimization)
}
geometric.mean <-
function (x) 
{
    exp(mean(log(x)))
}
getBootFun2 <-
function (calibrate, fun, envir, indicator_name) 
{
    if (calibrate) {
        function(x, i, threshold, aux, totals, rs, envir, indicator_name, 
            ...) {
            x <- x[i, , drop = FALSE]
            aux <- aux[i, , drop = FALSE]
            g <- calibWeights(aux, x$weight, totals, ...)
            x$weight <- g * x$weight
            fun(x, threshold, rs, envir, indicator_name)
        }
    }
    else {
        function(x, i, threshold, aux, totals, rs, envir, indicator_name, 
            ...) {
            x <- x[i, , drop = FALSE]
            fun(x, threshold, rs, envir, indicator_name)
        }
    }
}
getData.direct <-
function (object, ...) 
{
    throw_class_error(object, "direct")
    object$framework$smp_data
}
getData.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    if (object$transformation != "no") {
        message(strwrap(prefix = " ", initial = "", "The untransformed sample data set of the ebp object\n                    is returned."))
    }
    object$framework$smp_data
}
getData.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    message(strwrap(prefix = " ", initial = "", "The combined data set (combined_data) of the fh object\n                  is returned."))
    object$framework$combined_data
}
getFun2 <-
function (byDomain, direct_estimator, envir, indicator_name) 
{
    if (byDomain) {
        function(x, threshold, rs, envir, indicator_name) {
            if (inherits(threshold, "function")) {
                threshold <- threshold(x$y, x$weight)
            }
            value <- direct_estimator(x$y, x$weight, threshold)
            valueByDomain <- vapply(rs, function(r, x, t, evir) {
                i <- x$Domain == r
                if (!sum(i) > 0) {
                  assign("warnlist", c(get("warnlist", envir = envir), 
                    paste0(as.character(r), ":_:", indicator_name)), 
                    envir = envir)
                  NA
                }
                else {
                  direct_estimator(x$y[i], x$weight[i], threshold)
                }
            }, numeric(1), x = x)
            c(value, valueByDomain)
        }
    }
    else {
        function(x, threshold, rs, na.rm, envir) {
            if (inherits(threshold, "function")) {
                threshold <- threshold(x$y, x$weight)
            }
            direct_estimator(x$y, x$weight, threshold)
        }
    }
}
getGroups.direct <-
function (object, ...) 
{
    throw_class_error(object, "direct")
    object$framework$smp_domains_vec
}
getGroups.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    object$framework$smp_domains_vec
}
getGroups.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    object$ind$Domain
}
getGroupsFormula.direct <-
function (object, ...) 
{
    throw_class_error(object, "direct")
    eval(parse(text = paste("~", object$framework$smp_domains)))
}
getGroupsFormula.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    eval(parse(text = paste("~", object$framework$smp_domains)))
}
getGroupsFormula.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    eval(parse(text = paste("~", object$framework$domains)))
}
getIndicatorList_fixed <-
function () 
{
    list(mean_wrap = function(y, weights, threshold) {
        weighted.mean(x = y, w = weights)
    }, hcr_wrap = function(y, weights, threshold) {
        sw <- sum(weights)
        sum(weights[y < threshold])/sw
    }, pgap_wrap = function(y, weights, threshold) {
        sw <- sum(weights)
        sum(weights * (y < threshold) * (threshold - y)/threshold)/sw
    }, gini_wrap = function(y, weights, threshold) {
        ord <- order(y)
        y <- y[ord]
        weights <- weights[ord]
        wy <- weights * y
        sw <- sum(weights)
        cw <- cumsum(weights)
        ((2 * sum(wy * cw) - sum(weights^2 * y))/(sw * sum(wy)) - 
            1)
    }, qsr_wrap = function(y, weights, threshold) {
        quant14 <- wtd.quantile(x = y, weights = weights, probs = c(0.20000000000000001, 
            0.80000000000000004))
        iq1 <- y <= quant14[1]
        iq4 <- y > quant14[2]
        (sum(weights[iq4] * y[iq4])/sum(weights[iq4]))/(sum(weights[iq1] * 
            y[iq1])/sum(weights[iq1]))
    }, quant10_wrap = function(y, weights, threshold) {
        wtd.quantile(x = y, weights = weights, probs = 0.10000000000000001)
    }, quant25_wrap = function(y, weights, threshold) {
        wtd.quantile(x = y, weights = weights, probs = 0.25)
    }, quant50_wrap = function(y, weights, threshold) {
        wtd.quantile(x = y, weights = weights, probs = 0.5)
    }, quant75_wrap = function(y, weights, threshold) {
        wtd.quantile(x = y, weights = weights, probs = 0.75)
    }, quant90_wrap = function(y, weights, threshold) {
        wtd.quantile(x = y, weights = weights, probs = 0.90000000000000002)
    })
}
getResponse.direct <-
function (object, ...) 
{
    throw_class_error(object, "direct")
    object$framework$smp_data[, object$call$y]
}
getResponse.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    makeXY(object$fixed, object$framework$smp_data)$y
}
getResponse.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    object$framework$direct
}
getVarCov.ebp <-
function (obj, individuals = 1, type = "random.effects", ...) 
{
    throw_class_error(obj, "ebp")
    if (is.null(type) || !(type == "random.effects" || type == 
        "conditional" || type == "marginal")) {
        stop(strwrap(prefix = " ", initial = "", "The three options for type are ''random.effects'',\n                 ''conditional'' or ''marginal''."))
    }
    getVarCov(obj$model, individuals = individuals, type = type)
}
getVarCov.fh <-
function (obj, individuals = 1, type = "random.effects", ...) 
{
    throw_class_error(obj, "fh")
    if (is.null(type) || !(type == "random.effects" || type == 
        "conditional" || type == "marginal")) {
        stop(strwrap(prefix = " ", initial = "", "The three options for type are ''random.effects'',\n                 ''conditional'' or ''marginal''."))
    }
    if (type == "random.effects") {
        if (obj$model$correlation == "spatial") {
            result <- list(varmat = matrix(obj$model$variance$variance, 
                nrow = 1, ncol = 1, dimnames = list(c("(Intercept)"), 
                  c("(Intercept)"))), std.dev = sqrt(obj$model$variance$variance))
        }
        else {
            result <- list(varmat = matrix(obj$model$variance, 
                nrow = 1, ncol = 1, dimnames = list(c("(Intercept)"), 
                  c("(Intercept)"))), std.dev = sqrt(obj$model$variance))
        }
        class(result) <- c("getVarCov.fh", "VarCov_random")
    }
    else {
        result <- list()
        for (i in individuals) {
            if (!(is.numeric(i) || is.character(i))) {
                stop("individuals must be numeric or a character specifying a level of\n             a in-sample domain.")
            }
            if (is.numeric(i)) {
                i <- as.character(obj$ind$Domain[obj$ind$Out == 
                  0][i])
            }
            if (!(i %in% obj$ind$Domain[obj$ind$Out == 0])) {
                stop(strwrap(prefix = " ", initial = "", paste0("No variance-covariance matrix is available.\n                            Individual '", 
                  i, "' is not contained in the sample\n                            and therefore not used for the model fitting.")))
            }
            if (type == "conditional") {
                D <- diag(1, obj$framework$N_dom_smp)
                if (obj$method$method == "me") {
                  Beta.hat.tCiBeta.hat <- NULL
                  for (j in seq_len(obj$framework$N_dom_smp)) {
                    Beta.hat.tCiBeta.hat[j] <- t(obj$model$coefficients$coefficients) %*% 
                      obj$framework$Ci[, , j] %*% obj$model$coefficients$coefficients
                  }
                  V <- matrix(diag(obj$framework$vardir) + diag(as.numeric(Beta.hat.tCiBeta.hat)), 
                    nrow = obj$framework$N_dom_smp, ncol = obj$framework$N_dom_smp, 
                    dimnames = list(obj$ind$Domain[obj$ind$Out == 
                      0], obj$ind$Domain[obj$ind$Out == 0]))
                  result[[as.character(i)]] <- list(varmat = matrix(V[i, 
                    i], nrow = 1, ncol = 1, dimnames = list(c("1"), 
                    c("1"))), std.dev = sqrt(V[i, i]), domain = i)
                }
                else {
                  V <- matrix(diag(obj$framework$vardir), nrow = obj$framework$N_dom_smp, 
                    ncol = obj$framework$N_dom_smp, dimnames = list(obj$ind$Domain[obj$ind$Out == 
                      0], obj$ind$Domain[obj$ind$Out == 0]))
                  result[[as.character(i)]] <- list(varmat = matrix(V[i, 
                    i], nrow = 1, ncol = 1, dimnames = list(c("1"), 
                    c("1"))), std.dev = sqrt(V[i, i]), domain = i)
                }
                class(result) <- c("getVarCov.fh", "VarCov_conditional")
            }
            else if (type == "marginal") {
                D <- diag(1, obj$framework$N_dom_smp)
                if (obj$model$correlation == "spatial") {
                  Wt <- t(obj$framework$W)
                  A <- solve((D - obj$model$variance$correlation * 
                    Wt) %*% (D - obj$model$variance$correlation * 
                    obj$framework$W))
                  G <- obj$model$variance$variance * A
                  V <- matrix(G + D * obj$framework$vardir, nrow = obj$framework$N_dom_smp, 
                    ncol = obj$framework$N_dom_smp, dimnames = list(obj$ind$Domain[obj$ind$Out == 
                      0], obj$ind$Domain[obj$ind$Out == 0]))
                  result[[as.character(i)]] <- list(varmat = matrix(V[i, 
                    i], nrow = 1, ncol = 1, dimnames = list(c("1"), 
                    c("1"))), std.dev = sqrt(V[i, i]), domain = i, 
                    correlation = "spatial")
                }
                else if (obj$method$method == "me") {
                  Beta.hat.tCiBeta.hat <- NULL
                  for (j in seq_len(obj$framework$N_dom_smp)) {
                    Beta.hat.tCiBeta.hat[j] <- t(obj$model$coefficients$coefficients) %*% 
                      obj$framework$Ci[, , j] %*% obj$model$coefficients$coefficients
                  }
                  V <- matrix(obj$model$variance * D %*% t(D) + 
                    diag(obj$framework$vardir) + diag(as.numeric(Beta.hat.tCiBeta.hat)), 
                    nrow = obj$framework$N_dom_smp, ncol = obj$framework$N_dom_smp, 
                    dimnames = list(obj$ind$Domain[obj$ind$Out == 
                      0], obj$ind$Domain[obj$ind$Out == 0]))
                  result[[as.character(i)]] <- list(varmat = matrix(V[i, 
                    i], nrow = 1, ncol = 1, dimnames = list(c("1"), 
                    c("1"))), std.dev = sqrt(V[i, i]), domain = i, 
                    correlation = "no")
                }
                else {
                  V <- matrix(obj$model$variance * D %*% t(D) + 
                    diag(as.numeric(obj$framework$vardir)), nrow = obj$framework$N_dom_smp, 
                    ncol = obj$framework$N_dom_smp, dimnames = list(obj$ind$Domain[obj$ind$Out == 
                      0], obj$ind$Domain[obj$ind$Out == 0]))
                  result[[as.character(i)]] <- list(varmat = matrix(V[i, 
                    i], nrow = 1, ncol = 1, dimnames = list(c("1"), 
                    c("1"))), std.dev = sqrt(V[i, i]), domain = i, 
                    correlation = "no")
                }
                class(result) <- c("getVarCov.fh", "VarCov_marginal")
            }
        }
    }
    result
}
get_polygone <-
function (values) 
{
    if (is.null(dim(values))) {
        values <- as.data.frame(values)
    }
    n <- nrow(values)
    cols <- ceiling(sqrt(n))
    n <- cols^2
    values["id"] <- seq_len(nrow(values))
    poly <- data.frame(id = rep(seq_len(n), each = 4), ordering = seq_len((n * 
        4)), x = c(0, 1, 1, 0) + rep(0:(cols - 1), each = (cols * 
        4)), y = rep(c(0, 0, 1, 1) + rep(0:(cols - 1), each = 4), 
        cols))
    combo <- merge(poly, values, by = "id", all = TRUE, sort = FALSE)
    melt(combo[order(combo$ordering), ], id.vars = c("id", "x", 
        "y", "ordering"))
}
get_scale_points <-
function (y, ind, scale_points) 
{
    result <- NULL
    if (!is.null(scale_points)) {
        if (is.numeric(scale_points) && length(scale_points) == 
            2) {
            result <- scale_points
        }
        else {
            splt <- strsplit(ind, "_\\s*(?=[^_]+$)", perl = TRUE)[[1]]
            indicator_name <- splt[1]
            if (length(splt) == 2) {
                measure <- splt[2]
            }
            else {
                measure <- "ind"
            }
            if (indicator_name %in% names(scale_points)) {
                pointset <- scale_points[[indicator_name]]
                try(result <- pointset[[measure]])
            }
            if (is.null(result) || length(result) != 2) {
                warning(strwrap(prefix = " ", initial = "", "scale_points is of no apropriate form, default values\n                        will be used. See the descriptions and examples for\n                        details"))
                result <- NULL
            }
        }
    }
    if (is.null(result)) {
        rg <- range(y, na.rm = TRUE)
        result <- rg
    }
    return(result)
}
gridfitinter <-
function (y, expectile, Q) 
{
    nq <- length(Q)
    diff <- y %*% t(as.matrix(rep(1, nq))) - expectile
    vectordest <- apply(diff, 1, zerovalinter, Q)
}
hdp <-
function (fixed, pop_data, pop_domains, smp_data, smp_domains, 
    L = 50, threshold = NULL, transformation = "box.cox", interval = "default", 
    MSE = FALSE, B = 50, na.rm = FALSE, weights = NULL, pop_weights = NULL, 
    aggregate_to = NULL, custom_indicator = NULL, benchmark = NULL, 
    benchmark_type = "ratio", benchmark_weights = NULL, Q = sort(c(seq(0.0060000000000000001, 
        0.98999999999999999, 0.044999999999999998), 0.5, 0.99399999999999999, 
        0.01, 0.02, 0.95999999999999996, 0.97999999999999998)), 
    method = c("LBP"), tol = 9.9999999999999995e-07, maxit = 100, 
    k_b = 1.345, k_sigma_u = 2.5, k_sigma_e = 2.5) 
{
    hdp_check1(fixed = fixed, pop_data = pop_data, pop_domains = pop_domains, 
        smp_data = smp_data, smp_domains = smp_domains, L = L)
    hdp_check2(threshold = threshold, transformation = transformation, 
        interval = interval, MSE = MSE, B = B, L = L, custom_indicator = custom_indicator, 
        na.rm = na.rm, weights = weights, pop_weights = pop_weights, 
        benchmark = benchmark, benchmark_type = benchmark_type, 
        benchmark_level = benchmark_level, benchmark_weights = benchmark_weights)
    call <- match.call()
    if (inherits(call$fixed, "name")) {
        call$fixed <- fixed
    }
    if (is.null(benchmark_weights) & !is.null(weights)) {
        benchmark_weights <- "benchmark_weights"
        smp_data$benchmark_weights <- smp_data[[weights]]
    }
    framework <- framework_hdp(fixed = fixed, pop_data = pop_data, 
        pop_domains = pop_domains, smp_data = smp_data, smp_domains = smp_domains, 
        threshold = threshold, na.rm = na.rm, aggregate_to = aggregate_to, 
        weights = weights, pop_weights = pop_weights, custom_indicator = custom_indicator, 
        Q = Q, method = method, tol = tol, maxit = maxit, k_b = k_b, 
        k_sigma_u = k_sigma_u, k_sigma_e = k_sigma_e)
    point_estim <- point_estim_hdp(framework = framework, fixed = fixed, 
        transformation = transformation, interval = interval, 
        L = L, keep_data = TRUE, Ydump = Ydump)
    if (!is.null(benchmark)) {
        if (is.null(benchmark_level)) {
            point_estim$ind <- benchmark_ebp_national(point_estim = point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type)
        }
        else {
            point_estim$ind <- benchmark_ebp_level(point_estim = point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        }
        if (any(names(point_estim$ind) %in% c("Mean_bench"))) {
            if (any(is.na(point_estim$ind$Mean_bench))) {
                message(strwrap(prefix = " ", initial = "", "Benchmark point estimates for\n                          Mean contain missing values. Please check source data"))
            }
        }
        if (any(names(point_estim$ind) %in% c("Head_Count_bench"))) {
            if (any(is.na(point_estim$ind$Head_Count_bench))) {
                message(strwrap(prefix = " ", initial = "", "Benchmark point estimates for\n                          Head_Count contain missing values. Please check source data"))
            }
            else if (!all(point_estim$ind$Head_Count_bench >= 
                0 & point_estim$ind$Head_Count_bench <= 1)) {
                message(strwrap(prefix = " ", initial = "", "Please note that benchmark point estimates for\n                          Head_Count are outside the expected range [0,1]."))
            }
        }
    }
    if (MSE == TRUE) {
        mse_estimates <- parametric_bootstrap_hdp(framework = framework, 
            point_estim = point_estim, fixed = fixed, transformation = transformation, 
            interval = interval, L = L, B = B, benchmark = benchmark, 
            benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        hdp_out <- list(ind = point_estim$ind, MSE = mse_estimates, 
            transform_param = point_estim[c("optimal_lambda", 
                "shift_par")], model = point_estim$model, model.out = point_estim$model.out, 
            model_par = point_estim$model_par, framework = framework[c("N_dom_unobs", 
                "N_dom_smp", "N_smp", "N_pop", "smp_domains", 
                "smp_data", "smp_domains_vec", "pop_domains_vec")], 
            transformation = transformation, method = "reml", 
            fixed = fixed, call = call, successful_bootstraps = NULL)
    }
    else {
        hdp_out <- list(ind = point_estim$ind, MSE = NULL, transform_param = point_estim[c("optimal_lambda", 
            "shift_par")], model = point_estim$model, model.out = point_estim$model.out, 
            model_par = point_estim$model_par, framework = framework[c("N_dom_unobs", 
                "N_dom_smp", "N_smp", "N_pop", "smp_domains", 
                "smp_data", "smp_domains_vec", "pop_domains_vec")], 
            transformation = transformation, method = "reml", 
            fixed = fixed, call = call, successful_bootstraps = NULL)
    }
    class(hdp_out) <- c("hdp", "povmap")
    return(hdp_out)
}
hdp_check1 <-
function (fixed, pop_data, pop_domains, smp_data, smp_domains, 
    L) 
{
    if (is.null(fixed) || !inherits(fixed, "formula")) {
        stop("Fixed must be a formula object. See also help(ebp).")
    }
    if (!is.data.frame(pop_data)) {
        stop(strwrap(prefix = " ", initial = "", "Pop_data must be a data frame containing population data.\n                 See also help(ebp)."))
    }
    if (!is.character(pop_domains) || length(pop_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Pop_domains must be a vector of lenght 1 and of class\n                 character specifying the variable name of a numeric or factor\n                 variable indicating domains in the population data. See also\n                 help(ebp)."))
    }
    if (!is.data.frame(smp_data)) {
        stop(strwrap(prefix = " ", initial = "", "Smp_data must be a data frame containing sample data.\n                 See also help(ebp)."))
    }
    if (!is.character(smp_domains) || length(smp_domains) != 
        1) {
        stop(strwrap(prefix = " ", initial = "", "Smp_domains must be a vector of lenght 1 and of class\n                 character specifying the variable (name)  of a numeric or\n                 factor variable indicating domains in the sample data. See\n                 also help(ebp)."))
    }
    if (!is.numeric(L) || length(L) != 1 || L < 0) {
        stop(strwrap(prefix = " ", initial = "", "L needs to be a single value, interpreted as an integer,\n                 determining the number of Monte-Carlo simulations. The value\n                 must be at least 0. See also help(ebp)."))
    }
    if (!all(unique(as.character(smp_data[[smp_domains]])) %in% 
        unique(as.character(pop_data[[pop_domains]])))) {
        stop(strwrap(prefix = " ", initial = "", "The sample data contains domains that are not contained in the\n                population data."))
    }
}
hdp_check2 <-
function (threshold, transformation, interval, MSE, B, L, custom_indicator, 
    na.rm, weights, pop_weights, benchmark, benchmark_type, benchmark_level, 
    benchmark_weights) 
{
    if (!is.null(threshold) && !(is.numeric(threshold) && length(threshold) == 
        1) && !inherits(threshold, "function")) {
        stop(strwrap(prefix = " ", initial = "", "threshold needs to be a single numeric value or a function\n                 of y. If it is NULL 60% of the median is selected as threshold.\n                 See also help(ebp)."))
    }
    if (inherits(threshold, "function") && !all(attributes(formals(threshold))$names == 
        c("y"))) {
        stop(strwrap(prefix = " ", initial = "", "If threshold is a function the argument needs to be y and\n                 only y. Also a single numeric value is possible as threshold.\n                 If it is NULL 60% of the median of the target variable is\n                 selected as threshold. See also help(ebp)."))
    }
    if (is.null(transformation) || !(transformation == "box.cox" || 
        transformation == "log" || transformation == "dual" || 
        transformation == "log.shift" || transformation == "no" || 
        transformation == "ordernorm" || transformation == "arcsin")) {
        stop(strwrap(prefix = " ", initial = "", "The seven options for transformation are no', log,\n                 'box.cox', dual', log.shift', 'ordernorm', and\n                 'arcsin'."))
    }
    if (L == 0 && !(transformation == "no" || transformation == 
        "arcsin" | transformation == "log" | transformation == 
        "log.shift")) {
        stop(strwrap(prefix = " ", initial = "", "Analytic calculations not supported with transformations other than log, log shift, and arcsin at this time"))
    }
    if (any(interval != "default") & (!is.vector(interval, mode = "numeric") || 
        length(interval) != 2 || !(interval[1] < interval[2]))) {
        stop(strwrap(prefix = " ", initial = "", "interval needs to be a numeric vector of length 2 defining a\n                 lower and upper limit for the estimation of the optimal\n                 transformation parameter. The value of the lower limit needs\n                 to be smaller than the upper limit. You can also choose\n                 'default'. See also help(ebp)."))
    }
    if (transformation == "dual" & any(interval < 0)) {
        stop(strwrap(prefix = " ", initial = "", "For the dual transformation, lambda needs to be positive, so\n                 the lower limit of the interval cannot be negative. See also\n                 help(ebp)."))
    }
    if (!is.logical(MSE) || length(MSE) != 1) {
        stop(strwrap(prefix = " ", initial = "", "MSE must be a logical value. Set MSE to TRUE or FALSE. See\n                 also help(ebp)."))
    }
    if (MSE == TRUE && !(is.numeric(B) && length(B) == 1 && B > 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "If MSE is set to TRUE, a single numeric value for the number\n                 of bootstrap sample needs to be chosen that is greater than 1.\n                 See also help(ebp)."))
    }
    if (!is.null(custom_indicator)) {
        if (!inherits(custom_indicator, "list")) {
            stop(strwrap(prefix = " ", initial = "", "Additional indicators need to be added in argument\n                   custom_indicator as a list of functions. For help see\n                   Example 2 in help(ebp)."))
        }
        N_custom <- length(custom_indicator)
        for (i in seq_len(N_custom)) {
            if (!is.null(pop_weights)) {
                if (!all(c("y", "pop_weights") %in% names(formals(custom_indicator[[i]])))) {
                  stop(strwrap(prefix = " ", initial = "", "Please provide the argument pop_weights to the your\n                     custom_indicator. All other indicators will be\n                     calculated using population weights."))
                }
            }
            if (!inherits(custom_indicator[[i]], "function")) {
                stop(strwrap(prefix = " ", initial = "", "The elements of the list need to be functions. These\n                     functions for custom indicators need to have the\n                     argument y and optional the agruments pop_weights and\n                     threshold. For help see Example 2 in help(ebp)."))
            }
            else if (inherits(custom_indicator[[i]], "function") && 
                !all(names(formals(custom_indicator[[i]])) %in% 
                  c("y", "pop_weights", "threshold"))) {
                stop(strwrap(prefix = " ", initial = "", "Functions for custom indicators need to have exactly the\n                     following argument y and optional the arguments\n                     pop_weights, threshold. For help see Example 2 in\n                     help(ebp)."))
            }
        }
    }
    if (!(inherits(na.rm, "logical") && length(na.rm) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "na.rm needs to be a logical value. Set na.rm to TRUE or FALSE.\n                 See also help(ebp)."))
    }
    if (is.character(weights) && length(weights) != 1 || !is.character(weights) && 
        !is.null(weights)) {
        stop(strwrap(prefix = " ", initial = "", "Weights must be a vector of length 1 and of class character\n                 specifying the variable name of a numeric variable indicating\n                 weights in the sample data. See also help(ebp)."))
    }
    if (is.character(pop_weights) && length(pop_weights) != 1 || 
        !is.character(pop_weights) && !is.null(pop_weights)) {
        stop(strwrap(prefix = " ", initial = "", "Pop_weights must be a vector of length 1 and of class\n                 character specifying the variable name of a numeric variable\n                 indicating weights in the population data. See also\n                 help(ebp)."))
    }
    if (!is.null(benchmark)) {
        if (!(is.numeric(benchmark) || is.character(benchmark) || 
            is.data.frame(benchmark))) {
            stop(strwrap(prefix = " ", initial = "", "For fixed value: Benchmark must be a named vector\n                   containing the numeric benchmark value(s) and is of class\n                   numeric. The names of the vector matchs to the chosen\n                   indicators. \n For survey values: Benchmark must be a\n                   vector of class character containing the names of the chosen\n                   indicators."))
        }
        if (is.numeric(benchmark)) {
            if (!length(benchmark) %in% 1:2) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the length of benchmark must be 1 or 2. The names of this\n                     vector indicates whether the Mean, the Head_Count, or\n                     both in which order are supplied."))
            }
            if (is.null(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Please provide\n                     names."))
            }
            if (!length(benchmark) == length(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Each numeric must\n                     be labeled. Therefore, benchmark and names(benchmark) have\n                     the same length."))
            }
            if (!all(names(benchmark) %in% c("Mean", "Head_Count"))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a named vector containing the numeric\n                     benchmark value(s) and is of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names must match with 'Mean' and 'Head_Count'."))
            }
            if (!is.null(benchmark_weights)) {
                stop(strwrap(prefix = " ", initial = "", "For external benchmarking no benchmark weights can be\n                     used."))
            }
        }
        if (is.character(benchmark)) {
            if (!length(benchmark) %in% 1:2) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a vector of class character containing\n                     the names of the chosen indicators. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the length of benchmark must be 1 or 2. The vector\n                     indicates whether the Mean, the Head_Count, or both in\n                     which order are supplied."))
            }
            if (!all(benchmark %in% c("Mean", "Head_Count"))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a vector of class character containing\n                     the names of the chosen indicators. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     it must match with 'Mean' and 'Head_Count'."))
            }
            if (is.null(weights)) {
                stop(strwrap(prefix = " ", initial = "", "The argument benchmark indicates that it is benchmarked\n                     with the survey data. Please provide weights through the\n                     argument weights."))
            }
        }
        if (is.data.frame(benchmark)) {
            if (is.null(benchmark_level)) {
                stop(strwrap(prefix = " ", initial = "", "As the input in benchmark is a data.frame. Fixed benchmark\n                     values are used at a lower level. Please give the name\n                     of this variable in the sample and population data\n                     by the argument benchmark_level."))
            }
            if (!length(benchmark) %in% 2:3) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count."))
            }
            if (is.null(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. Please provide names."))
            }
            if (!length(benchmark) == length(names(benchmark))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. Each variable in the data.frame must\n                     be labeled."))
            }
            if (!all(names(benchmark)[-1] %in% c("Mean", "Head_Count"))) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. No other names are possible."))
            }
            if (names(benchmark)[1] != benchmark_level) {
                stop(strwrap(prefix = " ", initial = "", "Benchmark must be a data.frame composed of a variable\n                     of class character containing the domain names at which the\n                     benchmarkaing is performed and variable(s) with\n                     benchmark value(s) of class numeric. Benchmarking is\n                     supplied for the Mean and the Head_Count ratio. Therefore,\n                     the names of the data.frame must match for the first\n                     variable the benchmark_level and for the other(s) to Mean\n                     and Head_Count. The name of the first variable indicataing\n                     the domains of the benchmark_level does not match to the\n                     argument benchmark_level."))
            }
            if (!is.null(benchmark_weights)) {
                stop(strwrap(prefix = " ", initial = "", "For external benchmarking no benchmark weights can be\n                     used."))
            }
        }
    }
    if (benchmark_type != "ratio" && benchmark_type != "raking" && 
        benchmark_type != "ratio_complement") {
        stop(strwrap(prefix = " ", initial = "", "The benchmark version of ebp is only available with\n                   'raking', 'ratio', and 'ratio_complement'."))
    }
    if (benchmark_type == "ratio_complement" && (names(benchmark)[-1] %in% 
        "Head_Count") && max(benchmark[["Head_Count"]]) > 1) {
        stop(strwrap(prefix = " ", initial = "", "When benchmarking the headcount rate with ratio_complement, the target values must lie between 0 and 1."))
    }
    if (is.null(benchmark) && benchmark_type != "ratio") {
        stop(strwrap(prefix = " ", initial = "", "A benchmark type is provided, but no benchmark value.\n                   Please provide the argument 'benchmark' within the\n                   function."))
    }
}
head.estimators.povmap <-
function (x, n = 6L, addrownums = NULL, ...) 
{
    head(x$ind, n = n, addrownums = addrownums, ...)
}
icc <-
function (object) 
{
    u <- object$model_par$sigmau2est
    e <- (object$model_par$sigmae2est + object$model_par$sigmah2est)
    u/(u + e)
}
innersum <-
function (i, var, mu, popwt) 
{
    sumj <- weighted.mean(x = (pnorm((rep(mu[i], length(mu)) - 
        mu + var)/sqrt(2 * var)) - 0.5), w = popwt)
    return(sumj)
}
integrand <-
function (x, mean, sd) 
{
    sin(x)^2 * dnorm(x, mean = mean, sd = sd)
}
intervals.ebp <-
function (object, level = 0.94999999999999996, parm = NULL, ...) 
{
    throw_class_error(object, "ebp")
    if (!is.null(parm)) {
        confidence_intervals <- intervals(object$model, level = level)$fixed
        subset(confidence_intervals, rownames(confidence_intervals) %in% 
            parm)
    }
    else {
        intervals(object$model, level = level)$fixed
    }
}
intervals.fh <-
function (object, level = 0.94999999999999996, parm = NULL, ...) 
{
    throw_class_error(object, "fh")
    coefmat <- object$model$coefficients
    coefs <- coefmat[, 1]
    stds <- coefmat[, 2]
    dist <- qnorm(p = (1 - level)/2, 0, stds)
    ret_value <- data.frame(lower = coefs + dist, est. = coefs, 
        upper = coefs + abs(dist), row.names = row.names(coefmat))
    if (is.null(parm)) {
        as.matrix(ret_value)
    }
    else {
        as.matrix(ret_value[parm, ])
    }
}
inv_orderNorm_trans <-
function (orderNorm_obj, new_points_x_t, warn) 
{
    x_t <- orderNorm_obj$x.t
    old_points <- orderNorm_obj$x
    vals <- suppressWarnings(approx(x_t, old_points, xout = new_points_x_t, 
        rule = 1))
    if (any(is.na(vals$y))) {
        if (warn) {
            warning(strwrap(prefix = " ", initial = "", paste0("The ordernom transformation within a Monte Carlo replication\n             requested ", 
                sum(is.na(vals$y)), " values outside the observed\n             domain. Therefore, the logit approx. on ranks is applied.")))
        }
        fit <- orderNorm_obj$fit
        p <- qnorm(fitted(fit, type = "response"))
        l_idx <- vals$x < min(x_t, na.rm = T)
        h_idx <- vals$x > max(x_t, na.rm = T)
        if (any(l_idx)) {
            logits <- log(pnorm(vals$x[l_idx] + min(p, na.rm = T) - 
                min(x_t, na.rm = T))/(1 - pnorm(vals$x[l_idx] + 
                min(p, na.rm = T) - min(x_t, na.rm = T))))
            vals$y[l_idx] <- unname((logits - fit$coef[1])/fit$coef[[2]])
        }
        if (any(h_idx)) {
            logits <- log(pnorm(vals$x[h_idx] + max(p, na.rm = T) - 
                max(x_t, na.rm = T))/(1 - pnorm(vals$x[h_idx] + 
                max(p, na.rm = T) - max(x_t, na.rm = T))))
            vals$y[h_idx] <- unname((logits - fit$coef[1])/fit$coef[[2]])
        }
    }
    vals$y
}
jiang_jackknife <-
function (framework, combined_data, sigmau2, eblup, transformation, 
    vardir, method, interval) 
{
    m <- framework$m
    jack_sigmau2 <- vector(length = m)
    diff_jack_eblups <- data.frame(row.names = seq_len(m))
    diff_jack_g1 <- data.frame(row.names = seq_len(m))
    g1 <- rep(0, framework$m)
    jack_mse <- rep(0, framework$m)
    Vi <- 1/(sigmau2 + framework$vardir)
    Bd <- framework$vardir/(sigmau2 + framework$vardir)
    for (d in seq_len(framework$m)) {
        g1[d] <- framework$vardir[d] * (1 - Bd[d])
    }
    for (domain in seq_len(m)) {
        message("domain =", domain, "\n")
        data_insample <- combined_data[framework$obs_dom, ]
        data_tmp <- data_insample[-domain, ]
        framework_tmp <- framework_FH(combined_data = data_tmp, 
            fixed = framework$formula, vardir = vardir, domains = framework$domains, 
            transformation = transformation, correlation = framework$correlation, 
            corMatrix = framework$corMatrix, eff_smpsize = framework$eff_smpsize, 
            Ci = NULL, tol = NULL, maxit = NULL)
        sigmau2_tmp <- wrapper_estsigmau2(framework = framework_tmp, 
            method = method, interval = interval)
        jack_sigmau2[domain] <- sigmau2_tmp
        Vi_tmp <- 1/(sigmau2_tmp + framework$vardir)
        Bd_tmp <- framework$vardir/(sigmau2_tmp + framework$vardir)
        g1_tmp <- rep(0, framework$m)
        for (d_tmp in seq_len(framework$m)) {
            g1_tmp[d_tmp] <- framework$vardir[d_tmp] * (1 - Bd_tmp[d_tmp])
        }
        diff_jack_g1[, paste0(domain)] <- g1_tmp - g1
        framework_insample <- framework_FH(combined_data = data_insample, 
            fixed = framework$formula, vardir = vardir, domains = framework$domains, 
            transformation = transformation, correlation = framework$correlation, 
            corMatrix = framework$corMatrix, eff_smpsize = framework$eff_smpsize, 
            Ci = NULL, tol = NULL, maxit = NULL)
        eblup_tmp <- eblup_FH(framework = framework_insample, 
            sigmau2 = sigmau2_tmp, combined_data = data_insample)
        diff_jack_eblups[, paste0(domain)] <- eblup_tmp$eblup_data$FH - 
            eblup$eblup_data$FH[eblup$eblup_data$Out == 0]
    }
    jack_mse <- g1 - ((m - 1)/m) * rowSums(diff_jack_g1) + ((m - 
        1)/m) * rowSums(diff_jack_eblups^2)
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- jack_mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that the jackknife MSE is only available for\n                    in-sample domains."))
    }
    mse_out <- list(mse_data = mse_data, MSE_method = "jackknife")
    return(mse_out)
}
jiang_jackknife_yl <-
function (framework, combined_data, sigmau2, eblup, method, transformation, 
    vardir, Ci) 
{
    m <- framework$m
    jack_sigmau2 <- vector(length = m)
    diff_jack_eblups <- data.frame(row.names = seq_len(m))
    diff_jack_g1 <- data.frame(row.names = seq_len(m))
    g1 <- rep(0, framework$m)
    jack_mse <- rep(0, framework$m)
    gamma_tmp <- matrix(0, framework$m, framework$m)
    sigmau2_tmp <- matrix(0, framework$m)
    jack_sigmau2 <- matrix(0, framework$m)
    Bd <- 1 - eblup$gamma
    g1_tmp <- matrix(0, framework$m, framework$m)
    for (d in seq_len(framework$m)) {
        g1[d] <- framework$vardir[d] * (1 - Bd[d])
    }
    for (domain in seq_len(m)) {
        message("domain =", domain, "\n")
        data_insample <- framework$combined_data[framework$obs_dom, 
            ]
        data_tmp <- data_insample[-domain, ]
        Ci_tmp <- Ci[, , -domain]
        framework_tmp <- framework_FH(combined_data = data_tmp, 
            fixed = framework$formula, vardir = vardir, domains = framework$domains, 
            transformation = "no", eff_smpsize = framework$eff_smpsize, 
            correlation = framework$correlation, corMatrix = framework$corMatrix, 
            Ci = Ci_tmp, tol = framework$tol, maxit = framework$maxit)
        sigmau2_tmp <- wrapper_estsigmau2(framework = framework_tmp, 
            method = method)
        jack_sigmau2[domain] <- sigmau2_tmp$sigmau_YL
        framework_insample <- framework_FH(combined_data = data_insample, 
            fixed = framework$formula, vardir = vardir, domains = framework$domains, 
            transformation = "no", eff_smpsize = framework$eff_smpsize, 
            correlation = framework$correlation, corMatrix = framework$corMatrix, 
            Ci = Ci, tol = framework$tol, maxit = framework$maxit)
        Beta.hat.tCiBeta.hat <- NULL
        for (i in seq_len(framework_insample$m)) {
            Beta.hat.tCiBeta.hat[i] <- t(sigmau2_tmp$betahatw) %*% 
                framework_insample$Ci[, , i] %*% sigmau2_tmp$betahatw
        }
        gamma_tmp[, domain] <- (sigmau2_tmp$sigmau_YL + Beta.hat.tCiBeta.hat)/(sigmau2_tmp$sigmau_YL + 
            Beta.hat.tCiBeta.hat + framework_insample$vardir)
        for (d_tmp in seq_len(framework$m)) {
            g1_tmp[d_tmp, ] <- framework$vardir[d_tmp] * gamma_tmp[d_tmp, 
                ]
        }
        diff_jack_g1[, paste0(domain)] <- g1_tmp[, domain] - 
            g1
        eblup_tmp <- eblup_YL(framework = framework_insample, 
            sigmau2 = sigmau2_tmp, combined_data = data_insample)
        diff_jack_eblups[, paste0(domain)] <- eblup_tmp$eblup_data$FH - 
            eblup$eblup_data$FH[eblup$eblup_data$Out == 0]
    }
    jack_mse <- g1 - ((m - 1)/m) * rowSums(diff_jack_g1) + ((m - 
        1)/m) * rowSums(diff_jack_eblups^2)
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- jack_mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that the jackknife MSE is only available for\n                    in-sample domains."))
    }
    mse_out <- list(mse_data = mse_data, MSE_method = "jackknife", 
        g1 = g1, diff_jack_g1 = jack_sigmau2, diff_jack_eblups = diff_jack_eblups)
    return(mse_out)
}
li_lahiri <-
function (framework, sigmau2, combined_data, method) 
{
    prasad_rao <- prasad_rao(framework = framework, sigmau2 = sigmau2, 
        combined_data = combined_data)
    mse <- prasad_rao$FH[framework$obs_dom == TRUE]
    X <- framework$model_X
    psi <- matrix(c(framework$vardir), framework$m, 1)
    Y <- matrix(c(framework$direct), framework$m, 1)
    Z.area <- diag(1, framework$m)
    I <- diag(1, framework$m)
    Bd <- framework$vardir/(sigmau2 + framework$vardir)
    V <- sigmau2 * Z.area %*% t(Z.area) + I * psi[, 1]
    Vi <- solve(V)
    Xt <- t(X)
    XVi <- Xt %*% Vi
    Q <- solve(XVi %*% X)
    P <- Vi - (Vi %*% X %*% Q %*% XVi)
    if (method == "ampl") {
        Bias <- (sum(diag(P - Vi)) + (2/sigmau2))/sum(diag(Vi^2))
        for (d in seq_len(framework$m)) {
            mse[d] <- mse[d] - (Bd[d]^2) * Bias
        }
    }
    else if (method == "amrl") {
        Bias <- (2/sigmau2)/sum(diag(Vi^2))
        for (d in seq_len(framework$m)) {
            mse[d] <- mse[d] - (Bd[d]^2) * Bias
        }
    }
    mse_data <- prasad_rao
    mse_data$FH[framework$obs_dom == TRUE] <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains a correction\n                    following Li and Lahiri (2010) is implemented. For the\n                    out-of-sample domains, no estimate for the MSE is returned.\n                    For the reference see help(fh)."))
    }
    return(mse_data)
}
load_shapeaustria <-
function () 
{
    load(system.file("shapes/shape_austria_dis.rda", package = "povmap"), 
        envir = .GlobalEnv)
}
logLik.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    message(strwrap(prefix = " ", initial = "", paste0("Estimation approach used is reml: ", 
        round(object$model$logLik, 5))))
    invisible(object$model$logLik)
}
logLik.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    if (!is.null(object$model$model_select$loglike)) {
        message(strwrap(prefix = " ", initial = "", paste0("Estimation approach used is ", 
            object$method$method, ":", round(object$model$model_select$loglike, 
                5))))
        invisible(object$model$model_select$loglike)
    }
    else {
        message(paste0("No likelihood is returned for estimation approach ", 
            object$method$method, "."))
    }
}
logLik.plm <-
function (object) 
{
    e = object$residuals
    e2 = object$residuals^2
    tosum <- cbind(e2, rep(1, nobs(object)), e)
    group <- plm:::index.panelmodel(object)
    sum <- aggregate(tosum, by = list(group[, 1]), FUN = sum)
    s2e <- object$ercomp$sigma2[1]
    s2u <- object$ercomp$sigma2[2]
    Ti <- sum[, 3]
    term1 <- (1/s2e) * (sum[, 2] - s2u/(Ti * s2u + s2e) * sum[, 
        4]^2)
    term2 <- log(Ti * s2u/s2e + 1) + Ti * log(2 * pi * s2e)
    ll <- sum(-0.5 * (term1 + term2))
    attr(ll, "df") <- nobs(object) - object$df.residual
    attr(ll, "nobs") <- plm::nobs(object)
    return(ll)
}
log_bt <-
function (framework, sigmau2, combined_data, eblup = eblup, method, 
    MSE, backtransformation) 
{
    log_backtransformed <- if (backtransformation == "bc_crude") {
        bc_crude(framework = framework, sigmau2 = sigmau2, combined_data = combined_data, 
            eblup = eblup, method = method, MSE = MSE)
    }
    else if (backtransformation == "bc_sm") {
        bc_sm(framework = framework, sigmau2 = sigmau2, combined_data = combined_data, 
            eblup = eblup, method = method, MSE = MSE)
    }
    return(log_backtransformed)
}
log_shift_opt <-
function (y, lambda = lambda, shift = NULL) 
{
    with_shift <- function(y, lambda) {
        min <- min(y + lambda)
        if (min <= 0) {
            lambda <- lambda + abs(min) + 1
        }
        else {
            lambda <- lambda
        }
        return(lambda)
    }
    lambda <- with_shift(y = y, lambda = lambda)
    log_trafo <- function(y, lambda = lambda) {
        y <- log(y + lambda)
        return(y)
    }
    yt <- log_trafo(y = y, lambda = lambda)
    return(list(y = yt, shift = NULL))
}
log_shift_opt_back <-
function (y, lambda) 
{
    log_shift_opt_back <- function(y, lambda = lambda) {
        y <- exp(y) - lambda
        return(y = y)
    }
    y <- log_shift_opt_back(y = y, lambda = lambda)
    return(y = y)
}
log_shift_opt_std <-
function (y, lambda) 
{
    with_shift <- function(y, lambda) {
        min <- min(y + lambda)
        if (min <= 0) {
            lambda <- lambda + abs(min(y)) + 1
        }
        else {
            lambda <- lambda
        }
        return(lambda)
    }
    lambda <- with_shift(y = y, lambda = lambda)
    log_trafo_std <- function(y, lambda = lambda) {
        gm <- geometric.mean(y + lambda)
        y <- gm * log(y + lambda)
        return(y)
    }
    y <- log_trafo_std(y = y, lambda = lambda)
    return(y)
}
log_transform <-
function (y, shift = 0) 
{
    min <- min(y)
    if (min <= 0) {
        shift <- abs(min) + 1
        y <- y + shift
    }
    y <- log(y)
    return(list(y = y, shift = shift))
}
log_transform_back <-
function (y, shift = 0) 
{
    y <- exp(y) - shift
    return(y = y)
}
makeXY <-
function (formula, data) 
{
    mf <- model.frame(formula = formula, data = data)
    x <- model.matrix(attr(mf, "terms"), data = mf)
    y <- model.response(mf)
    list(y = y, x = x)
}
map_plot <-
function (object, indicator = "all", MSE = FALSE, var = FALSE, 
    CV = FALSE, map_obj = NULL, map_dom_id = NULL, map_tab = NULL, 
    color = c("white", "red4"), viridis_option = NULL, scale_points = NULL, 
    na.color = "transparent", guide = "colourbar", return_data = FALSE, 
    save_file = NULL, save_format = "pdf") 
{
    if (is.null(map_obj)) {
        message(strwrap(prefix = " ", initial = "", "No Map Object has been\n                    provided. An artificial polygon is used for\n                    visualization"))
        map_pseudo(object = object, indicator = indicator, panelplot = FALSE, 
            MSE = MSE, CV = CV)
    }
    else if (!inherits(x = map_obj, what = "sf")) {
        stop(strwrap(prefix = " ", initial = "", "map_obj is not of class 'sf', 'data.frame'  from the\n                 sf package"))
    }
    else {
        if (length(color) != 2 || !is.vector(color)) {
            stop(strwrap(prefix = " ", initial = "", "col needs to be a vector of length 2 defining the starting,\n                   mid and upper color of the map-plot"))
        }
        plot_real(object, indicator = indicator, MSE = MSE, var = var, 
            CV = CV, map_obj = map_obj, map_dom_id = map_dom_id, 
            map_tab = map_tab, col = color, viridis_option = viridis_option, 
            scale_points = scale_points, return_data = return_data, 
            na.color = na.color, guide = guide, save_format = save_format, 
            save_file = save_file)
    }
}
map_pseudo <-
function (object, indicator, panelplot, MSE, CV) 
{
    x <- y <- id <- value <- NULL
    values <- estimators(object = object, indicator = indicator, 
        MSE = MSE, CV = CV)$ind
    indicator <- colnames(values)[-1]
    tplot <- get_polygone(values = values)
    if (panelplot) {
        ggplot(tplot, aes(x = x, y = y)) + geom_polygon(aes(group = id, 
            fill = value)) + facet_wrap(~variable, ncol = ceiling(sqrt(length(unique(tplot$variable)))))
    }
    else {
        for (ind in indicator) {
            print(ggplot(tplot[tplot$variable == ind, ], aes(x = x, 
                y = y)) + ggtitle(paste0(ind)) + geom_polygon(aes(group = id, 
                fill = value)))
            cat("Press [enter] to continue")
            line <- readline()
        }
    }
}
mapplot_check <-
function (object, map_obj, map_dom_id, map_tab, col, return_data) 
{
    if (!inherits(object, "emdi")) {
        stop("First object needs to be of class emdi.")
    }
    if (!is.null(map_obj) && !(inherits(map_dom_id, "character") && 
        length(map_dom_id) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "A domain ID needs to be given by argument map_dom_id. This\n                 argument  must be a vector of lenght 1 and of class character\n                 specifying the variable (name) in map_obj. Thus, it needs to\n                 be contained in map_obj. See also help(map_plot)."))
    }
    if (!(map_dom_id %in% names(map_obj))) {
        stop(strwrap(prefix = " ", initial = "", paste0(map_dom_id, 
            " is not contained in map_obj. Please\n                        provide valid variable name for pop_domains.")))
    }
    if (length(col) != 2 || !is.vector(col)) {
        stop(strwrap(prefix = " ", initial = "", "col needs to be a vector of length 2 defining the lower and\n                 upper color of the map plot."))
    }
    if (!is.null(map_tab) && !(inherits(map_tab, "data.frame") && 
        dim(map_tab)[2] == 2)) {
        stop(strwrap(prefix = " ", initial = "", "If the IDs in the data object and shape file differ a mapping\n                 table needs to be used. This table needs to be a data frame\n                 with two colums. See also help(map_plot)."))
    }
    if (!(inherits(return_data, "logical") && length(return_data) == 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "return_data needs to be a logical value. Set na.rm to TRUE or\n                 FALSE. See also help(map_plot)."))
    }
}
ml_plm <-
function (fixed = fixed, smp_data = smp_data, smp_domains = smp_domains, 
    transformation = transformation, lambda = lambda, framework = framework) 
{
    sd_transformed_data <- std_data_transformation(fixed = fixed, 
        smp_data = smp_data, transformation = transformation, 
        lambda = lambda)
    model_PLM <- NULL
    weights_arg <- NULL
    if (!is.null(framework$weight)) {
        weights_arg <- framework$smp_data[, framework$weights]
    }
    args <- list(formula = fixed, data = sd_transformed_data, 
        weights = weights_arg, model = "random", index = framework$smp_domains, 
        random.method = framework$random_method)
    try(model_PLM <- do.call(plm:::plm, args), silent = TRUE)
    if (is.null(model_PLM)) {
        stop(strwrap(prefix = " ", initial = "", "The likelihood did not converge when estimating a random effects model to select the optimal\n                 transformation parameter. Try using a non-adapative transformation."))
    }
    else {
        model_PLM <- model_PLM
    }
    log_likelihood <- -logLik.plm(model_PLM)[1]
    return(log_likelihood)
}
model_par <-
function (framework, mixed_model, fixed, transformation_par) 
{
    betas <- nlme::fixed.effects(mixed_model)
    sigmae2est <- mixed_model$sigma^2
    rand_eff <- rep(0, framework$N_dom_pop)
    rand_eff_h <- rep(0, framework$N_subdom_pop)
    rand_eff_h_smp <- NULL
    if (!is.null(framework$smp_subdomains) && !is.null(framework$pop_subdomains)) {
        sigmau2est <- as.numeric(VarCorr(mixed_model)[2, 1])
        sigmah2est <- as.numeric(VarCorr(mixed_model)[4, 1])
        rand_eff[framework$dist_obs_dom] <- random.effects(mixed_model, 
            level = 1)$"(Intercept)"[framework$dist_obs_smp_dom]
        rand_eff_h[framework$dist_obs_subdom] <- random.effects(mixed_model, 
            level = 2)$"(Intercept)"[framework$dist_obs_smp_subdom]
        rand_eff_h_smp <- random.effects(mixed_model, level = 2)$"(Intercept)"
    }
    else {
        sigmau2est <- as.numeric(nlme::VarCorr(mixed_model)[1, 
            1])
        sigmah2est <- 0
        rand_eff[framework$dist_obs_dom] <- (random.effects(mixed_model)[[1]])
    }
    if (framework$model_parameters != "fixed") {
        varFix = mixed_model$varFix
        varErr = lmeInfo:::varcomp_vcov(mixed_model)
    }
    else {
        varFix = NULL
        varErr = NULL
    }
    e0 <- residuals(mixed_model, level = 0)
    return(list(betas = betas, sigmae2est = sigmae2est, sigmah2est = sigmah2est, 
        sigmau2est = sigmau2est, rand_eff = rand_eff, rand_eff_h = rand_eff_h, 
        rand_eff_h_smp = rand_eff_h_smp, varFix = varFix, varErr = varErr, 
        e0 = e0))
}
model_par_ell <-
function (framework, re_model, fixed, transformation_par) 
{
    betas <- re_model$coefficients
    sigmae2est <- re_model$ercomp$sigma2[1]
    sigmau2est <- re_model$ercomp$sigma2[2]
    if (framework$model_parameters != "fixed") {
        varFix <- re_model$vcov
    }
    else {
        varFix = NULL
    }
    residuals <- as.vector(re_model$model[, 1] - predict(re_model))
    if (is.null(framework$weights)) {
        weights <- rep(1, framework$N_smp)
    }
    else {
        weights <- framework$smp_data[, framework$weights]
    }
    mean_residuals <- aggregate_weighted_mean(df = residuals, 
        by = list(framework$smp_data[, framework$smp_domains]), 
        w = weights)[, 2]
    framework$pop_data[[paste0(fixed[2])]] <- seq_len(nrow(framework$pop_data))
    X_pop <- model.matrix(fixed, framework$pop_data)
    mu_fixed <- X_pop %*% betas
    return(list(betas = betas, sigmae2est = sigmae2est, sigmau2est = sigmau2est, 
        varFix = varFix, varErr = NULL, residuals = residuals, 
        mean_residuals = mean_residuals, mu_fixed = mu_fixed))
}
model_par_hdp <-
function (framework, transformation_par, mixed_model, fixed, 
    mod.out) 
{
    model.f <- model.frame(fixed, data = transformation_par$transformed_data)
    ys <- as.numeric(model.response(model.f))
    xs <- model.matrix(fixed, data = transformation_par$transformed_data)[, 
        , drop = FALSE]
    betas <- mixed_model$coefficients
    sigmae2est <- mixed_model$sigma2e
    if (framework$N_dom_unobs > 0) {
        betas.out <- rbind(rep(betas[1, 1], dim(mod.out$coefficients)[2]), 
            mod.out$coefficients[-1, ])
        colnames(betas.out) <- unique(framework$pop_domains_vec)[!framework$dist_obs_dom]
        sigma2e.out <- mod.out$sigma2e
    }
    else {
        betas.out <- NULL
        sigma2e.out <- NULL
    }
    sigmau2est <- mixed_model$sigma2u
    rand_eff <- rep(0, length(unique(framework$pop_domains_vec)))
    bary <- as.vector(unlist(lapply(split(ys, framework$smp_domains_vec), 
        mean)))
    barx <- matrix(unlist(lapply(split.data.frame(xs, framework$smp_domains_vec), 
        colMeans)), framework$N_dom_smp, ncol(xs), byrow = T)
    Bi <- (sigmae2est/framework$n_smp)/(sigmae2est/framework$n_smp + 
        c(sigmau2est))
    rand_eff[framework$dist_obs_dom] <- (1 - Bi) * (bary - diag(barx %*% 
        betas))
    return(list(betas = betas, betas.out = betas.out, sigmae2est = sigmae2est, 
        sigma2e.out = sigma2e.out, sigmau2est = sigmau2est, rand_eff = rand_eff))
}
model_select <-
function (framework, sigmau2, method, interval, eblup, B, vardir = vardir, 
    transformation, combined_data) 
{
    m <- nrow(framework$model_X)
    p <- ncol(framework$model_X)
    D <- diag(1, framework$m)
    res <- eblup$real_res + eblup$random_effects
    if (method != "me") {
        if (framework$correlation == "spatial") {
            Vi <- solve(eblup$V)
            loglike <- (-0.5) * (m * log(2 * pi) + determinant(eblup$V, 
                logarithm = TRUE)$modulus + t(res) %*% Vi %*% 
                res)
            AIC <- (-2) * loglike + 2 * (p + 2)
            BIC <- (-2) * loglike + (p + 2) * log(m)
        }
        else {
            loglike <- (-0.5) * (sum(log(2 * pi * (sigmau2 + 
                framework$vardir)) + (res^2)/(sigmau2 + framework$vardir)))
            AIC <- (-2) * loglike + 2 * (p + 1)
            BIC <- (-2) * loglike + (p + 1) * log(m)
            KIC <- (-2) * loglike + 3 * (p + 1)
        }
        if ((framework$correlation == "no" && transformation == 
            "no") && !is.null(B)) {
            B1 <- vector(length = B)
            B3 <- vector(length = B)
            B5 <- vector(length = B)
            loglike.boot <- vector(length = B)
            loglikestar.boot <- vector(length = B)
            for (b in seq_len(B)) {
                W1 <- rnorm(n = m, mean = 0, sd = 1)
                u.boot <- sqrt(sigmau2) * W1
                W2 <- rnorm(n = m, mean = 0, sd = 1)
                e.boot <- sqrt(framework$vardir) * W2
                direct.boot <- framework$model_X %*% eblup$coefficients$coefficients + 
                  u.boot + e.boot
                combined_data$direct.boot[framework$obs_dom == 
                  TRUE] <- direct.boot
                combined_data$direct.boot <- as.numeric(combined_data$direct.boot)
                formula.tmp <- update(framework$formula, direct.boot ~ 
                  .)
                framework.boot <- framework_FH(combined_data = combined_data, 
                  fixed = formula.tmp, vardir = vardir, domains = framework$domains, 
                  transformation = "no", eff_smpsize = framework$eff_smpsize, 
                  correlation = framework$correlation, corMatrix = framework$W, 
                  Ci = framework$Ci, tol = framework$tol, maxit = framework$maxit)
                sigmau2.boot <- wrapper_estsigmau2(framework = framework.boot, 
                  method = method, interval = interval)
                eblup.boot <- eblup_FH(framework = framework.boot, 
                  sigmau2 = sigmau2.boot, combined_data = combined_data)
                B1[b] <- sum(((sigmau2 + framework$vardir) + 
                  ((framework$model_X %*% (eblup$coefficients$coefficients - 
                    eblup.boot$coefficients$coefficients))^2) - 
                  ((direct.boot - framework$model_X %*% eblup.boot$coefficients$coefficients)^2))/(sigmau2.boot + 
                  framework$vardir))
                loglike.boot[b] <- -(framework$m/2 * log(2 * 
                  pi)) - (1/2 * sum(log(sigmau2.boot + framework$vardir))) - 
                  (1/2 * sum((framework$direct - framework$model_X %*% 
                    eblup.boot$coefficients$coefficients)^2/(sigmau2.boot + 
                    framework$vardir)))
                res.boot <- eblup.boot$real_res + eblup.boot$random_effects
                loglikestar.boot[b] <- (-0.5) * (sum(log(2 * 
                  pi * (sigmau2.boot + framework$vardir)) + (res.boot^2)/(sigmau2.boot + 
                  framework$vardir)))
                B3[b] <- sum(((sigmau2.boot + framework$vardir) + 
                  (framework$model_X %*% (eblup$coefficients$coefficients - 
                    eblup.boot$coefficients$coefficients))^2)/(sigmau2 + 
                  framework$vardir))
                B5[b] <- sum((log(sigmau2.boot + framework$vardir) + 
                  (((direct.boot - framework$model_X %*% eblup.boot$coefficients$coefficients)^2))/(sigmau2.boot + 
                    framework$vardir)))
            }
            AICc <- (-2) * loglike + mean(B1)
            AICb1 <- (-2) * loglike - 2 * (mean(loglike.boot) - 
                mean(loglikestar.boot))
            AICb2 <- (-2) * loglike - 4 * (mean(loglike.boot) - 
                loglike)
            B2 <- sum(log(sigmau2 + framework$vardir)) + mean(B3) - 
                mean(B5)
            KICc <- AICc + B2
            KICb1 <- AICb1 + B2
            KICb2 <- AICb2 + B2
        }
    }
    P <- framework$model_X %*% solve(t(framework$model_X) %*% 
        framework$model_X) %*% t(framework$model_X)
    SSE <- as.numeric(t(framework$direct) %*% (diag(1, length(framework$direct)) - 
        P) %*% framework$direct)
    MSE <- SSE/(m - p)
    one <- matrix(1, m, 1)
    SST <- as.numeric(t(framework$direct) %*% (diag(1, length(framework$direct)) - 
        (1/m) * one %*% t(one)) %*% framework$direct)
    MST <- SST/(m - 1)
    R2_regular <- 1 - (MSE/MST)
    barD <- sum(framework$vardir)/m
    hii <- NULL
    for (i in seq_len(m)) {
        hii[i] <- as.numeric(t(framework$model_X[i, ]) %*% solve(t(framework$model_X) %*% 
            framework$model_X) %*% framework$model_X[i, ])
    }
    Dw <- sum((1 - hii) * framework$vardir)/(m - p)
    hxbMSE <- (2 * MSE)/(1 + exp((2 * Dw)/MSE))
    hxbMST <- (2 * MST)/(1 + exp((2 * barD)/MST))
    FH_R2 <- 1 - (hxbMSE/hxbMST)
    if (!all(framework$obs_dom == TRUE)) {
        message(strwrap(prefix = " ", initial = "", "Please note that the model selection criteria are only\n                    computed based on the in-sample domains."))
    }
    if (framework$correlation == "spatial" || transformation != 
        "no") {
        criteria <- data.frame(loglike = loglike, AIC = AIC, 
            BIC = BIC, AdjR2 = R2_regular, FH_R2 = FH_R2)
    }
    else if (framework$correlation == "no" && transformation == 
        "no" && !(B > 1) && method != "me") {
        criteria <- data.frame(loglike = loglike, AIC = AIC, 
            BIC = BIC, KIC = KIC, AdjR2 = R2_regular, FH_R2 = FH_R2)
    }
    else if (framework$correlation == "no" && transformation == 
        "no" && (B > 1) && method != "me") {
        criteria <- data.frame(loglike = loglike, AIC = AIC, 
            AICc = AICc, AICb1 = AICb1, AICb2 = AICb2, BIC = BIC, 
            KIC = KIC, KICc = KICc, KICb1 = KICb1, KICb2 = KICb2, 
            AdjR2 = R2_regular, FH_R2 = FH_R2)
    }
    else if (method == "me") {
        criteria <- data.frame(AdjR2 = R2_regular, FH_R2 = FH_R2)
    }
    return(criteria)
}
monte_carlo <-
function (mixed_model, transformation, transformation_par, L, 
    framework, lambda, shift, model_par, gen_model, fixed, Ydump) 
{
    if (!is.null(framework$aggregate_to_vec)) {
        N_dom_pop_tmp <- framework$N_dom_pop_agg
        pop_domains_vec_tmp <- framework$aggregate_to_vec
    }
    else {
        N_dom_pop_tmp <- framework$N_dom_pop
        pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    if (!is.null(Ydump)) {
        Ydumpdf <- data.frame(matrix(ncol = 6, nrow = 0))
        colnames(Ydumpdf) <- c("L", "Domain", "Simulated_Y", 
            "XBetahat", "eta", "epsilon")
        write.csv(Ydumpdf, Ydump, row.names = FALSE)
    }
    ests_mcmc <- array(dim = c(N_dom_pop_tmp, L, length(framework$indicator_names)))
    betas <- model_par$betas
    for (l in seq_len(L)) {
        if (framework$model_parameters == "variable") {
            R <- chol(model_par$varFix)
            model_par$betas <- t(R) %*% matrix(rnorm(ncol(R)), 
                ncol(R)) + betas
            gen_model <- gen_model(model_par = model_par, fixed = fixed, 
                framework = framework, dep_var = dep_var)
        }
        errors <- errors_gen(framework = framework, model_par = model_par, 
            gen_model = gen_model)
        population_vector <- prediction_y(transformation = transformation, 
            lambda = lambda, shift = shift, errors_gen = errors, 
            gen_model = gen_model, framework = framework, fixed = fixed)
        if (!is.null(framework$pop_weights)) {
            pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
        }
        else {
            pop_weights_vec <- rep(1, nrow(framework$pop_data))
        }
        if (!is.null(Ydump)) {
            if (!is.null(framework$smp_subdomains) && !is.null(framework$pop_subdomains)) {
                Ydumpdf <- data.frame(rep(l, nrow(framework$pop_data)), 
                  framework$pop_domains_vec, population_vector, 
                  gen_model$mu, errors$vu, errors$eta, errors$epsilon)
            }
            else {
                Ydumpdf <- data.frame(rep(l, nrow(framework$pop_data)), 
                  framework$pop_domains_vec, population_vector, 
                  gen_model$mu, errors$vu, errors$epsilon)
            }
            write.table(Ydumpdf, file = Ydump, row.names = FALSE, 
                append = TRUE, col.names = F, sep = ",")
        }
        ests_mcmc[, l, ] <- matrix(nrow = N_dom_pop_tmp, data = unlist(lapply(framework$indicator_list, 
            function(f, threshold) {
                matrix(nrow = N_dom_pop_tmp, data = unlist(mapply(y = split(population_vector, 
                  pop_domains_vec_tmp), pop_weights = split(pop_weights_vec, 
                  pop_domains_vec_tmp), f, threshold = framework$threshold)), 
                  byrow = TRUE)
            }, threshold = framework$threshold)))
    }
    point_estimates <- data.frame(Domain = unique(pop_domains_vec_tmp), 
        apply(ests_mcmc, c(3), rowMeans))
    colnames(point_estimates) <- c("Domain", framework$indicator_names)
    return(point_estimates)
}
monte_carlo_dt <-
function (mixed_model, transformation, transformation_par, L, 
    framework, lambda, shift, model_par, gen_model, fixed, Ydump) 
{
    if (!is.null(framework$aggregate_to_vec)) {
        N_dom_pop_tmp <- framework$N_dom_pop_agg
        pop_domains_vec_tmp <- framework$aggregate_to_vec
    }
    else {
        N_dom_pop_tmp <- framework$N_dom_pop
        pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    if (framework$model_parameters == "variable") {
        R <- chol(model_par$varErr)
        sigma2 <- c(-1, -1)
        while (sigma2[2] < 0 | sigma2[1] < 0) {
            sigma2 <- t(R) %*% matrix(rnorm(ncol(R)), ncol(R)) + 
                diag(model_par$varErr)
            model_par$sigmae2est <- sigma2[2]
            model_par$sigmau2est <- sigma2[1]
        }
        R <- chol(model_par$varFix)
        model_par$betas <- t(R) %*% matrix(rnorm(ncol(R)), ncol(R)) + 
            model_par$betas
        gen_model <- gen_model(model_par = model_par, fixed = fixed, 
            framework = framework, dep_var = dep_var)
    }
    errors_mat <- errors_gen_mat(framework = framework, model_par = model_par, 
        gen_model = gen_model, L = L)
    population_vector_dt <- prediction_y_dt(transformation = transformation, 
        lambda = lambda, shift = shift, errors_gen = errors_mat, 
        gen_model = gen_model, framework = framework, fixed = fixed, 
        L = L)
    if (!is.null(Ydump)) {
        vu_vec <- matrix(errors_mat$vu, ncol = 1)
        epsilon_vec <- matrix(errors_mat$epsilon, ncol = 1)
        population_vector_vec <- matrix(population_vector_dt, 
            ncol = 1)
        Lindex <- rep(1:L, each = nrow(framework$pop_data))
        Ydumpdf <- data.frame(Lindex, rep(framework$pop_domains_vec, 
            L), population_vector_vec, rep(gen_model$mu, L), 
            vu_vec, epsilon_vec)
        colnames(Ydumpdf) <- c("L", "Domain", "Simulated_Y", 
            "XBetahat", "eta", "epsilon")
        write.table(Ydumpdf, file = Ydump, row.names = FALSE, 
            append = FALSE, col.names = T, sep = ",")
    }
    y <- cbind(Domain = as.data.table(framework$pop_domain), 
        population_vector_dt)
    y <- cbind(y, pop_weights = as.data.table(framework$pop_data[[framework$pop_weights]]))
    indicators <- function(y, pop_weights, threshold, framework) {
        lapply(framework$indicator_list, function(f) f(y, pop_weights = pop_weights, 
            threshold = framework$threshold))
    }
    ests_mcmc <- y[, unlist(lapply(.SD, indicators, pop_weights = pop_weights.V1, 
        framework = framework), recursive = FALSE), by = Domain.V1, 
        .SDcols = -ncol(y)]
    if (!is.null(framework$indicator_list[["Quantiles"]])) {
        dcast(ests_mcmc, Domain.V1 ~ Quantile_names, value_var = pattern("Quantiles+"))
    }
    ests_mcmc2 <- data.table::melt(data = ests_mcmc, id.vars = "Domain.V1", 
        measure.vars = patterns(paste0("\\.", framework$indicator_names, 
            "+")))
    point_estimates <- data.frame(ests_mcmc2[, lapply(.SD, mean), 
        by = Domain.V1, .SDcols = 3:ncol(ests_mcmc2)])
    colnames(point_estimates) <- c("Domain", framework$indicator_names)
    return(point_estimates)
}
monte_carlo_ell <-
function (transformation, L, framework, lambda, shift, model_par, 
    fixed, Ydump, alpha_model = NULL) 
{
    if (!is.null(framework$aggregate_to_vec)) {
        N_dom_pop_tmp <- framework$N_dom_pop_agg
        pop_domains_vec_tmp <- framework$aggregate_to_vec
    }
    else {
        N_dom_pop_tmp <- framework$N_dom_pop
        pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    if (!is.null(Ydump)) {
        Ydumpdf <- data.frame(matrix(ncol = 6, nrow = 0))
        colnames(Ydumpdf) <- c("L", "Domain", "Simulated_Y", 
            "XBetahat", "eta", "epsilon")
        write.csv(Ydumpdf, Ydump, row.names = FALSE)
    }
    ests_mcmc <- array(dim = c(N_dom_pop_tmp, L, length(framework$indicator_names)))
    betas <- model_par$betas
    message("\r", "Bootstrap started                                            ")
    start_time <- Sys.time()
    for (l in seq_len(L)) {
        if (framework$model_parameters == "variable") {
            R <- chol(model_par$varFix)
            model_par$betas <- t(R) %*% matrix(rnorm(ncol(R)), 
                ncol(R)) + betas
        }
        if (framework$errors != "nonnormal") {
            errors <- errors_gen_ell(framework = framework, model_par = model_par, 
                alpha_model = alpha_model)
        }
        else {
            errors <- errors_gen_ell_nonp(framework = framework, 
                model_par = model_par, alpha_model = alpha_model)
        }
        population_vector <- prediction_y_ell(transformation = transformation, 
            lambda = lambda, shift = shift, model_par = model_par, 
            errors = errors, framework = framework, fixed = fixed)
        if (!is.null(framework$pop_weights)) {
            pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
        }
        else {
            pop_weights_vec <- rep(1, nrow(framework$pop_data))
        }
        if (!is.null(Ydump)) {
            Ydumpdf <- data.frame(rep(l, framework$N_pop), framework$pop_domains_vec, 
                population_vector, model_par$mu_fixed, errors$vu, 
                errors$epsilon)
            write.table(Ydumpdf, file = Ydump, row.names = FALSE, 
                append = TRUE, col.names = F, sep = ",")
        }
        ests_mcmc[, l, ] <- matrix(nrow = N_dom_pop_tmp, data = unlist(lapply(framework$indicator_list, 
            function(f, threshold) {
                matrix(nrow = N_dom_pop_tmp, data = unlist(mapply(y = split(population_vector, 
                  pop_domains_vec_tmp), pop_weights = split(pop_weights_vec, 
                  pop_domains_vec_tmp), f, threshold = framework$threshold)), 
                  byrow = TRUE)
            }, threshold = framework$threshold)))
        if (l%%20 == 0) {
            if (l != L) {
                delta <- difftime(Sys.time(), start_time, units = "secs")
                remaining <- (delta/l) * (L - l)
                remaining <- unclass(remaining)
                remaining <- sprintf("%02d:%02d:%02d:%02d", remaining%/%86400, 
                  remaining%%86400%/%3600, remaining%%3600%/%60, 
                  remaining%%60%/%1)
                message("\r", l, " of ", L, " Bootstrap iterations completed \t\n              Approximately ", 
                  remaining, " remaining \n")
            }
        }
    }
    point_estimates <- data.frame(Domain = unique(pop_domains_vec_tmp), 
        apply(ests_mcmc, c(3), rowMeans))
    var_estimates <- data.frame(Domain = unique(pop_domains_vec_tmp), 
        apply(ests_mcmc, 3, rowvar))
    colnames(point_estimates) <- c("Domain", framework$indicator_names)
    colnames(var_estimates) <- c("Domain", framework$indicator_names)
    return(list(point_estimates = point_estimates, var_estimates = var_estimates))
}
monte_carlo_hdp <-
function (transformation, L, framework, lambda, shift, model_par, 
    gen_model, fixed) 
{
    N_dom_pop_tmp <- framework$N_dom_pop
    pop_domains_vec_tmp <- framework$pop_domains_vec
    ests_mcmc <- array(dim = c(N_dom_pop_tmp, L, length(framework$indicator_names)))
    for (l in seq_len(L)) {
        errors <- errors_gen_hdp(framework = framework, model_par = model_par, 
            gen_model = gen_model)
        population_vector <- prediction_y(gen_model = gen_model, 
            errors_gen = errors, framework = framework, fixed = fixed, 
            transformation = transformation, lambda = lambda, 
            shift = shift)
        if (!is.null(framework$pop_weights)) {
            pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
        }
        else {
            pop_weights_vec <- rep(1, nrow(framework$pop_data))
        }
        ests_mcmc[, l, ] <- matrix(nrow = N_dom_pop_tmp, data = unlist(lapply(framework$indicator_list, 
            function(f, threshold) {
                matrix(nrow = N_dom_pop_tmp, data = unlist(mapply(y = split(population_vector, 
                  pop_domains_vec_tmp), pop_weights = split(pop_weights_vec, 
                  pop_domains_vec_tmp), f, threshold = framework$threshold)), 
                  byrow = TRUE)
            }, threshold = framework$threshold)))
    }
    point_estimates <- data.frame(Domain = unique(pop_domains_vec_tmp), 
        apply(ests_mcmc, c(3), rowMeans))
    colnames(point_estimates) <- c("Domain", framework$indicator_names)
    return(point_estimates)
}
mqre_g <-
function (fixed, framework, transformation_par, Qi, var.weights, 
    maxit, acc, k_b, k_sigma_e, k_sigma_u) 
{
    model.f <- model.frame(fixed, data = transformation_par$transformed_data)
    ys <- as.numeric(model.response(model.f))
    xs <- model.matrix(fixed, data = transformation_par$transformed_data)[, 
        , drop = FALSE]
    area.s <- framework$smp_domains_vec
    area_id <- unique(area.s)
    psi.q <- function(u, q, k) {
        sm <- median(abs(u))/0.67449999999999999
        w <- psi.huber(u/sm, k)
        ww <- 2 * (1 - q) * w
        ww[u > 0] <- 2 * q * w[u > 0]
        w <- ww
        w * u
    }
    out1 <- QRLM(y = ys, x = xs, q = Qi, var.weights = var.weights, 
        maxit = maxit, acc = acc, k = k_b)
    est.sigma2e <- rep(1, framework$N_dom_smp)
    for (i in 1:framework$N_dom_smp) {
        e.1.H <- psi.q(out1$residuals[, i], Qi[i], k = k_sigma_e)
        mod.lmm <- summary(lme4::lmer(e.1.H ~ 1 + (1 | area.s)))
        est.sigma2e[i] <- as.numeric(mod.lmm$sigma^2)
    }
    resid <- NULL
    if (ncol(xs) == 2) {
        for (i in 1:framework$N_dom_smp) {
            pred <- xs[area.s == area_id[i], -1] * out1$coef[-1, 
                i]
            resid <- c(resid, c(ys[area.s == area_id[i]] - pred))
        }
    }
    if (ncol(xs) > 2) {
        for (i in 1:framework$N_dom_smp) {
            pred <- xs[area.s == area_id[i], -1] %*% out1$coef[-1, 
                i]
            resid <- c(resid, c(ys[area.s == area_id[i]] - pred))
        }
    }
    require(emdi)
    res.fh <- tapply(resid, area.s, mean)
    dta.fh <- data.frame(res.fh = as.numeric(res.fh), vardir.fh = as.numeric(est.sigma2e/framework$n_smp), 
        area.fh = area_id)
    fh_std <- emdi::fh(fixed = res.fh ~ 1, vardir = "vardir.fh", 
        domains = "area.fh", method = "reblup", k = k_sigma_u, 
        combined_data = dta.fh)
    B0.coef <- as.numeric(fh_std$model$coefficients[1])
    est.sigma2u <- as.numeric(fh_std$model$variance)
    coefficients <- rbind(rep(B0.coef, framework$N_dom_smp), 
        out1$coef[-1, ])
    colnames(coefficients) <- c(unique(framework$smp_domains_vec))
    return(list(coefficients = coefficients, sigma2u = (est.sigma2u), 
        sigma2e = (est.sigma2e), quantile = Qi))
}
mqre_out <-
function (qmat, fixed, framework, transformation_par, var.weights, 
    maxit, acc, k_b, k_sigma_e) 
{
    Qi_hat <- tapply(qmat[, 1], qmat[, 2], mean)
    Qi_bar <- rep(Qi_hat, framework$n_smp)
    D_hat <- sum((qmat[, 1] - Qi_bar)^2)/(framework$N_smp - framework$N_dom_smp)
    Di_hat <- D_hat/framework$n_smp
    all_vars <- all.vars(fixed)
    auxilary_vars <- all_vars[all_vars != as.character(fixed[2])]
    Xpop0 <- model.matrix(reformulate(auxilary_vars), data = framework$pop_data)[, 
        , drop = FALSE]
    Xpop <- data.frame(Xpop0, area.p = framework$pop_data[framework$smp_domains])
    colnames(Xpop) <- c(colnames(Xpop0), "area.p")
    require(dplyr)
    Xpopmean <- Xpop %>% group_by(area.p) %>% summarize(across(everything(), 
        mean, na.rm = TRUE))
    Xpopmean_obs = Xpopmean[framework$dist_obs_dom, ]
    Xpopmean_unobs = Xpopmean[!framework$dist_obs_dom, ]
    logit_inv = function(x) {
        exp(x)/(1 + exp(x))
    }
    gradient = function(D, y, X, beta) {
        mu = logit_inv(X %*% beta)
        -2 * t((y - mu) * mu * (1 - mu)) %*% diag(1/D) %*% X
    }
    Hessian = function(D, y, X, beta) {
        mu = logit_inv(X %*% beta)
        t(X) %*% diag(as.vector(2 * mu^2 * (1 - mu)^2/D)) %*% 
            X - t(X) %*% diag(as.vector(2 * (y - mu) * (1 - 2 * 
            mu) * mu * (1 - mu))) %*% X
    }
    eta_init <- matrix(0, dim(Xpopmean_obs[, -1])[2], 1)
    max_iter = 100
    tol = 9.9999999999999995e-08
    eta <- eta_init
    for (iter in 1:max_iter) {
        grad <- gradient(D = Di_hat, y = matrix(Qi_hat, dim(Xpopmean_obs[, 
            -1])[1], 1), X = as.matrix(Xpopmean_obs[, -1]), beta = eta)
        hess <- Hessian(D = Di_hat, y = matrix(Qi_hat, dim(Xpopmean_obs[, 
            -1])[1], 1), X = as.matrix(Xpopmean_obs[, -1]), beta = eta)
        update <- MASS::ginv(hess)
        eta <- eta - update %*% t(grad)
        if (sqrt(sum((update %*% t(grad))^2)) < tol) {
            break
        }
    }
    Qi_out = logit_inv(as.matrix(Xpopmean_unobs[, -1]) %*% eta)
    model.f <- model.frame(fixed, data = transformation_par$transformed_data)
    ys <- as.numeric(model.response(model.f))
    xs <- model.matrix(fixed, data = transformation_par$transformed_data)[, 
        , drop = FALSE]
    area.s <- framework$smp_domains_vec
    area_id <- unique(area.s)
    psi.q <- function(u, q, k) {
        sm <- median(abs(u))/0.67449999999999999
        w <- psi.huber(u/sm, k)
        ww <- 2 * (1 - q) * w
        ww[u > 0] <- 2 * q * w[u > 0]
        w <- ww
        w * u
    }
    coef.out = matrix(0, dim(Xpopmean_obs[, -1])[2], length(Qi_out))
    est.sigma2e = NULL
    for (k in 1:length(Qi_out)) {
        out1 <- QRLM(y = ys, x = xs, q = Qi_out[k], var.weights = var.weights, 
            maxit = maxit, acc = acc, k = k_b)
        e.1.H <- psi.q(out1$residuals, Qi_out[k], k = k_sigma_e)
        mod.lmm <- summary(lme4::lmer(e.1.H ~ 1 + (1 | area.s)))
        est.sigma2e[k] <- as.numeric(mod.lmm$sigma^2)
        coef.out[, k] <- out1$coef
    }
    colnames(coef.out) <- as.matrix(Xpopmean_unobs[, 1])
    return(list(coefficients = coef.out, sigma2e = (est.sigma2e), 
        quantile.out = Qi_out, Xpopmean = Xpopmean, eta = eta))
}
mse_estim <-
function (framework, lambda, shift, model_par, gen_model, res_s, 
    fitted_s, fixed, transformation, interval, L, boot_type, 
    benchmark, benchmark_type, benchmark_level) 
{
    if (is.null(framework$MSE_pop_weights)) {
        if (boot_type == "wild") {
            superpop <- superpopulation_wild(framework = framework, 
                model_par = model_par, gen_model = gen_model, 
                lambda = lambda, shift = shift, transformation = transformation, 
                res_s = res_s, fitted_s = fitted_s, fixed = fixed)
        }
        else if (is.null(framework$smp_subdomains) && is.null(framework$pop_subdomains)) {
            superpop <- superpopulation(framework = framework, 
                model_par = model_par, gen_model = gen_model, 
                lambda = lambda, shift = shift, transformation = transformation, 
                fixed = fixed)
        }
        else {
            superpop <- superpopulation_2f(framework = framework, 
                model_par = model_par, gen_model = gen_model, 
                lambda = lambda, shift = shift, transformation = transformation, 
                fixed = fixed)
        }
        pop_income_vector <- superpop$pop_income_vector
        if (inherits(framework$threshold, "function")) {
            framework$threshold <- framework$threshold(y = pop_income_vector)
        }
        if (!is.null(framework$aggregate_to_vec)) {
            N_dom_pop_tmp <- framework$N_dom_pop_agg
            pop_domains_vec_tmp <- framework$aggregate_to_vec
        }
        else {
            N_dom_pop_tmp <- framework$N_dom_pop
            pop_domains_vec_tmp <- framework$pop_domains_vec
        }
        if (!is.null(framework$pop_weights)) {
            pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
        }
        else {
            pop_weights_vec <- rep(1, nrow(framework$pop_data))
        }
        true_indicators <- matrix(nrow = N_dom_pop_tmp, data = unlist(lapply(framework$indicator_list, 
            function(f, threshold) {
                matrix(nrow = N_dom_pop_tmp, data = unlist(mapply(y = split(pop_income_vector, 
                  pop_domains_vec_tmp), pop_weights = split(pop_weights_vec, 
                  pop_domains_vec_tmp), f, threshold = framework$threshold)), 
                  byrow = TRUE)
            }, threshold = framework$threshold)))
        vu_tmp <- superpop$vu_tmp
        eta_tmp <- superpop$eta_tmp
    }
    else {
        if (inherits(framework$threshold, "function")) {
            framework$threshold <- framework$threshold(y = pop_income_vector)
        }
        if (!is.null(framework$aggregate_to_vec)) {
            N_dom_pop_tmp <- framework$N_dom_pop_agg
            pop_domains_vec_tmp <- framework$aggregate_to_vec
        }
        else {
            N_dom_pop_tmp <- framework$N_dom_pop
            pop_domains_vec_tmp <- framework$pop_domains_vec
        }
        if (!is.null(framework$pop_weights)) {
            pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
        }
        else {
            pop_weights_vec <- rep(1, nrow(framework$pop_data))
        }
        true_indicators_weighted <- true_indicators_weighted(framework = framework, 
            model_par = model_par, gen_model = gen_model, lambda = lambda, 
            shift = shift, transformation = transformation, fixed = fixed)
        true_indicators <- true_indicators_weighted$true_indicators
        vu_tmp <- true_indicators_weighted$vu_tmp
    }
    colnames(true_indicators) <- framework$indicator_names
    if (!is.null(benchmark)) {
        if (is.character(benchmark)) {
            add_bench <- data.frame(true_indicators[, benchmark])
            if (!is.null(dim(add_bench))) {
                colnames(add_bench) <- c(paste0(benchmark, "_bench"))
            }
            else {
                names(add_bench) <- c(paste0(benchmark, "_bench"))
            }
        }
        else {
            if (is.numeric(benchmark)) {
                add_bench <- true_indicators[, names(benchmark)]
                if (!is.null(dim(add_bench))) {
                  colnames(add_bench) <- c(paste0(names(benchmark), 
                    "_bench"))
                }
                else {
                  names(add_bench) <- c(paste0(names(benchmark), 
                    "_bench"))
                }
            }
            else {
                add_bench <- as.data.frame(true_indicators[, 
                  names(benchmark)[-1]])
                if (!is.null(dim(add_bench))) {
                  colnames(add_bench) <- c(paste0(names(benchmark)[-1], 
                    "_bench"))
                }
                else {
                  names(add_bench) <- c(paste0(names(benchmark)[-1], 
                    "_bench"))
                }
            }
        }
        true_indicators <- as.matrix(cbind(true_indicators, add_bench))
    }
    if (boot_type == "wild") {
        bootstrap_sample <- bootstrap_par_wild(fixed = fixed, 
            transformation = transformation, framework = framework, 
            model_par = model_par, lambda = lambda, shift = shift, 
            vu_tmp = vu_tmp, res_s = res_s, fitted_s = fitted_s)
    }
    else {
        bootstrap_sample <- bootstrap_par(fixed = fixed, transformation = transformation, 
            framework = framework, model_par = model_par, lambda = lambda, 
            shift = shift, vu_tmp = vu_tmp)
    }
    framework$smp_data <- bootstrap_sample
    bootstrap_point_estim <- as.matrix(point_estim(fixed = fixed, 
        transformation = transformation, interval = interval, 
        L = L, framework = framework)[[1]][, -1])
    colnames(bootstrap_point_estim) <- framework$indicator_names
    if (!is.null(benchmark)) {
        if (is.null(benchmark_level)) {
            bootstrap_point_estim <- benchmark_ebp_national(point_estim = bootstrap_point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type)
        }
        else {
            bootstrap_point_estim <- benchmark_ebp_level(point_estim = bootstrap_point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        }
    }
    return((bootstrap_point_estim - true_indicators)^2)
}
mse_estim_hdp <-
function (framework, lambda, shift, model_par, gen_model, res_s, 
    fitted_s, fixed, transformation, interval, L, benchmark, 
    benchmark_type, benchmark_level) 
{
    superpop <- superpopulation_hdp(framework = framework, model_par = model_par, 
        gen_model = gen_model, lambda = lambda, shift = shift, 
        transformation = transformation, fixed = fixed)
    pop_income_vector <- superpop$pop_income_vector
    if (inherits(framework$threshold, "function")) {
        framework$threshold <- framework$threshold(y = pop_income_vector)
    }
    if (!is.null(framework$aggregate_to_vec)) {
        N_dom_pop_tmp <- framework$N_dom_pop_agg
        pop_domains_vec_tmp <- framework$aggregate_to_vec
    }
    else {
        N_dom_pop_tmp <- framework$N_dom_pop
        pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    if (!is.null(framework$pop_weights)) {
        pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
    }
    else {
        pop_weights_vec <- rep(1, nrow(framework$pop_data))
    }
    true_indicators <- matrix(nrow = N_dom_pop_tmp, data = unlist(lapply(framework$indicator_list, 
        function(f, threshold) {
            matrix(nrow = N_dom_pop_tmp, data = unlist(mapply(y = split(pop_income_vector, 
                pop_domains_vec_tmp), pop_weights = split(pop_weights_vec, 
                pop_domains_vec_tmp), f, threshold = framework$threshold)), 
                byrow = TRUE)
        }, threshold = framework$threshold)))
    colnames(true_indicators) <- framework$indicator_names
    if (!is.null(benchmark)) {
        if (is.character(benchmark)) {
            add_bench <- data.frame(true_indicators[, benchmark])
            if (!is.null(dim(add_bench))) {
                colnames(add_bench) <- c(paste0(benchmark, "_bench"))
            }
            else {
                names(add_bench) <- c(paste0(benchmark, "_bench"))
            }
        }
        else {
            if (is.numeric(benchmark)) {
                add_bench <- true_indicators[, names(benchmark)]
                if (!is.null(dim(add_bench))) {
                  colnames(add_bench) <- c(paste0(names(benchmark), 
                    "_bench"))
                }
                else {
                  names(add_bench) <- c(paste0(names(benchmark), 
                    "_bench"))
                }
            }
            else {
                add_bench <- true_indicators[, names(benchmark)[-1]]
                if (!is.null(dim(add_bench))) {
                  colnames(add_bench) <- c(paste0(names(benchmark)[-1], 
                    "_bench"))
                }
                else {
                  names(add_bench) <- c(paste0(names(benchmark)[-1], 
                    "_bench"))
                }
            }
        }
        true_indicators <- as.matrix(cbind(true_indicators, add_bench))
    }
    bootstrap_sample <- bootstrap_par_hdp(fixed = fixed, transformation = transformation, 
        framework = framework, model_par = model_par, lambda = lambda, 
        shift = shift, vu_tmp = superpop$vu_tmp)
    framework$smp_data <- bootstrap_sample
    bootstrap_point_estim <- as.matrix(point_estim_hdp(fixed = fixed, 
        transformation = transformation, interval = interval, 
        L = L, framework = framework)[[1]][, -1])
    if (!is.null(benchmark)) {
        if (is.null(benchmark_level)) {
            bootstrap_point_estim <- benchmark_ebp_national(point_estim = bootstrap_point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type)
        }
        else {
            bootstrap_point_estim <- benchmark_ebp_level(point_estim = bootstrap_point_estim, 
                framework = framework, fixed = fixed, benchmark = benchmark, 
                benchmark_type = benchmark_type, benchmark_level = benchmark_level)
        }
    }
    return((bootstrap_point_estim - true_indicators)^2)
}
mse_estim_wrapper <-
function (i, B, framework, lambda, shift, model_par, gen_model, 
    fixed, transformation, interval, L, res_s, fitted_s, start_time, 
    boot_type, seedvec, benchmark, benchmark_type, benchmark_level) 
{
    tmp <- mse_estim(framework = framework, lambda = lambda, 
        shift = shift, model_par = model_par, gen_model = gen_model, 
        res_s = res_s, fitted_s = fitted_s, fixed = fixed, transformation = transformation, 
        interval = interval, L = L, boot_type = boot_type, benchmark = benchmark, 
        benchmark_type = benchmark_type, benchmark_level = benchmark_level)
    if (i%%10 == 0) {
        if (i != B) {
            delta <- difftime(Sys.time(), start_time, units = "secs")
            remaining <- (delta/i) * (B - i)
            remaining <- unclass(remaining)
            remaining <- sprintf("%02d:%02d:%02d:%02d", remaining%/%86400, 
                remaining%%86400%/%3600, remaining%%3600%/%60, 
                remaining%%60%/%1)
            message("\r", i, " of ", B, " Bootstrap iterations completed \t\n              Approximately ", 
                remaining, " remaining \n")
            if (.Platform$OS.type == "windows") 
                flush.console()
        }
    }
    return(tmp)
}
mse_estim_wrapper_hdp <-
function (i, B, framework, lambda, shift, model_par, gen_model, 
    fixed, transformation, interval, L, res_s, fitted_s, start_time, 
    seedvec, benchmark, benchmark_type, benchmark_level) 
{
    tmp <- mse_estim_hdp(framework = framework, lambda = lambda, 
        shift = shift, model_par = model_par, gen_model = gen_model, 
        res_s = res_s, fitted_s = fitted_s, fixed = fixed, transformation = transformation, 
        interval = interval, L = L, benchmark = benchmark, benchmark_type = benchmark_type, 
        benchmark_level = benchmark_level)
    if (i%%10 == 0) {
        if (i != B) {
            delta <- difftime(Sys.time(), start_time, units = "secs")
            remaining <- (delta/i) * (B - i)
            remaining <- unclass(remaining)
            remaining <- sprintf("%02d:%02d:%02d:%02d", remaining%/%86400, 
                remaining%%86400%/%3600, remaining%%3600%/%60, 
                remaining%%60%/%1)
            message("\r", i, " of ", B, " Bootstrap iterations completed \t\n              Approximately ", 
                remaining, " remaining \n")
            if (.Platform$OS.type == "windows") 
                flush.console()
        }
    }
    return(tmp)
}
mse_povmap <-
function (object, indicator = "all", CV = FALSE) 
{
    if (inherits(object, "ell")) {
        object$MSE <- object$var
    }
    if (is.null(object$MSE) && CV == TRUE) {
        stop(strwrap(prefix = " ", initial = "", "No MSE estimates in povmap object: arguments MSE and CV have to\n                 be FALSE or a new povmap object with variance/MSE needs to be\n                 generated."))
    }
    if ((ncol(object$ind) == 11) && any(indicator == "Custom" | 
        indicator == "custom")) {
        stop(strwrap(prefix = " ", initial = "", "No individual indicators are defined. Either select other\n                 indicators or define custom indicators and generate a new povmap\n                 object. See also help(ebp)."))
    }
    if (inherits(object, "fh")) {
        object$MSE <- object$MSE[, c("Domain", "Direct", "FH")]
        object$ind <- object$ind[, c("Domain", "Direct", "FH")]
    }
    all_cv <- sqrt(object$MSE[, -1])/object$ind[, -1]
    if (any(indicator == "Quantiles") || any(indicator == "quantiles")) {
        indicator <- c(indicator[!(indicator == "Quantiles" || 
            indicator == "quantiles")], "Quantile_10", "Quantile_25", 
            "Median", "Quantile_75", "Quantile_90")
    }
    if (any(indicator == "poverty") || any(indicator == "Poverty")) {
        indicator <- c(indicator[!(indicator == "poverty" || 
            indicator == "Poverty")], "Head_Count", "Poverty_Gap")
    }
    if (any(indicator == "inequality") || any(indicator == "Inequality")) {
        indicator <- c(indicator[!(indicator == "inequality" || 
            indicator == "Inequality")], "Gini", "Quintile_Share")
    }
    if (any(indicator == "custom") || any(indicator == "Custom")) {
        indicator <- c(indicator[!(indicator == "custom" | indicator == 
            "Custom")], colnames(object$ind[-c(1, 2, 3, 4, 5, 
            6, 7, 8, 9, 10, 11)]))
    }
    if (any(indicator == "all") || any(indicator == "All")) {
        ind <- object$MSE
        ind_cv <- cbind(Domain = object$MSE[, 1], all_cv)
        ind_name <- "All indicators"
    }
    else if (any(indicator == "fh") || any(indicator == "FH")) {
        ind <- object$MSE[, c("Domain", "FH")]
        ind_cv <- cbind(Domain = object$MSE[, 1], all_cv)
        ind_name <- "Fay-Herriot estimates"
    }
    else if (any(indicator == "Direct") || any(indicator == "direct")) {
        ind <- object$MSE[, c("Domain", "Direct")]
        ind_cv <- cbind(Domain = object$MSE[, 1], all_cv)
        ind_name <- "Direct estimates used in Fay-Herriot approach"
    }
    else {
        selection <- colnames(object$MSE[-1]) %in% indicator
        ind <- object$MSE[, c(TRUE, selection)]
        ind_cv <- data.frame(Domain = object$MSE[, 1], all_cv[, 
            selection])
        colnames(ind_cv) <- colnames(ind)
        ind_name <- paste(unique(indicator), collapse = ", ")
    }
    if (CV == FALSE) {
        mse_povmap <- list(ind = ind, ind_name = ind_name)
    }
    else {
        mse_povmap <- list(ind = ind, ind_cv = ind_cv, ind_name = ind_name)
    }
    class(mse_povmap) <- "mse.povmap"
    return(mse_povmap)
}
no_transform <-
function (y, shift = NULL) 
{
    return(list(y = y, shift = NULL))
}
no_transform_back <-
function (y) 
{
    return(y = y)
}
nobs.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    N_obs <- object$framework$N_smp
    N_obs
}
nobs.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    N_obs <- object$framework$N_dom_smp
    N_obs
}
nonparametricboot_spatial <-
function (sigmau2, combined_data, framework, vardir, eblup, B, 
    transformation, method, mse_type) 
{
    g1 <- rep(0, framework$m)
    g2 <- rep(0, framework$m)
    mse <- rep(0, framework$m)
    BCoef.boot <- eblup$coefficients$coefficients
    rho.boot <- sigmau2$rho
    sigma2.boot <- sigmau2$sigmau2
    D <- diag(1, framework$m)
    Xt <- t(framework$model_X)
    Wt <- t(framework$W)
    W <- framework$W
    DrhoW <- D - rho.boot * W
    DrhoWt <- t(DrhoW)
    DrhoWDrhoWt <- solve(DrhoWt %*% DrhoW)
    var.DrhoW <- sigmau2$sigmau2 * DrhoWDrhoWt
    V.rho <- var.DrhoW + D * framework$vardir
    V.rhoi <- solve(V.rho)
    Q.rho <- solve(t(framework$model_X) %*% V.rhoi %*% framework$model_X)
    res <- framework$direct - framework$model_X %*% BCoef.boot
    u.hat <- var.DrhoW %*% V.rhoi %*% res
    VG <- V.rho - var.DrhoW
    P <- V.rhoi - V.rhoi %*% framework$model_X %*% Q.rho %*% 
        Xt %*% V.rhoi
    Ve <- VG %*% P %*% VG
    Vu <- DrhoW %*% var.DrhoW %*% P %*% var.DrhoW %*% DrhoWt
    XtV.rhoi <- Xt %*% V.rhoi
    Q.rho <- solve(XtV.rhoi %*% framework$model_X)
    G1 <- var.DrhoW - var.DrhoW %*% V.rhoi %*% var.DrhoW
    G2 <- var.DrhoW %*% t(XtV.rhoi)
    Xcoef <- matrix(0, 1, framework$p)
    for (d in seq_len(framework$m)) {
        g1[d] <- G1[d, d]
        Xcoef[1, ] <- framework$model_X[d, ] - G2[d, ]
        g2[d] <- Xcoef %*% Q.rho %*% t(Xcoef)
    }
    eigenVecVe0 <- eigen(Ve)$vectors
    eigenVecVe <- eigenVecVe0[, seq_len((framework$m - framework$p))]
    eigenValVe0 <- eigen(Ve)$values
    eigenValVe <- diag(sqrt(1/eigenValVe0[seq_len((framework$m - 
        framework$p))]))
    Vei <- eigenVecVe %*% eigenValVe %*% t(eigenVecVe)
    eigenVecVu0 <- eigen(Vu)$vectors
    eigenVecVu <- eigenVecVu0[, seq_len((framework$m - framework$p))]
    eigenValVu0 <- 1/(eigen(Vu)$values)
    eigenValVu <- diag(sqrt(eigenValVu0[seq_len((framework$m - 
        framework$p))]))
    Vui <- eigenVecVu %*% eigenValVu %*% t(eigenVecVu)
    est.u <- as.vector(Vui %*% ((DrhoW) %*% u.hat))
    est.e <- as.vector(Vei %*% (res - u.hat))
    sdu <- sqrt(sigma2.boot)
    std.u <- rep(0, framework$m)
    for (d in seq_len(framework$m)) {
        std.u[d] <- (sdu * (est.u[d] - mean(est.u)))/sqrt(mean((est.u - 
            mean(est.u))^2))
    }
    std.e <- rep(0, framework$m)
    for (d in seq_len(framework$m)) {
        std.e[d] <- (est.e[d] - mean(est.e))/sqrt(mean((est.e - 
            mean(est.e))^2))
    }
    bootstrapMSE <- matrix(0, framework$m, B)
    estTheta <- matrix(0, framework$m, B)
    trueTheta <- matrix(0, framework$m, B)
    difmse.npb <- matrix(0, framework$m, 1)
    g1.help <- matrix(0, framework$m, 1)
    g2.help <- matrix(0, framework$m, 1)
    difg1.npb <- matrix(0, framework$m, 1)
    difg2.npb <- matrix(0, framework$m, 1)
    difg3.npb <- matrix(0, framework$m, 1)
    difmse.npbBC <- matrix(0, framework$m, 1)
    notSuc <- matrix(0, B, 1)
    for (b in seq_len(B)) {
        u.boot <- sample(std.u, framework$m, replace = TRUE)
        e.samp <- sample(std.e, framework$m, replace = TRUE)
        e.boot <- sqrt(framework$vardir) * e.samp
        v.boot <- solve(D - rho.boot * W) %*% u.boot
        data_tmp <- data.frame(Domain = framework$combined_data[[framework$domains]])
        data_tmp$theta.boot[framework$obs_dom == TRUE] <- as.numeric(framework$model_X %*% 
            BCoef.boot + v.boot)
        direct.boot <- as.numeric(data_tmp$theta.boot[framework$obs_dom == 
            TRUE] + e.boot)
        combined_data$direct.boot[framework$obs_dom == TRUE] <- direct.boot
        combined_data$direct.boot <- as.numeric(combined_data$direct.boot)
        formula.tmp <- update.formula(framework$formula, direct.boot ~ 
            .)
        framework.boot <- framework_FH(combined_data = combined_data, 
            fixed = formula.tmp, vardir = vardir, domains = framework$domains, 
            transformation = transformation, eff_smpsize = framework$eff_smpsize, 
            correlation = framework$correlation, corMatrix = framework$W, 
            Ci = framework$Ci, tol = framework$tol, maxit = framework$maxit)
        sigmau2.boot <- wrapper_estsigmau2(framework = framework.boot, 
            method = method)
        eblupSFH.boot <- eblup_SFH(framework = framework.boot, 
            sigmau2 = sigmau2.boot, combined_data = combined_data)
        eblupSFH.boot$eblup_data$FH[eblupSFH.boot$eblup_data$Out == 
            1] <- NA
        if (sigmau2.boot$convergence == FALSE || sigmau2.boot$sigmau2 < 
            0 || sigmau2.boot$rho < (-1) || sigmau2.boot$rho > 
            1) {
            notSuc[b, ] <- 1
            next
        }
        message("b =", b, "\n")
        rho.tmp.boot <- sigmau2.boot$rho
        sigma2.tmp.boot <- sigmau2.boot$sigmau2
        thetaSFH.boot <- eblupSFH.boot$eblup_data$FH[framework$obs_dom == 
            TRUE]
        est.coef.sblup <- Q.rho %*% XtV.rhoi %*% direct.boot
        data_tmp$thetaSFH.sblup.boot[framework$obs_dom == TRUE] <- framework$model_X %*% 
            est.coef.sblup + var.DrhoW %*% V.rhoi %*% (direct.boot - 
            framework$model_X %*% est.coef.sblup)
        thetaSFH.boot.in <- eblupSFH.boot$eblup_data$FH[eblupSFH.boot$eblup_data$Out == 
            0]
        difg3.npb[, 1] <- difg3.npb[, 1] + (thetaSFH.boot.in - 
            data_tmp$thetaSFH.sblup.boot[framework$obs_dom == 
                TRUE])^2
        data_tmp <- data_tmp[complete.cases(data_tmp$theta.boot), 
            ]
        estTheta[, b] <- thetaSFH.boot
        trueTheta[, b] <- data_tmp$theta.boot
        bootstrapMSE[, b] <- (thetaSFH.boot - data_tmp$theta.boot)^2
        difmse.npb[, 1] <- difmse.npb[, 1] + (thetaSFH.boot - 
            data_tmp$theta.boot)^2
        A <- solve((D - rho.tmp.boot * Wt) %*% (D - rho.tmp.boot * 
            W))
        var.DrhoW.boot <- sigma2.tmp.boot * A
        V.rho.boot <- var.DrhoW.boot + D * framework$vardir
        Vi.rho.boot <- solve(V.rho.boot)
        XtVi.rho.boot <- Xt %*% Vi.rho.boot
        Q.rho.boot <- solve(XtVi.rho.boot %*% framework$model_X)
        G1 <- var.DrhoW.boot - var.DrhoW.boot %*% Vi.rho.boot %*% 
            var.DrhoW.boot
        G2 <- var.DrhoW.boot %*% Vi.rho.boot %*% framework$model_X
        Xcoef <- matrix(0, 1, framework$p)
        for (d in seq_len(framework$m)) {
            g1.help[d] <- G1[d, d]
            Xcoef[1, ] <- framework$model_X[d, ] - G2[d, ]
            g2.help[d] <- Xcoef %*% Q.rho.boot %*% t(Xcoef)
        }
        difg1.npb <- difg1.npb + g1.help
        difg2.npb <- difg2.npb + g2.help
    }
    NoSuc <- (B - sum(notSuc[, 1]))
    mse.npb <- difmse.npb[, 1]/NoSuc
    g3.npb <- difg3.npb/NoSuc
    g1.npb <- difg1.npb/NoSuc
    g2.npb <- difg2.npb/NoSuc
    mse.npbBC <- 2 * (g1 + g2) - difg1.npb[, 1]/NoSuc - difg2.npb[, 
        1]/NoSuc + difg3.npb[, 1]/NoSuc
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    notSuc <- paste(NoSuc, "out of", B)
    if (mse_type == "spatialnonparboot") {
        mse_data$FH <- NA
        mse_data$FH[framework$obs_dom == TRUE] <- mse.npb
        mse_data$Out[framework$obs_dom == TRUE] <- 0
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        mse_data <- list(mse_data = mse_data, MSE_method = "naive non-parametric bootstrap", 
            successful_bootstraps = notSuc)
        if (!all(framework$obs_dom == TRUE)) {
            message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains the\n                      non-parametric bootstrap MSE estimator for the spatial FH\n                      model is implemented. For the out-of-sample domains, no\n                      estimate for the MSE is returned. For the reference,\n                      see help(fh)."))
        }
    }
    if (mse_type == "spatialnonparbootbc") {
        mse_data$FH <- NA
        mse_data$FH[framework$obs_dom == TRUE] <- mse.npbBC
        mse_data$Out[framework$obs_dom == TRUE] <- 0
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        mse_data <- list(mse_data = mse_data, MSE_method = "bias corrected non-parametric bootstrap", 
            successful_bootstraps = notSuc)
        if (!all(framework$obs_dom == TRUE)) {
            message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains the bias\n                      corrected non-parametric bootstrap MSE estimator for the\n                      spatial FH model is implemented. For the out-of-sample\n                      domains, no estimate for the MSE is returned. For the\n                      reference, see help(fh)."))
        }
    }
    return(mse_data)
}
optimal_parameter <-
function (generic_opt, fixed, smp_data, smp_domains, transformation, 
    interval, framework) 
{
    if (transformation != "no" && transformation != "log" && 
        transformation != "ordernorm" && transformation != "arcsin" && 
        transformation != "logit") {
        if (transformation == "box.cox" && any(interval == "default")) {
            interval <- c(-1, 2)
        }
        else if (transformation == "dual" && any(interval == 
            "default")) {
            interval <- c(0, 2)
        }
        else if (transformation == "log.shift" && any(interval == 
            "default")) {
            span <- range(smp_data[paste(fixed[2])])
            if ((span[1] + 1) <= 1) {
                lower <- abs(span[1]) + 1
            }
            else {
                lower <- 0
            }
            upper <- diff(span)/2
            interval <- c(lower, upper)
        }
        if (!is.null(framework$nlme_method)) {
            optimal_parameter <- optimize(generic_opt, fixed = fixed, 
                smp_data = smp_data, smp_domains = smp_domains, 
                transformation = transformation, interval = interval, 
                framework = framework, maximum = FALSE)$minimum
        }
        else {
            optimal_parameter <- optimize(generic_opt_ell, fixed = fixed, 
                smp_data = smp_data, smp_domains = smp_domains, 
                transformation = transformation, interval = interval, 
                framework = framework, maximum = FALSE)$minimum
        }
    }
    else {
        optimal_parameter <- NULL
    }
    return(optimal_parameter)
}
ordernorm <-
function (y, shift = NULL) 
{
    y <- orderNorm(unlist(y), warn = FALSE)$x.t
    return(list(y = y, shift = shift))
}
ordernorm_back <-
function (y, shift = NULL, framework, fixed) 
{
    orderNorm_obj <- orderNorm(x = framework$smp_data[, paste(fixed[[2]])], 
        warn = FALSE)
    y <- inv_orderNorm_trans(orderNorm_obj = orderNorm_obj, new_points_x_t = y, 
        warn = TRUE)
    return(y = y)
}
parametric_bootstrap <-
function (framework, point_estim, fixed, transformation, interval = c(-1, 
    2), L, B, boot_type, parallel_mode, cpus, benchmark, benchmark_type, 
    benchmark_level) 
{
    message("\r", "Bootstrap started                                            ")
    if (boot_type == "wild") {
        res_s <- residuals(point_estim$model)
        fitted_s <- fitted(point_estim$model, level = 1)
    }
    else {
        res_s <- NULL
        fitted_s <- NULL
    }
    start_time <- Sys.time()
    if (cpus > 1) {
        cpus <- min(cpus, parallel::detectCores())
        parallelMap::parallelStart(mode = parallel_mode, cpus = cpus, 
            show.info = F, logging = F)
        if (parallel_mode == "socket") {
            parallel::clusterSetRNGStream()
        }
        slavelibs <- parallel::clusterEvalQ(, .libPaths())
        if (!max(.libPaths() %in% slavelibs[[1]])) {
            libname <- .libPaths()
            parallelMap:::parallelExport("libname")
            parallel:::clusterEvalQ(, .libPaths(libname))
        }
        parallelMap::parallelLibrary("nlme")
        mses <- simplify2array(parallelMap::parallelLapply(xs = seq_len(B), 
            fun = mse_estim_wrapper, B = B, framework = framework, 
            lambda = point_estim$optimal_lambda, shift = point_estim$shift_par, 
            model_par = point_estim$model_par, gen_model = point_estim$gen_model, 
            fixed = fixed, transformation = transformation, interval = interval, 
            L = L, res_s = res_s, fitted_s = fitted_s, start_time = start_time, 
            boot_type = boot_type, benchmark = benchmark, benchmark_type = benchmark_type, 
            benchmark_level = benchmark_level))
        parallelMap::parallelStop()
    }
    else {
        mses <- simplify2array(lapply(X = seq_len(B), FUN = mse_estim_wrapper, 
            B = B, framework = framework, lambda = point_estim$optimal_lambda, 
            shift = point_estim$shift_par, model_par = point_estim$model_par, 
            gen_model = point_estim$gen_model, fixed = fixed, 
            transformation = transformation, interval = interval, 
            L = L, res_s = res_s, fitted_s = fitted_s, start_time = start_time, 
            boot_type = boot_type, benchmark = benchmark, benchmark_type = benchmark_type, 
            benchmark_level = benchmark_level))
    }
    message("\r", "Bootstrap completed", "\n")
    if (.Platform$OS.type == "windows") {
        flush.console()
    }
    mses <- apply(mses, c(1, 2), mean)
    if (is.null(framework$aggregate_to_vec)) {
        mses <- data.frame(Domain = unique(framework$pop_domains_vec), 
            mses)
    }
    else {
        mses <- data.frame(Domain = unique(framework$aggregate_to_vec), 
            mses)
    }
    return(mses)
}
parametric_bootstrap_hdp <-
function (framework, point_estim, fixed, transformation, interval = c(-1, 
    2), L, B, benchmark, benchmark_type, benchmark_level) 
{
    message("\r", "Bootstrap started                                            ")
    res_s <- NULL
    fitted_s <- NULL
    start_time <- Sys.time()
    mses <- simplify2array(lapply(X = seq_len(B), FUN = mse_estim_wrapper_hdp, 
        B = B, framework = framework, lambda = point_estim$optimal_lambda, 
        shift = point_estim$shift_par, model_par = point_estim$model_par, 
        gen_model = point_estim$gen_model, fixed = fixed, transformation = transformation, 
        interval = interval, L = L, res_s = res_s, fitted_s = fitted_s, 
        start_time = start_time, benchmark = benchmark, benchmark_type = benchmark_type, 
        benchmark_level = benchmark_level))
    message("\r", "Bootstrap completed", "\n")
    if (.Platform$OS.type == "windows") {
        flush.console()
    }
    mses <- apply(mses, c(1, 2), mean)
    if (is.null(framework$aggregate_to_vec)) {
        mses <- data.frame(Domain = unique(framework$pop_domains_vec), 
            mses)
    }
    else {
        mses <- data.frame(Domain = unique(framework$aggregate_to_vec), 
            mses)
    }
    return(mses)
}
parametricboot_spatial <-
function (sigmau2, combined_data, framework, vardir, eblup, B, 
    transformation, method, mse_type) 
{
    g1 <- rep(0, framework$m)
    g2 <- rep(0, framework$m)
    mse <- rep(0, framework$m)
    BCoef.boot <- eblup$coefficients$coefficients
    rho.boot <- sigmau2$rho
    sigma2.boot <- sigmau2$sigmau2
    D <- diag(1, framework$m)
    Xt <- t(framework$model_X)
    Wt <- t(framework$W)
    W <- framework$W
    DrhoW <- D - rho.boot * W
    DrhoWt <- t(DrhoW)
    DrhoWDrhoWt <- solve(DrhoWt %*% DrhoW)
    var.DrhoW <- sigmau2$sigmau2 * DrhoWDrhoWt
    V.rho <- var.DrhoW + D * framework$vardir
    V.rhoi <- solve(V.rho)
    Q.rho <- solve(t(framework$model_X) %*% V.rhoi %*% framework$model_X)
    res <- framework$direct - framework$model_X %*% BCoef.boot
    u.hat <- var.DrhoW %*% V.rhoi %*% res
    XtV.rhoi <- Xt %*% V.rhoi
    Q.rho <- solve(XtV.rhoi %*% framework$model_X)
    G1 <- var.DrhoW - var.DrhoW %*% V.rhoi %*% var.DrhoW
    G2 <- var.DrhoW %*% t(XtV.rhoi)
    Xcoef <- matrix(0, 1, framework$p)
    for (d in seq_len(framework$m)) {
        g1[d] <- G1[d, d]
        Xcoef[1, ] <- framework$model_X[d, ] - G2[d, ]
        g2[d] <- Xcoef %*% Q.rho %*% t(Xcoef)
    }
    difmse.pb <- matrix(0, framework$m, 1)
    g1.help <- matrix(0, framework$m, 1)
    g2.help <- matrix(0, framework$m, 1)
    difg1.pb <- matrix(0, framework$m, 1)
    difg2.pb <- matrix(0, framework$m, 1)
    difg3.pb <- matrix(0, framework$m, 1)
    difmse.pbBC <- matrix(0, framework$m, 1)
    notSuc <- matrix(0, B, 1)
    for (b in seq_len(B)) {
        u.boot <- rnorm(framework$m, 0, sqrt(sigma2.boot))
        v.boot <- solve(D - rho.boot * W) %*% u.boot
        theta.boot <- framework$model_X %*% BCoef.boot + v.boot
        e.boot <- rnorm(framework$m, 0, sqrt(framework$vardir))
        direct.boot <- theta.boot + e.boot
        combined_data$direct.boot[framework$obs_dom == TRUE] <- direct.boot
        formula.tmp <- update.formula(framework$formula, direct.boot ~ 
            .)
        framework.boot <- framework_FH(combined_data = combined_data, 
            fixed = formula.tmp, vardir = vardir, domains = framework$domains, 
            transformation = transformation, eff_smpsize = framework$eff_smpsize, 
            correlation = framework$correlation, corMatrix = framework$W, 
            Ci = framework$Ci, tol = framework$tol, maxit = framework$maxit)
        sigmau2.boot <- wrapper_estsigmau2(framework = framework.boot, 
            method = method)
        eblupSFH.boot <- eblup_SFH(framework = framework.boot, 
            sigmau2 = sigmau2.boot, combined_data = combined_data)
        eblupSFH.boot$eblup_data$FH[eblupSFH.boot$eblup_data$Out == 
            1] <- NA
        if (sigmau2.boot$convergence == FALSE || sigmau2.boot$sigmau2 < 
            0 | sigmau2.boot$rho < (-1) || sigmau2.boot$rho > 
            1) {
            notSuc[b, ] <- 1
            next
        }
        message("b =", b, "\n")
        rho.tmp.boot <- sigmau2.boot$rho
        sigma2.tmp.boot <- sigmau2.boot$sigmau2
        BCoef.tmp.boot <- eblupSFH.boot$coefficients$coefficients
        thetaSFH.boot <- eblupSFH.boot$eblup_data$FH[framework$obs_dom == 
            TRUE]
        est.coef.sblup <- Q.rho %*% XtV.rhoi %*% direct.boot
        thetaSFH.sblup.boot <- framework$model_X %*% est.coef.sblup + 
            var.DrhoW %*% V.rhoi %*% (direct.boot - framework$model_X %*% 
                est.coef.sblup)
        difg3.pb[, 1] <- difg3.pb[, 1] + (thetaSFH.boot - thetaSFH.sblup.boot)^2
        difmse.pb[, 1] <- difmse.pb[, 1] + (thetaSFH.boot - theta.boot)^2
        A <- solve((D - rho.tmp.boot * Wt) %*% (D - rho.tmp.boot * 
            W))
        var.DrhoW.boot <- sigma2.tmp.boot * A
        V.rho.boot <- var.DrhoW.boot + D * framework$vardir
        Vi.rho.boot <- solve(V.rho.boot)
        XtVi.rho.boot <- Xt %*% Vi.rho.boot
        Q.rho.boot <- solve(XtVi.rho.boot %*% framework$model_X)
        G1 <- var.DrhoW.boot - var.DrhoW.boot %*% Vi.rho.boot %*% 
            var.DrhoW.boot
        G2 <- var.DrhoW.boot %*% Vi.rho.boot %*% framework$model_X
        Xcoef <- matrix(0, 1, framework$p)
        for (d in seq_len(framework$m)) {
            g1.help[d] <- G1[d, d]
            Xcoef[1, ] <- framework$model_X[d, ] - G2[d, ]
            g2.help[d] <- Xcoef %*% Q.rho.boot %*% t(Xcoef)
        }
        difg1.pb <- difg1.pb + g1.help
        difg2.pb <- difg2.pb + g2.help
    }
    NoSuc <- (B - sum(notSuc[, 1]))
    mse.pb <- difmse.pb[, 1]/NoSuc
    g1.pb <- difg1.pb/NoSuc
    g2.pb <- difg2.pb/NoSuc
    g3.pb <- difg3.pb/NoSuc
    mse.pbBC <- 2 * (g1 + g2) - difg1.pb[, 1]/NoSuc - difg2.pb[, 
        1]/NoSuc + difg3.pb[, 1]/NoSuc
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    notSuc <- paste(NoSuc, "out of", B)
    if (mse_type == "spatialparboot") {
        mse_data$FH <- NA
        mse_data$FH[framework$obs_dom == TRUE] <- mse.pb
        mse_data$Out[framework$obs_dom == TRUE] <- 0
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        mse_data <- list(mse_data = mse_data, MSE_method = "naive parametric bootstrap", 
            successful_bootstraps = notSuc)
        if (!all(framework$obs_dom == TRUE)) {
            message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains the naive\n                      parametric bootstrap MSE estimator for the spatial FH\n                      model is implemented. For the out-of-sample domains, no\n                      estimate for the MSE is returned. For the reference,\n                      see help(fh)."))
        }
    }
    if (mse_type == "spatialparbootbc") {
        mse_data$FH <- NA
        mse_data$FH[framework$obs_dom == TRUE] <- mse.pbBC
        mse_data$Out[framework$obs_dom == TRUE] <- 0
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        mse_data <- list(mse_data = mse_data, MSE_method = "bias corrected parametric bootstrap", 
            successful_bootstraps = notSuc)
        if (!all(framework$obs_dom == TRUE)) {
            message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains the bias\n                      corrected parametric bootstrap MSE estimator for the\n                      spatial FH model is implemented. For the out-of-sample\n                      domains, no estimate for the MSE is returned. For the\n                      reference, see help(fh)."))
        }
    }
    return(mse_data)
}
plot.direct <-
function (x, ...) 
{
    message(strwrap(prefix = " ", initial = "", "For emdi objects obtained by direct estimation diagnostic\n                  plots are not reasonable."))
}
plot.ebp <-
function (x, label = "orig", color = c("blue", "lightblue3"), 
    gg_theme = NULL, cooks = TRUE, range = NULL, ...) 
{
    plot_check(x = x, label = label, color = color, cooks = cooks, 
        range = range)
    residuals <- residuals(x$model, level = 0, type = "pearson")
    rand.eff <- nlme::ranef(x$model)$"(Intercept)"
    srand.eff <- (rand.eff - mean(rand.eff))/sd(rand.eff)
    tmp <- as.matrix(random.effects(x$model))[, 1]
    model <- x$model
    model$call$fixed <- x$fixed
    cook_df <- NULL
    indexer <- NULL
    likelihoods <- NULL
    opt_lambda <- FALSE
    if (cooks == TRUE) {
        cooksdist <- NULL
        try(cooksdist <- as.vector(suppressWarnings(cooks.distance(model))), 
            silent = TRUE)
        if (is.null(cooksdist)) {
            cooks <- FALSE
            warning(strwrap(prefix = " ", initial = "", paste0("Cook's distance could not be calculated, this is\n                             usually due to exceedence of available memory. Try\n                             using cooks = FALSE to avoid this message and\n                             improve computation time.")))
        }
        else {
            cook_df <- data.frame(index = seq_along(cooksdist), 
                cooksdist)
            indexer <- cook_df[order(cooksdist, decreasing = TRUE), 
                ][seq_len(3), ]
        }
    }
    if (x$transformation == "box.cox" || x$transformation == 
        "dual" || x$transformation == "log.shift") {
        opt_lambda <- TRUE
        if (is.null(range)) {
            range <- seq(x$transform_param$optimal_lambda - (0.5 * 
                x$transform_param$optimal_lambda), x$transform_param$optimal_lambda + 
                (0.5 * x$transform_param$optimal_lambda), length = 50)
        }
        else {
            range <- range
        }
        likelihoods <- vapply(range, function(lam, fixed, smp_data, 
            smp_domains, transformation) {
            result <- NULL
            try(result <- -as.numeric(generic_opt(lam, fixed, 
                smp_data, smp_domains, transformation)), silent = TRUE)
            if (is.null(result)) 
                result <- NA
            result
        }, numeric(1), fixed = x$fixed, smp_data = x$framework$smp_data, 
            smp_domains = x$framework$smp_domains, transformation = x$transformation)
        if (any(is.na(likelihoods))) {
            warning(strwrap(prefix = " ", initial = "", paste0("For some lambda in the chosen range, the\n                             likelihood does not converge. For these lambdas,\n                             no likelihood is plotted. Choose a different range\n                             to avoid this behaviour")))
        }
    }
    NextMethod("plot", cooks = cooks, range = range, opt_lambda = opt_lambda, 
        cook_df = cook_df, indexer = indexer, likelihoods = likelihoods, 
        residuals = residuals, srand.eff = srand.eff, tmp = tmp)
}
plot.fh <-
function (x, label = "orig", color = c("blue", "lightblue3"), 
    gg_theme = NULL, cooks = TRUE, range = NULL, ...) 
{
    plot_check(x = x, label = label, color = color, cooks = cooks, 
        range = range)
    if (any(is.na(x$model$std_real_residuals))) {
        residuals <- x$model$std_real_residuals[!is.na(x$model$std_real_residuals)]
        warning(strwrap(prefix = " ", initial = "", "At least one value in the standardized realized residuals\n                    is NA. Only numerical values are plotted."))
    }
    else {
        residuals <- x$model$std_real_residuals
    }
    residuals <- (residuals - mean(residuals))/sd(residuals)
    rand.eff <- x$model$random_effects
    srand.eff <- (rand.eff - mean(rand.eff))/sd(rand.eff)
    tmp <- srand.eff
    NextMethod("plot", cooks = FALSE, boxcox = FALSE, cook_df = NULL, 
        indexer = NULL, likelihoods = NULL, opt_lambda = FALSE, 
        residuals = residuals, srand.eff = srand.eff, tmp = tmp)
}
plot.povmap <-
function (x, label = "orig", color = c("blue", "lightblue3"), 
    gg_theme = NULL, cooks = TRUE, range = NULL, ...) 
{
    plot_check(x = x, label = label, color = color, cooks = cooks, 
        range = range)
    Residuals <- Random <- index <- lambda <- log_likelihood <- cooksdist <- NULL
    plotList <- vector(mode = "list", length = 5)
    plotList <- lapply(plotList, function(x) NA)
    names(plotList) <- c("qq_plots", "density_res", "density_ran", 
        "cooks_distance", "likelihood")
    extra_args <- list(...)
    residuals <- extra_args[["residuals"]]
    srand.eff <- extra_args[["srand.eff"]]
    tmp <- extra_args[["tmp"]]
    cook_df <- extra_args[["cook_df"]]
    indexer <- extra_args[["indexer"]]
    likelihoods <- extra_args[["likelihoods"]]
    opt_lambda <- extra_args[["opt_lambda"]]
    label <- define_label(x = x, label = label)
    res <- qplot(sample = residuals) + geom_abline(colour = color[1]) + 
        ggtitle(label$qq_res["title"]) + ylab(label$qq_res["y_lab"]) + 
        xlab(label$qq_res["x_lab"]) + gg_theme
    ran <- ggplot(data.frame(tmp), aes(sample = tmp)) + stat_qq(distribution = qnorm, 
        dparams = list(mean = mean(tmp), sd = sd(tmp))) + geom_abline(intercept = 0, 
        slope = 1, na.rm = TRUE, col = color[1]) + ggtitle(label$qq_ran["title"]) + 
        ylab(label$qq_ran["y_lab"]) + xlab(label$qq_ran["x_lab"]) + 
        gg_theme
    plotList[[1]] <- arrangeGrob(res, ran, ncol = 2)
    grid.arrange(plotList[[1]])
    cat("Press [enter] to continue")
    line <- readline()
    print((plotList[[2]] <- ggplot(data.frame(Residuals = residuals), 
        aes(x = Residuals), fill = color[2], color = color[2]) + 
        geom_density(fill = color[2], color = color[2], alpha = 0.40000000000000002) + 
        stat_function(fun = dnorm) + ylab(label$d_res["y_lab"]) + 
        xlab(label$d_res["x_lab"]) + ggtitle(label$d_res["title"]) + 
        gg_theme))
    cat("Press [enter] to continue")
    line <- readline()
    print((plotList[[3]] <- ggplot(data.frame(Random = srand.eff), 
        aes(x = Random), fill = color[2], color = color[2]) + 
        geom_density(fill = color[2], color = color[2], alpha = 0.40000000000000002) + 
        stat_function(fun = dnorm) + ylab(label$d_ran["y_lab"]) + 
        xlab(label$d_ran["x_lab"]) + ggtitle(label$d_ran["title"]) + 
        gg_theme))
    if (cooks == TRUE) {
        cat("Press [enter] to continue")
        line <- readline()
        print((plotList[[4]] <- ggplot(data = cook_df, aes(x = index, 
            y = cooksdist)) + geom_segment(aes(x = index, y = 0, 
            xend = index, yend = cooksdist), colour = color[1]) + 
            xlab("Index") + ylab(label$cooks["y_lab"]) + geom_text(label = indexer[, 
            1], data = indexer) + ggtitle(label$cooks["title"]) + 
            gg_theme))
    }
    if (opt_lambda == TRUE) {
        cat("Press [enter] to continue")
        line <- readline()
        if (any(label$opt_lambda["x_lab"] == "expression(lambda)") || 
            any(label$opt_lambda["x_lab"] == "expression(Lambda)")) {
            x_lab <- expression(lambda)
        }
        else {
            x_lab <- label$opt_lambda["x_lab"]
        }
        if (any(is.na(likelihoods))) {
            warning(strwrap(prefix = " ", initial = "", "For some lambda in the chosen range, the\n                      likelihood does not converge. For these lambdas,\n                      no likelihood is plotted. Choose a different range\n                      to avoid this behaviour"))
        }
        print((plotList[[5]] <- ggplot(data.frame(lambda = range, 
            log_likelihood = likelihoods), aes(x = lambda, y = log_likelihood)) + 
            geom_line() + xlab(x_lab) + ylab(label$opt_lambda["y_lab"]) + 
            geom_vline(xintercept = x$transform_param$optimal_lambda, 
                colour = color[1]) + ggtitle(label$opt_lambda["title"]) + 
            gg_theme))
    }
    invisible(plotList)
}
plot_check <-
function (x, label, color, cooks, range) 
{
    if (!any(inherits(x, which = TRUE, c("ebp", "fh")))) {
        stop(strwrap(prefix = " ", initial = "", "First object needs to be of class emdi, model. For emdi\n                 objects obtained by direct estimation diagnostic plots are not\n                 reasonable."))
    }
    if (is.null(label) || (!(label == "orig" || label == "no_title" || 
        label == "blank") && !inherits(label, "list"))) {
        stop(strwrap(prefix = " ", initial = "", "label can be either one of the following characters 'orig',\n                 'no_title' or 'blank' or a list as specified in help(plot.emdi)."))
    }
    if (length(color) != 2 || !is.vector(color)) {
        stop(strwrap(prefix = " ", initial = "", "color needs to be a vector of length 2 defining the two\n                 colors for the diagnostic plot. See also help(plot.emdi)."))
    }
    if (!(inherits(cooks, "logical") && length(cooks) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "cooks needs to be a logical value. Set na.rm to TRUE or\n                 FALSE. See also help(plot.emdi)."))
    }
    if (!is.null(range) && !inherits(range, "numeric")) {
        stop(strwrap(prefix = " ", initial = "", "range must be a sequence determining the range of the x-axis\n                 for plots of the optimal parameter.. Set na.rm to TRUE or\n                 FALSE. See also help(plot.emdi)."))
    }
}
plot_real <-
function (object, indicator = "all", MSE = FALSE, var = var, 
    CV = FALSE, map_obj = NULL, map_dom_id = NULL, map_tab = NULL, 
    col = col, viridis_option = NULL, scale_points = NULL, na.color = "transparent", 
    return_data = FALSE, guide = NULL, save_file = NULL, save_format = "pdf") 
{
    if (!is.null(map_obj) && is.null(map_dom_id)) {
        stop("No Domain ID for the map object is given")
    }
    long <- lat <- group <- NULL
    map_data <- estimators(object = object, indicator = indicator, 
        MSE = MSE, var = var, CV = CV)$ind
    if (!is.null(map_tab)) {
        names(map_tab)[2] <- map_dom_id
        map_data <- merge(x = map_data, y = map_tab, by.x = "Domain", 
            by.y = names(map_tab)[1])
        matcher <- match(as.vector(unlist(sf::st_drop_geometry(map_obj[map_dom_id]))), 
            map_data[, names(map_tab)[2]])
        if (any(is.na(matcher))) {
            if (all(is.na(matcher))) {
                stop(strwrap(prefix = " ", initial = "", "Domains of map_tab and Map object do not match. Check\n                     map_tab"))
            }
            else {
                warning(strwrap(prefix = " ", initial = "", "Not all Domains of map_tab and Map objects could be\n                         matched. Check map_tab"))
            }
        }
        map_data <- map_data[matcher, ]
    }
    else {
        matcher <- match(as.vector(unlist(sf::st_drop_geometry(map_obj[map_dom_id][, 
            1]))), map_data[, "Domain"])
        if (any(is.na(matcher))) {
            if (all(is.na(matcher))) {
                stop(strwrap(prefix = " ", initial = "", "Domain of povmap and Map object do not match. Try using\n                     map_tab"))
            }
            else {
                warning(strwrap(prefix = " ", initial = "", "Not all Domains of povmap and Map objects could be matched."))
            }
        }
        map_data <- map_data[matcher, ]
    }
    map_obj <- merge(x = map_obj, y = map_data, by.x = map_dom_id, 
        by.y = "Domain", all.x = T)
    indicator <- colnames(map_data)
    indicator <- indicator[!(indicator %in% c("Domain", map_dom_id))]
    for (ind in indicator) {
        map_obj2 <- sf::st_drop_geometry(map_obj)
        map_obj2[ind][, 1][!is.finite(map_obj2[ind][, 1])] <- NA
        scale_point <- get_scale_points(map_obj2[ind][, 1], ind, 
            scale_points)
        if (is.null(viridis_option)) {
            print(ggplot(data = map_obj, aes(fill = get(ind), 
                color = "black")) + labs(x = "", y = "", fill = gsub(pattern = "_", 
                replacement = " ", x = ind)) + geom_sf(color = "black") + 
                scale_fill_gradient(low = col[1], high = col[2], 
                  limits = scale_point, guide = guide, na.value = na.color) + 
                theme(axis.ticks = element_blank(), axis.text = element_blank(), 
                  ) + ggpattern:::geom_sf_pattern(data = map_obj[(is.na(map_obj$Head_Count)), 
                ], aes(fill = get(ind), colour = ""), pattern_color = "black") + 
                geom_sf(data = map_obj[(is.na(map_obj[, ind])), 
                  ], color = "black", fill = "transparent") + 
                guides(colour = guide_legend(order = 2, "No estimates", 
                  override.aes = list(fill = na.color, color = "black"))) + 
                guides(fill = guide_colourbar(order = 1)))
        }
        else {
            print(ggplot(map_obj, aes(fill = get(ind), color = "black")) + 
                labs(x = "", y = "", fill = gsub(pattern = "_", 
                  replacement = " ", x = ind)) + geom_sf(color = "black") + 
                scale_fill_viridis(option = viridis_option, na.value = na.color) + 
                scale_colour_manual(values = NA) + theme(axis.ticks = element_blank(), 
                axis.text = element_blank()) + geom_sf_pattern(data = map_obj[(is.na(map_obj[, 
                ind])), ], aes(fill = get(ind), colour = ""), 
                pattern_color = "black") + guides(colour = guide_legend(order = 2, 
                "No estimates", override.aes = list(fill = na.color, 
                  color = "black"))) + geom_sf(data = map_obj[(is.na(map_obj[, 
                ind])), ], color = "black", fill = "transparent") + 
                guides(fill = guide_colourbar(order = 1)))
        }
        if (!is.null(save_file)) {
            ggplot2:::ggsave(file = paste0(save_file, "_", ind, 
                ".", save_format))
        }
        if (!ind == tail(indicator, 1)) {
            cat("Press [enter] to continue")
            line <- readline()
        }
    }
    if (return_data) {
        return(map_obj)
    }
}
point_estim <-
function (framework, fixed, transformation, interval, L, keep_data = FALSE, 
    Ydump = NULL) 
{
    optimal_lambda <- optimal_parameter(generic_opt = generic_opt, 
        fixed = fixed, smp_data = framework$smp_data, smp_domains = framework$smp_domains, 
        transformation = transformation, interval = interval, 
        framework = framework)
    transformation_par <- data_transformation(fixed = fixed, 
        smp_data = framework$smp_data, transformation = transformation, 
        lambda = optimal_lambda)
    shift_par <- transformation_par$shift
    weights_arg <- NULL
    if (!is.null(framework$weights) && any(framework$weights_type %in% 
        c("nlme", "nlme_lambda", "hybrid2"))) {
        transformation_par$transformed_data$weights_temp <- framework$smp_data[, 
            framework$weights]
        weights_arg <- ~1/weights_temp
    }
    random_arg <- NULL
    if (!is.null(framework$smp_subdomains) && !is.null(framework$pop_subdomains)) {
        random_arg <- list(as.formula(~1), as.formula(~1))
        names(random_arg) <- c(framework$smp_domains, framework$smp_subdomains)
    }
    else {
        random_arg[framework$smp_domains] <- list(as.formula(~1))
    }
    args <- list(fixed = fixed, data = transformation_par$transformed_data, 
        random = random_arg, method = framework$nlme_method, 
        control = nlme::lmeControl(maxIter = framework$nlme_maxiter, 
            tolerance = framework$nlme_tolerance, opt = framework$nlme_opt, 
            optimMethod = framework$nlme_optimmethod, msMaxIter = framework$nlme_msmaxiter, 
            msTol = framework$nlme_mstol, returnObject = framework$nlme_returnobject), 
        keep.data = keep_data, weights = weights_arg)
    mixed_model <- do.call(nlme:::lme, args)
    dep_var <- transformation_par$transformed_data[[as.character(mixed_model$terms[[2]])]]
    est_par <- model_par(mixed_model = mixed_model, framework = framework, 
        fixed = fixed, transformation_par = transformation_par)
    if (framework$model_parameters != "variable") {
        gen_par <- gen_model(model_par = est_par, fixed = fixed, 
            framework = framework, dep_var = dep_var)
    }
    else {
        gen_par <- NULL
    }
    est_par$rand_eff <- gen_par$rand_eff
    est_par$betas <- gen_par$betas
    est_par$sigmau2est <- gen_par$sigmau2est
    est_par$sigmae2est <- gen_par$sigmae2est
    est_par$e0 <- gen_par$e0
    est_par$e1 <- gen_par$e1
    est_par$e2 <- gen_par$e2
    est_par$gamma <- gen_par$gamma
    est_par$gamma_sub <- gen_par$gamma_sub
    if (inherits(framework$threshold, "function")) {
        framework$threshold <- framework$threshold(y = as.numeric(framework$smp_data[[paste0(fixed[2])]]))
    }
    if (L > 0 & framework$data.table == FALSE) {
        indicator_prediction <- monte_carlo(mixed_model = mixed_model, 
            transformation = transformation, transformation_par = transformation_par, 
            L = L, framework = framework, lambda = optimal_lambda, 
            shift = shift_par, model_par = est_par, gen_model = gen_par, 
            fixed = fixed, Ydump = Ydump)
    }
    else if (L > 0 & framework$data.table == TRUE) {
        indicator_prediction <- monte_carlo_dt(mixed_model = mixed_model, 
            transformation = transformation, transformation_par = transformation_par, 
            L = L, framework = framework, lambda = optimal_lambda, 
            shift = shift_par, model_par = est_par, gen_model = gen_par, 
            fixed = fixed, Ydump = Ydump)
    }
    else {
        indicator_prediction <- analytic(transformation = transformation, 
            framework = framework, lambda = optimal_lambda, shift = shift_par, 
            model_par = est_par, gen_model = gen_par, fixed = fixed, 
            Ydump = Ydump)
    }
    mixed_model$coefficients_weighted <- if (!is.null(framework$weights)) {
        as.numeric(est_par$betas)
    }
    else {
        NULL
    }
    names(mixed_model$coefficients_weighted) <- if (!is.null(framework$weights)) {
        rownames(est_par$betas)
    }
    else {
        NULL
    }
    return(list(ind = indicator_prediction, optimal_lambda = optimal_lambda, 
        shift_par = shift_par, model_par = est_par, gen_model = gen_par, 
        model = mixed_model))
}
point_estim_direct <-
function (direct_estimator, indicator_name, framework, boot_type, 
    B, seed, X_calib, totals) 
{
    if (inherits(framework$threshold, "function")) {
        framework$threshold <- framework$threshold(framework$y_vec, 
            framework$weights_vec)
    }
    value <- direct_estimator(y = framework$y_vec, weights = framework$weights_vec, 
        threshold = framework$threshold)
    valueByDomain <- aggregate(seq_len(framework$N_smp), list(Domain = framework$smp_domains_vec), 
        function(i, y, threshold, weights) {
            direct_estimator(y = y[i], weights = weights[i], 
                threshold = threshold)
        }, y = framework$y_vec, weights = framework$weights_vec, 
        threshold = framework$threshold)
    names(valueByDomain)[2] <- indicator_name
    names(valueByDomain)[1] <- "Domain"
    rs <- as.factor(as.matrix(valueByDomain[1])[, 1])
    return(list(value = value, valueByDomain = valueByDomain, 
        domain = rs))
}
point_estim_ell <-
function (framework, fixed, alpha, transformation, interval, 
    L, keep_data = FALSE, Ydump = NULL) 
{
    optimal_lambda <- optimal_parameter(generic_opt = generic_opt, 
        fixed = fixed, smp_data = framework$smp_data, smp_domains = framework$smp_domains, 
        transformation = transformation, interval = interval, 
        framework = framework)
    transformation_par <- data_transformation(fixed = fixed, 
        smp_data = framework$smp_data, transformation = transformation, 
        lambda = optimal_lambda)
    shift_par <- transformation_par$shift
    random_arg <- NULL
    random_arg[framework$smp_domains] <- list(as.formula(~1))
    names(random_arg) <- c(framework$smp_domains)
    weights_arg <- NULL
    if (!is.null(framework$weight)) {
        weights_arg <- framework$smp_data[, framework$weights]
    }
    args <- list(formula = fixed, data = transformation_par$transformed_data, 
        weights = weights_arg, model = "random", index = framework$smp_domains, 
        random.method = framework$random_method)
    re_model <- do.call(plm:::plm, args)
    est_par <- model_par_ell(re_model = re_model, framework = framework, 
        fixed = fixed, transformation_par = transformation_par)
    if (!is.null(alpha)) {
        alpha_model <- alphamodel(residuals = est_par$residuals, 
            alpha = alpha, framework = framework)
    }
    else {
        alpha_model <- NULL
    }
    if (inherits(framework$threshold, "function")) {
        framework$threshold <- framework$threshold(y = as.numeric(framework$smp_data[[paste0(fixed[2])]]))
    }
    if (L > 0) {
        indicator_prediction <- monte_carlo_ell(transformation = transformation, 
            L = L, framework = framework, lambda = optimal_lambda, 
            shift = shift_par, model_par = est_par, fixed = fixed, 
            Ydump = Ydump, alpha_model = alpha_model)
    }
    else {
        stop(strwrap(prefix = " ", initial = "", "L must be positive when using ELL estimation"))
    }
    return(list(ind = indicator_prediction$point_estimates, var = indicator_prediction$var_estimates, 
        optimal_lambda = optimal_lambda, shift_par = shift_par, 
        model_par = est_par, gen_model = gen_model, model = re_model, 
        alpha_model = alpha_model$alpha_model))
}
point_estim_hdp <-
function (framework, fixed, transformation, interval, L, keep_data = FALSE, 
    Ydump = NULL) 
{
    optimal_lambda <- optimal_parameter(generic_opt = generic_opt, 
        fixed = fixed, smp_data = framework$smp_data, smp_domains = framework$smp_domains, 
        transformation = transformation, interval = interval, 
        framework = framework)
    transformation_par <- data_transformation(fixed = fixed, 
        smp_data = framework$smp_data, transformation = transformation, 
        lambda = optimal_lambda)
    shift_par <- transformation_par$shift
    model.f <- model.frame(fixed, data = transformation_par$transformed_data)
    ys <- as.numeric(model.response(model.f))
    xs <- model.matrix(fixed, data = transformation_par$transformed_data)[, 
        , drop = FALSE]
    area.s <- transformation_par$transformed_data[[framework$smp_domains]]
    p <- ncol(xs)
    area_id <- sort(unique(area.s))
    if (is.null(framework$weights)) {
        var.weights = rep(1, nrow(xs))
    }
    else {
        var.weights = framework$weights
    }
    mod <- QRLM(y = ys, x = xs, q = framework$Q, var.weights = var.weights, 
        maxit = framework$maxit, acc = framework$tol, k = framework$k_b)
    qo <- matrix(c(gridfitinter(ys, mod$fitted.values, mod$q.values)), 
        nrow = framework$N_smp, ncol = 1)
    qmat <- matrix(c(qo, area.s), nrow = framework$N_smp, ncol = 2)
    require(sae)
    if (framework$method == "LBP") {
        tmp.Xmean <- rep(1, framework$N_dom_smp)
        tmp.Popn <- framework$n_pop[framework$dist_obs_dom]
        Xmean <- data.frame(area_id, tmp.Xmean)
        Popn <- data.frame(area_id, tmp.Popn)
        tmp.dta <- data.frame(qmat[, 1], area.s)
        names(tmp.dta) <- c("qij", "area.s")
        LBP <- sae::eblupBHF(formula = qij ~ 1, dom = area.s, 
            meanxpop = Xmean, popnsize = Popn, method = "REML", 
            data = tmp.dta)
        Qi <- LBP$eblup$eblup
        Qi <- ifelse(Qi > 1, 0.999, Qi)
        Qi <- ifelse(Qi < 0, 0.001, Qi)
    }
    if (framework$method == "Naive") {
        Qi <- tapply(qmat[, 1], qmat[, 2], mean)
    }
    mixed_model <- mqre_g(fixed = fixed, framework = framework, 
        transformation_par = transformation_par, Qi = Qi, var.weights = var.weights, 
        maxit = framework$maxit, acc = framework$tol, k_b = framework$k_b, 
        k_sigma_e = framework$k_sigma_e, k_sigma_u = framework$k_sigma_u)
    if (framework$N_dom_unobs > 0) {
        mod.out <- mqre_out(qmat = qmat, fixed = fixed, framework = framework, 
            transformation_par = transformation_par, var.weights = var.weights, 
            maxit = framework$maxit, acc = framework$tol, k_b = framework$k_b, 
            k_sigma_e = framework$k_sigma_e)
    }
    else {
        mod.out <- NULL
    }
    est_par <- model_par_hdp(mixed_model = mixed_model, transformation_par = transformation_par, 
        framework = framework, fixed = fixed, mod.out = mod.out)
    gen_par <- gen_model_hdp(model_par = est_par, fixed = fixed, 
        framework = framework)
    if (inherits(framework$threshold, "function")) {
        framework$threshold <- framework$threshold(y = as.numeric(framework$smp_data[[paste0(fixed[2])]]))
    }
    indicator_prediction <- monte_carlo_hdp(L = L, framework = framework, 
        model_par = est_par, gen_model = gen_par, fixed = fixed, 
        transformation = transformation, lambda = optimal_lambda, 
        shift = shift_par)
    return(list(ind = indicator_prediction, optimal_lambda = optimal_lambda, 
        shift_par = shift_par, model_par = est_par, gen_model = gen_par, 
        model = mixed_model, model.out = mod.out))
}
point_povmap <-
function (object, indicator = "all") 
{
    if (is.null(object$ind)) {
        stop(strwrap(prefix = " ", initial = "", "No estimates in object: method point not applicable"))
    }
    if ((ncol(object$ind) == 11) && any(indicator == "Custom" | 
        indicator == "custom")) {
        stop(strwrap(prefix = " ", initial = "", "No individual indicators are defined. Either select other\n                 indicators or define custom indicators and generate a new emdi\n                 object. See also help(direct) or help(ebp)."))
    }
    if (any(indicator == "Quantiles") || any(indicator == "quantiles")) {
        indicator <- c(indicator[!(indicator == "Quantiles" | 
            indicator == "quantiles")], "Quantile_10", "Quantile_25", 
            "Median", "Quantile_75", "Quantile_90")
    }
    if (any(indicator == "poverty") || any(indicator == "Poverty")) {
        indicator <- c(indicator[!(indicator == "poverty" | indicator == 
            "Poverty")], "Head_Count", "Poverty_Gap")
    }
    if (any(indicator == "inequality") || any(indicator == "Inequality")) {
        indicator <- c(indicator[!(indicator == "inequality" | 
            indicator == "Inequality")], "Gini", "Quintile_Share")
    }
    if (any(indicator == "custom") || any(indicator == "Custom")) {
        indicator <- c(indicator[!(indicator == "custom" | indicator == 
            "Custom")], colnames(object$ind[-c(1, 2, 3, 4, 5, 
            6, 7, 8, 9, 10, 11)]))
    }
    if (inherits(object, "fh")) {
        object$ind["Out"] <- NULL
    }
    if (any(indicator == "all") || any(indicator == "All")) {
        ind <- object$ind
        ind_name <- "All indicators"
    }
    else if (any(indicator == "fh") || any(indicator == "FH")) {
        ind <- object$ind[, c("Domain", "FH")]
        ind_name <- "Fay-Herriot estimates"
    }
    else if (any(indicator == "fh_bench") || any(indicator == 
        "FH_Bench")) {
        ind <- object$ind[, c("Domain", "FH_Bench")]
        ind_name <- "Benchmarked Fay-Herriot estimates"
    }
    else if (any(indicator == "Direct") || any(indicator == "direct")) {
        ind <- object$ind[, c("Domain", "Direct")]
        ind_name <- "Direct estimates used in Fay-Herriot approach"
    }
    else {
        selection <- colnames(object$ind[-1]) %in% indicator
        ind <- object$ind[, c(TRUE, selection)]
        ind_name <- paste(unique(indicator), collapse = ", ")
    }
    point_emdi <- list(ind = ind, ind_name = ind_name)
    class(point_emdi) <- "point.emdi"
    return(point_emdi)
}
prasad_rao <-
function (framework, sigmau2, combined_data) 
{
    g1 <- rep(0, framework$m)
    g2 <- rep(0, framework$m)
    g3 <- rep(0, framework$m)
    mse <- rep(0, framework$m)
    Vi <- 1/(sigmau2 + framework$vardir)
    Bd <- framework$vardir/(sigmau2 + framework$vardir)
    SumAD2 <- sum(Vi^2)
    XtVi <- t(Vi * framework$model_X)
    Q <- solve(XtVi %*% framework$model_X)
    VarA <- 2/SumAD2
    for (d in seq_len(framework$m)) {
        g1[d] <- framework$vardir[d] * (1 - Bd[d])
        xd <- matrix(framework$model_X[d, ], nrow = 1, ncol = framework$p)
        g2[d] <- (Bd[d]^2) * xd %*% Q %*% t(xd)
        g3[d] <- (Bd[d]^2) * VarA/(sigmau2 + framework$vardir[d])
        mse[d] <- g1[d] + g2[d] + 2 * g3[d]
    }
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        h <- rep(0, framework$M - framework$m)
        mse_out <- rep(0, framework$M - framework$m)
        pred_data_tmp <- combined_data[framework$obs_dom == FALSE, 
            ]
        pred_data_tmp <- data.frame(pred_data_tmp, helper = rnorm(1, 
            0, 1))
        formula.tools::lhs(framework$formula) <- quote(helper)
        pred_data <- makeXY(formula = framework$formula, data = pred_data_tmp)
        pred_X <- pred_data$x
        for (d_out in seq_len((framework$M - framework$m))) {
            xd_out <- matrix(pred_X[d_out, ], nrow = 1, ncol = framework$p)
            h[d_out] <- xd_out %*% Q %*% t(xd_out)
            mse_out[d_out] <- sigmau2 + h[d_out]
        }
        mse_data$FH[framework$obs_dom == FALSE] <- mse_out
        mse_data$Out[framework$obs_dom == FALSE] <- 1
    }
    return(mse_data)
}
prasad_rao_spatial <-
function (framework, sigmau2, combined_data, method) 
{
    g1 <- rep(0, framework$m)
    g2 <- rep(0, framework$m)
    g3 <- rep(0, framework$m)
    g4 <- rep(0, framework$m)
    mse.help <- rep(0, framework$m)
    mse <- rep(0, framework$m)
    D <- diag(1, framework$m)
    Xt <- t(framework$model_X)
    Wt <- t(framework$W)
    DrhoWDrhoWt <- solve((D - sigmau2$rho * Wt) %*% (D - sigmau2$rho * 
        framework$W))
    var.DrhoW <- sigmau2$sigmau2 * DrhoWDrhoWt
    V.rho <- var.DrhoW + D * framework$vardir
    V.rhoi <- solve(V.rho)
    XtV.rhoi <- Xt %*% V.rhoi
    Q.rho <- solve(t(framework$model_X) %*% V.rhoi %*% framework$model_X)
    G1 <- var.DrhoW - var.DrhoW %*% V.rhoi %*% var.DrhoW
    G2 <- var.DrhoW %*% V.rhoi %*% framework$model_X
    Xcoef <- matrix(0, 1, framework$p)
    for (d in seq_len(framework$m)) {
        g1[d] <- G1[d, d]
        Xcoef[1, ] <- framework$model_X[d, ] - G2[d, ]
        g2[d] <- Xcoef %*% Q.rho %*% t(Xcoef)
    }
    der.rho <- 2 * sigmau2$rho * Wt %*% framework$W - framework$W - 
        Wt
    DrhoWDrhoWtmat <- (-1) * sigmau2$sigmau2 * (DrhoWDrhoWt %*% 
        der.rho %*% DrhoWDrhoWt)
    P <- V.rhoi - t(XtV.rhoi) %*% Q.rho %*% XtV.rhoi
    PDrhoWDrhoWt <- P %*% DrhoWDrhoWt
    PDrhoWDrhoWtmat <- P %*% DrhoWDrhoWtmat
    fisher <- matrix(0, 2, 2)
    fisher[1, 1] <- (0.5) * sum(diag((PDrhoWDrhoWt %*% PDrhoWDrhoWt)))
    fisher[1, 2] <- (0.5) * sum(diag((PDrhoWDrhoWt %*% PDrhoWDrhoWtmat)))
    fisher[2, 1] <- fisher[1, 2]
    fisher[2, 2] <- (0.5) * sum(diag((PDrhoWDrhoWtmat %*% PDrhoWDrhoWtmat)))
    fisheri <- solve(fisher)
    V.rhoiDrhoWDrhoWt <- V.rhoi %*% DrhoWDrhoWt
    V.rhoiDrhoWDrhoWtmat <- V.rhoi %*% DrhoWDrhoWtmat
    line1 <- V.rhoiDrhoWDrhoWt - sigmau2$sigmau2 * V.rhoiDrhoWDrhoWt %*% 
        V.rhoiDrhoWDrhoWt
    line1t <- t(line1)
    line2 <- V.rhoiDrhoWDrhoWtmat - sigmau2$sigmau2 * V.rhoiDrhoWDrhoWtmat %*% 
        V.rhoiDrhoWDrhoWt
    line2t <- t(line2)
    lines <- matrix(0, 2, framework$m)
    for (d in seq_len(framework$m)) {
        lines[1, ] <- line1t[d, ]
        lines[2, ] <- line2t[d, ]
        g3[d] <- sum(diag(lines %*% V.rho %*% t(lines) %*% fisheri))
    }
    mse.help <- g1 + g2 + 2 * g3
    psi <- diag(c(framework$vardir), framework$m)
    D1help <- (-1) * (DrhoWDrhoWt %*% der.rho %*% DrhoWDrhoWt)
    D2help <- 2 * sigmau2$sigmau2 * DrhoWDrhoWt %*% der.rho %*% 
        DrhoWDrhoWt %*% der.rho %*% DrhoWDrhoWt - 2 * sigmau2$sigmau2 * 
        DrhoWDrhoWt %*% Wt %*% framework$W %*% DrhoWDrhoWt
    D <- (psi %*% V.rhoi %*% D1help %*% V.rhoi %*% psi) * (fisheri[1, 
        2] + fisheri[2, 1]) + psi %*% V.rhoi %*% D2help %*% V.rhoi %*% 
        psi * fisheri[2, 2]
    for (d in seq_len(framework$m)) {
        g4[d] <- (0.5) * D[d, d]
    }
    mse <- mse.help - g4
    if (method == "ml") {
        Q.rhoXtV.rhoi <- Q.rho %*% XtV.rhoi
        V.rhoiX <- V.rhoi %*% framework$model_X
        h1 <- (-1) * sum(diag(Q.rhoXtV.rhoi %*% DrhoWDrhoWt %*% 
            V.rhoiX))
        h2 <- (-1) * sum(diag(Q.rhoXtV.rhoi %*% DrhoWDrhoWtmat %*% 
            V.rhoiX))
        h <- matrix(c(h1, h2), nrow = 2, ncol = 1)
        bML <- (fisheri %*% h)/2
        tbML <- t(bML)
        GV.rhoi <- var.DrhoW %*% V.rhoi
        GV.rhoiDrhoWDrhoWt <- GV.rhoi %*% DrhoWDrhoWt
        GV.rhoiDrhoWDrhoWtmat <- GV.rhoi %*% DrhoWDrhoWtmat
        V.rhoiDrhoWDrhoWt <- V.rhoi %*% DrhoWDrhoWt
        dg1_dDrhoWDrhoWt <- DrhoWDrhoWt - 2 * GV.rhoiDrhoWDrhoWt + 
            sigmau2$sigmau2 * GV.rhoiDrhoWDrhoWt %*% V.rhoiDrhoWDrhoWt
        dg1_dp <- DrhoWDrhoWtmat - 2 * GV.rhoiDrhoWDrhoWtmat + 
            sigmau2$sigmau2 * GV.rhoiDrhoWDrhoWtmat %*% V.rhoiDrhoWDrhoWt
        grad.g1d <- matrix(0, nrow = 2, ncol = 1)
        bMLgrad.g1 <- rep(0, framework$m)
        for (d in seq_len(framework$m)) {
            grad.g1d[1, 1] <- dg1_dDrhoWDrhoWt[d, d]
            grad.g1d[2, 1] <- dg1_dp[d, d]
            bMLgrad.g1[d] <- tbML %*% grad.g1d
        }
        mse <- mse - bMLgrad.g1
    }
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains an analytical\n                    MSE for the spatial FH model is implemented. For the\n                    out-of-sample domains, no estimate for the MSE is returned.\n                    For the reference, see help(fh)."))
    }
    return(mse_data)
}
predict.povmap <-
function (object, ...) 
{
    object$ind
}
prediction_y <-
function (gen_model, errors_gen, framework, fixed, transformation, 
    lambda, shift) 
{
    y_pred <- gen_model$mu + errors_gen$epsilon + errors_gen$vu
    y_pred <- back_transformation(y = y_pred, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    y_pred[!is.finite(y_pred)] <- 0
    return(y_pred)
}
prediction_y_dt <-
function (transformation, lambda, shift, errors_gen, gen_model, 
    framework, fixed, L = L) 
{
    mu <- data.table::setDT(rep(list(as.vector(gen_model$mu)), 
        L))
    epsilon <- data.table::as.data.table(errors_gen$epsilon)
    vu <- data.table::as.data.table(errors_gen$vu)
    y_pred <- vu + epsilon + mu
    y_pred[, `:=`(1:ncol(y_pred), y_pred[, lapply(.SD, back_transformation, 
        transformation = transformation, lambda = lambda, shift = shift, 
        framework = framework, fixed = fixed)])]
    y_pred[mapply(is.infinite, y_pred)] <- NA
    return(y_pred)
}
prediction_y_ell <-
function (transformation, lambda, shift, model_par, errors, framework, 
    fixed) 
{
    y_pred <- model_par$mu_fixed + errors$epsilon + errors$vu
    y_pred <- back_transformation(y = y_pred, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    y_pred[!is.finite(y_pred)] <- 0
    return(y_pred)
}
print.compare.fh <-
function (x, ...) 
{
    if (!(is.null(x$Brown))) {
        cat("Brown test", "\n")
        cat("\n")
        cat("Null hypothesis: EBLUP estimates do not differ significantly from the\n      direct estimates", 
            "\n")
        cat("\n")
        print(data.frame(W.value = x[[1]]$W, Df = x[[1]]$Df, 
            p.value = x[[1]]$p.value, row.names = ""))
        if (length(x) == 2) {
            cat("\n")
            cat("Correlation between synthetic part and direct estimator: ", 
                round(x[[2]], 2), "\n")
        }
    }
    else {
        if (length(x) == 2) {
            cat("\n")
            cat("Correlation between synthetic part and direct estimator: ", 
                round(x[[2]], 2), "\n")
        }
    }
}
print.direct <-
function (x, ...) 
{
    throw_class_error(x, "direct")
    cat("Direct estimation\n")
    cat("\n")
    cat("In-sample domains: ", x$framework$N_dom_smp, "\n")
    cat("\n")
    cat("Units in each Domain:")
    print(table(x$framework$smp_domains_vec))
}
print.ebp <-
function (x, ...) 
{
    throw_class_error(x, "ebp")
    if (is.null(x$call$weights)) {
        cat("Empirical Best Prediction\n")
    }
    else {
        cat("Empirical Best Prediction with sampling weights\n")
    }
    cat("\n")
    cat("Out-of-sample domains: ", x$framework$N_dom_unobs, "\n")
    cat("In-sample domains: ", x$framework$N_dom_smp, "\n")
    if (x$transformation == "box.cox") {
        transform_method <- data.frame(Transformation = x$transformation, 
            Method = x$method, Optimal_lambda = x$transform_param$optimal_lambda, 
            Shift_parameter = round(x$transform_param$shift_par, 
                3), row.names = "")
    }
    else if (x$transformation == "dual") {
        transform_method <- data.frame(Transformation = x$transformation, 
            Method = x$method, Optimal_lambda = x$transform_param$optimal_lambda, 
            row.names = "")
    }
    else if (x$transformation == "log") {
        transform_method <- data.frame(Transformation = x$transformation, 
            Shift_parameter = round(x$transform_param$shift_par, 
                3), row.names = "")
    }
    else if (x$transformation == "no") {
        transform_method <- NULL
    }
    cat("\n")
    if (is.null(transform_method)) {
        cat("Transformation: No transformation \n")
    }
    else {
        cat("Transformation:\n")
        print(transform_method)
    }
    cat("\n")
    cat("Model fit:\n")
    cat("For model fit lme methods are applicable to emdiObject$model \n")
    cat("where transformed_data equals smp_data transformed by function \n")
    cat("data_transformation using above given transformation and lambda \n")
    cat("and where fixed/list(fixed) equals ")
    print(x$fixed)
    cat("\n")
}
print.estimators.povmap <-
function (x, ...) 
{
    cat(paste0("Indicator/s: ", x$ind_name, "\n"))
    print(x$ind)
}
print.fh <-
function (x, ...) 
{
    throw_class_error(x, "fh")
    cat("Empirical Best Linear Unbiased Prediction (Fay-Herriot)\n")
    cat("\n")
    cat("Out-of-sample domains: ", x$framework$N_dom_unobs, "\n")
    if (x$model$correlation == "temporal" || x$model$correlation == 
        "spatio-temporal") {
        cat("In-sample domains: ", x$framework$N_dom_smp/x$model$n_time, 
            "\n")
        cat("Number of time periods: ", x$model$n_time, "\n")
        cat("\n")
    }
    else {
        cat("In-sample domains: ", x$framework$N_dom_smp, "\n")
        cat("\n")
    }
    cat("Variance and MSE estimation:\n")
    if (x$method$method == "reblup" || x$method$method == "reblupbc") {
        cat("Variance estimation method: robustified ml,", x$method$method, 
            "\n")
        if (x$method$method == "reblup") {
            cat("k = ", x$model$k, "\n")
        }
        else if (x$method$method == "reblupbc") {
            cat("k = ", x$model$k, ", mult_constant = ", x$model$mult_constant, 
                "\n")
        }
    }
    else {
        cat("Variance estimation method: ", x$method$method, 
            "\n")
    }
    if (x$model$correlation == "no") {
        cat("Variance of random effects: ", x$model$variance, 
            "\n")
    }
    else {
        cat("Estimated variance component(s): ", x$model$correlation, 
            "correlation assumed\n")
        cat("Variance of random effects: ", x$model$variance$variance, 
            "\n")
        cat("Spatial correlation parameter: ", x$model$variance$correlation, 
            "\n")
    }
    cat("MSE method: ", x$method$MSE_method, "\n")
    cat("\n")
    if (x$transformation$transformation == "no") {
        transform_data <- NULL
    }
    else {
        if (x$transformation$backtransformation == "sm") {
            backtransformation <- "slud-maiti"
        }
        else {
            backtransformation <- x$transformation$backtransformation
        }
        transform_data <- data.frame(Transformation = x$transformation$transformation, 
            Back_transformation = backtransformation, row.names = "")
    }
    if (is.null(transform_data)) {
        cat("Transformation: No transformation \n")
    }
    else {
        cat("Transformation:\n")
        print(transform_data)
    }
}
print.getVarCov.fh <-
function (x, ...) 
{
    if (inherits(x, "VarCov_random")) {
        cat("Random effects variance covariance matrix\n")
        print(x$varmat)
        cat("  Standard Deviations:", round(x$std.dev, 2), "\n")
    }
    else if (inherits(x, "VarCov_conditional")) {
        for (i in names(x)) {
            cat("domain", as.character(x[[i]]$domain), "\n")
            cat("Conditional variance covariance matrix\n")
            print(x[[i]]$varmat)
            cat("  Standard Deviations:", round(x[[i]]$std.dev, 
                2), "\n")
        }
    }
    else if (inherits(x, "VarCov_marginal")) {
        for (i in names(x)) {
            cat("domain", as.character(x[[i]]$domain), "\n")
            cat("Marginal variance covariance matrix\n")
            print(x[[i]]$varmat)
            cat("  Standard Deviations:", round(x[[i]]$std.dev, 
                2), "\n")
        }
        if (x[[1]]$correlation == "spatial") {
            cat("\n")
            cat(strwrap(prefix = " ", initial = "", "Please note, if the correlation argument of the fh object is\n                  set to spatial, the variance covariance matrix has non-zero\n                  off-diagonal elements, because the assumption of independence\n                  of the error terms does not hold. The diagonal elements are\n                  returned."))
        }
    }
}
print.step_fh <-
function (x, ...) 
{
    cat("\n")
    cat("Call:\n ")
    print(x$call)
    cat("\n")
    cat("Coefficients:\n ")
    printCoefmat(as.matrix(x$model$coefficients), has.Pvalue = TRUE)
}
print.summary.direct <-
function (x, ...) 
{
    throw_class_error(x, "direct")
    cat("Direct estimation\n")
    cat("\n")
    cat("Call:\n ")
    print(x$call)
    cat("\n")
    cat("In-sample domains: ", x$in_smp, "\n")
    cat("\n")
    cat("Sample sizes:\n")
    cat("Units in sample: ", x$size_smp, "\n")
    print(x$size_dom)
    cat("\n")
    cat("Units in each Domain:")
    print(x$smp_size_tab)
}
print.summary.ebp <-
function (x, ...) 
{
    throw_class_error(x, "ebp")
    cat("Empirical Best Prediction\n")
    cat("\n")
    cat("Call:\n ")
    print(x$call)
    cat("\n")
    cat("Out-of-sample domains: ", x$out_of_smp, "\n")
    cat("In-sample domains: ", x$in_smp, "\n")
    if (!is.null(x$in_smp_sub)) {
        cat("Out-of-sample subdomains: ", x$out_of_smp_sub, "\n")
        cat("In-sample subdomains: ", x$in_smp_sub, "\n")
    }
    cat("\n")
    cat("Sample sizes:\n")
    cat("Units in sample: ", x$size_smp, "\n")
    cat("Units in population: ", x$size_pop, "\n")
    print(x$size_dom)
    cat("\n")
    if (is.null(x$call$weights)) {
        cat("Explanatory measures:\n")
    }
    else {
        cat("Explanatory measures for the mixed model:\n")
    }
    print(x$coeff_determ)
    cat("\n")
    if (is.null(x$call$weights)) {
        cat("Residual diagnostics:\n")
    }
    else {
        cat("Residual diagnostics for the mixed model:\n")
    }
    print(x$normality)
    cat("\n")
    cat("Estimated variance of random effects:\n")
    print(x$variance)
    cat("\n")
    cat("ICC: ", x$icc, "\n")
    cat("\n")
    cat("Shrinkage factors", "\n")
    print(x$shrinkage)
    cat("\n")
    if (is.null(x$transform)) {
        cat("Transformation: No transformation \n")
    }
    else {
        cat("Transformation:\n")
        print(x$transform)
    }
}
print.summary.ell <-
function (x, ...) 
{
    throw_class_error(x, "ell")
    cat("ELL estimation\n")
    cat("\n")
    cat("Call:\n ")
    print(x$call)
    cat("\n")
    cat("Out-of-sample domains: ", x$out_of_smp, "\n")
    cat("In-sample domains: ", x$in_smp, "\n")
    if (!is.null(x$in_smp_sub)) {
        cat("Out-of-sample subdomains: ", x$out_of_smp_sub, "\n")
        cat("In-sample subdomains: ", x$in_smp_sub, "\n")
    }
    cat("\n")
    cat("Sample sizes:\n")
    cat("Units in sample: ", x$size_smp, "\n")
    cat("Units in population: ", x$size_pop, "\n")
    print(x$size_dom)
    cat("\n")
    if (is.null(x$call$weights)) {
        cat("Explanatory measures:\n")
    }
    else {
        cat("Explanatory measures for the random effects model:\n")
    }
    print(x$coeff_determ)
    cat("\n")
    if (is.null(x$call$weights)) {
        cat("Residual diagnostics:\n")
    }
    else {
        cat("Residual diagnostics for the random effects model:\n")
    }
    print(x$normality)
    cat("\n")
    cat("Estimated variance of random effects:\n")
    print(x$variance)
    cat("\n")
    if (is.null(x$transform)) {
        cat("Transformation: No transformation \n")
    }
    else {
        cat("Transformation:\n")
        print(x$transform)
    }
}
print.summary.fh <-
function (x, ...) 
{
    throw_class_error(x, "fh")
    cat("Call:\n ")
    print(x$call)
    cat("\n")
    cat("Out-of-sample domains: ", x$out_of_smp, "\n")
    cat("In-sample domains: ", x$in_smp, "\n")
    cat("\n")
    cat("Variance and MSE estimation:\n")
    if (x$method$method == "reblup" || x$method$method == "reblupbc") {
        cat("Variance estimation method: robustified ml,", x$method$method, 
            "\n")
        if (x$method$method == "reblup") {
            cat("k = ", x$model$k, "\n")
        }
        else if (x$method$method == "reblupbc") {
            cat("k = ", x$model$k, ", mult_constant = ", x$model$mult_constant, 
                "\n")
        }
    }
    else {
        cat("Variance estimation method: ", x$method$method, 
            "\n")
    }
    if (x$model$correlation == "no") {
        cat("Estimated variance component(s): ", x$model$variance, 
            "\n")
    }
    else {
        cat("Estimated variance component(s): ", x$model$correlation, 
            "correlation assumed\n")
        print(x$model$variance)
    }
    cat("MSE method: ", x$method$MSE_method, "\n")
    cat("\n")
    cat("Coefficients:\n")
    printCoefmat(as.matrix(x$model$coefficients), has.Pvalue = TRUE)
    cat("\n")
    cat("Explanatory measures:\n")
    if (is.null(x$model$model_select)) {
        cat("No explanatory measures provided \n")
    }
    else {
        print(x$model$model_select)
    }
    cat("\n")
    cat("Residual diagnostics:\n")
    print(x$normality)
    cat("\n")
    if (is.null(x$transform)) {
        cat("Transformation: No transformation \n")
    }
    else {
        cat("Transformation:\n")
        print(x$transform)
    }
}
pseudo <-
function (framework, combined_data, eblup, mse_type, method) 
{
    MSE <- saeRobust::mse(object = eblup$eblupobject, type = mse_type, 
        predType = method)
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    if (is.element("reblup", method)) {
        mse_data$FH[framework$obs_dom == TRUE] <- MSE$pseudo
    }
    if (is.element("reblupbc", method)) {
        mse_data$FH[framework$obs_dom == TRUE] <- MSE$pseudobc
    }
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
    }
    mse_data <- list(mse_data = mse_data, MSE_method = "pseudo linearization")
}
qqnorm.direct <-
function (y, ...) 
{
    message(strwrap(prefix = " ", initial = "", "For emdi objects obtained by direct estimation diagnostic\n                  plots are not reasonable."))
}
qqnorm.ebp <-
function (y, color = c("blue", "lightblue3"), gg_theme = NULL, 
    ...) 
{
    residuals <- residuals(y$model, level = 0, type = "pearson")
    if (y$model_par$sigmah2est == 0) {
        rand.eff <- nlme::ranef(y$model)$"(Intercept)"
        srand.eff <- (rand.eff - mean(rand.eff))/sd(rand.eff)
        tmp <- as.matrix(random.effects(y$model))[, 1]
        model <- y$model
        model$call$fixed <- y$fixed
        NextMethod("qqnorm", residuals = residuals, tmp = tmp)
    }
    else {
        rand.eff <- random.effects(y$model, level = 1)$"(Intercept)"
        srand.eff <- (rand.eff - mean(rand.eff))/sd(rand.eff)
        rand_eff_sa <- random.effects(y$model, level = 2)$"(Intercept)"
        tmp <- as.matrix(random.effects(y$model, level = 1)$"(Intercept)")
        tmp_sa <- as.matrix(random.effects(y$model, level = 2)$"(Intercept)")
        model <- y$model
        model$call$fixed <- y$fixed
        NextMethod("qqnorm", residuals = residuals, tmp = tmp, 
            tmp_sa = tmp_sa)
    }
}
qqnorm.emdi <-
function (y, color = c("blue", "lightblue3"), gg_theme = NULL, 
    ...) 
{
    extra_args <- list(...)
    residuals <- extra_args[["residuals"]]
    tmp <- extra_args[["tmp"]]
    tmp_sa <- extra_args[["tmp_sa"]]
    res <- qplot(sample = residuals) + geom_abline(colour = color[1]) + 
        ggtitle("Error term") + ylab("Quantiles of pearson residuals") + 
        xlab("Theoretical quantiles") + gg_theme
    ran <- ggplot(data.frame(tmp), aes(sample = tmp)) + stat_qq(distribution = qnorm, 
        dparams = list(mean = mean(tmp), sd = sd(tmp))) + geom_abline(intercept = 0, 
        slope = 1, na.rm = TRUE, col = color[1]) + ggtitle("Area Random effect") + 
        ylab("Quantiles of random effects") + xlab("Theoretical quantiles") + 
        gg_theme
    if (!is.null(tmp_sa)) {
        ran_sa <- ggplot(data.frame(tmp_sa), aes(sample = tmp_sa)) + 
            stat_qq(distribution = qnorm, dparams = list(mean = mean(tmp_sa), 
                sd = sd(tmp_sa))) + geom_abline(intercept = 0, 
            slope = 1, na.rm = TRUE, col = color[1]) + ggtitle("Sub-area random effect") + 
            ylab("Quantiles of random effects") + xlab("Theoretical quantiles") + 
            gg_theme
    }
    invisible(grid.arrange(arrangeGrob(res, ran, ran_sa, ncol = 3)))
}
qqnorm.fh <-
function (y, color = c("blue", "lightblue3"), gg_theme = NULL, 
    ...) 
{
    if (any(is.na(y$model$std_real_residuals))) {
        residuals <- y$model$std_real_residuals[!is.na(y$model$std_real_residuals)]
        warning(strwrap(prefix = " ", initial = "", "At least one value in the standardized realized residuals\n                    is NA. Only numerical values are plotted."))
    }
    else {
        residuals <- y$model$std_real_residuals
    }
    residuals <- (residuals - mean(residuals))/sd(residuals)
    rand.eff <- y$model$random_effects
    srand.eff <- (rand.eff - mean(rand.eff))/sd(rand.eff)
    tmp <- srand.eff
    NextMethod("qqnorm", residuals = residuals, tmp = tmp)
}
random.effects.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    ranef(object$model)
}
random.effects.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    random_effects <- object$model$random_effects
    row.names(random_effects) <- object$ind$Domain[object$ind$Out == 
        0]
    random_effects
}
ranef.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    ranef(object$model)
}
ranef.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    random_effects <- object$model$random_effects
    row.names(random_effects) <- object$ind$Domain[object$ind$Out == 
        0]
    random_effects
}
reestimate_lmer <-
function (object = object) 
{
    data <- object$model$data
    formula <- object$model$call$fixed
    formula <- paste0(formula, " + (1 | ", names(object$model$call$random[1]), 
        ")")
    if (!object$model$call$random[2] == "NULL") {
        formula <- paste0(formula, " + (1 | ", names(object$model$call$random[2]), 
            ")")
    }
    args = list(formula = formula, data = data, weights = object$model$data[, 
        object$framework$weight])
    lme <- do.call(lme4:::lmer, args)
    return(lme)
}
reml <-
function (fixed = fixed, smp_data = smp_data, smp_domains = smp_domains, 
    transformation = transformation, lambda = lambda, framework = framework) 
{
    sd_transformed_data <- std_data_transformation(fixed = fixed, 
        smp_data = smp_data, transformation = transformation, 
        lambda = lambda)
    model_REML <- NULL
    try(if (!is.null(framework$weights) && framework$weights_type == 
        "nlme_lambda") {
        sd_transformed_data$weights_scaled <- smp_data[, framework$weights]/mean(smp_data[, 
            framework$weights], na.rm = TRUE)
        model_REML <- lme(fixed = fixed, data = sd_transformed_data, 
            random = as.formula(paste0("~ 1 | as.factor(", smp_domains, 
                ")")), method = framework$nlme_method, control = nlme::lmeControl(maxIter = framework$nlme_maxiter, 
                tolerance = framework$nlme_tolerance, opt = framework$nlme_opt, 
                optimMethod = framework$nlme_optimmethod, msMaxIter = framework$nlme_msmaxiter, 
                msTol = framework$nlme_mstol, returnObject = framework$nlme_returnobject), 
            keep.data = FALSE, weights = varComb(varIdent(as.formula(paste0("~ 1 | as.factor(", 
                framework$smp_domains, ")"), )), varFixed(as.formula(paste0("~1/", 
                "weights_scaled")))))
    }
    else {
        model_REML <- lme(fixed = fixed, data = sd_transformed_data, 
            random = as.formula(paste0("~ 1 | as.factor(", smp_domains, 
                ")")), method = framework$nlme_method, control = nlme::lmeControl(maxIter = framework$nlme_maxiter, 
                tolerance = framework$nlme_tolerance, opt = framework$nlme_opt, 
                optimMethod = framework$nlme_optimmethod, msMaxIter = framework$nlme_msmaxiter, 
                msTol = framework$nlme_mstol, returnObject = framework$nlme_returnobject), 
            keep.data = FALSE)
    }, silent = TRUE)
    if (is.null(model_REML)) {
        stop(strwrap(prefix = " ", initial = "", "The likelihood did not converge when estimating an nlme model to select the optimal\n                 transformation parameter. Try adjusting nlme_opt, nlme_maxiter, nlme_tolerance, \n                 nlme_optimmethod, or nlme_returnobject when calling ebp, or using a non-adapative transformation. See also\n                 help(ebp)."))
    }
    else {
        model_REML <- model_REML
    }
    log_likelihood <- -logLik(model_REML)
    return(log_likelihood)
}
residuals.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    residuals(object$model, ...)
}
residuals.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    type <- ""
    try(type <- list(...)[[1]], silent = TRUE)
    if (type == "standardized") {
        object$model$std_real_residuals
    }
    else {
        object$model$real_residuals
    }
}
robustboot <-
function (framework, combined_data, eblup, mse_type, B, method) 
{
    MSE <- saeRobust::mse(object = eblup$eblupobject, type = mse_type, 
        predType = method, B = B)
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    if (is.element("reblup", method)) {
        mse_data$FH[framework$obs_dom == TRUE] <- MSE$boot
    }
    if (is.element("reblupbc", method)) {
        mse_data$FH[framework$obs_dom == TRUE] <- MSE$bootbc
    }
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
    }
    mse_data <- list(mse_data = mse_data, MSE_method = "bootstrap")
}
rowvar <-
function (x) 
{
    rowvar <- apply(x, 1, var)
}
scaler <-
function (x, region) 
{
    average_x <- tapply(x, INDEX = region, FUN = mean, na.rm = TRUE)
    df <- merge(data.frame(x, region), data.frame(names(average_x), 
        average_x), by.x = "region", by.y = "names.average_x.")
    return(df$x/df$average_x)
}
sigma.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    object$model$sigma
}
slud_maiti <-
function (framework, sigmau2, eblup, combined_data) 
{
    nu <- framework$model_X %*% eblup$coefficients$coefficients
    gamma <- eblup$gamma
    tau <- sigmau2 + framework$vardir
    X <- framework$model_X
    psi <- matrix(c(framework$vardir), framework$m, 1)
    Z.area <- diag(1, framework$m)
    I <- diag(1, framework$m)
    V <- sigmau2 * Z.area %*% t(Z.area) + I * psi[, 1]
    Vi <- solve(V)
    Xt <- t(X)
    XVi <- Xt %*% Vi
    Q <- solve(XVi %*% X)
    D <- diag(1, framework$m)
    Deriv1 <- solve((sigmau2 * D) + diag(c(framework$vardir), 
        framework$m))
    Var.sigma <- ((1/2) * sum(diag(Deriv1 %*% Deriv1)))^(-1)
    tmp <- NULL
    for (i in seq_len(framework$m)) {
        tmp[i] <- (t(framework$model_X)[, i] %*% Q %*% framework$model_X[i, 
            ])/(tau[i]^2)
    }
    mse <- NULL
    for (j in seq_len(framework$m)) {
        mse[j] <- exp(2 * (nu[j, 1] + sigmau2)) * (1 - exp(-gamma[j] * 
            framework$vardir[j])) + ((framework$vardir[j]^2)/tau[j]^2) * 
            exp(2 * nu[j, 1] + sigmau2 * (1 + gamma[j])) * (t(framework$model_X)[, 
            j] %*% Q %*% framework$model_X[j, ]) + Var.sigma * 
            ((framework$vardir[j]^2)/tau[j]^2) * exp(2 * nu[j, 
            1] + sigmau2 * (1 + gamma[j])) * ((1/4) * (1 + 3 * 
            gamma[j])^2 + (1/tau[j])) - exp(2 * (nu[j, 1] + sigmau2)) * 
            (2 * (1 - exp(-gamma[j] * framework$vardir[j])) * 
                (t(framework$model_X)[, j] %*% Q %*% framework$model_X[j, 
                  ]) - Var.sigma * (2 + (((framework$vardir[j]^2)/tau[j]^2) - 
                2) * exp(-gamma[j] * framework$vardir[j])) * 
                sum(tmp) + Var.sigma * (2 + (((2 * (framework$vardir[j]^2))/(tau[j]^2)) - 
                2) * exp(-gamma[j] * framework$vardir[j]) - ((framework$vardir[j]^2)/(tau[j]^3)) * 
                exp(-gamma[j] * framework$vardir[j]) * (1 + ((framework$vardir[j]^2)/(2 * 
                tau[j])))))
    }
    mse_data <- data.frame(Domain = framework$combined_data[[framework$domains]])
    mse_data$Direct <- NA
    mse_data$Direct[framework$obs_dom == TRUE] <- framework$vardir
    mse_data$FH[framework$obs_dom == TRUE] <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that EBLUP and MSE results are only returned\n                    for in-sample domains. For more information see help(fh)."))
    }
    return(mse_data)
}
spatialcor.tests <-
function (direct, corMatrix) 
{
    spatialcor_check(direct = direct, corMatrix = corMatrix)
    if (is.matrix(corMatrix) == FALSE) {
        corMatrix <- as.matrix(corMatrix)
    }
    corMatrix_list <- mat2listw(corMatrix)
    moran <- moran.test(direct, corMatrix_list, randomisation = TRUE, 
        zero.policy = TRUE, alternative = "greater")
    geary <- geary.test(direct, corMatrix_list, randomisation = TRUE, 
        zero.policy = TRUE, alternative = "greater")
    out <- data.frame(Statistics = c("Moran's I", "Geary's C"), 
        Value = c(unname(moran$estimate[1]), unname(geary$estimate[1])), 
        p.value = c(moran$p.value, geary$p.value))
    out
}
spatialcor_check <-
function (direct, corMatrix) 
{
    if (!is.vector(direct)) {
        stop("direct must be a vector.")
    }
    if (any(is.na(direct))) {
        stop("direct must not contain NAs.")
    }
    if (any(is.na(corMatrix))) {
        stop("corMatrix must not contain NAs.")
    }
    if (!(is.matrix(corMatrix) || is.data.frame(corMatrix))) {
        stop("corMatrix must be a matrix or data frame.")
    }
    if (dim(corMatrix)[1] != dim(corMatrix)[2]) {
        stop(strwrap(prefix = " ", initial = "", "corMatrix must be a matrix or data frame with same number of\n                 rows and columns equal to the length of direct."))
    }
    if (length(direct) != dim(corMatrix)[1]) {
        stop(strwrap(prefix = " ", initial = "", "The vector containing the direct estimates must have the same\n                 length as the dimensions of corMatrix."))
    }
    if (all(corMatrix == 0)) {
        stop(strwrap(prefix = " ", initial = "", "The elements of corMatrix are all equal to 0. Please provide\n                 a valid proximity matrix. A description how a proximity matrix\n                 can be computed can be found in the vignette."))
    }
}
specify_decimal <-
function (x, k) 
trimws(format(round(x, k), nsmall = k))
std_data_transformation <-
function (fixed = fixed, smp_data, transformation, lambda) 
{
    y_vector <- as.matrix(smp_data[paste(fixed[[2]])])
    if (transformation == "box.cox") {
        std_transformed <- as.data.frame(box_cox_std(y = y_vector, 
            lambda = lambda))
    }
    else if (transformation == "dual") {
        std_transformed <- as.data.frame(dual_std(y = y_vector, 
            lambda = lambda))
    }
    else if (transformation == "log.shift") {
        std_transformed <- as.data.frame(log_shift_opt_std(y = y_vector, 
            lambda = lambda))
    }
    else if (transformation == "log") {
        std_transformed <- log(smp_data[paste(fixed[[2]])])
    }
    else if (transformation == "no") {
        std_transformed <- smp_data[paste(fixed[[2]])]
    }
    else if (transformation == "arcsin") {
        std_transformed <- smp_data[paste(fixed[[2]])]
    }
    else if (transformation == "ordernorm") {
        std_transformed <- smp_data[paste(fixed[[2]])]
    }
    else if (transformation == "logit") {
        std_transformed <- smp_data[paste(fixed[[2]])]
    }
    smp_data[paste(fixed[[2]])] <- std_transformed
    return(transformed_data = smp_data)
}
step <-
function (object, scope, criteria, direction, trace, steps, ...) 
{
    UseMethod("step")
}
step.default <-
function (object, ...) 
stats::step(object, ...)
step.fh <-
function (object, scope = NULL, criteria = "AIC", direction = "both", 
    trace = TRUE, steps = 1000, ...) 
{
    step_check(object = object, scope = scope, criteria = criteria, 
        direction = direction, trace = trace, steps = steps)
    if ((criteria == "AICc" || criteria == "AICb1" || criteria == 
        "AICb2" || criteria == "KICc" || criteria == "KICb1" || 
        criteria == "KICb2") && (is.null(object$model$seed))) {
        object$call$seed <- 123
        catmessage <- capture.output(object <- eval(object$call))
        message(strwrap(prefix = " ", initial = "", "Seed in fh object not defined, 123 used as default\n                    seed."))
    }
    startobject <- object
    cut.string <- function(string) {
        if (length(string) > 1L) {
            string[-1L] <- paste0("\n", string[-1L])
        }
        string
    }
    step.results <- function(models, fit, object, catmessage) {
        change <- vapply(models, "[[", "change", FUN.VALUE = character(1))
        rdf <- vapply(models, "[[", "df.resid", FUN.VALUE = numeric(1))
        ddf <- c(NA, diff(rdf))
        infcriteria <- NULL
        infcriteria <- vapply(models, "[[", "criteria", FUN.VALUE = numeric(1))
        heading <- c("Stepwise Model Path \nAnalysis of Deviance Table", 
            "\nInitial Model:", deparse(object$fixed), "\nFinal Model:", 
            deparse(fit$fixed), "\n")
        aod <- data.frame(Step = I(change), Df = ddf, criteria = infcriteria, 
            check.names = FALSE)
        attr(aod, "heading") <- heading
        fit$call$MSE <- startobject$call$MSE
        fit$call$formula <- NULL
        invisible(fit <- eval(fit$call))
        if (catmessage == TRUE) {
            message("\n")
            message(strwrap(prefix = " ", initial = "", "Please note that the model selection criteria are only\n                      computed based of the in-sample domains."))
        }
        class(fit) <- c("step_fh", "fh", "emdi")
        fit
    }
    Terms <- terms(object$fixed)
    object$call$formula <- object$formula <- Terms
    md <- missing(direction)
    backward <- direction == "both" | direction == "backward"
    forward <- direction == "both" | direction == "forward"
    if (missing(scope)) {
        fdrop <- numeric()
        fadd <- attr(Terms, "factors")
        if (md) {
            forward <- FALSE
        }
    }
    else {
        if (is.list(scope)) {
            fdrop <- if (!is.null(fdrop <- scope$lower)) {
                attr(terms(update.formula(object$fixed, fdrop)), 
                  "factors")
            }
            else {
                numeric()
            }
            fadd <- if (!is.null(fadd <- scope$upper)) {
                attr(terms(update.formula(object$fixed, fadd)), 
                  "factors")
            }
        }
        else {
            fadd <- if (!is.null(fadd <- scope)) {
                attr(terms(update.formula(object$fixed, scope)), 
                  "factors")
            }
            fdrop <- numeric()
        }
    }
    models <- vector("list", steps)
    n <- object$framework$N_dom_smp
    fit <- object
    bcriteria <- fit$model$model_select[[criteria]]
    edf <- length(attr(terms(object$fixed), "term.labels")) + 
        1
    if (bcriteria == -Inf) {
        stop(criteria, "is -infinity for this model, so 'step' cannot proceed", 
            sep = " ")
    }
    nm <- 1
    if (trace == TRUE) {
        message("Start: ", criteria, " = ", format(round(bcriteria, 
            2)), "\n", cut.string(deparse(fit$fixed)), "\n\n", 
            sep = "")
        flush.console()
    }
    models[[nm]] <- list(df.resid = n - edf, change = "", criteria = bcriteria)
    while (steps > 0) {
        steps <- steps - 1
        infcriteria <- bcriteria
        ffac <- attr(Terms, "factors")
        scope <- factor.scope(ffac, list(add = fadd, drop = fdrop))
        aod <- NULL
        change <- NULL
        if (backward && length(scope$drop)) {
            aod <- drop1.fh(fit, criteria = criteria, scope = scope$drop, 
                scale = 0)
            rn <- row.names(aod)
            row.names(aod) <- c(rn[1L], paste("-", rn[-1L]))
            if (any(aod$Df == 0, na.rm = TRUE)) {
                zdf <- aod$Df == 0 & !is.na(aod$Df)
                change <- rev(rownames(aod)[zdf])[1L]
            }
        }
        if (is.null(change)) {
            if (forward && length(scope$add)) {
                aodf <- add1.fh(fit, criteria = criteria, scope = scope$add)
                rn <- row.names(aodf)
                row.names(aodf) <- c(rn[1L], paste("+", rn[-1L]))
                aod <- if (is.null(aod)) {
                  aodf
                }
                else {
                  rbind(aod, aodf[-1, , drop = FALSE])
                }
            }
            attr(aod, "heading") <- NULL
            nzdf <- if (!is.null(aod$Df)) {
                aod$Df != 0 | is.na(aod$Df)
            }
            aod <- aod[nzdf, ]
            if (is.null(aod) || ncol(aod) == 0) {
                break
            }
            nc <- match("criteria", names(aod))
            nc <- nc[!is.na(nc)][1L]
            o <- order(aod[, nc])
            names(aod) <- c("df", criteria)
            if (trace == TRUE) {
                print(aod[o, ])
            }
            if (o[1L] == 1) {
                break
            }
            change <- rownames(aod)[o[1L]]
        }
        fit$call$fixed <- update(fit$fixed, as.formula(paste("~ . ", 
            change)), evaluate = FALSE)
        fit$call$MSE <- FALSE
        fit$call$formula <- NULL
        catmessage <- capture.output(fit <- eval(fit$call))
        nnew <- fit$framework$N_dom_smp
        if (all(is.finite(c(n, nnew))) && nnew != n) {
            stop("number of rows in use has changed: remove missing values?")
        }
        Terms <- terms(fit$fixed)
        bcriteria <- fit$model$model_select[[criteria]]
        edf <- length(attr(terms(fit$fixed), "term.labels")) + 
            1
        if (trace == TRUE) {
            message("\nStep: ", criteria, " = ", format(round(bcriteria, 
                2)), "\n", cut.string(deparse(fit$fixed)), "\n\n", 
                sep = "")
            flush.console()
        }
        if (bcriteria >= infcriteria + 9.9999999999999995e-08) {
            break
        }
        nm <- nm + 1
        models[[nm]] <- list(df.resid = n - edf, change = "", 
            criteria = bcriteria)
    }
    if (any(grepl(pattern = c("Please note that the model selection criteria are\n                            only computed based on the in-sample domains."), 
        x = ""))) {
        catmessage <- TRUE
    }
    else {
        catmessage <- FALSE
    }
    step.results(models = models[seq(nm)], fit, object, catmessage)
}
step_check <-
function (object, scope, criteria, direction, trace, steps) 
{
    if (!inherits(object, "fh")) {
        stop("Object needs to be fh object.")
    }
    if (!(object$method$method == "ml")) {
        stop(strwrap(prefix = " ", initial = "", "The variance estimation method of the random effect has to be\n                 ml. Otherwise the comparison of models based on information\n                 criteria would not be valid."))
    }
    if (is.null(criteria) || !(criteria == "AIC" || criteria == 
        "AICc" || criteria == "AICb1" || criteria == "AICb2" || 
        criteria == "BIC" || criteria == "KIC" || criteria == 
        "KICc" || criteria == "KICb1" || criteria == "KICb2")) {
        stop(strwrap(prefix = " ", initial = "", "The nine options for criteria are ''AIC', ''AICc'',\n                 ''AICb1'', ''AICb2'', ''BIC'', ''KIC'', ''KICc'', ''KICb1'',\n                 ''KICb2''."))
    }
    if (is.null(object$model$model_select[[criteria]])) {
        stop(strwrap(prefix = " ", initial = "", "The fh object does not contain the chosen criterion. Please\n                 set the second element of the input argument B of the fh\n                 function to a number greater than 1 to receive results for all\n                 of the information criteria. For some model extensions of the\n                 fh model the information criteria are not defined. Check the\n                 model_select component of the fh object\n                 (objectname$model$model_select). If no criteria are provided,\n                 it is not possible to apply the stepwise variable selection\n                 algorithm."))
    }
    if (is.null(direction) || !(direction == "forward" || direction == 
        "backward" || direction == "both")) {
        stop(strwrap(prefix = " ", initial = "", "The three options for direction are ''forward', ''backward'',\n                 ''both''."))
    }
    if (!is.logical(trace) || length(trace) != 1) {
        stop(strwrap(prefix = " ", initial = "", "trace must be a logical value. Set MSE to TRUE or FALSE. The\n                 default is set to TRUE. See also help(step)."))
    }
    if (!is.null(scope) && ((!inherits(scope, "formula")) && 
        (!inherits(scope, "list") || (!inherits(scope[[1]], "formula") || 
            !inherits(scope[[2]], "formula"))))) {
        stop(strwrap(prefix = " ", initial = "", "Scope must be a formula or a list including two formulas\n                 (lower and upper)."))
    }
    if (!is.numeric(steps) || !(is.numeric(steps) && length(steps) == 
        1)) {
        stop(strwrap(prefix = " ", initial = "", "steps must be a single number determining the maximum number\n                 of steps. See help(step)."))
    }
}
subset.estimators.povmap <-
function (x, ...) 
{
    x <- as.data.frame(x)
    subset(x = x, ...)
}
summary.direct <-
function (object, ...) 
{
    throw_class_error(object, "direct")
    call_povmap <- object$call
    N_dom_smp <- object$framework$N_dom_smp
    smp_size <- object$framework$N_smp
    smp_size_tab <- table(object$framework$smp_domains_vec)
    smp_size_dom <- rbind(Sample_domains = summary(as.numeric(smp_size_tab)))
    sum_povmap <- list(out_of_smp = NULL, in_smp = N_dom_smp, 
        size_smp = smp_size, size_pop = NULL, size_dom = smp_size_dom, 
        smp_size_tab = smp_size_tab, transform = NULL, normality = NULL, 
        icc = NULL, coeff_determ = NULL, model = NULL, call = call_povmap)
    class(sum_povmap) <- c("summary.direct", "povmap")
    sum_povmap
}
summary.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    call_povmap <- object$call
    N_dom_unobs <- object$framework$N_dom_unobs
    N_dom_smp <- object$framework$N_dom_smp
    N_subdom_unobs <- object$framework$N_subdom_unobs
    N_subdom_smp <- object$framework$N_subdom_smp
    smp_size <- object$framework$N_smp
    pop_size <- object$framework$N_pop
    smp_size_dom <- summary(as.data.frame(table(object$framework$smp_domains_vec))[, 
        "Freq"])
    pop_size_dom <- summary(as.data.frame(table(object$framework$pop_domains_vec))[, 
        "Freq"])
    sizedom_smp_pop <- rbind(Sample_domains = smp_size_dom, Population_domains = pop_size_dom)
    if (object$transformation == "box.cox" || object$transformation == 
        "dual") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Method = object$method, Optimal_lambda = object$transform_param$optimal_lambda, 
            Shift_parameter = round(object$transform_param$shift_par, 
                3), row.names = "")
    }
    else if (object$transformation == "log.shift") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Method = object$method, Optimal_lambda = object$transform_param$optimal_lambda, 
            row.names = "")
    }
    else if (object$transformation == "log") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Shift_parameter = round(object$transform_param$shift_par, 
                3), row.names = "")
    }
    else if (object$transformation == "ordernorm") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Shift_parameter = 0, row.names = "")
    }
    else if (object$transformation == "arcsin") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Shift_parameter = 0, row.names = "")
    }
    else if (object$transformation == "no") {
        transform_method <- NULL
    }
    residuals <- object$model_par$e1
    skewness_res <- skewness(residuals)
    kurtosis_res <- kurtosis(residuals)
    variance_res <- object$model_par$sigmae2est
    variance_ran <- object$model_par$sigmau2est
    if (!is.null(object$framework$smp_subdomains) && !is.null(object$framework$pop_subdomains)) {
        residuals <- object$model_par$e2
        dist_obs_dom <- unique(object$framework$pop_domains_vec) %in% 
            unique(object$framework$smp_domains_vec)
        dist_obs_subdom <- unique(object$framework$pop_subdomains_vec) %in% 
            unique(object$framework$smp_subdomains_vec)
        ranef <- object$model_par$rand_eff[dist_obs_dom]
        ranef_sub <- object$model_par$rand_eff_h[dist_obs_subdom]
        skewness_ran <- skewness(ranef)
        kurtosis_ran <- kurtosis(ranef)
        skewness_ran_sub <- skewness(ranef_sub)
        kurtosis_ran_sub <- kurtosis(ranef_sub)
        variance_ran_sub <- object$model_par$sigmah2est
        if (length(residuals) > 3 && length(residuals) < 5000) {
            shapiro_p_res <- shapiro.test(residuals)[[2]]
            shapiro_W_res <- shapiro.test(residuals)[[1]]
        }
        else {
            warning(strwrap(prefix = " ", initial = "", "Number of observations exceeds 5000 or is lower then 3 and\n                    thus the Shapiro-Wilk test is not applicable for the\n                    residuals."))
            shapiro_W_res <- NA
            shapiro_p_res <- NA
        }
        if (length(ranef) > 3 && length(ranef) < 5000) {
            shapiro_p_ran <- shapiro.test(ranef)[[2]]
            shapiro_W_ran <- shapiro.test(ranef)[[1]]
        }
        else {
            warning(strwrap(prefix = " ", initial = "", "Number of domains exceeds 5000 or is lower then 3 and thus\n                    the Shapiro-Wilk test is not applicable for the area random\n                    effects."))
            shapiro_p_ran <- NA
            shapiro_W_ran <- NA
        }
        if (length(ranef_sub) > 3 && length(ranef_sub) < 5000) {
            shapiro_p_ran_sub <- shapiro.test(ranef_sub)[[2]]
            shapiro_W_ran_sub <- shapiro.test(ranef_sub)[[1]]
        }
        else {
            warning(strwrap(prefix = " ", initial = "", "Number of subdomains exceeds 5000 or is lower then 3 and thus\n                    the Shapiro-Wilk test is not applicable for the subarea random\n                    effects."))
            shapiro_p_ran_sub <- NA
            shapiro_W_ran_sub <- NA
        }
        norm <- data.frame(Skewness = c(skewness_res, skewness_ran, 
            skewness_ran_sub), Kurtosis = c(kurtosis_res, kurtosis_ran, 
            kurtosis_ran_sub), Shapiro_W = c(shapiro_W_res, shapiro_W_ran, 
            shapiro_W_ran_sub), Shapiro_p = c(shapiro_p_res, 
            shapiro_p_ran, shapiro_p_ran_sub), row.names = c("Error", 
            paste0(object$framework$smp_domains, " random effect"), 
            paste0(object$framework$smp_subdomains, " random effect")))
        var <- data.frame(Variance = c(variance_res, variance_ran, 
            variance_ran_sub), row.names = c("Error", paste0(object$framework$smp_domains, 
            " random effect"), paste0(object$framework$smp_subdomains, 
            " random effect")))
    }
    else {
        dist_obs_dom <- unique(object$framework$pop_domains_vec) %in% 
            unique(object$framework$smp_domains_vec)
        ranef <- object$model_par$rand_eff[dist_obs_dom]
        skewness_ran <- skewness(ranef)
        kurtosis_ran <- kurtosis(ranef)
        if (length(residuals) > 3 && length(residuals) < 5000) {
            shapiro_p_res <- shapiro.test(residuals)[[2]]
            shapiro_W_res <- shapiro.test(residuals)[[1]]
        }
        else {
            warning(strwrap(prefix = " ", initial = "", "Number of observations exceeds 5000 or is lower then 3 and\n                    thus the Shapiro-Wilk test is not applicable for the\n                    residuals."))
            shapiro_p_res <- NA
            shapiro_W_res <- NA
        }
        if (length(ranef) > 3 && length(ranef) < 5000) {
            shapiro_p_ran <- shapiro.test(ranef)[[2]]
            shapiro_W_ran <- shapiro.test(ranef)[[1]]
        }
        else {
            warning(strwrap(prefix = " ", initial = "", "Number of domains exceeds 5000 or is lower then 3 and thus\n                    the Shapiro-Wilk test is not applicable for the random\n                    effects."))
            shapiro_p_ran <- NA
            shapiro_W_ran <- NA
        }
        norm <- data.frame(Skewness = c(skewness_res, skewness_ran), 
            Kurtosis = c(kurtosis_res, kurtosis_ran), Shapiro_W = c(shapiro_W_res, 
                shapiro_W_ran), Shapiro_p = c(shapiro_p_res, 
                shapiro_p_ran), row.names = c("Error", "Random_effect"))
        var <- data.frame(Variance = c(variance_res, variance_ran), 
            row.names = c("Error", "Random_effect"))
    }
    tempMod <- object$model
    tempMod$call$fixed <- object$fixed
    r_squared <- suppressWarnings(r.squaredGLMM(tempMod))
    if (is.matrix(r_squared)) {
        r_marginal <- r_squared[1, 1]
        r_conditional <- r_squared[1, 2]
    }
    else {
        r_marginal <- r_squared[1]
        r_conditional <- r_squared[2]
    }
    icc_mixed <- icc(object)
    groups = tempMod$data[, object$framework$smp_domains]
    if (is.null(object$framework$weights)) {
        object$framework$weights <- "temp_weights"
        object$model$data$temp_weights <- 1
    }
    y_yhat <- data.frame(Y = tempMod$data[, 1], marginal = tempMod$fitted[, 
        1], conditional = tempMod$fitted[, 2], weights = object$model$data[, 
        object$framework$weights])
    y_yhat_bar <- aggregate_weighted_mean(y_yhat, by = list(groups), 
        w = object$model$data[, object$framework$weights])[, 
        -c(1, 5)]
    r2_area <- cor(y_yhat_bar[])[2:3, 1]^2
    r_marginal_area <- r2_area[1]
    r_conditional_area <- r2_area[2]
    coeff_det <- data.frame(Marginal_R2 = r_marginal, Conditional_R2 = r_conditional, 
        Marginal_Area_R2 = r_marginal_area, Conditional_Area_R2 = r_conditional_area, 
        row.names = "")
    if (is.null(object$model_par$gamma_sub)) {
        shrinkage <- data.frame(gamma = t(as.matrix(summary(object$model_par$gamma))), 
            row.names = paste0(object$framework$smp_domains, 
                ""))
    }
    else {
        shrinkage <- data.frame(gamma = t(as.matrix(cbind(summary(object$model_par$gamma), 
            summary(object$model_par$gamma_sub)))), row.names = c(paste0(object$framework$smp_domains, 
            ""), paste0(object$framework$smp_subdomains, "")))
    }
    sum_povmap <- list(out_of_smp = N_dom_unobs, in_smp = N_dom_smp, 
        out_of_smp_sub = N_subdom_unobs, in_smp_sub = N_subdom_smp, 
        size_smp = smp_size, size_pop = pop_size, size_dom = sizedom_smp_pop, 
        smp_size_tab = NULL, transform = transform_method, normality = norm, 
        variance = var, shrinkage = shrinkage, icc = icc_mixed, 
        coeff_determ = coeff_det, call = call_povmap)
    class(sum_povmap) <- c("summary.ebp", "povmap")
    sum_povmap
}
summary.ell <-
function (object, ...) 
{
    throw_class_error(object, "ell")
    call_povmap <- object$call
    N_dom_unobs <- object$framework$N_dom_unobs
    N_dom_smp <- object$framework$N_dom_smp
    N_subdom_unobs <- object$framework$N_subdom_unobs
    N_subdom_smp <- object$framework$N_subdom_smp
    smp_size <- object$framework$N_smp
    pop_size <- object$framework$N_pop
    smp_size_dom <- summary(as.data.frame(table(object$framework$smp_domains_vec))[, 
        "Freq"])
    pop_size_dom <- summary(as.data.frame(table(object$framework$pop_domains_vec))[, 
        "Freq"])
    sizedom_smp_pop <- rbind(Sample_domains = smp_size_dom, Population_domains = pop_size_dom)
    if (object$transformation == "box.cox" || object$transformation == 
        "dual") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Method = object$method, Optimal_lambda = object$transform_param$optimal_lambda, 
            Shift_parameter = round(object$transform_param$shift_par, 
                3), row.names = "")
    }
    else if (object$transformation == "log.shift") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Method = object$method, Optimal_lambda = object$transform_param$optimal_lambda, 
            row.names = "")
    }
    else if (object$transformation == "log") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Shift_parameter = round(object$transform_param$shift_par, 
                3), row.names = "")
    }
    else if (object$transformation == "ordernorm") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Shift_parameter = 0, row.names = "")
    }
    else if (object$transformation == "arcsin") {
        transform_method <- data.frame(Transformation = object$transformation, 
            Shift_parameter = 0, row.names = "")
    }
    else if (object$transformation == "no") {
        transform_method <- NULL
    }
    residuals <- object$model_par$residuals - rep(object$model_par$mean_residuals, 
        object$framework$n_smp)
    skewness_res <- skewness(residuals)
    kurtosis_res <- kurtosis(residuals)
    variance_res <- object$model_par$sigmae2est
    variance_ran <- object$model_par$sigmau2est
    dist_obs_dom <- unique(object$framework$pop_domains_vec) %in% 
        unique(object$framework$smp_domains_vec)
    ranef <- object$model_par$mean_residuals
    skewness_ran <- skewness(ranef)
    kurtosis_ran <- kurtosis(ranef)
    if (length(residuals) > 3 && length(residuals) < 5000) {
        shapiro_p_res <- shapiro.test(residuals)[[2]]
        shapiro_W_res <- shapiro.test(residuals)[[1]]
    }
    else {
        warning(strwrap(prefix = " ", initial = "", "Number of observations exceeds 5000 or is lower then 3 and\n                    thus the Shapiro-Wilk test is not applicable for the\n                    residuals."))
        shapiro_p_res <- NA
        shapiro_W_res <- NA
    }
    if (length(ranef) > 3 && length(ranef) < 5000) {
        shapiro_p_ran <- shapiro.test(ranef)[[2]]
        shapiro_W_ran <- shapiro.test(ranef)[[1]]
    }
    else {
        warning(strwrap(prefix = " ", initial = "", "Number of domains exceeds 5000 or is lower then 3 and thus\n                    the Shapiro-Wilk test is not applicable for the random\n                    effects."))
        shapiro_p_ran <- NA
        shapiro_W_ran <- NA
    }
    norm <- data.frame(Skewness = c(skewness_res, skewness_ran), 
        Kurtosis = c(kurtosis_res, kurtosis_ran), Shapiro_W = c(shapiro_W_res, 
            shapiro_W_ran), Shapiro_p = c(shapiro_p_res, shapiro_p_ran), 
        row.names = c("Error", "Random_effect"))
    var <- data.frame(Variance = c(variance_res, variance_ran), 
        row.names = c("Error", "Random_effect"))
    r_squared <- summary(object$model)$r.squared
    groups = object$framework$smp_data[, object$framework$smp_domains]
    if (is.null(object$framework$weights)) {
        temp_weights <- rep(1, object$framework$N_smp)
    }
    else {
        temp_weights <- object$framework$smp_data[, object$framework$weights]
    }
    y_yhat <- data.frame(Y = object$model$model[, 1], Yhat = object$model$model[, 
        1] - object$model_par$residuals, weights = temp_weights)
    y_yhat_bar <- aggregate_weighted_mean(y_yhat, by = list(groups), 
        w = temp_weights)
    r2_area <- cor(y_yhat_bar[, 2], y_yhat_bar[, 3])^2
    coeff_det <- data.frame(R2 = r_squared[1], Area_R2 = r2_area, 
        row.names = "")
    sum_povmap <- list(out_of_smp = N_dom_unobs, in_smp = N_dom_smp, 
        out_of_smp_sub = N_subdom_unobs, in_smp_sub = N_subdom_smp, 
        size_smp = smp_size, size_pop = pop_size, size_dom = sizedom_smp_pop, 
        smp_size_tab = NULL, transform = transform_method, normality = norm, 
        variance = var, coeff_determ = coeff_det, call = call_povmap)
    class(sum_povmap) <- c("summary.ell", "povmap")
    sum_povmap
}
summary.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    skewness_stdres <- skewness(object$model$std_real_residuals, 
        na.rm = TRUE)
    kurtosis_stdres <- kurtosis(object$model$std_real_residuals, 
        na.rm = TRUE)
    if (length(object$model$std_real_residuals) >= 3 && length(object$model$std_real_residuals) < 
        5000) {
        shapiro_stdres_W <- shapiro.test(object$model$std_real_residuals)[[1]]
        shapiro_stdres_p <- shapiro.test(object$model$std_real_residuals)[[2]]
    }
    else {
        warning(strwrap(prefix = " ", initial = "", "Number of domains must be between 3 and 5000, otherwise\n                    the Shapiro-Wilk test is not applicable."))
        shapiro_stdres_W <- NA
        shapiro_stdres_p <- NA
    }
    skewness_random <- skewness(object$model$random_effects, 
        na.rm = TRUE)
    kurtosis_random <- kurtosis(object$model$random_effects, 
        na.rm = TRUE)
    if (length(object$model$random_effects) >= 3 && length(object$model$random_effects) < 
        5000) {
        shapiro_random_W <- shapiro.test(object$model$random_effects)[[1]]
        shapiro_random_p <- shapiro.test(object$model$random_effects)[[2]]
    }
    else {
        shapiro_random_W <- NA
        shapiro_random_p <- NA
    }
    normality <- data.frame(Skewness = c(skewness_stdres, skewness_random), 
        Kurtosis = c(kurtosis_stdres, kurtosis_random), Shapiro_W = c(shapiro_stdres_W, 
            shapiro_random_W), Shapiro_p = c(shapiro_stdres_p, 
            shapiro_random_p), row.names = c("Standardized_Residuals", 
            "Random_effects"))
    if (object$transformation$transformation == "no") {
        transform_data <- NULL
    }
    else {
        if (object$transformation$backtransformation == "sm") {
            backtransformation <- "slud-maiti"
        }
        else {
            backtransformation <- object$transformation$backtransformation
        }
        transform_data <- data.frame(Transformation = object$transformation$transformation, 
            Back_transformation = backtransformation, row.names = "")
    }
    sum_povmap <- list(out_of_smp = object$framework$N_dom_unobs, 
        in_smp = object$framework$N_dom_smp, size_smp = NULL, 
        size_pop = NULL, size_dom = NULL, smp_size_tab = NULL, 
        transform = transform_data, normality = normality, icc = NULL, 
        coeff_determ = NULL, model = object$model, method = object$method, 
        call = object$call)
    class(sum_povmap) <- c("summary.fh", "povmap")
    sum_povmap
}
superpopulation <-
function (framework, model_par, gen_model, lambda, shift, transformation, 
    fixed) 
{
    eps <- vector(length = framework$N_pop)
    eps[framework$obs_dom] <- rnorm(sum(framework$obs_dom), 0, 
        sqrt(model_par$sigmae2est))
    eps[!framework$obs_dom] <- rnorm(sum(!framework$obs_dom), 
        0, sqrt(model_par$sigmae2est + model_par$sigmau2est))
    vu_tmp <- rnorm(framework$N_dom_pop, 0, sqrt(model_par$sigmau2est))
    vu_pop <- rep(vu_tmp, framework$n_pop)
    Y_pop_b <- gen_model$mu_fixed + eps + vu_pop
    Y_pop_b <- back_transformation(y = Y_pop_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_pop_b[!is.finite(Y_pop_b)] <- 0
    return(list(pop_income_vector = Y_pop_b, vu_tmp = vu_tmp))
}
superpopulation_2f <-
function (framework, model_par, gen_model, lambda, shift, transformation, 
    fixed) 
{
    vu_tmp <- rnorm(framework$N_dom_pop, 0, sqrt(model_par$sigmau2est))
    vu_pop <- rep(vu_tmp, framework$n_pop)
    eta_tmp <- rnorm(framework$N_subdom_pop, 0, sqrt(model_par$sigmah2est))
    eta_pop <- rep(eta_tmp, framework$n_pop_subdom)
    eps <- vector(length = framework$N_pop)
    eps[framework$obs_dom & framework$obs_subdom] <- rnorm(sum(framework$obs_dom & 
        framework$obs_subdom), 0, sqrt(model_par$sigmae2est))
    eps[framework$obs_dom & !framework$obs_subdom] <- rnorm(sum(framework$obs_dom & 
        !framework$obs_subdom), 0, sqrt(model_par$sigmae2est + 
        model_par$sigmah2est))
    eps[!framework$obs_dom] <- rnorm(sum(!framework$obs_dom), 
        0, sqrt(model_par$sigmae2est + model_par$sigmah2est + 
            model_par$sigmau2est))
    Y_pop_b <- gen_model$mu_fixed + eps + eta_pop + vu_pop
    Y_pop_b <- back_transformation(y = Y_pop_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_pop_b[!is.finite(Y_pop_b)] <- 0
    return(list(pop_income_vector = Y_pop_b, vu_tmp = vu_tmp, 
        eta_tmp = eta_tmp))
}
superpopulation_hdp <-
function (framework, model_par, gen_model, lambda, shift, transformation, 
    fixed) 
{
    eps <- rep(0, framework$N_pop)
    eps[framework$obs_dom] <- rnorm(sum(framework$n_pop[framework$dist_obs_dom]), 
        0, rep(sqrt(model_par$sigmae2est), framework$n_pop[framework$dist_obs_dom]))
    if (framework$N_dom_unobs > 0) {
        eps[!framework$obs_dom] <- rnorm(sum(framework$n_pop[!framework$dist_obs_dom]), 
            0, rep(sqrt(model_par$sigma2e.out), framework$n_pop[!framework$dist_obs_dom]))
    }
    vu_tmp <- rnorm(framework$N_dom_pop, 0, sqrt(model_par$sigmau2est))
    vu_pop <- rep(vu_tmp, framework$n_pop)
    Y_pop_b <- gen_model$mu_fixed + eps + vu_pop
    Y_pop_b <- back_transformation(y = Y_pop_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_pop_b[!is.finite(Y_pop_b)] <- 0
    return(list(pop_income_vector = Y_pop_b, vu_tmp = vu_tmp))
}
superpopulation_wild <-
function (framework, model_par, gen_model, lambda, shift, transformation, 
    res_s, fitted_s, fixed) 
{
    res_s <- sqrt(model_par$sigmae2est) * (res_s - mean(res_s))/sd(res_s)
    vu_tmp <- rnorm(framework$N_dom_pop, 0, sqrt(model_par$sigmau2est))
    vu_pop <- rep(vu_tmp, framework$n_pop)
    Y_pop_b <- gen_model$mu_fixed + vu_pop
    indexer <- FNN::knnx.index(data = fitted_s, query = Y_pop_b, 
        k = 1)
    eps <- res_s[indexer]
    wu <- sample(c(-1, 1), size = length(eps), replace = TRUE)
    eps <- abs(eps) * wu
    Y_pop_b <- Y_pop_b + eps
    Y_pop_b <- back_transformation(y = Y_pop_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework, 
        fixed = fixed)
    Y_pop_b[!is.finite(Y_pop_b)] <- 0
    return(list(pop_income_vector = Y_pop_b, vu_tmp = vu_tmp))
}
tail.estimators.povmap <-
function (x, n = 6L, keepnums = TRUE, addrownums = NULL, ...) 
{
    tail(x$ind, n = n, keepnums = keepnums, ...)
}
terms.ebp <-
function (x, ...) 
{
    throw_class_error(x, "ebp")
    terms(aov(x$fixed, x$framework$smp_data))
}
terms.fh <-
function (x, ...) 
{
    throw_class_error(x, "fh")
    terms(aov(x$fixed, x$framework$combined_data))
}
throw_class_error <-
function (object, subclass) 
{
    if (!inherits(object, "povmap")) {
        error_string <- paste0(subclass, " object has to be created by the povmap\n                           package for povmap methods to work.")
        stop(error_string)
    }
}
transformation <-
function (y, transformation, lambda, shift, framework, fixed) 
{
    transformed <- if (transformation == "no") {
        no_transform(y = y)
    }
    else if (transformation == "log") {
        log_transform(y = y, shift = shift)
    }
    else if (transformation == "box.cox") {
        box_cox(y = y, lambda = lambda, shift = shift)
    }
    else if (transformation == "dual") {
        dual(y = y, lambda = lambda, shift = shift)
    }
    else if (transformation == "log.shift") {
        log_shift_opt(y = y, lambda = lambda)
    }
    else if (transformation == "arcsin") {
        arcsin_transform(y = y, shift = shift)
    }
    else if (transformation == "ordernorm") {
        ordernorm(y = y, shift = shift)
    }
    else if (transformation == "logit") {
        logit_transform(y = y, shift = shift)
    }
    return(y = transformed)
}
transformed_percentile <-
function (mu = mu, threshold = threshold, var = var, transformation = transformation, 
    lambda = lambda, shift = shift, p = p) 
{
    mu_percentile <- mu + qnorm(p, 0, var)
    transformed_percentile <- back_transformation(y = mu_percentile, 
        transformation = transformation, lambda = lambda, shift = shift)
    return(transformed_percentile)
}
true_indicators_weighted <-
function (framework, model_par, gen_model, lambda, shift, transformation, 
    fixed) 
{
    if (is.null(framework$smp_subdomains) && is.null(framework$pop_subdomains)) {
        eta_pop <- rep(0, framework$N_pop)
        framework$obs_subdom <- rep(0, framework$N_pop)
    }
    else {
        eta_tmp <- rnorm(framework$N_subdom_pop, 0, sqrt(model_par$sigmah2est))
        eta_pop <- rep(eta_tmp, framework$n_pop_subdom)
    }
    vu_tmp <- rnorm(framework$N_dom_pop, 0, sqrt(model_par$sigmau2est))
    vu_pop <- rep(vu_tmp, framework$n_pop)
    if (!is.null(framework$aggregate_to_vec)) {
        N_dom_pop_tmp <- framework$N_dom_pop_agg
        pop_domains_vec_tmp <- framework$aggregate_to_vec
    }
    else {
        N_dom_pop_tmp <- framework$N_dom_pop
        pop_domains_vec_tmp <- framework$pop_domains_vec
    }
    if (!is.null(framework$pop_weights)) {
        pop_weights_vec <- framework$pop_data[[framework$pop_weights]]
    }
    else {
        pop_weights_vec <- rep(1, framework$N_pop)
    }
    var_eps <- vector(length = framework$N_pop)
    var_eps[(framework$obs_dom & framework$obs_subdom)] <- (model_par$sigmae2est)
    var_eps[(framework$obs_dom & !framework$obs_subdom)] <- (model_par$sigmae2est + 
        model_par$sigmah2est)
    var_eps[!framework$obs_dom] <- (model_par$sigmae2est + model_par$sigmah2est + 
        model_par$sigmau2est)
    eps <- rnorm(framework$N_pop, 0, sqrt(var_eps))
    true_indicators_weighted <- matrix(nrow = N_dom_pop_tmp, 
        ncol = length(framework$indicator_names))
    colnames(true_indicators_weighted) <- framework$indicator_names
    Y_pop_b <- gen_model$mu_fixed + vu_pop + eta_pop + eps
    Y_pop_b <- back_transformation(y = Y_pop_b, transformation = transformation, 
        lambda = lambda, shift = shift, framework = framework)
    Y_pop_mu <- gen_model$mu_fixed + vu_pop + eta_pop
    if ("Mean" %in% framework$indicator_names) {
        EY_pop_mu <- expected_untransformed_mean(Y_pop_mu, var = var_eps, 
            transformation = transformation, lambda = lambda)
        Y_pop_b <- EY_pop_mu + ((Y_pop_b - Y_pop_mu)/sqrt(framework$pop_data[, 
            framework$MSE_pop_weights]))
        true_indicators_weighted[, "Mean"] <- mapply(FUN = weighted.mean, 
            x = split(Y_pop_b, pop_domains_vec_tmp), w = split(pop_weights_vec, 
                pop_domains_vec_tmp))
    }
    if ("Head_Count" %in% framework$indicator_names) {
        p_pov <- vector(length = framework$N_pop)
        p_pov <- expected_head_count(mu = Y_pop_mu, threshold = framework$threshold, 
            var = var_eps, transformation = transformation, lambda = lambda, 
            shift = shift)
        pov <- mapply(FUN = rbinom, n = 1, size = framework$pop_data[, 
            framework$MSE_pop_weights], prob = p_pov)
        pov <- as.vector(pov)/framework$pop_data[, framework$MSE_pop_weights]
        true_indicators_weighted[, "Head_Count"] <- mapply(FUN = weighted.mean, 
            x = split(pov, pop_domains_vec_tmp), w = split(pop_weights_vec, 
                pop_domains_vec_tmp))
        return(list(true_indicators = true_indicators_weighted, 
            vu_tmp = vu_tmp))
    }
}
update_beta_re <-
function (model_par, weight_smp, framework, dep_var, fixed) 
{
    rand_eff <- model_par$rand_eff
    rand_eff_h <- model_par$rand_eff_h
    sums <- aggregate(data.frame(weight_smp, weight_smp^2), by = list(framework$smp_domains_vec), 
        FUN = sum)
    delta2 <- sums[, 3]/sums[, 2]^2
    gamma <- model_par$sigmau2est/(model_par$sigmau2est + ((model_par$sigmae2est + 
        model_par$sigmah2est) * delta2))
    indep_smp <- model.matrix(fixed, framework$smp_data)
    mean_indep <- aggregate_weighted_mean(indep_smp, by = list(framework$smp_domains_vec), 
        w = weight_smp)[, -1]
    mean_dep <- aggregate_weighted_mean(dep_var, by = list(framework$smp_domains_vec), 
        w = weight_smp)[, -1]
    dep_var_ast <- dep_var - rep(gamma * mean_dep, framework$n_smp)
    indep_weight <- indep_smp * weight_smp
    shrunk_mean_indep <- gamma * mean_indep
    shrunk_mean_indep_smp <- shrunk_mean_indep[rep(row.names(shrunk_mean_indep), 
        times = framework$n_smp), ]
    indep_var_ast <- as.matrix(indep_smp - shrunk_mean_indep_smp)
    if (model_par$sigmah2est > 0) {
        sums_sub <- aggregate(data.frame(weight_smp, weight_smp^2)[framework$smp_subdomains_vec, 
            ], by = list(framework$smp_subdomains_vec), FUN = sum)
        sums_sub <- sums_sub[framework$dist_obs_smp_subdom, ]
        delta2_sub <- sums_sub[, 3]/sums_sub[, 2]^2
        gamma_sub <- model_par$sigmah2est/(model_par$sigmah2est + 
            model_par$sigmae2est * delta2_sub)
        submean_dep <- aggregate_weighted_mean(dep_var, by = list(framework$smp_subdomains_vec), 
            w = weight_smp)[, -1]
        dep_var_ast <- dep_var_ast - rep(gamma_sub * submean_dep, 
            framework$n_smp_subdom)
        mean_indep_sub <- aggregate_weighted_mean(indep_smp, 
            by = list(framework$smp_subdomains_vec), w = weight_smp)[, 
            -1]
        shrunk_mean_indep_sub <- gamma_sub * mean_indep_sub
        shrunk_mean_indep_sub_smp <- shrunk_mean_indep_sub[rep(row.names(shrunk_mean_indep_sub), 
            times = framework$n_smp_subdom), ]
        indep_var_ast <- as.matrix(indep_var_ast - shrunk_mean_indep_sub_smp)
    }
    num <- t(indep_weight) %*% dep_var_ast
    den <- t(indep_weight) %*% indep_var_ast
    betas <- solve(den) %*% num
    rand_eff[framework$dist_obs_dom] <- gamma * (mean_dep - as.matrix(mean_indep) %*% 
        betas)
    if (model_par$sigmah2est > 0) {
        mean_e0_sub <- aggregate_weighted_mean(model_par$e0, 
            by = list(framework$smp_subdomains_vec), w = weight_smp)
        rand_eff_h[framework$dist_obs_subdom] <- gamma_sub * 
            mean_e0_sub[, 2]
    }
    return(list(betas = betas, rand_eff = rand_eff, rand_eff_h = rand_eff_h, 
        gamma = gamma))
}
update_sigma2 <-
function (dep_var, betas, weight_smp, framework, rand_eff, fixed) 
{
    indep_smp <- model.matrix(fixed, framework$smp_data)
    e0 <- dep_var - indep_smp %*% betas
    rand_eff_smp <- rep(rand_eff[framework$dist_obs_dom], framework$n_smp)
    transformed_par <- data.frame(e0, weight_smp, framework$smp_data[, 
        framework$smp_domains])
    colnames(transformed_par) <- c("e0", "weight_smp", framework$smp_domains)
    random_arg <- NULL
    if (!is.null(framework$smp_subdomains) && !is.null(framework$pop_subdomains)) {
        random_arg <- list(as.formula(~1), as.formula(~1))
        names(random_arg) <- c(framework$smp_domains, framework$smp_subdomains)
    }
    else {
        random_arg[framework$smp_domains] <- list(as.formula(~1))
    }
    args <- list(fixed = e0 ~ 1, data = transformed_par, random = random_arg, 
        method = framework$nlme_method, weights = ~1/weight_smp)
    revised_var <- do.call(nlme:::lme, args)
    if (!is.null(framework$smp_subdomains) && !is.null(framework$pop_subdomains)) {
        sigmau2est <- as.numeric(VarCorr(revised_var)[2, 1])
        dof_adj_h <- (framework$N_subdom_smp - 1)/(framework$N_subdom_smp - 
            ncol(indep_smp))
        sigmah2est <- as.numeric(VarCorr(revised_var)[4, 1]) * 
            dof_adj_h
    }
    else {
        sigmau2est <- as.numeric(nlme::VarCorr(revised_var)[1, 
            1])
        sigmah2est <- 0
    }
    dof_adj_e <- (framework$N_smp - 1)/(framework$N_smp - ncol(indep_smp))
    sigmae2est <- revised_var$sigma^2 * dof_adj_e
    dof_adj_u <- (framework$N_dom_smp - 1)/(framework$N_dom_smp - 
        ncol(indep_smp))
    sigmau2est <- sigmau2est * dof_adj_u
    return(list(sigmae2est = sigmae2est, sigmau2est = sigmau2est))
}
vcov.ebp <-
function (object, ...) 
{
    throw_class_error(object, "ebp")
    vcov(object$model, ...)
}
vcov.fh <-
function (object, ...) 
{
    throw_class_error(object, "fh")
    object$model$beta_vcov
}
weighted.sd <-
function (x, w) 
{
    delta_sq <- (x - mean(x))^2
    nzero_w <- (length(w[w > 0]) - 1)/length(w[w > 0])
    result <- sqrt(sum(w * (delta_sq))/(nzero_w * sum(w)))
    return(result)
}
wrapper_MSE <-
function (framework, combined_data, sigmau2, vardir, Ci, eblup, 
    transformation, method, interval, mse_type, B = NULL) 
{
    mse_data <- if (mse_type == "analytical") {
        analytical_mse(framework = framework, sigmau2 = sigmau2, 
            combined_data = combined_data, method = method)
    }
    else if (mse_type == "jackknife") {
        if (method == "me") {
            jiang_jackknife_yl(framework = framework, combined_data = combined_data, 
                sigmau2 = sigmau2, vardir = vardir, Ci = Ci, 
                eblup = eblup, transformation = transformation, 
                method = method)
        }
        else {
            jiang_jackknife(framework = framework, combined_data = combined_data, 
                sigmau2 = sigmau2, vardir = vardir, eblup = eblup, 
                transformation = transformation, method = method, 
                interval = interval)
        }
    }
    else if (mse_type == "weighted_jackknife") {
        chen_weighted_jackknife(framework = framework, combined_data = combined_data, 
            sigmau2 = sigmau2, eblup = eblup, vardir = vardir, 
            transformation = transformation, method = method, 
            interval = interval)
    }
    else if (mse_type == "pseudo") {
        pseudo(framework = framework, combined_data = combined_data, 
            eblup = eblup, mse_type = "pseudo", method = method)
    }
    else if (mse_type == "boot") {
        robustboot(framework = framework, combined_data = combined_data, 
            eblup = eblup, mse_type = "boot", method = method, 
            B = B)
    }
    else if (mse_type == "spatialnonparboot" || mse_type == "spatialnonparbootbc") {
        nonparametricboot_spatial(framework = framework, combined_data = combined_data, 
            sigmau2 = sigmau2, eblup = eblup, B = B, method = method, 
            vardir = vardir, transformation = transformation, 
            mse_type = mse_type)
    }
    else if (mse_type == "spatialparboot" || mse_type == "spatialparbootbc") {
        parametricboot_spatial(framework = framework, combined_data = combined_data, 
            sigmau2 = sigmau2, eblup = eblup, B = B, method = method, 
            vardir = vardir, transformation = transformation, 
            mse_type = mse_type)
    }
    return(mse_data)
}
wrapper_estsigmau2 <-
function (framework, method, interval) 
{
    sigmau2 <- if (method == "reml" && framework$correlation == 
        "no") {
        Reml(interval = interval, vardir = framework$vardir, 
            x = framework$model_X, direct = framework$direct, 
            areanumber = framework$m)
    }
    else if (method == "amrl") {
        AMRL(interval = interval, vardir = framework$vardir, 
            x = framework$model_X, direct = framework$direct, 
            areanumber = framework$m)
    }
    else if (method == "amrl_yl") {
        AMRL_YL(interval = interval, vardir = framework$vardir, 
            x = framework$model_X, direct = framework$direct, 
            areanumber = framework$m)
    }
    else if (method == "ampl") {
        AMPL(interval = interval, vardir = framework$vardir, 
            x = framework$model_X, direct = framework$direct, 
            areanumber = framework$m)
    }
    else if (method == "ampl_yl") {
        AMPL_YL(interval = interval, vardir = framework$vardir, 
            x = framework$model_X, direct = framework$direct, 
            areanumber = framework$m)
    }
    else if (method == "ml" && framework$correlation == "no") {
        MPL(interval = interval, vardir = framework$vardir, x = framework$model_X, 
            direct = framework$direct, areanumber = framework$m)
    }
    else if (method == "ml" && framework$correlation == "spatial") {
        SML(direct = framework$direct, X = framework$model_X, 
            vardir = framework$vardir, areanumber = framework$m, 
            W = framework$W, tol = framework$tol, maxit = framework$maxit)
    }
    else if (method == "reml" && framework$correlation == "spatial") {
        SREML(direct = framework$direct, X = framework$model_X, 
            vardir = framework$vardir, areanumber = framework$m, 
            W = framework$W, tol = framework$tol, maxit = framework$maxit)
    }
    else if (method == "me") {
        ybarralohr(vardir = framework$vardir, direct = framework$direct, 
            x = framework$model_X, Ci = framework$Ci, tol = framework$tol, 
            maxit = framework$maxit, p = framework$p, areanumber = framework$m)
    }
    return(sigmau2)
}
write.excel <-
function (object, file = NULL, indicator = "all", MSE = FALSE, 
    CV = FALSE, split = FALSE, model = TRUE) 
{
    if (is.null(file) == TRUE) {
        file <- file.path(tempdir(), "excel_output.xlsx")
    }
    writeexcel_check(object = object, file = file, split = split)
    wb <- createWorkbook()
    headlines_cs <- createStyle(fontColour = "#ffffff", halign = "center", 
        valign = "center", fgFill = NULL, textDecoration = "Bold", 
        border = "Bottom", borderStyle = "medium")
    if (inherits(object, "direct")) {
        wb <- add_summary_direct(object = object, wb = wb, headlines_cs = headlines_cs)
    }
    else if (inherits(object, "ebp")) {
        wb <- add_summary_ebp(object = object, wb = wb, headlines_cs = headlines_cs)
    }
    else if (inherits(object, "fh")) {
        wb <- add_summary_fh(object = object, wb = wb, headlines_cs = headlines_cs)
    }
    else if (inherits(object, "ell")) {
        wb <- add_summary_ell(object = object, wb = wb, headlines_cs = headlines_cs)
    }
    else if (inherits(object, "hdp")) {
        wb <- add_summary_hdp(object = object, wb = wb, headlines_cs = headlines_cs)
    }
    if (!split && (MSE || CV)) {
        wb <- add_estims(object = object, indicator = indicator, 
            wb = wb, headlines_cs = headlines_cs, MSE = MSE, 
            CV = CV)
    }
    else {
        wb <- add_pointests(wb = wb, object = object, indicator = indicator, 
            headlines_cs = headlines_cs)
        if (MSE || CV) {
            wb <- add_precisions(object = object, indicator = indicator, 
                MSE = MSE, wb = wb, headlines_cs = headlines_cs, 
                CV = CV)
        }
    }
    if (model) {
        wb <- add_model(object = object, wb = wb)
    }
    saveWorkbook(wb, file, overwrite = TRUE)
}
write.ods <-
function (object, file = NULL, indicator = "all", MSE = FALSE, 
    CV = FALSE, split = FALSE) 
{
    no_file <- FALSE
    if (is.null(file)) {
        file <- "ods_output.ods"
        no_file <- TRUE
    }
    writeods_check(object = object, file = file, split = split)
    wb <- gsub(".ods", "", file)
    if (inherits(object, "direct")) {
        add_summary_direct_ods(object = object, wb = wb, no_file = no_file)
    }
    else if (inherits(object, "ebp")) {
        add_summary_ods_ebp(object = object, wb = wb, no_file = no_file)
    }
    else if (inherits(object, "fh")) {
        add_summary_ods_fh(object = object, no_file = no_file, 
            wb = wb)
    }
    if (!split && (MSE || CV)) {
        add_estims_ods(object = object, indicator = indicator, 
            wb = wb, no_file = no_file, MSE = MSE, CV = CV)
    }
    else {
        add_pointests_ods(wb = wb, object = object, no_file = no_file, 
            indicator = indicator)
        if (MSE || CV) {
            add_precisions_ods(object = object, indicator = indicator, 
                MSE = MSE, wb = wb, no_file = no_file, CV = CV)
        }
    }
}
writeexcel_check <-
function (object, file, split) 
{
    if (!inherits(object, "povmap")) {
        stop("First object needs to be of class povmap.")
    }
    if (!(inherits(split, "logical") && length(split) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "split must to be a logical value. Set CV to TRUE or FALSE."))
    }
    if (!inherits(file, "character") || (length(grep(".xlsx", 
        file)) == 0)) {
        stop(strwrap(prefix = " ", initial = "", "file must to be a character string that determines a path and\n                 filename. It should end on .xlsx"))
    }
}
writeods_check <-
function (object, file, split) 
{
    if (!inherits(object, "povmap")) {
        stop("First object needs to be of class povmap.")
    }
    if (!(inherits(split, "logical") && length(split) == 1)) {
        stop(strwrap(prefix = " ", initial = "", "split must to be a logical value. Set CV to TRUE or FALSE."))
    }
    if (!inherits(file, "character") || (length(grep(".ods", 
        file)) == 0)) {
        stop(strwrap(prefix = " ", initial = "", "file must to be a character string that determines a path and\n                 filename. It should end on .ods"))
    }
    testZIP <- 1
    try(testZIP <- shell("zip"), silent = TRUE)
    if (testZIP == 1) {
        stop(strwrap(prefix = " ", initial = "", "No zipping application was found, see details in\n                 help(write.ods) for details."))
    }
}
wtd.quantile <-
function (x, weights = NULL, probs = NULL) 
{
    n <- length(x)
    order <- order(x)
    x <- x[order]
    weights <- weights[order]
    if (is.null(weights)) {
        rw <- seq_len(n)/n
    }
    else {
        rw <- cumsum(weights)/sum(weights)
    }
    q <- vapply(probs, function(p) {
        if (p == 0) {
            return(x[1])
        }
        else if (p == 1) {
            return(x[n])
        }
        select <- min(which(rw >= p))
        if (rw[select] == p) {
            mean(x[select:(select + 1)])
        }
        else {
            x[select]
        }
    }, numeric(1))
    return(unname(q))
}
ybarralohr <-
function (direct, x, vardir, Ci, areanumber, p, tol, maxit) 
{
    wi <- rep(1, areanumber)
    conv <- 1
    iter <- 0
    x <- as.matrix(x)
    x <- t(x)
    rownames(x) <- NULL
    inverse.square.root.mat <- function(mat, maxit) {
        stopifnot(nrow(mat) == ncol(mat))
        niter <- 0
        G.inv <- diag(1, nrow(mat))
        for (niter in seq_len(maxit)) {
            mat.tmp <- 0.5 * (mat + ginv(G.inv))
            G.inv <- 0.5 * (G.inv + ginv(mat))
            mat <- mat.tmp
        }
        return(list(G = mat, G.inv = G.inv))
    }
    while (conv > tol & iter < maxit) {
        wi.tmp <- wi
        wC <- matrix(0, p, p)
        for (i in seq_len(areanumber)) {
            wC <- wC + wi[i] * Ci[, , i]
        }
        G <- t(wi * t(x)) %*% t(x)
        Gi <- inverse.square.root.mat(G, maxit = maxit)$G.inv
        GiwCGi <- Gi %*% wC %*% Gi
        decomp <- eigen(GiwCGi)
        P <- decomp$vectors
        Djj <- rep(0, p)
        cond <- which((1 - decomp$values) > 1/areanumber)
        Djj[cond] <- 1/(1 - decomp$values[cond])
        D <- diag(Djj)
        Beta.hat <- Gi %*% P %*% D %*% t(P) %*% Gi %*% t(t(as.matrix(wi * 
            direct, areanumber, 1)) %*% t(x))
        Beta.hat.tCiBeta.hat <- NULL
        for (i in seq_len(areanumber)) {
            Beta.hat.tCiBeta.hat[i] <- t(Beta.hat) %*% Ci[, , 
                i] %*% Beta.hat
        }
        sigmau2 <- (1/(areanumber - p)) * sum((direct - t(x) %*% 
            Beta.hat)^2 - vardir - Beta.hat.tCiBeta.hat)
        if (sigmau2 <= 0) {
            sigmau2 <- 0
        }
        wi <- 1/(sigmau2 + vardir + Beta.hat.tCiBeta.hat)
        conv <- mean(abs(wi - wi.tmp))
        iter <- iter + 1
    }
    estsigma2u <- sigmau2
    return(list(sigmau_YL = estsigma2u, betahatw = Beta.hat, 
        Beta.hat.tCiBeta.hat = Beta.hat.tCiBeta.hat))
}
yoshimori_lahiri <-
function (framework, sigmau2, combined_data, method) 
{
    prasad_rao <- prasad_rao(framework = framework, sigmau2 = sigmau2, 
        combined_data = combined_data)
    mse <- prasad_rao$FH[framework$obs_dom == TRUE]
    X <- framework$model_X
    psi <- matrix(c(framework$vardir), framework$m, 1)
    Y <- matrix(c(framework$direct), framework$m, 1)
    Z.area <- diag(1, framework$m)
    I <- diag(1, framework$m)
    Bd <- framework$vardir/(sigmau2 + framework$vardir)
    V <- sigmau2 * Z.area %*% t(Z.area) + I * psi[, 1]
    Vi <- solve(V)
    Xt <- t(X)
    XVi <- Xt %*% Vi
    Q <- solve(XVi %*% X)
    P <- Vi - (Vi %*% X %*% Q %*% XVi)
    if (method == "ampl_yl") {
        Bias <- (sum(diag(P - Vi)))/sum(diag(Vi^2))
        for (d in seq_len(framework$m)) {
            mse[d] <- mse[d] - (Bd[d]^2) * Bias
        }
    }
    else if (method == "amrl_yl") {
        mse <- mse
    }
    mse_data <- prasad_rao
    mse_data$FH[framework$obs_dom == TRUE] <- mse
    mse_data$Out[framework$obs_dom == TRUE] <- 0
    if (!all(framework$obs_dom == TRUE)) {
        mse_data$FH[framework$obs_dom == FALSE] <- NA
        mse_data$Out[framework$obs_dom == FALSE] <- 1
        message(strwrap(prefix = " ", initial = "", "Please note that only for in-sample-domains a correction\n                    following Yoshimori and Lahiri (2014) is implemented. For\n                    the out-of-sample domains, no estimate for the MSE is\n                    returned. For the reference see help(fh)."))
    }
    return(mse_data)
}
zerovalinter <-
function (y, x) 
{
    if (min(y) > 0) {
        xmin <- x[y == min(y)]
        if (length(xmin) > 0) 
            xmin <- xmin[length(xmin)]
        xzero <- xmin
    }
    else {
        if (max(y) < 0) {
            xmin <- x[y == max(y)]
            if (length(xmin) > 0) 
                xmin <- xmin[1]
            xzero <- xmin
        }
        else {
            y1 <- min(y[y > 0])
            if (length(y1) > 0) 
                y1 <- y1[length(y1)]
            y2 <- max(y[y < 0])
            if (length(y2) > 0) 
                y2 <- y2[1]
            x1 <- x[y == y1]
            if (length(x1) > 0) 
                x1 <- x1[length(x1)]
            x2 <- x[y == y2]
            if (length(x2) > 0) 
                x2 <- x2[1]
            xzero <- (x2 * y1 - x1 * y2)/(y1 - y2)
            xmin <- x1
            if (abs(y2) < y1) 
                xmin <- x2
        }
    }
    resu <- xzero
    resu
}
