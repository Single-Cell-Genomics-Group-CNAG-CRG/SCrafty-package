#' This function allows you to see plots inline, especially useful when trying
#' to format font sizes.
#'
#' Saves the plot in a tmp location and loads it as an image.
#'
#' @param x plot to visualize
#' @param w width in inches
#' @param h height in inches
#' @param dpi resolution
#' @param units character string specifying the units of the dimensions.
#'     By default in, inches, but it can also be px, cm, or mm.
#'
#' @return Show plot image in Viewer pane
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' df <- data.frame(x = 1:10, y = 1:10)
#' tmp_plt <- ggplot2::ggplot(df, ggplot2::aes(x = x, y = y)) +
#' ggplot2::geom_point()
#' ggpreview(x = tmp_plt, w = 9, h = 4, units = "in")
#'}

ggpreview <- function(x, w = 5, h = 5, dpi = 150, units = "in") {
  
  # Test valid input
  if (!units %in% c("in", "px", "cm", "mm")) {
    stop("units has to be: in, px, cm, or mm")
  }

  tmp <- tempfile(fileext = ".png")

  grDevices::png(
    filename = tmp,
    width = w,
    height = h,
    res = dpi,
    units = units)

  print(x)

  grDevices::dev.off()

  rstudioapi::viewer(tmp)
}
