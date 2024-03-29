% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qc_general.R
\name{gene_count_hist}
\alias{gene_count_hist}
\title{This function returns a histogram of the number of spots that detected a gene.}
\usage{
gene_count_hist(
  se,
  slot = "counts",
  assay = "Spatial",
  sample_id = "orig.ident"
)
}
\arguments{
\item{se}{Spatial Seurat object we want to assess.}

\item{slot}{slot from where we want to extract the count matrix.}

\item{assay}{assay from where we want to extract the count matrix.}

\item{sample_id}{Feature in metadata by which to identify the sample if the
object is merged and contains several samples.}
}
\value{
List with the 4 QC plots
}
\description{
This function returns a histogram of the number of spots that detected a gene.
}
\examples{
\dontrun{
library(Seurat)
library(SeuratData)
sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
gene_count_hist(
  se = sp_obj,
  slot = "counts",
  assay = "Spatial",
  sample_id = "orig.ident")
}

}
