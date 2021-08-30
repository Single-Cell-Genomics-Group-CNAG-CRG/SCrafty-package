#' This function returns a histogram of the number of spots that detected a gene.
#'
#' @param se Spatial Seurat object we want to assess.
#' @param assay assay from where we want to extract the count matrix.
#' @param slot slot from where we want to extract the count matrix.
#' @param sample_id Feature in metadata by which to identify the sample if the
#'    object is merged and contains several samples.
#' @return List with the 4 QC plots
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' gene_count_hist(
#'   se = sp_obj,
#'   slot = "counts",
#'   assay = "Spatial",
#'   sample_id = "orig.ident")
#' }
#' 

gene_count_hist <- function(
  se,
  slot = "counts",
  assay = "Spatial",
  sample_id = "orig.ident") {
  
  # Set pipe operator
  `%>%` <- magrittr::`%>%`
  
  # Extract count matrix
  count_mtrx <- Seurat::GetAssayData(object = se,
                                     slot = slot,
                                     assay = assay)

  # Dataframe containing how many reads per gene and on how many spots that
  # gene is found
  gene_attr <- lapply(as.character(unique(se@meta.data[, sample_id])),
                      function(id) {
    
    # Subset matrix to sample of interest
    sub_mtrx <- count_mtrx[, se@meta.data[, sample_id] == id]
    
    # Get nUMI, number of spots and sample id dataframe
    gene_attr <- data.frame(
      "nUMI" = Matrix::rowSums(sub_mtrx), 
      "nSpots" = Matrix::rowSums(sub_mtrx > 0),
      "sample_id" = id)
  }) %>%
    dplyr::bind_rows()
  
  ggplot2::ggplot() +
    ggplot2::geom_histogram(data = gene_attr,
                            ggplot2::aes(nUMI),
                            fill = "red",
                            alpha = 0.7,
                            color = "red",
                            bins = 50) +
    ggplot2::facet_wrap(. ~ sample_id, scales = "free") +
    ggplot2::scale_x_log10() +
    ggplot2::ggtitle("Total counts per gene (log10 scale)") +
    ggpubr::theme_pubr()
}
