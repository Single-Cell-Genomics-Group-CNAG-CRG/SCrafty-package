# CNAGSCG-package
R package with functions we can all benefit from

## Before we begin
Keep in mind that these being a shared package maintained by us all it is important we stick to consitent best practices so we can all read other peoples code and contribute on top of each other. When adding new functions or modifying pre-existing ones please use **pull requests** so someone else can check your code prior to merging in the main branch.
* Best practices on how to write an R package are detailed in Hadley Wickham's [book](https://r-pkgs.org/).
* Best practices on R function writing can be found  in the books [`R for Data Science`](https://r4ds.had.co.nz/functions.html) and the [`Functions chapter of Advanced R`](https://adv-r.hadley.nz/functions.html).
* Best practices on how to write R code [here](https://www.datanovia.com/en/blog/r-coding-style-best-practices/). Use package `lintr` to make sure the basic best practices are met. 

## Adding New Functions
New functions need to be written in an R script file following the predefined format as shown in the toy function [`fbind()`](https://github.com/Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package/blob/main/R/fbind.R) and saved in the `R/` directory. For ease of use the R script name should be the same as the function name.

After adding a new function make sure everything runs smoothly by:\
1- running `devtools::load_all()`, this runs a mock build of the package and allows you to test the function runs correctly within the package environment. \
2- running `devtools::check()`, after making sure the function runs well we need to be sure that all the moving parts of the foofactors package still work in the package environment. `devtools::check()`is the equivalent of running `R CMD check` in the terminal.\

