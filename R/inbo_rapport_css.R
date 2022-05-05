#' Deprecated functions
#'
#' | old function | new function |
#' | ------------------- | ------------------- |
#' | `ìnbo_ebook()` | `epub_book()` |
#' | `ìnbo_handouts()` | `handouts()` |
#' | `ìnbo_poster()` | `poster()` |
#' | `ìnbo_rapport()` | `pdf_report()` |
#' | `inbo_rapport_css()` | `report_template()` |
#' | `ìnbo_slides()` | `slides()` |
#' | `ìnbo_verslag()` | `minutes()` |
#' | `report()` | `pdf_report()` |
#' @rdname deprecated
#' @family deprecated
#' @param format defunct
#' @export
inbo_rapport_css <- function(format = "html") {
  .Defunct(
    "gitbook",
    msg = "`inbo_rapport_css` is defunct.
Use the `INBOmd::gitbook()` or `INBOmd::ebook()` output formats."
  )
}
