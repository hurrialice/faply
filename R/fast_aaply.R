#' Fast and more predictable apply function on multidimensional array
#'
#' The output should be equivalent (check the defination of equivalence in testthat package) to
#' \code{plyr::aaply(X, MARGIN, FUN, .drop=FALSE)}
#'
#' @param X a multidimensional array
#' @param MARGIN the dimension for which you want to apply the function on
#' @param FUN a function
#'
#' @examples
#' dims <- c(2,10,2,5,1)
#' arr <- array(1:prod(dims), dims, lapply(dims, function(d) 1:d))
#' fast_aaply(arr, c(2,4,3), sum)
#'
#' @export
fast_aaply <-function(X, MARGIN, FUN){
    FUN <- match.fun(FUN)

    # understand X
    d <- dim(X)

    # get result
    res0 <- apply(X, MARGIN, FUN)
    res <- res0


    if (length(FUN(seq(10)))==1) {
        # this function will collapse dimension!
        # e.g. sum function, i.g. sum(mat)->numeric

        dim(res) <- c(dim(res0), 1)
        # we need to initialize viable dimname at first
        dimnames(res) <- lapply(dim(res), function(i) 1:i)
        dimnames(res)[-length(dim(res))] <- dimnames(res0)
        return(res)

    }
    else {
        # if the function is not collapsing, e.g. cumsum(vec)-> vec
        if (all(d[-MARGIN] == 1)){
            dim(res) <- c(1, dim(res0))

        }

        # move whatever being called to front
        len.ans <- length(MARGIN)
        dres <- seq_len(length(dim(res)))
        dans <- rev(rev(dres)[1:len.ans])
        new_dres <- dres[c(dres[dans], dres[-dans])]
        res <- aperm(res, new_dres)
        return(res)
    }
}
