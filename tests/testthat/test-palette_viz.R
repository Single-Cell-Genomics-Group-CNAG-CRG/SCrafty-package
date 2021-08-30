test_that("multiplication works", {
  hex_vec <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00",
  "#CC79A7", "#666666", "#AD7700", "#1C91D4", "#007756", "#D5C711",
  "#005685", "#A04700")
  p <- palette_viz(col_vec = hex_vec)
  expect_identical(is(p), "gg")
})
