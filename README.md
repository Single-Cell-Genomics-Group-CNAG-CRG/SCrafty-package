
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SCrafty-package

<!-- badges: start -->

<!-- badges: end -->

The packages CNAGSCG aims at being a recollection of common functions we
use in our day to day life analyzing single-cell data.

## Installation

You can install the released version of CNAGSCG from
[GitHub](https://github.com/Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package/blob/main/README.md)
with:

``` r
devtools::install_github("Single-Cell-Genomics-Group-CNAG-CRG/SCrafty-package", ref = "main")
```

And the development version with:

``` r
# install.packages("devtools")
devtools::install_github("Single-Cell-Genomics-Group-CNAG-CRG/SCrafty-package", ref = "devel")
```

## Before we begin

Keep in mind that these being a shared package maintained by us all it
is important we stick to consistent best practices so we can all read
other peoples code and contribute on top of each other. When adding new
functions or modifying pre-existing ones please use **pull requests** so
someone else can check your code prior to merging in the main branch.  
\* Best practices on how to write an R package are detailed in Hadley
Wickham’s [book](https://r-pkgs.org/).  
\* Best practices on R function writing can be found in the books [`R
for Data Science`](https://r4ds.had.co.nz/functions.html) and the
[`Functions chapter of Advanced
R`](https://adv-r.hadley.nz/functions.html).  
\* Best practices on how to write R code can be found
[here](https://www.datanovia.com/en/blog/r-coding-style-best-practices/)
and [here](https://style.tidyverse.org/index.html#). Use package `lintr`
to make sure the basic best practices are met. You can run
`lintr::lint_dir()` to lint a specific directory or
`lintr::lint_package()` to lint all the files in the package.  

## Adding New Functions

New functions need to be written in an R script file following the
predefined format as shown in the toy function
[`fbind()`](https://github.com/Single-Cell-Genomics-Group-CNAG-CRG/CNAGSCG-package/blob/main/R/fbind.R)
and saved in the `R/` directory. For ease of use the R script name
should be the same as the function name. This can be done by running
`usethis::use_r("fbind")` which will initialize the R script in the
right directory.

After adding a new function make sure everything runs smoothly by:  
1- running `devtools::load_all()`, this runs a mock build of the package
and allows you to test the function runs correctly within the package
environment.  
2- running `devtools::document()`to build the documentation for the
function in `man/` and `NAMESPACE`. Check will return error if the
documentation for a function in `R/` is not present.  
3- running `devtools::check()`, after making sure the function runs well
we need to be sure that all the moving parts of the package still work
in the package environment. `devtools::check()`is the equivalent of
running `R CMD check` in the terminal.  
4- Add a unit test for the function via `devtools::use_test("fbind")`.
This will open an rscript named **test-fbind.R** in `test/testthat`. To
check that all the unit tests runs properly you can run
`devtools::test()`.  
5- Lastly, if you add an example in `README.Rmd` compile it using
`devtools::build_readme()`.  
Bonus, if your package requires a dependency not found the file
DESCRITPION section imports you can add it by running
`usethis::use_package("dplyr")`.

## Examples

Add examples of functions below:

``` r
library(SCrafty)
library(ggplot2)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(Seurat)
#> Attaching SeuratObject
library(GOstats)
#> Loading required package: Biobase
#> Loading required package: BiocGenerics
#> Loading required package: parallel
#> 
#> Attaching package: 'BiocGenerics'
#> The following objects are masked from 'package:parallel':
#> 
#>     clusterApply, clusterApplyLB, clusterCall, clusterEvalQ,
#>     clusterExport, clusterMap, parApply, parCapply, parLapply,
#>     parLapplyLB, parRapply, parSapply, parSapplyLB
#> The following objects are masked from 'package:dplyr':
#> 
#>     combine, intersect, setdiff, union
#> The following objects are masked from 'package:stats':
#> 
#>     IQR, mad, sd, var, xtabs
#> The following objects are masked from 'package:base':
#> 
#>     anyDuplicated, append, as.data.frame, basename, cbind, colnames,
#>     dirname, do.call, duplicated, eval, evalq, Filter, Find, get, grep,
#>     grepl, intersect, is.unsorted, lapply, Map, mapply, match, mget,
#>     order, paste, pmax, pmax.int, pmin, pmin.int, Position, rank,
#>     rbind, Reduce, rownames, sapply, setdiff, sort, table, tapply,
#>     union, unique, unsplit, which.max, which.min
#> Welcome to Bioconductor
#> 
#>     Vignettes contain introductory material; view with
#>     'browseVignettes()'. To cite Bioconductor, see
#>     'citation("Biobase")', and for packages 'citation("pkgname")'.
#> Loading required package: Category
#> Loading required package: stats4
#> Loading required package: AnnotationDbi
#> Loading required package: IRanges
#> Loading required package: S4Vectors
#> 
#> Attaching package: 'S4Vectors'
#> The following objects are masked from 'package:dplyr':
#> 
#>     first, rename
#> The following object is masked from 'package:base':
#> 
#>     expand.grid
#> 
#> Attaching package: 'IRanges'
#> The following objects are masked from 'package:dplyr':
#> 
#>     collapse, desc, slice
#> 
#> Attaching package: 'AnnotationDbi'
#> The following object is masked from 'package:dplyr':
#> 
#>     select
#> Loading required package: Matrix
#> 
#> Attaching package: 'Matrix'
#> The following object is masked from 'package:S4Vectors':
#> 
#>     expand
#> Loading required package: graph
#> 
#> 
#> Attaching package: 'GOstats'
#> The following object is masked from 'package:AnnotationDbi':
#> 
#>     makeGOGraph
```

If you are going to use Seurat object for function examples please use
datasets from `SeuratData` to run the vignette so we can all recreate
the examples easily.

``` r
# devtools::install_github('satijalab/seurat-data')
library(SeuratData)
#> Registered S3 method overwritten by 'cli':
#>   method     from         
#>   print.boxx spatstat.geom
#> ── Installed datasets ───────────────────────────────────── SeuratData v0.2.1 ──
#> ✓ pbmcMultiome 0.1.0                    ✓ stxBrain     0.1.1
#> ────────────────────────────────────── Key ─────────────────────────────────────
#> ✓ Dataset loaded successfully
#> > Dataset built with a newer version of Seurat than installed
#> ❓ Unknown version of Seurat installed
```

### QC

Under development…👩💻 🧑💻

### GO analysis

Here is a set of funtions to compute GO analysis:

``` r
gene_de <- c("MS4A1", "CD79A", "CD79B")
gene_universe <- c("HLA-DRA", "AIF1", "C1QA", "LYZ", "SELENOP", "ADAMDEC1",
"CD14", "CD68", "IGF1", "LGMN", "AXL", "C5AR1", "CD163", "CD163L1", "CD209",
"CSF1R", "IL10", "IL10RA", "IL13RA1", "NRP1", "NRP2", "SDC3", "SIGLEC1",
"TGFBI", "TGFBR1", "EEF1A1", "OAZ1", "RPL15", "RPL19", "RPS19", "RPS29",
"TPT1", "UBA52", "APOE", "FCGRT", "MKI67", "PCLAF", "RRM2", "CD1C", "CLC",
"IL4", "TPSAB1", "CPA3", "NRG1", "RETN", "EREG", "ACOD1", "TNIP3", "VCAN",
"INHBA", "CXCL5", "HTRA1", "SPP1", "HSPA1B", "CXCR2", "PI3", "PROK2",
"HSPA6", "NCCRP1", "LAD1", "CCL22", "MS4A1", "CD79A", "CD79B")

GO_results <- gene_enrichment_GO(
  gene_de = gene_de,
  gene_universe = gene_universe,
  gene_from  = "SYMBOL",
  gene_to  = "ENTREZID",
  annotation = "org.Hs.eg.db",
  pvalue_cutoff = 0.05,
  test_direction = "over",
  ontology = "BP")
#> 
#> 'select()' returned 1:1 mapping between keys and columns
#> 'select()' returned 1:1 mapping between keys and columns
#> Loading required package: org.Hs.eg.db

knitr::kable(summary(GO_results))
```

| GOBPID       |    Pvalue | OddsRatio |  ExpCount | Count | Size | Term                                                               |
| :----------- | --------: | --------: | --------: | ----: | ---: | :----------------------------------------------------------------- |
| <GO:0050853> | 0.0000252 |       Inf | 0.1428571 |     3 |    3 | B cell receptor signaling pathway                                  |
| <GO:0050851> | 0.0001007 |       Inf | 0.1904762 |     3 |    4 | antigen receptor-mediated signaling pathway                        |
| <GO:0002429> | 0.0005036 |       Inf | 0.2857143 |     3 |    6 | immune response-activating cell surface receptor signaling pathway |
| <GO:0002757> | 0.0005036 |       Inf | 0.2857143 |     3 |    6 | immune response-activating signal transduction                     |
| <GO:0002764> | 0.0005036 |       Inf | 0.2857143 |     3 |    6 | immune response-regulating signaling pathway                       |
| <GO:0002768> | 0.0005036 |       Inf | 0.2857143 |     3 |    6 | immune response-regulating cell surface receptor signaling pathway |
| <GO:0030183> | 0.0005036 |       Inf | 0.2857143 |     3 |    6 | B cell differentiation                                             |
| <GO:0042113> | 0.0005036 |       Inf | 0.2857143 |     3 |    6 | B cell activation                                                  |
| <GO:0002253> | 0.0008814 |       Inf | 0.3333333 |     3 |    7 | activation of immune response                                      |
| <GO:0030098> | 0.0008814 |       Inf | 0.3333333 |     3 |    7 | lymphocyte differentiation                                         |
| <GO:0002521> | 0.0014102 |       Inf | 0.3809524 |     3 |    8 | leukocyte differentiation                                          |
| <GO:0030097> | 0.0030218 |       Inf | 0.4761905 |     3 |   10 | hemopoiesis                                                        |
| <GO:0048534> | 0.0041550 |       Inf | 0.5238095 |     3 |   11 | hematopoietic or lymphoid organ development                        |
| <GO:0046649> | 0.0055400 |       Inf | 0.5714286 |     3 |   12 | lymphocyte activation                                              |
| <GO:0050778> | 0.0055400 |       Inf | 0.5714286 |     3 |   12 | positive regulation of immune response                             |
| <GO:0002520> | 0.0072020 |       Inf | 0.6190476 |     3 |   13 | immune system development                                          |
| <GO:0042100> | 0.0090151 |        58 | 0.1904762 |     2 |    4 | B cell proliferation                                               |
| <GO:0050776> | 0.0114578 |       Inf | 0.7142857 |     3 |   15 | regulation of immune response                                      |
| <GO:0002684> | 0.0334920 |       Inf | 1.0000000 |     3 |   21 | positive regulation of immune system process                       |
| <GO:0045321> | 0.0387802 |       Inf | 1.0476190 |     3 |   22 | leukocyte activation                                               |
| <GO:0032943> | 0.0401904 |        18 | 0.3809524 |     2 |    8 | mononuclear cell proliferation                                     |
| <GO:0046651> | 0.0401904 |        18 | 0.3809524 |     2 |    8 | lymphocyte proliferation                                           |
| <GO:0002115> | 0.0476190 |       Inf | 0.0476190 |     1 |    1 | store-operated calcium entry                                       |
| <GO:0060401> | 0.0476190 |       Inf | 0.0476190 |     1 |    1 | cytosolic calcium ion transport                                    |
| <GO:0060402> | 0.0476190 |       Inf | 0.0476190 |     1 |    1 | calcium ion transport into cytosol                                 |
| <GO:0070509> | 0.0476190 |       Inf | 0.0476190 |     1 |    1 | calcium ion import                                                 |
| <GO:1902656> | 0.0476190 |       Inf | 0.0476190 |     1 |    1 | calcium ion import into cytosol                                    |

Visualization… Under development…👩💻 🧑💻

### Preview

With `ggpreview` we can preview a plot in the viewer pane. It is very
handy to find the right height and width as well as the right font size.

``` r
df <- data.frame(x = 1:10, y = 1:10)
tmp_plt <- ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) + 
  ggplot2::geom_point()

SCrafty::ggpreview(x = tmp_plt, w = 9, h = 4)
```
