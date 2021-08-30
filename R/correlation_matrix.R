#' This function returns a correlation heatmap matrix between the features of
#' interest specified including genes and or metadata features.
#'
#' @param se Spatial Seurat object we want to assess.
#' @param genes vector with genes that we want to build
#'    the correlation heatmap with.
#' @param feats vector with metadata features that we want to build
#'    the correlation heatmap with.
#' @param assay assay from where we want to extract the gene expression.
#' @param slot slot from where we want to extract the gene expression.
#' @param cor_method Method to use for correlation: 
#'    c("pearson", "kendall", "spearman"). By default pearson.
#' @param ... Further arguments to pass to ggcorrplot::ggcorrplot
#' @return Correlation matrix heatmap
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' sp_obj <- SeuratData::LoadData(ds = "stxBrain", type = "posterior1")
#' correlation_heatmap(
#'   se = sp_obj,
#'   slot = "counts",
#'   assay = "Spatial",
#'   genes = c("Ms4a1", "Cd79a", "Cd3d", "Cd3e", "Cd8a"),
#'   feats = NULL,
#'   cor_method = "pearson",
#'   title = "Gene-Gene correlation heatmap")
#' }
#' 

correlation_heatmap <- function(
  se,
  genes = NULL,
  feats = NULL,
  assay = "Spatial",
  slot = "data",
  cor_method = "pearson",
  ...) {
  
  if (!is.null(genes)) {
    
    # Extract expression matrix
    expr_mtrx <- Seurat::GetAssayData(
      object = se,
      assay = assay,
      slot = slot)
    
    # Return warning for those genes not found in the expression matrix
    if (sum(genes %in% rownames(expr_mtrx)) != length(genes)) {
      gene_out <- genes[! genes %in% rownames(expr_mtrx)]
      gene_out <- paste(gene_out, collapse = ", ")
      warning(glue::glue("{gene_out} not found in assay {assay}, slot {slot}"))
    }
    
    # Subset expression matrix to genes of interest
    genes_sub <- genes[genes %in% rownames(expr_mtrx)]
    
    # Deal with behaviour of creating a matrix with just 1 row
    if (length(genes_sub) == 1) {
      mtrx_genes <- as.matrix(expr_mtrx[genes_sub, ])
      colnames(mtrx_genes) <- genes_sub
    } else if (length(genes_sub) > 1) {
      mtrx_genes <- t(as.matrix(expr_mtrx[genes_sub, ]))
    }
  }
  
  # Extract features of interest
  if (!is.null(feats)) {
    mtrx_feats <- se@meta.data[, feats]
  }
  
  # Sanity check and combining genes and feats into mtrx if both are defined
  if (is.null(genes) & is.null(feats)) {
    
    stop("Need to pass either genes or metadata features")
    
  } else if ((! is.null(genes)) & is.null(feats)) {
    
    mtrx <- mtrx_genes
    
  } else if (is.null(genes) & (! is.null(feats))) {
    
    mtrx <- mtrx_feats
    
  } else {
    
    mtrx <- cbind(mtrx_genes, mtrx_feats)
    
  }
  
  # Remove features that are all 0
  mtrx <- mtrx[, colSums(mtrx) > 0]
  mtrx_cor <- cor(as.matrix(mtrx))
  
  # Compute correlation P-value
  p_mat <- corrplot::cor.mtest(mat = mtrx,
                               conf_int = 0.95,
                               method = cor_method)
  
  # Add new line in names over 30 characters long
  colnames(mtrx_cor) <- stringr::str_wrap(string = colnames(mtrx_cor),
                                          width = 30)
  rownames(mtrx_cor) <- stringr::str_wrap(string = rownames(mtrx_cor),
                                          width = 30)
  
  # Plot correlation matrix as a heatmap
  ggcorrplot::ggcorrplot(
    corr = mtrx_cor,
    p.mat = p_mat[[1]],
    hc.order = TRUE,
    type = "full",
    insig = "blank",
    lab = FALSE,
    outline.col = "lightgrey",
    method = "square",
    colors = c("#6D9EC1", "white", "#E46726"),
    legend.title = glue::glue("Correlation\n({cor_method})"),
    ...) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = 22, hjust = 0.5, face = "bold"),
      legend.text = ggplot2::element_text(size = 12),
      legend.title = ggplot2::element_text(size = 15),
      axis.text.x = ggplot2::element_text(angle = 90, vjust = 0.5),
      axis.text = ggplot2::element_text(size = 18, vjust = 0.5))
  
}
