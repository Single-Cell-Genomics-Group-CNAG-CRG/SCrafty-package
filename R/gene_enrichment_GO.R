#' This function carries out a GO enrichment analysis between a set of
#' differentially expressed genes within the specified gene universe.
#'
#' @param gene_de Vector of gene symbols or ensemble identifiers
#'   we want to test.
#' @param gene_universe Vector of gene symbols or ensemble identifiers
#'   constituting the entire gene universe to test, rownames(se_obj).
#' @param gene_type Character string specifying if the gene vector are SYMBOL or
#'    ENSEMBLE identifiers. By default SYMBOL, can also be ENSEMBL.
#' @param pvalue_cutoff Cutoff to use for the Pvalue
#' @param test_direction Character string which can be either "over" or "under".
#'   This determines whether the test performed detects over or under
#'   represented GO terms.
#' @param annotation Character string specifying specifying the annotation of
#'   the organism to use. By default human org.Hs.eg.db but you can also choose
#'   mouse org.Mm.eg.db.
#' @param ontology which ontology do we want to test BP (biological processes),
#'   CC (cellular component), or MF (molecular function)
#'
#' @return Named vector with ENTREZID as the values.
#' @export
#' @examples
#' \dontrun{
#'   gene_de <- c("MS4A1", "CD79A", "CD79B")
#'   gene_universe <- c("HLA-DRA", "AIF1", "C1QA", "LYZ", "SELENOP", "ADAMDEC1",
#'   "CD14", "CD68", "IGF1", "LGMN", "AXL", "C5AR1", "CD163", "CD163L1",
#'   "CD209", "CSF1R", "IL10", "IL10RA", "IL13RA1", "NRP1", "NRP2", "SDC3",
#'   "TGFBI", "TGFBR1", "EEF1A1", "OAZ1", "RPL15", "RPL19", "RPS19", "RPS29",
#'   "TPT1", "UBA52", "APOE", "FCGRT", "MKI67", "PCLAF", "RRM2", "CD1C", "CLC",
#'   "IL4", "TPSAB1", "CPA3", "NRG1", "RETN", "EREG", "ACOD1", "TNIP3", "VCAN",
#'   "INHBA", "CXCL5", "HTRA1", "SPP1", "HSPA1B", "CXCR2", "PI3", "PROK2",
#'   "HSPA6", "NCCRP1", "LAD1", "CCL22", "MS4A1", "CD79A", "CD79B", "SIGLEC1")
#'
#'   GO_results <- gene_enrichment_GO(
#'   gene_de = gene_de,
#'   gene_universe = gene_universe,
#'   gene_type = "SYMBOL",
#'   annotation = "org.Hs.eg.db",
#'   pvalue_cutoff = 0.05,
#'   test_direction = "over",
#'   ontology = "BP")
#' }

gene_enrichment_GO <- function(gene_de,
                               gene_universe,
                               gene_type  = "SYMBOL",
                               pvalue_cutoff = 0.05,
                               test_direction = "over",
                               annotation = "org.Hs.eg.db",
                               ontology = "BP") {
  
  # Test valid input
  if (!gene_type %in% c("SYMBOL", "ENSEMBL")) {
    stop("gene_type has to be: SYMBOL or ENSEMBL")
  }
  
  if (!annotation %in% c("org.Hs.eg.db", "org.Mm.eg.db")) {
    stop("annotation has to be: org.Hs.eg.db or org.Mm.eg.db")
  }
  
  if (!ontology %in% c("BP", "CC", "MF")) {
    stop("ontology has to be: BP, CC or MF")
  }
  
  # Convert Target genes from symbol/ensembl to entrezID
  target_enrich <- convert_symb_entrez(gene_vec = unique(gene_de),
                                       annotation = annotation)

  # Convert Universe genes from symbol/ensembl to entrezID
  univers_g <- convert_symb_entrez(gene_vec = unique(gene_universe),
                                   annotation = annotation)

  # Create a GOHyperGParams instance
  params <- methods::new(
    "GOHyperGParams",
    geneIds = target_enrich,
    universeGeneIds = univers_g,
    annotation = annotation,
    ontology = ontology,
    pvalueCutoff = pvalue_cutoff,
    testDirection = test_direction)

  # Carry out hyper geometric test
  hgOver <- GOstats::hyperGTest(params)
  return(hgOver)

}
