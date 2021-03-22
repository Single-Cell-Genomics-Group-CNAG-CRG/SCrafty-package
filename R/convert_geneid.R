#' This function converts a vector of gene identifiers to other identifiers 
#'
#' @param gene_vec Vector of gene identifiers to convert to
#'   entrezID.
#' @param gene_from Character string specifying the gene identifier is gene_vec,
#'   By default SYMBOL, can also be ENTREZID, ENSEMBL, UNIGENE
#' @param gene_to Character string specifying what the gene id we want to
#'   convert the gene_vec to. By default ENTREZID, can also be SYMBOL, ENSEMBL,
#'   UNIGENE
#' @param annotation Character string specifying specifying the annotation of
#'   the organism to use. By default human org.Hs.eg.db but you can also choose
#'   mouse org.Mm.eg.db.
#'
#' @return Named vector with ENTREZID as the values.
#' @export
#' @examples
#' \dontrun{
#'   symbol_vec <- c("MS4A1", "CD4", "FOXP3")
#'   entrezid_vec <- convert_geneid(
#'   gene_vec = symbol_vec,
#'   gene_from = "SYMBOL",
#'   gene_to = "ENTREZID",
#'   annotation = "org.Hs.eg.db")
#'}

convert_geneid <- function(gene_vec,
                           gene_from  = "SYMBOL",
                           gene_to  = "ENTREZID",
                           annotation = "org.Hs.eg.db") {
  
  # Test valid input
  if (!gene_from %in% c("SYMBOL", "ENSEMBL", "ENTREZID", "UNIGENE")) {
    stop("gene_from has to be: SYMBOL, ENSEMBL, ENTREZID, or UNIGENE")
  }

    if (!gene_to %in% c("SYMBOL", "ENSEMBL", "ENTREZID", "UNIGENE")) {
    stop("gene_to has to be: SYMBOL, ENSEMBL, ENTREZID, or UNIGENE")
  }
  
  if (!annotation %in% c("org.Hs.eg.db", "org.Mm.eg.db")) {
    stop("annotation has to be: org.Hs.eg.db or org.Mm.eg.db")
  }
  
  # Run separate function for human or mouse
  if (annotation == "org.Hs.eg.db") {
    # Convert symbols to ENTREZID
    de_entrezid <- AnnotationDbi::mapIds(
      x = org.Hs.eg.db::org.Hs.eg.db,
      keys = unlist(gene_vec),
      column = gene_to,
      keytype = gene_from)

  } else if (annotation == "org.Mm.eg.db") {
    # Convert symbols to ENTREZID
    de_entrezid <- AnnotationDbi::mapIds(
      x = org.Mm.eg.db::org.Mm.eg.db,
      keys = unlist(gene_vec),
      column = gene_to,
      keytype = gene_from)

  }

    return(de_entrezid)

}
