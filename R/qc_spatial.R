#' This function returns QC metric plots with Spatial Seurat objects.
#'
#' @param se_obj Spatial Seurat object we want to assess.
#' @param assay assay from where we want to extract the count matrix.
#' @param slot slot from where we want to extract the count matrix.
#' @param nfeat Character string indicating the name of the variable in the
#'    metadata containing the number of genes.
#' @param ncount Character string indicating the name of the variable in the
#'    metadata containing the number of UMIs.
#' @param percent.mito Character string indicating the name of the variable in
#'    the metadata containing the mitochondrial percentage. Defaults to NULL in 
#'    which case it computes it using the gollowing regex "^MT-".
#' @param percent.ribo Character string indicating the name of the variable in
#'    the metadata containing the ribosomal percentage. Defaults to NULL in 
#'    which case it computes it using the gollowing regex "^RPL|^RPS".
#' @return List with the 4 QC plots
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' qc_st_plots(
#'   se = sp_obj,
#'   nfeat = "nFeature_Spatial",
#'   ncount = "nCount_Spatial",
#'   slot = "counts",
#'   assay = "Spatial") %>%
#' cowplot::plot_grid(
#'   plotlist = .,
#'   align = "hv",
#'   axis = "trbl")
#' }
#' 

qc_st_plots <- function(se_obj,
                        nfeat = "nFeature_Spatial",
                        ncount = "nCount_Spatial",
                        slot = "counts",
                        assay = "Spatial",
                        percent.mito = NULL,
                        percent.ribo = NULL) {

  p1 <- Seurat::SpatialFeaturePlot(object = se_obj,
                                   features = nfeat) +
    ggplot2::ggtitle("Unique genes per spot")
  
  p2 <- Seurat::SpatialFeaturePlot(object = se_obj,
                                   features = ncount) +
    ggplot2::ggtitle("Total counts per spots")
  
  count_mtrx <- Seurat::GetAssayData(object = se_obj,
                                     slot = slot,
                                     assay = assay)
  
  gene_attr <- data.frame(nUMI = Matrix::rowSums(count_mtrx), 
                          nSpots = Matrix::rowSums(count_mtrx > 0))
  
  # Collect all genes coded on the mitochondrial genome
  if (is.null(percent.mito)) {
    mt.genes <- grep(pattern = "^MT-",
                     x = rownames(count_mtrx),
                     value = TRUE,
                     ignore.case = TRUE)
    se_obj[["percent.mito"]] <- (Matrix::colSums(count_mtrx[mt.genes, ]) /
                                   Matrix::colSums(count_mtrx)) * 100
  } else {
    se_obj[["percent.mito"]] <- se_obj[[percent.mito]]
  }
  
  
  # Collect all genes coding for ribosomal proteins
  if (is.null(percent.ribo)) {
    rp.genes <- grep(pattern = "^RPL|^RPS",
                     x = rownames(count_mtrx),
                     value = TRUE,
                     ignore.case = TRUE)
    se_obj[["percent.ribo"]] <- (Matrix::colSums(count_mtrx[rp.genes, ]) /
                                   Matrix::colSums(count_mtrx)) * 100
  } else {
    se_obj[["percent.ribo"]] <- se_obj[[percent.ribo]]
  }
  
  p3 <- Seurat::SpatialFeaturePlot(object = se_obj,
                                   features = "percent.mito") +
    ggplot2::ggtitle("Mitochondrial % per spot")
  
  p4 <- Seurat::SpatialFeaturePlot(object = se_obj,
                                   features = "percent.ribo") +
    ggplot2::ggtitle("Ribosomal % per spot")
  
  
  return(list(p1, p2, p3, p4))
}
