#' set correct css file and bookdown template
#' @param format the required output format. Either "html" or "epub".
#' @param language the language used in the colophon.
#' @export
#' @family utils
inbo_rapport_css <- function(
  format = c("html", "epub"), language = c("nl", "en")
) {
  language <- match.arg(language)
  format <- match.arg(format)
  source_dir <- system.file("css", package = "INBOmd")
  file.copy(source_dir, getwd(), recursive = TRUE, overwrite = TRUE)
  file.path(
    "css",
    sprintf(
      ifelse(format == "epub", "inbo_%s.epub3", "gitbook_%s.html"), language
    )
  )
}
