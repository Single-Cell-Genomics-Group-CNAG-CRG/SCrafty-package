#' This function returns a list where the 1st element is plot composition
#' representing the absolute number and proportion of a variable grouped by a
#' feature of interest and the 2nd are the individual plots.. 
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
#' @param label Logical vector indicating if we want to show proportion labels
#'    in the tile plot. By default FALSE. 
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
#'   "name" = unique(se_obj@meta.data$CellType),
#'   "color" = terrain.colors(10)
#' )
#' 
#' grouping_order <- c("Cytotoxic T cell", "CD4+ T cell", "CD14+ monocyte", "B cell",
#'              "Megakaryocyte", "CD16+ monocyte", "Natural killer cell",
#'              "Dendritic cell", "Plasmacytoid dendritic cell", "Unassigned")

#' SCrafty::composition_plot(
#'   metadata = se_obj@meta.data,
#'   x = "Method",
#'   grouping_vr = "CellType",
#'   gradient_col = rainbow(5),
#'   col_df = col_df,
#'   x_order = unique(se_obj@meta.data$Method),
#'   grouping_order = grouping_order,
#'   title = "Distribution of cells over methods",
#'   label = TRUE
#' )
#' 
#' }
#'

composition_plot <- function(
  metadata,
  x,
  grouping_vr,
  gradient_col = c("#7ab2ff", "#ffc157", "#fa5e25"),
  col_df = NULL,
  x_order = NULL,
  grouping_order = NULL,
  title = "",
  label = FALSE) {
  
  # Set pipe operator
  `%>%` <- magrittr::`%>%`
  
  # Set the grouping and X variable levels if specified
  if (! is.null(grouping_order)) {
    lvl_grp <- grouping_order
  } else if (is.null(grouping_order) & ! is.null(col_df)) {
    lvl_grp <- col_df$name
  } else {
    lvl_grp <- sort(unique(metadata[, grouping_vr]))
  }
  
  if (! is.null(x_order)) {
    lvl_x <- x_order
  } else {
    lvl_x <- sort(unique(metadata[, x]))
  }
  
  # Rename and convert features of interest to factor since if not count will remove non-existent levels
  metadata[, "x"] <- factor(metadata[, x], levels = lvl_x)
  
  metadata[, "grouping_vr"] <- factor(metadata[, grouping_vr],
                                        levels = lvl_grp)

  # Get number of x per group
  count_df <- metadata %>%
    dplyr::count(grouping_vr, x, .drop = FALSE) %>%
    dplyr::mutate(
      x = factor(x, levels = lvl_x),
      grouping_vr = factor(grouping_vr, levels = lvl_grp)
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
    # Add personalized color palette if specified
    { if (! is.null(col_df) & ! is.null(grouping_order)) ggplot2::scale_fill_manual(values = col_df$color, breaks = grouping_order) } +
    { if (! is.null(col_df) & is.null(grouping_order)) ggplot2::scale_fill_manual(values = col_df$color, breaks = col_df$name) } +
    ggplot2::labs(
      x = "",
      y = "# of cells",
      fill = grouping_vr)
  
  # Tile plot with intensity colored by proportion
  tile_df <- count_df %>%
    dplyr::group_by(x, .drop = FALSE) %>%
    # Proportion of x within each class in groping_vr
    dplyr::mutate(Proportion = n / sum(n) * 100) %>%
    dplyr::ungroup()
  
  tile_plt <- tile_df %>%
    ggplot2::ggplot(
      data = .,
      ggplot2::aes(
        x = x,
        y = grouping_vr,
        fill = Proportion)) +
    ggplot2::geom_tile(color = "grey") +
    # Add proportion text in tile plot
    { if (label) ggplot2::geom_text(ggplot2::aes(label = round(Proportion, 2))) } +
    ggplot2::theme_minimal() +
    ggplot2::scale_fill_gradientn(colours = gradient_col) +
    ggplot2::theme(
      # axis.text.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank()
      ) +
    ggplot2::labs(x = x)
  
  # Tile plot with absolute proportions
  abs_prop_df <- metadata %>%
    dplyr::count(grouping_vr, .drop = FALSE) %>%
    # Total proportion of x within the dataset
    dplyr::mutate(Proportion = n / sum(n) * 100) %>%
    dplyr::ungroup()
  
  abs_prop_plt <- abs_prop_df %>%
    ggplot2::ggplot(
      data = .,
      ggplot2::aes(
        x = 1,
        y = grouping_vr,
        fill = Proportion)) +
    ggplot2::geom_tile(color = "grey") +
    # Add proportion text in tile plot
    { if (label) ggplot2::geom_text(ggplot2::aes(label = round(Proportion, 2))) } +
    ggplot2::theme_minimal() +
    ggplot2::scale_fill_gradientn(colours = gradient_col,
                                  limits = c(0, max(tile_df$Proportion))) +
    ggplot2::theme(
      axis.text = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank(),
      legend.position = "none" 
    ) +
    ggplot2::labs(title = "Absolute proportions")
  
  # tile_color <- data.frame(
  #   "ylab" = factor(unique(count_df$grouping_vr),
  #                   levels = lvl_grp)
  #                   ) %>% 
  #   ggplot2::ggplot(.,
  #     ggplot2::aes(
  #       x = 1,
  #       y =  ylab,
  #       fill = ylab)) +
  #   ggplot2::geom_tile(color = "grey") +
  #   ggplot2::theme_minimal() +
  #   ggplot2::theme(
  #     legend.position = "none",
  #     axis.text = ggplot2::element_blank(),
  #     axis.ticks = ggplot2::element_blank(),
  #     plot.background = ggplot2::element_blank(),
  #     panel.grid.major = ggplot2::element_blank(),
  #     panel.grid.minor = ggplot2::element_blank()
  #   ) +
  #   # Add personalized color palette if specified
  #   { if (! is.null(col_df) & ! is.null(grouping_order)) 
  #     ggplot2::scale_fill_manual(values = col_df$color,
  #                                breaks = grouping_order) } +
  #   { if (! is.null(col_df) & is.null(grouping_order)) 
  #     ggplot2::scale_fill_manual(values = col_df$color,breaks = col_df$name) } +
  #   ggplot2::labs(y = "% of cells", x = "")
  
  joint_plt <- patchwork::plot_spacer() + col_plot + abs_prop_plt + tile_plt +  
    patchwork::plot_layout(widths = c(0.1, 1)) +
    patchwork::plot_annotation(title = title)
  
  # Show the joint plot directly in the Viewer pane
  print(joint_plt)
  
  return(list("joint_plt" = joint_plt,
              ind_plt = list(col_plot, tile_plt, abs_prop_plt)))
}
