### Lazy evaluation: Force evaluation of argument

# Examples from the `force()` function help page speak for themselves.  
# Here is another one from H. Wickham online course [Advanced R Programming](http://adv-r.had.co.nz/)  
# The example here does not work (bug in Hadley Wickham's course?)
add <- function(x) {
  function(y) x + y
}
adders <- lapply(1:10, add)
adders[[1]](10)
#> [1] 11
adders[[10]](10)
#> [1] 20


# This example works (`force` help page)

f <- function(y) function() y
lf <- vector("list", 5)
for (i in seq_along(lf)) lf[[i]] <- f(i)
lf[[1]]()  # returns 5
