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
  assert_that(
    is.null(caption) || is.string(caption),
    msg = "caption is not a string"
  )
  if (interactive() || opts_knit$get("rmarkdown.pandoc.to") == "html") {
    assert_that(
      interactive() ||
        (
          !is.null(opts_current$get()$results) &&
          opts_current$get()$results == "asis"
        ),
      msg = paste(
        "results = 'asis' is required for chunk", opts_current$get()$label
      )
    )
    assert_that(
      length(find.package("DT", quiet = TRUE)) == 1,
      msg = "The 'DT' is not available.
Please install it with install.packages('DT')"
    )
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
