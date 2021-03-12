test_that("convert_symb_entrez works for human-symbol", {
  symbol_vec <- c("MS4A1", "CD4", "FOXP3")

  entrezid_vec <- convert_symb_entrez(
    gene_vec = symbol_vec,
    gene_type = "SYMBOL",
    annotation = "org.Hs.eg.db")

  expect_vec <- c("931", "920", "50943")
  names(expect_vec) <- symbol_vec

  expect_equal(entrezid_vec, expect_vec)
})


test_that("convert_symb_entrez works for mouse-symbol", {
  symbol_vec <- c("Ms4a1", "Cd4", "Foxp3")

  entrezid_vec <- convert_symb_entrez(
    gene_vec = symbol_vec,
    gene_type = "SYMBOL",
    annotation = "org.Mm.eg.db")

  expect_vec <- c("12482", "12504", "20371")
  names(expect_vec) <- symbol_vec

  expect_equal(entrezid_vec, expect_vec)
})
