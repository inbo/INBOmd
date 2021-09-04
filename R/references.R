#' Insert references at this position
#'
#' @param appendix Chapters after the references become the appendix.
#' @param part Include the appendix as a part (level 0) heading.
#' Only relevant for pdf output.
#' @family utils
#' @export
#' @importFrom assertthat assert_that is.flag noNA
#' @importFrom knitr is_html_output
references <- function(appendix = FALSE, part = FALSE) {
  assert_that(is.flag(appendix), noNA(appendix))
  if (is_html_output()) {
    output <- c(
      "# Referenties {-}", "<div id='refs'></div>",
      "# (APPENDIX) Bijlage {-}"[appendix]
    )
  } else {
    assert_that(is.flag(part), noNA(part))
    output <- c(
      "\\appendix"[appendix],
      "\\part{\\appendixname}"[appendix && part]
    )
  }
  cat(output, sep = "\n\n")
}
