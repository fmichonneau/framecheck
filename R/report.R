#' @export
print.framecheck_report <- function(x, ...) {
  cli::cli_h1("framecheck report")
  for (r in x$results) {
    if (r$ok) {
      cli::cli_alert_success(r$check)
    } else {
      cli::cli_alert_danger("{r$check}: {r$detail}")
    }
  }
  invisible(x)
}
