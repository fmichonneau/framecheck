#' Run a list of checks against a data frame
#'
#' @param data A data frame.
#' @param checks A list of check functions, e.g. created by [chk_has_columns()].
#' @return An object of class `framecheck_report`.
#' @export
#' @examples
#' df <- data.frame(id = c(1, 2), score = c(5, 99))
#' check_frame(df, list(
#'   chk_has_columns(c("id", "score")),
#'   chk_unique_key("id"),
#'   chk_in_range("score", 0, 10)
#' ))
check_frame <- function(data, checks) {
  results <- lapply(checks, function(chk) chk(data))
  structure(
    list(
      results = results,
      ok = all(vapply(results, function(r) r$ok, logical(1)))
    ),
    class = "framecheck_report"
  )
}

#' Did every check in a report pass?
#'
#' @param report A `framecheck_report`.
#' @return Logical scalar.
#' @export
is_ok <- function(report) {
  report$ok
}
