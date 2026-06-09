#' Internal constructor for a single check result
#'
#' @param check Character label for the check.
#' @param ok Logical scalar: did the check pass?
#' @param n_fail Integer count of failing elements.
#' @param detail Human-readable failure detail.
#' @return An object of class `framecheck_result`.
#' @keywords internal
framecheck_result <- function(check, ok, n_fail = 0L, detail = "") {
  structure(
    list(check = check, ok = ok, n_fail = as.integer(n_fail), detail = detail),
    class = "framecheck_result"
  )
}

#' Check that a data frame contains the expected columns
#'
#' @param cols Character vector of required column names.
#' @return A check function taking a data frame.
#' @export
chk_has_columns <- function(cols) {
  function(data) {
    missing <- setdiff(cols, names(data))
    framecheck_result(
      check = "has_columns",
      ok = length(missing) == 0,
      n_fail = length(missing),
      detail = if (length(missing)) {
        paste0("missing: ", paste(missing, collapse = ", "))
      } else {
        ""
      }
    )
  }
}

#' Check that a column has the expected class
#'
#' @param col Column name.
#' @param type Expected first class, e.g. "numeric".
#' @return A check function taking a data frame.
#' @export
chk_col_type <- function(col, type) {
  function(data) {
    actual <- class(data[[col]])[1]
    framecheck_result(
      check = paste0("col_type(", col, ")"),
      ok = actual == type,
      n_fail = as.integer(actual != type),
      detail = if (actual != type) {
        paste0("expected ", type, ", got ", actual)
      } else {
        ""
      }
    )
  }
}

#' Check that a set of columns forms a unique key
#'
#' @param cols Character vector of key columns.
#' @return A check function taking a data frame.
#' @export
chk_unique_key <- function(cols) {
  function(data) {
    dup <- duplicated(data[cols])
    framecheck_result(
      check = paste0("unique_key(", paste(cols, collapse = ", "), ")"),
      ok = !any(dup),
      n_fail = sum(dup),
      detail = if (any(dup)) paste0(sum(dup), " duplicate rows") else ""
    )
  }
}

#' Check that a numeric column falls within a range
#'
#' @param col Column name.
#' @param min,max Inclusive bounds.
#' @param n_show Maximum number of distinct out-of-range values to show in the detail.
#' @return A check function taking a data frame.
#' @export
chk_in_range <- function(col, min, max, n_show = 5L) {
  function(data) {
    x <- data[[col]]
    in_bounds <- x >= min & x <= max
    n_na <- sum(is.na(x))
    bad_vals <- sort(unique(x[!in_bounds & !is.na(x)]))
    detail <- if (length(bad_vals)) {
      shown <- bad_vals[seq_len(min(n_show, length(bad_vals)))]
      extra <- length(bad_vals) - length(shown)
      suffix <- if (extra > 0) paste0(" ... (", extra, " more)") else ""
      paste0(
        "out-of-range values [",
        min,
        ", ",
        max,
        "]: ",
        paste(shown, collapse = ", "),
        suffix
      )
    } else {
      ""
    }
    framecheck_result(
      check = paste0("in_range(", col, ")"),
      ok = n_na == 0 && all(in_bounds, na.rm = TRUE),
      n_fail = sum(!in_bounds, na.rm = TRUE),
      detail = detail
    )
  }
}
