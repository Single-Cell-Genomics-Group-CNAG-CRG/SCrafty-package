
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CNAGSCG

<!-- badges: start -->

<!-- badges: end -->

The packages CNAGSCG aims at being a recollection of common functions we
use in our day to day life analyzing single-cell data.

## Installation

You can install the released version of CNAGSCG from
[GitHub](https://github.com/Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package/blob/main/README.md)
with:

``` r
devtools::install_github(" Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package", ref = "main")
```

And the development version with:

``` r
# install.packages("devtools")
devtools::install_github("Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package", ref = "devel")
```

## Before we begin

Keep in mind that these being a shared package maintained by us all it
is important we stick to consitent best practices so we can all read
other peoples code and contribute on top of each other. When adding new
functions or modifying pre-existing ones please use **pull requests** so
someone else can check your code prior to merging in the main branch. \*
Best practices on how to write an R package are detailed in Hadley
Wickham’s [book](https://r-pkgs.org/). \* Best practices on R function
writing can be found in the books [`R for Data
Science`](https://r4ds.had.co.nz/functions.html) and the [`Functions
chapter of Advanced R`](https://adv-r.hadley.nz/functions.html). \* Best
practices on how to write R code
[here](https://www.datanovia.com/en/blog/r-coding-style-best-practices/).
Use package `lintr` to make sure the basic best practices are met.

## Adding New Functions

New functions need to be written in an R script file following the
predefined format as shown in the toy function
[`fbind()`](https://github.com/Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package/blob/main/R/fbind.R)
and saved in the `R/` directory. For ease of use the R script name
should be the same as the function name.

After adding a new function make sure everything runs smoothly by:  
1- running `devtools::load_all()`, this runs a mock build of the package
and allows you to test the function runs correctly within the package
environment.  \
2- runninf `devtools::document()`to build the documentation for the function in `man/` and `NAMESPACE`. Check will return error if the documentation is not present for a function in `R/` is not present. \
3- running `devtools::check()`, after making sure the function runs well
we need to be sure that all the moving parts of the foofactors package
still work in the package environment. `devtools::check()`is the
equivalent of running `R CMD check` in the terminal. \
4- Add a unit test for the function via `devtools::use_test("foo")`.
This will open an rscript named **test-fbind.R** in `test/testthat`. To
check that the unit test runs properly you can run `devtools::test()`. \

## Examples

Add examples of functions below:

``` r
library(CNAGSCG)
## basic example code
```
