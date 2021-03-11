####
# 

# It is set to be used for human genes only.
# It requires the packages org.Hs.eg.db and GOstats to be installed.
####
# gene_universe: vector with all the genes evaluated in order to set the gene universe. Must be ENTREZID names for the genes.
# gene_de: vector with all the differentially expressed genes from the gene universe. Must be ENTREZID names for the genes.
# pvalueCutoff: Cutoff to use for the Pvalue
# testDirection: 
####
# Returns: hgOver with the enriched GO terms 
####
# library(org.Hs.eg.db) # It is called in convert_symb_entrez

#' This function performs a hyper geometric test with a set of differentially 
#' expressed genes over a defined gene universe. 
#'
#' Saves the plot in a tmp location and loads it as an image.
#'
#' @param gene_de Vector of gene symbols or ensemble identifiers we want to test.
#' @param gene_universe Vector of gene symbols or ensemble identifiers constituting the entire gene universe to test, rownames(se_obj). 
#' @param gene_type Character string specifying if the gene vector are SYMBOL or ENSEMBLE identifiers. By default SYMBOL, can also be ENSEMBL.
#' @param pvalueCutoff Cutoff to use for the Pvalue
#' @param testDirection Character string which can be either "over" or "under". This determines whether the test performed detects over or under represented GO terms.
#' @param annotation Character string specifying specifying the annotation of the organism to use. By default human org.Hs.eg.db but you can also choose mouse org.Mm.eg.db.
#' @param ontology which ontology do we want to test BP (biological processes), CC (cellular component), or MF (molecular function)
#'
#' @return Named vector with ENTREZID as the values.
#' @export
#' @examples
#' \dontrun{
#'   gene_de <- c("MS4A1", "CD79A", "CD79B")
#'   gene_universe <- c("HLA-DRA", "AIF1", "C1QA", "LYZ", "SELENOP", "ADAMDEC1",
#'   "CD14", "CD68", "IGF1", "LGMN", "AXL", "C5AR1", "CD163", "CD163L1", "CD209",
#'   "CSF1R", "IL10", "IL10RA", "IL13RA1", "NRP1", "NRP2", "SDC3", "SIGLEC1",
#'   "TGFBI", "TGFBR1", "EEF1A1", "OAZ1", "RPL15", "RPL19", "RPS19", "RPS29",
#'   "TPT1", "UBA52", "APOE", "FCGRT", "MKI67", "PCLAF", "RRM2", "CD1C", "CLC",
#'   "IL4", "TPSAB1", "CPA3", "NRG1", "RETN", "EREG", "ACOD1", "TNIP3", "VCAN",
#'   "INHBA", "CXCL5", "HTRA1", "SPP1", "HSPA1B", "CXCR2", "PI3", "PROK2",
#'   "HSPA6", "NCCRP1", "LAD1", "CCL22", "MS4A1", "CD79A", "CD79B")
#'   
#'   GO_results <- gene_enrichment_GO(
#'   gene_de = gene_de,
#'   gene_universe = gene_universe,
#'   gene_type = "SYMBOL",
#'   annotation = "org.Hs.eg.db",
#'   pvalueCutoff = 0.05,
#'   testDirection = "over",
#'   ontology = "BP")
#' }

gene_enrichment_GO <- function(gene_de, 
                               gene_universe,
                               gene_type  = c("SYMBOL", "ENSEMBL"),
                               pvalueCutoff = 0.05,
                               testDirection = "over",
                               annotation = c("org.Hs.eg.db", "org.Mm.eg.db"),
                               ontology = c("BP", "CC", "MF")) {
  # library(GOstats)
  
  # Convert Target genes from symbol to entrezID
  target_enrich <- convert_symb_entrez(gene_vec = unique(gene_de),
                                       annotation = annotation)
  
  # Convert Universe genes from symbol to entrezID
  univers_g <- convert_symb_entrez(gene_vec = unique(gene_universe),
                                   annotation = annotation) 
  
  # Create a GOHyperGParams instance
  params <- new("GOHyperGParams",
                geneIds = target_enrich, 
                universeGeneIds = univers_g,
                annotation = annotation,
                ontology = ontology,
                pvalueCutoff = pvalueCutoff,
                testDirection = testDirection)

  # Carry out hyper geometric test
  hgOver <- GOstats::hyperGTest(params)
  return(hgOver)
  
}
