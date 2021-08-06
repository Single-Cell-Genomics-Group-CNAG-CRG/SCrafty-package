#' Basic function to convert human to mouse gene names
#'
#' @param x Human gene symbol list to convert to mouse
#' @return Converted gene list
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' # A list of cell cycle markers, from Tirosh et al, 2015, is loaded with Seurat.  We can
#' # segregate this list into markers of G2/M phase and markers of S phase
#' s.genes_hs <- cc.genes$s.genes
#' 
#' s.genes_mm <- human_gene_to_mouse(x = s.genes_hs)
#' 
#' }
#' 

human_gene_to_mouse <- function(x){
  # https://www.r-bloggers.com/2016/10/converting-mouse-to-human-gene-names-with-biomart-package/
  # Basic function to convert human to mouse gene names
  # require("biomaRt")
  
  human <- biomaRt::useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  
  mouse <- biomaRt::useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  
  genesV2 <-  biomaRt::getLDS(
    attributes = c("hgnc_symbol"),
    filters = "hgnc_symbol",
    values = x ,
    mart = human,
    attributesL = c("mgi_symbol"),
    martL = mouse, uniqueRows = TRUE)
  
  humanx <- unique(genesV2[, 2])

  return(humanx)
}


#' Basic function to convert mouse to human gene names
#'
#' @param x Mouse gene symbol list to convert to human
#' @return Converted gene list
#' @export
#' @examples
#' \dontrun{
#' library(Seurat)
#' # A list of cell cycle markers, from Tirosh et al, 2015, is loaded with Seurat.  We can
#' # segregate this list into markers of G2/M phase and markers of S phase
#' musGenes <- c("Hmmr", "Tlx3", "Cpeb4")
#' 
#' hsGenes <- convertMouseGeneList(x = musGenes)
#' 
#' }
#' 
mouse_gene_to_human <- function(x){
  require("biomaRt")
  human = useMart("ensembl", dataset = "hsapiens_gene_ensembl")
  mouse = useMart("ensembl", dataset = "mmusculus_gene_ensembl")
  genesV2 = getLDS(attributes = c("mgi_symbol"), filters = "mgi_symbol", values = x , mart = mouse, attributesL = c("hgnc_symbol"), martL = human, uniqueRows=T)
  humanx <- unique(genesV2[, 2])
  # Print the first 6 genes found to the screen
  print(head(humanx))
  return(humanx)
}