#' Use a different table style depending on the output format
#'
#' - **interactive session**: \code{\link[DT]{datatable}}
#' - **html**: \code{\link[DT]{datatable}}
#' - **other**: \code{\link[knitr]{kable}}
#'
#' @param x the dataframe
#' @inheritParams DT::datatable
#' @inheritParams knitr::kable
#' @importFrom knitr opts_knit kable opts_current
#' @importFrom dplyr %>% mutate_all
#' @export
dyn_table <- function(
  x, caption = NULL, rownames = FALSE, escape = TRUE, align, ...
) {
  assert_that(is.flag(escape))
  assert_that(is.flag(rownames))
  assert_that(noNA(rownames))
  assert_that(noNA(escape))
  if (!is.null(caption)) {
    assert_that(is.string(caption))
  }
  if (interactive() || opts_knit$get("rmarkdown.pandoc.to") == "html") {
    if (!interactive() && opts_current$get()$results != "asis") {
      stop("results = 'asis' is required for chunk ", opts_current$get()$label)
    }
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
    if (!interactive() && !is.null(caption)) {
      sprintf(
        "<table>\n    <caption>(\\#tab:%s) %s</caption>\n</table>",
        opts_current$get()$label, caption
      ) %>%
        cat()
    }
    return(
      DT::datatable(
        data = x, rownames = rownames, escape = escape, ...
      )
    )
  }
  if (escape) {
    return(knitr::kable(x, caption = caption, ...))
  }
  knitr::kable(x, caption = caption, format = "pandoc", escape = FALSE, ...)
}
