#' This function converts a vector of gene symbols to its entrezID form so that
#' it can be used to perform GO enrichment analysis.
#' Saves the plot in a tmp location and loads it as an image.
#'
#' @param gene_vec Vector of gene symbols or ensemble identifier to convert to
#'   entrezID.
#' @param gene_type Character string specifying if the gene vector are SYMBOL or
#'   ENSEMBLE identifiers. By default SYMBOL, can also be ENSEMBL.
#' @param annotation Character string specifying specifying the annotation of
#'   the organism to use. By default human org.Hs.eg.db but you can also choose
#'   mouse org.Mm.eg.db.
#'
#' @return Named vector with ENTREZID as the values.
#' @export
#' @examples
#' \dontrun{
#'   symbol_vec <- c("MS4A1", "CD4", "FOXP3")
#'   entrezid_vec <- convert_symb_entrez(
#'   gene_vec = symbol_vec,
#'   gene_type = "SYMBOL",
#'   annotation = "org.Hs.eg.db")
#'}

convert_symb_entrez <- function(gene_vec,
                                gene_type  = c("SYMBOL", "ENSEMBL"),
                                annotation = c("org.Hs.eg.db", "org.Mm.eg.db"))
  {
  if (annotation == "org.Hs.eg.db") {
    # Convert symbols to ENTREZID
    de_entrezid <- AnnotationDbi::mapIds(
      x = org.Hs.eg.db::org.Hs.eg.db,
      keys = unlist(gene_vec),
      column = "ENTREZID",
      keytype = "SYMBOL")

  } else if (annotation == "org.Mm.eg.db") {
    # Convert symbols to ENTREZID
    de_entrezid <- AnnotationDbi::mapIds(
      x = org.Mm.eg.db::org.Mm.eg.db,
      keys = unlist(gene_vec),
      column = "ENTREZID",
      keytype = "SYMBOL")

  }

    return(de_entrezid)

}
