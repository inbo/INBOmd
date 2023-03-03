#' Add the report numbers to a bookdown report
#' @param path the path to the `index.Rmd` of the bookdown report.
#' @inheritParams validate_doi
#' @param year Publication year
#' @param reportnr Report number assigned by the INBO library.
#' @param depotnr Report number assigned by the INBO library.
#' @param embargo The earliest date at which the report can be made public on
#' the INBO website.
#' Defaults to today.
#' @param ordernr Optional reference number specified by the client.
#' @param copies Set the required number of copies in case you really need a
#' printed version of the report.
#' Omit in case you only require a digital version.
#' Keep in mind that the INBO policy is to be "radically digital".
#' Which implies to only print a report if it is mandatory.
#' @param motivation Required motivation in case `copies` is set to a non-zero
#' number.
#' @param pages Number of pages of the report.
#' Only required in case `copies` is set to a non-zero number.
#' @family utils
#' @export
#' @importFrom assertthat assert_that is.count is.date is.string noNA
#' @importFrom fs is_dir is_file path
add_report_numbers <- function(
  path, doi, year, reportnr, depotnr, embargo = Sys.Date(), ordernr,
  copies, motivation, pages
) {
  validate_doi(doi)
  assert_that(
    is.count(year), is.count(reportnr), is.string(depotnr), is.date(embargo),
    noNA(year), noNA(reportnr), noNA(depotnr), noNA(embargo),
    length(embargo) == 1
  )
  assert_that(
    year >= as.integer(format(Sys.Date(), "%Y")),
    msg = "`year` must be at least the current year"
  )
  assert_that(is_dir(path), msg = "`path` is not an existing directory")
  assert_that(
    is_file(path(path, "_bookdown.yml")),
    msg = "No `_bookdown.yml` found in `path`"
  )
  assert_that(
    is_file(path(path, "index.Rmd")), msg = "No `index.Rmd` found in `path`"
  )

  # read file
  path(path, "index.Rmd") |>
    readLines() -> index
  yaml <- head(index, grep("---", index)[2])
  content <- tail(index, -grep("---", index)[2])

  # remove existing values
  yaml <- yaml[!grepl("^(depotnr|doi|embargo|ordernr|reportnr|year):", yaml)]
  which_print <- grep("^print:", yaml)
  if (length(which_print)) {
    top <- grep("^\\w", yaml) - 1
    top <- head(top[top > which_print], 1)
    yaml <- c(head(yaml, which_print - 1), tail(yaml, -top))
  }

  # calculate new values
  sprintf(
    "year: %i\ndoi: %s\nreportnr: %s\ndepotnr: %s\nembargo: %s", year, doi,
    reportnr, depotnr, embargo
  ) -> extra
  if (!missing(ordernr)) {
    assert_that(is.string(ordernr), noNA(ordernr))
    extra <- sprintf("%s\nordernr: \"%s\"", extra, ordernr)
  }
  if (!missing(copies)) {
    assert_that(
      is.count(copies), is.string(motivation), noNA(motivation), is.count(pages)
    )
    extra <- sprintf(
      "%s\nprint:\n  copies: %i\n  motivation: \"%s\"\n  pages: %i",
      extra, copies, motivation, pages
    )
  }

  # insert new values
  top <- grep("^\\w", yaml) - 1
  top <- head(top[top > grep("^reviewer:", yaml)], 1)
  c(head(yaml, top), extra, tail(yaml, -top), content) |>
    writeLines(path(path, "index.Rmd"))

  return(invisible(NULL))
}
