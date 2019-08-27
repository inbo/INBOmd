#' Use a different table style depending on the output format
#'
#' - **interactive session**: \code{\link[DT]{datatable}}
#' - **html**: \code{\link[DT]{datatable}}
#' - **other**: \code{\link[pander]{pandoc.table}}
#'
#' @param x the dataframe
#' @inheritParams DT::datatable
#' @inheritParams pander::pandoc.table
#' @importFrom knitr opts_knit
#' @importFrom dplyr %>% mutate_all
dyn_table <- function(
  x, caption = NULL, rownames = FALSE, escape = TRUE, justify, ...
) {
  if (interactive() || opts_knit$get("rmarkdown.pandoc.to") == "html") {
    if (length(find.package("DT", quiet = TRUE)) == 0) {
      stop("The 'DT' is not available.
Please install it with install.packages('DT')")
    }
    if (!escape) {
      x %>%
        mutate_all(
          gsub, pattern = "\\*\\*(.*)\\*\\*", replacement = "<b>\\1</b>"
        ) %>%
        mutate_all(gsub, pattern = "_(.*)_", replacement = "<i>\\1</i>") -> x
    }
    DT::datatable(
      data = x, caption = caption, rownames = rownames, escape = escape, ...
    )
  } else {
    if (length(find.package("pander", quiet = TRUE)) == 0) {
      stop("The 'pander' is not available.
Please install it with install.packages('pander')")
    }
    if (missing(justify)) {
      pander::pandoc.table(
        x, caption = caption, missing = getOption("knitr.kable.NA"), ...
      )
    } else {
      pander::pandoc.table(
        x, caption = caption, missing = getOption("knitr.kable.NA"),
        justify = justify, ...
      )
    }
  }
}
