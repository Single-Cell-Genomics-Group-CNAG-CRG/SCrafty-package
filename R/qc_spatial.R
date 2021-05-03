#' This function returns QC metric plots with Spatial Seurat objects.
#'
#' @param se Spatial Seurat object we want to assess.
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

qc_st_plots <- function(se,
                        nfeat = "nFeature_Spatial",
                        ncount = "nCount_Spatial",
                        slot = "counts",
                        assay = "Spatial",
                        percent.mito = NULL,
                        percent.ribo = NULL) {

  p1 <- Seurat::SpatialFeaturePlot(object = se,
                                   features = nfeat) +
    ggplot2::ggtitle("Unique genes per spot")
  
  p2 <- Seurat::SpatialFeaturePlot(object = se,
                                   features = ncount) +
    ggplot2::ggtitle("Total counts per spots")
  
  count_mtrx <- Seurat::GetAssayData(object = se,
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
    se[["percent.mito"]] <- (Matrix::colSums(count_mtrx[mt.genes, ]) /
                                   Matrix::colSums(count_mtrx)) * 100
  } else {
    se[["percent.mito"]] <- se[[percent.mito]]
  }
  
  
  # Collect all genes coding for ribosomal proteins
  if (is.null(percent.ribo)) {
    rp.genes <- grep(pattern = "^RPL|^RPS",
                     x = rownames(count_mtrx),
                     value = TRUE,
                     ignore.case = TRUE)
    se[["percent.ribo"]] <- (Matrix::colSums(count_mtrx[rp.genes, ]) /
                                   Matrix::colSums(count_mtrx)) * 100
  } else {
    se[["percent.ribo"]] <- se[[percent.ribo]]
  }
  
  p3 <- Seurat::SpatialFeaturePlot(object = se,
                                   features = "percent.mito") +
    ggplot2::ggtitle("Mitochondrial % per spot")
  
  p4 <- Seurat::SpatialFeaturePlot(object = se,
                                   features = "percent.ribo") +
    ggplot2::ggtitle("Ribosomal % per spot")
  
  
  return(list(p1, p2, p3, p4))
}


#########################
#### Histogram plots ####
#########################

#' This function returns the number of features histogram of the Seurat object.
#'
#' @param se Spatial Seurat object we want to assess.
#' @param nfeat Character string indicating the name of the variable in the
#'    metadata containing the number of genes.
#' @param sample_id Feature in metadata by which to identify the sample if the
#'    object is merged and contains several samples.
#' @return Histogram with the nFeature distribution by sample.
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' nfeature_hist_st(se = sp_obj,
#'                  nfeat = "nFeature_Spatial",
#'                  sample_id = "orig.ident")
#' }
#' 

nfeature_hist_st <- function(
  se,
  nfeat = "nFeature_Spatial",
  sample_id = "orig.ident") {
  ggplot2::ggplot() +
    ggplot2::geom_histogram(data = se[[]], 
                            ggplot2::aes_string(nfeat),
                            fill = "red",
                            alpha = 0.7,
                            color = "red",
                            bins = 50) +
    ggplot2::facet_wrap(sample_id, scales = "free") +
    ggplot2::ggtitle("Unique genes per spot") +
    ggplot2::labs(x = "Number of Detected Genes",
                  y = "Number of Spots") +
    ggpubr::theme_pubr()
  
}


#' This function returns the number of counts histogram of the Seurat object.
#'
#' @param se Spatial Seurat object we want to assess.
#' @param ncounts Character string indicating the name of the variable in the
#'    metadata containing the number of genes.
#' @param sample_id Feature in metadata by which to identify the sample if the
#'    object is merged and contains several samples.
#' @return Histogram with the nUMI distribution by sample.
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' ncount_hist_st(se = sp_obj,
#'                  ncount = "nCount_Spatial",
#'                  sample_id = "orig.ident")
#' }
#' 

ncount_hist_st <- function(
  se,
  ncount = "nCount_Spatial",
  sample_id = "orig.ident") {
  ggplot2::ggplot() +
    ggplot2::geom_histogram(data = se[[]], 
                            ggplot2::aes_string(ncount),
                            fill = "red",
                            alpha = 0.7,
                            color = "red",
                            bins = 50) +
    ggplot2::facet_wrap(sample_id, scales = "free") +
    ggplot2::ggtitle("Total counts per spots") +
    ggplot2::labs(x = "Library Size (total UMI)",
                  y = "Number of Spots") +
    ggpubr::theme_pubr()
  
}


#' This function returns the mitochondrial \% histogram of the Seurat object.
#'
#' @param se Spatial Seurat object we want to assess.
#' @param mito_percent Character string indicating the name of the variable in
#' the metadata containing the mitochondrial \% for each spot.
#' @param sample_id Feature in metadata by which to identify the sample if the
#'    object is merged and contains several samples.
#' @return Histogram with the mitochondrial \% distribution by sample.
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' mit_pct_hist_st(se = sp_obj,
#'                  mito_percent = "percent.mito",
#'                  sample_id = "orig.ident")
#' }
#' 

mit_pct_hist_st <- function(
  se,
  mito_percent = "percent.mito",
  sample_id = "orig.ident") {
  ggplot2::ggplot() +
    ggplot2::geom_histogram(data = se[[]], 
                            ggplot2::aes_string(mito_percent),
                            fill = "red",
                            alpha = 0.7,
                            color = "red",
                            bins = 50) +
    ggplot2::facet_wrap(sample_id, scales = "free") +
    ggplot2::ggtitle("Mitochondrial % per spot") +
    ggplot2::labs(x = "Mitochondrial % ",
                  y = "Number of Spots") +
    ggpubr::theme_pubr()
  
}

#' This function returns the ribosomal \% histogram of the Seurat object.
#'
#' @param se Spatial Seurat object we want to assess.
#' @param ribo_percent Character string indicating the name of the variable in
#' the metadata containing the ribosomal \% for each spot.
#' @param sample_id Feature in metadata by which to identify the sample if the
#'    object is merged and contains several samples.
#' @return Histogram with the Ribosomal \% distribution by sample.
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' ribo_pct_hist_st(se = sp_obj,
#'                  ribo_percent = "percent.ribo",
#'                  sample_id = "orig.ident")
#' }
#' 

ribo_pct_hist_st <- function(
  se,
  ribo_percent = "percent.ribo",
  sample_id = "orig.ident") {
  ggplot2::ggplot() +
    ggplot2::geom_histogram(data = se[[]], 
                            ggplot2::aes_string(ribo_percent),
                            fill = "red",
                            alpha = 0.7,
                            color = "red",
                            bins = 50) +
    ggplot2::facet_wrap(sample_id, scales = "free") +
    ggplot2::ggtitle("Ribosomal % per spot") +
    ggplot2::labs(x = "Ribosomal % ",
                  y = "Number of Spots") +
    ggpubr::theme_pubr()
  
}