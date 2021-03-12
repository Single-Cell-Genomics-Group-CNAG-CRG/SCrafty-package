test_that("gene_enrichment_GO works", {
  library(GOstats)
  gene_de <- c("MS4A1", "CD79A", "CD79B")
  gene_universe <- c("HLA-DRA", "AIF1", "C1QA", "LYZ", "SELENOP", "ADAMDEC1",
  "CD14", "CD68", "IGF1", "LGMN", "AXL", "C5AR1", "CD163", "CD163L1", "CD209",
  "CSF1R", "IL10", "IL10RA", "IL13RA1", "NRP1", "NRP2", "SDC3", "SIGLEC1",
  "TGFBI", "TGFBR1", "EEF1A1", "OAZ1", "RPL15", "RPL19", "RPS19", "RPS29",
  "TPT1", "UBA52", "APOE", "FCGRT", "MKI67", "PCLAF", "RRM2", "CD1C", "CLC",
  "IL4", "TPSAB1", "CPA3", "NRG1", "RETN", "EREG", "ACOD1", "TNIP3", "VCAN",
  "INHBA", "CXCL5", "HTRA1", "SPP1", "HSPA1B", "CXCR2", "PI3", "PROK2",
  "HSPA6", "NCCRP1", "LAD1", "CCL22", "MS4A1", "CD79A", "CD79B")

  GO_results <- gene_enrichment_GO(
    gene_de = gene_de,
    gene_universe = gene_universe,
    gene_type = "SYMBOL",
    annotation = "org.Hs.eg.db",
    pvalue_cutoff = 0.05,
    test_direction = "over",
    ontology = "BP")

  expect_equal(is(GO_results), c("GOHyperGResult", "HyperGResultBase"))
})
