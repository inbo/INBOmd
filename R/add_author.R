#' Add an author to the a report
#'
#' This function will interactively add the information of an author from the
#' local authors database.
#' @inheritParams add_report_numbers
#' @family utils
#' @export
#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs is_dir is_file path
add_author <- function(path = ".") {
  assert_that(is.string(path), noNA(path))
  assert_that(is_dir(path), msg = "`path` is not an existing directory")
  assert_that(
    is_file(path(path, "_bookdown.yml")),
    msg = "No `_bookdown.yml` found in `path`"
  )
  assert_that(
    is_file(path(path, "index.Rmd")), msg = "No `index.Rmd` found in `path`"
  )

  path(path, "index.Rmd") |>
    readLines() -> index
  author <- grep("^author:", index)
  assert_that(
    length(author) > 0, msg = "No `author:` entry found in yaml header"
  )
  assert_that(
    length(author) == 1, msg = "Multiple `author:` entries found in yaml header"
  )
  use_author() |>
    author2yaml(corresponding = FALSE) -> extra
  top <- grep("^\\w+:", index) - 1
  insert <- head(top[top > author], 1)
  head(index, insert) |>
    c(extra, tail(index, -insert)) |>
    writeLines(path(path, "index.Rmd"))
  return(invisible(NULL))
}
