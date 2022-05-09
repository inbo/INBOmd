#' validate a DOI
#'
#' Checks the format of a DOI.
#' The format must obey https://www.doi.org/doi_handbook/2_Numbering.html#2.2
#' The DOI should the minimal version.
#' Hence no `doi:`, `https://doi.org` or other prefixes.
#' An example of a minimal version is `10.21436/inbor.70809860`.
#' The part before the forward slash consists of two or three sets of digits
#' separated by a dot.
#' E.g. `10.21436` or `10.21436.1`.
#' The part afther the forward slash consists either of only digits or of
#' two sets of any character separated by a dot.
#' @param doi a string containing the DOI.
#' @export
#' @importFrom assertthat assert_that is.string noNA
validate_doi <- function(doi) {
  assert_that(is.string(doi), noNA(doi))
  assert_that(
    grepl("^[0-9]+\\.[0-9]+(\\.[0-9]+)?\\/([0-9]+|.*\\..*)$", doi),
    msg = "DOI is not a in the correct format. See ?INBOmd::validate_doi"
  )
}
