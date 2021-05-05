#' This function returns a plot composition representing the absolute number 
#' and proportion of a variable grouped by a feature of interest. 
#'
#' @param metadata metadata from the Seurat object - se_obj\@meta.data
#' @param x character string indicating the X axis - cell type annotation
#' @param grouping_vr character string specifying the feature to group
#'    the data by - condition
#' @param gradient_col vector of n colors indicating the color gradient to
#'    use in the proportion tile plot
#' @param col_df data frame with variables name and color containing
#'    the name - color pair
#' @param x_order character string vector containing the x names in the
#'    desired order
#' @param grouping_order character string vector containing the grouping names
#' in the desired order
#' @param title character string indicating the plot title, by default and
#'    empty string ""
#' @return Composition plot
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' library(SeuratData)
#' # SeuratData::InstallData(ds = "pbmcsca")
#' se_obj <- SeuratData::LoadData(ds = "pbmcsca")
#' 
#' col_df <- data.frame(
#'   "name" = unique(se_obj@meta.data$Method),
#'   "color" = terrain.colors(9)
#' )
#' 
#' x_order <- c("Cytotoxic T cell", "CD4+ T cell", "CD14+ monocyte", "B cell",
#'              "Megakaryocyte", "CD16+ monocyte", "Natural killer cell",
#'              "Dendritic cell", "Plasmacytoid dendritic cell", "Unassigned")

#' SCrafty::composition_plot(
#'   metadata = se_obj@meta.data,
#'   x = "CellType",
#'   grouping_vr = "Method",
#'   gradient_col = rainbow(5),
#'   col_df = col_df,
#'   x_order = x_order,
#'   grouping_order = unique(se_obj@meta.data$Method),
#'   title = "Cellular distribution of cells over clusters & methods"
#' )
#' 
#' }
#' 


composition_plot <- function(
  metadata,
  x,
  grouping_vr,
  gradient_col = c("#fffedb", "#ffc157", "#fa5e25"),
  col_df = NULL,
  x_order = NULL,
  grouping_order = NULL,
  title = "") {
  
  # Set pipe operator
  `%>%` <- magrittr::`%>%`
  
  # Rename and convert features of interest to factor since if not count will remove non-existent levels
  if (is.null(x_order)) {
    metadata[, "x"] <- factor(metadata[, x])
  } else {
    metadata[, "x"] <- factor(metadata[, x], levels = x_order)
  }
  
  if (is.null(x_order)) {
    metadata[, "grouping_vr"] <- factor(metadata[, grouping_vr])
  } else {
    metadata[, "grouping_vr"] <- factor(metadata[, grouping_vr],
                                        levels = grouping_order)
  }
  
  # Get number of x per group
  count_df <- metadata %>%
    dplyr::count(grouping_vr, x, .drop = FALSE) %>%
    dplyr::mutate(
      grouping_vr = factor(grouping_vr, levels = grouping_order),
      x =  factor(x, levels = x_order),
      )
  
  # Stacked barplot with absolute cell numbers
  col_plot <- ggplot2::ggplot(
    data = count_df,
    ggplot2::aes(x = x, y = n, fill = grouping_vr)) +
    ggplot2::geom_col() +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_blank()
      ) +
    ggplot2::labs(
      x = "",
      y = "# of cells",
      fill = grouping_vr)
  
  # Tile plot with intensity colored by proportion
  tile_plt <- count_df %>%
    dplyr::group_by(x, .drop = FALSE) %>%
    dplyr::mutate(Proportion = n / sum(n) * 100) %>%
    dplyr::ungroup() %>%
    ggplot2::ggplot(
      data = .,
      ggplot2::aes(
        x = x,
        y = grouping_vr,
        fill = Proportion)) +
    ggplot2::geom_tile(color = "grey") +
    ggplot2::theme_minimal() +
    ggplot2::scale_fill_gradientn(colours = gradient_col) +
    ggplot2::theme(
      axis.text.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank()
      ) +
    ggplot2::labs(x = x)
  
  # Color legend to append to the left of the proportion tile plot
  tile_color <- data.frame(
    "ylab" = factor(unique(count_df$grouping_vr), levels = grouping_order)) %>% 
    ggplot2::ggplot(
      .,
      ggplot2::aes(
        x = 1,
        y =  ylab,
        fill = ylab)) +
    ggplot2::geom_tile(color = "grey") +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      legend.position = "none",
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank()
    ) +
    ggplot2::labs(y = "% of cells", x = "")
  
  # Add personalized color palette if specified
  if (!is.null(col_df)) {
    col_plot <- col_plot +
      ggplot2::scale_fill_manual(
        values = col_df$color,
        breaks = col_df$name)
    
    tile_color <- tile_color +
      ggplot2::scale_fill_manual(
        values = col_df$color,
        breaks = as.character(col_df$name))
    
  }
  
  patchwork::plot_spacer() + col_plot + tile_color + tile_plt +  
    patchwork::plot_layout(widths = c(0.1, 1)) +
    patchwork::plot_annotation(
      title = title)
  
}
