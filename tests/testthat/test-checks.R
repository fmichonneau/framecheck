test_that("chk_has_columns passes when required columns are present", {
  df <- data.frame(a = 1, b = 2)
  res <- chk_has_columns(c("a", "b"))(df)
  expect_true(res$ok)
})

test_that("chk_in_range flags a column that is just NAs", {
  df <- data.frame(x = c(NA_real_, NA_real_))
  res <- chk_in_range("x", 0, 10)(df)
  expect_false(res$ok)
})

test_that("report print output is stable", {
  df <- data.frame(id = c(1, 1), score = c(5, 99))
  report <- check_frame(
    df,
    list(
      chk_has_columns(c("id", "score")),
      chk_unique_key("id"),
      chk_in_range("score", 0, 10)
    )
  )
  expect_snapshot(print(report))
})