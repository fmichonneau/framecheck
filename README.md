
<!-- README.md is generated from README.Rmd. Please edit that file -->

# framecheck

`framecheck` runs contract-style checks on a data frame and returns a
structured report of what passed and failed, instead of stopping at the
first error.

## Installation

``` r
# from your internal Posit Package Manager repository
install.packages("framecheck")
```

## Usage

``` r
library(framecheck)

check_frame(
  data.frame(id = c(1, 1)),
  list(
    chk_col_type("id", "numeric"),     # passes
    chk_has_columns(c("id", "score")), # fails: 'score' missing
    chk_unique_key("id")               # fails: duplicate id
  )
)
#> 
#> ── framecheck report ───────────────────────────────────────────────────────────
#> ✔ col_type(id)
#> ✖ has_columns: missing: score
#> ✖ unique_key(id): 1 duplicate rows
```
