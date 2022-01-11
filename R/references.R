#' Insert references at this position
#'
#' @param appendix Chapters after the references become the appendix.
#' @param part Include the appendix as a part (level 0) heading.
#' Only relevant for pdf output.
#' @family utils
#' @export
#' @importFrom assertthat assert_that has_name is.flag noNA
#' @importFrom knitr is_html_output
#' @importFrom rmarkdown yaml_front_matter
references <- function(appendix = FALSE, part = FALSE) {
  assert_that(is.flag(appendix), noNA(appendix))
  if (is_html_output()) {
    fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
    style <- ifelse(has_name(fm, "style"), fm$style, "INBO")
    lang <- ifelse(
      has_name(fm, "lang"), fm$lang, ifelse(style == "Flanders", "en", "nl")
    )
    ref_title <- sprintf(
      "# %s {-}",
      c(nl = "Referenties", en = "Bibliography", fr = "Bibliographie")[lang]
    )
    app_title <- sprintf(
      "# (APPENDIX) %s {-}",
      c(nl = "Bijlage", en = "Appendix", fr = "Annexe")[lang]
    )
    output <- c(ref_title, "<div id='refs'></div>", app_title[appendix])
  } else {
    assert_that(is.flag(part), noNA(part))
    output <- c(
      "\\appendix"[appendix],
      "\\part{\\appendixname}"[appendix && part]
    )
  }
  cat(output, sep = "\n\n")
}
