#' set correct css file and bookdown template
#' @param format the required output format. Either "html" or "epub"
#' @export
inbo_rapport_css <- function(format = "html") {
  source_dir <- system.file(
    "rmarkdown", "templates", "inbo_rapport", "skeleton", "css",
    package = "INBOmd"
  )
  file.copy(source_dir, getwd(), recursive = TRUE, overwrite = TRUE)
  if (format == "epub") {
    "css/inbo.epub3"
  } else {
    "css/gitbook.html"
  }
}
