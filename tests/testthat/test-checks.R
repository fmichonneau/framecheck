test_that("chk_has_columns passes when required columns are present", {
  df <- data.frame(a = 1, b = 2)
  res <- chk_has_columns(c("a", "b"))(df)
  expect_true(res$ok)
})
