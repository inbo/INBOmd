#' set correct css file and bookdown template
#' @param format the required output format. Either "html" or "epub"
#' @export
#' @family utils
inbo_rapport_css <- function(format = "html") {
  source_dir <- system.file(
    "css",
    package = "INBOmd"
  )
  file.copy(source_dir, getwd(), recursive = TRUE, overwrite = TRUE)
  if (format == "epub") {
    file.path("css", "inbo.epub3")
  } else {
    file.path("css", "gitbook.html")
  }
}
