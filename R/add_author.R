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
  if (is_file(path(path, "_bookdown.yml"))) {
    return(add_author_bookdown(path = path))
  }
  if (is_file(path(path, "_quarto.yml"))) {
    return(add_author_quarto(path = path))
  }
  stop("Neither `_bookdown.yml` nor `_quarto.yml` found in `path`")
}

#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs is_dir is_file path
add_author_bookdown <- function(path) {
  assert_that(
    is_file(path(path, "_bookdown.yml")),
    msg = "No `_bookdown.yml` found in `path`"
  )
  assert_that(
    is_file(path(path, "index.Rmd")),
    msg = "No `index.Rmd` found in `path`"
  )

  path(path, "index.Rmd") |>
    readLines() -> index
  lang <- grep("^lang:", index)
  assert_that(length(lang) > 0, msg = "No `lang:` entry found in yaml header")
  assert_that(
    length(lang) == 1,
    msg = "Multiple `lang:` entries found in yaml header"
  )
  lang <- gsub("lang: ", "", index[lang])

  author <- grep("^author:", index)
  assert_that(
    length(author) > 0,
    msg = "No `author:` entry found in yaml header"
  )
  assert_that(
    length(author) == 1,
    msg = "Multiple `author:` entries found in yaml header"
  )
  check_author(lang = lang) |>
    author2yaml(corresponding = FALSE) -> extra
  top <- grep("^\\w+:", index) - 1
  insert <- head(top[top > author], 1)
  head(index, insert) |>
    c(extra, tail(index, -insert)) |>
    writeLines(path(path, "index.Rmd"))
  return(invisible(NULL))
}

#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs is_dir is_file path
#' @importFrom yaml read_yaml write_yaml
add_author_quarto <- function(path) {
  assert_that(
    is_file(path(path, "_quarto.yml")),
    msg = "No `_quarto.yml` found in `path`"
  )
  path(path, "_quarto.yml") |>
    read_yaml() -> yaml
  # fmt:skip
  stopifnot(
    "No `lang:` entry found in `_quarto.yml`" = has_name(yaml, "lang"),
    "No `flandersqmd:` entry found in `_quarto.yml`" = has_name(
      yaml,
      "flandersqmd"
    ),
    "No `author:` entry found in the `flandersqmd` section of `_quarto.yml`" =
      has_name(yaml$flandersqmd, "author")
  )
  lang <- yaml$lang
  extra <- check_author(lang = lang)
  yaml$flandersqmd$author <- c(
    yaml$flandersqmd$author,
    list(
      list(
        name = list(given = extra$given, family = extra$family),
        email = extra$email,
        orcid = extra$orcid,
        affiliation = list(extra$affiliation)
      )
    )
  )
  yaml$flandersqmd$author <- lapply(
    yaml$flandersqmd$author,
    FUN = function(x) {
      if (!is.list(x$affiliation)) {
        x$affiliation <- as.list(x$affiliation)
      }
      return(x)
    }
  )
  write_yaml(
    yaml,
    file = path(path, "_quarto.yml"),
    handlers = c(
      "logical" = function(x) {
        attr(x, "class") <- "verbatim"
        ifelse(x, "true", "false")
      }
    )
  )
  return(invisible(NULL))
}
