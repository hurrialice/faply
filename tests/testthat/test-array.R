library(testthat)

# a general array with named dimnames
dn_arr <- list(
    "v1" = letters[1:2],
    "v2" = letters[1:3],
    "v3" = letters[1:4],
    "v4" = letters[1] # vs is the dimension with length=1
)
arr <- array(seq(prod(lengths(dn_arr))),
             lengths(dn_arr),
             dn_arr)

# function generators
fgen <- function(ff, FUN, ...){
    function(x, MAR) {
        ff(x, MAR, FUN, ...)
    }
}
aaply_cumsum <- fgen(plyr::aaply, cumsum, .drop=FALSE)
faply_cumsum <- fgen(fast_aaply, cumsum)
aaply_sum <- fgen(plyr::aaply, sum, .drop=FALSE)
faply_sum <- fgen(fast_aaply, sum)


test_that("cumsum works", {

    eequal_cumsum <- function(arr, mar){
        expect_equivalent(aaply_cumsum(arr, mar),
                 faply_cumsum(arr, mar))
    }

    eequal_cumsum(arr, c(1,2))
    eequal_cumsum(arr, c(4))
    eequal_cumsum(arr, c(4,2))
    eequal_cumsum(arr, c(2,3))
    eequal_cumsum(arr, c(2,3,1))
    eequal_cumsum(arr, c(2,3,4))

})


test_that("sum works", {

    eequal_sum <- function(arr, mar){
        expect_equivalent(aaply_sum(arr, mar),
                 faply_sum(arr, mar))
    }

    eequal_sum(arr, c(1,2))
    eequal_sum(arr, c(3,4))
    eequal_sum(arr, c(4,2))
    eequal_sum(arr, c(2,3))
    eequal_sum(arr, c(2,3,1))
    eequal_sum(arr, c(2,3,4))

})
