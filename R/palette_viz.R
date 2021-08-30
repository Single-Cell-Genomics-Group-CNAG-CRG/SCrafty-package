#' This function allows you to visualize a palette
#'
#' @param col_vec vector containing the palette colors
#' @return Tile plot showing the palette composition
#' @export
#' @examples
#' \dontrun{
#' hex_vec <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00",
#' "#CC79A7", "#666666", "#AD7700", "#1C91D4", "#007756", "#D5C711",
#' "#005685", "#A04700")
#' palette_viz(col_vec = hex_vec)
#' }
#'

palette_viz <- function(col_vec) {
  # Convert vector to dataframe
  col_df <- data.frame(
    colname = col_vec)
  
  # plot it, using scale_color_identity to interpret the hex as a color
  ggplot2::ggplot(
    col_df,
    ggplot2::aes(x = colname,
                 y = 1,
                 fill = colname)) +
    ggplot2::geom_tile() +
    ggplot2::geom_text(
      ggplot2::aes(label = colname)) +
    ggplot2::scale_fill_identity() +
    ggplot2::theme_void()
  
}
