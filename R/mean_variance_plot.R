#' This function returns 2 plots to assess the mean-variance relationship of the
#' count data.
#'
#' @param se_obj Seurat object we want to assess.
#' @param assay assay from where we want to extract the count matrix.
#' @param slot slot from where we want to extract the count matrix.
#' @return patchwork object with 2 plots
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(dplyr)
#' data("pbmc_small")
#' mean_variance_plot(se_obj = pbmc_small, assay = "RNA", slot = "counts")
#' }

mean_variance_plot <- function(se_obj, assay, slot) {
  # This function is extracted from here -
  # https://rawgit.com/ChristophH/sctransform/supp_html/supplement/variance_stabilizing_transformation.html
  
  # Set pipe operator
  `%>%` <- magrittr::`%>%`
  
  # Extract count matrix
  count_mtrx <- Seurat::GetAssayData(
    object = se_obj,
    assay = assay,
    slot = slot)
  
  # Get mean and variance from each gene
  gene_attr <- data.frame(
    mean_count = Matrix::rowMeans(count_mtrx),
    detection_rate = Matrix::rowMeans(count_mtrx > 0),
    variance = apply(count_mtrx, 1, stats::var)) %>%
    # Compute log10 of mean and variance
    dplyr::mutate(
      log10_mean = log10(.data$mean_count),
      log10_variance = log10(.data$variance)
    )
  
  rownames(gene_attr) <- rownames(count_mtrx)
  
  cell_attr <- data.frame(n_umi = Matrix::colSums(count_mtrx),
                          n_gene = Matrix::colSums(count_mtrx > 0))
  
  rownames(cell_attr) <- colnames(count_mtrx)
  
  raw_plt <- ggplot2::ggplot(gene_attr, ggplot2::aes(mean_count, variance)) +
    ggplot2::geom_point(alpha = 0.3, shape = 16) + 
    ggplot2::geom_density_2d(size = 0.3) + 
    ggplot2::geom_abline(intercept = 0, slope = 1, color = "red") +
    ggplot2::theme_minimal()
  
  log_plt <- ggplot2::ggplot(gene_attr,
                             ggplot2::aes(log10_mean, log10_variance)) +
    ggplot2::geom_point(alpha = 0.3, shape = 16) + 
    ggplot2::geom_density_2d(size = 0.3) + 
    ggplot2::geom_abline(intercept = 0, slope = 1, color = "red") +
    ggplot2::theme_minimal()
  
  raw_plt + log_plt
}
