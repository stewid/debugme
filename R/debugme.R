foo_x <- function() {
    if (runif(1) < 0.3)
        stop("Unable to determine 'x'.", call. = FALSE)
    1
}

foo_y <- function() {
    if (runif(1) < 0.3)
        return(0)
    4
}

##' Determine foo
##'
##' @return a numeric value.
##' @export
##' @useDynLib debugme foo_c_code
##' @examples
##' foo()
foo <- function() {
    x <- foo_x()
    y <- foo_y()
    result <- .Call(foo_c_code, x, y)
    result
}
