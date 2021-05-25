#' set correct css file and bookdown template
#' @param format the required output format. Either "html" or "epub".
#' @param lang the language used in the colophon.
#' @export
#' @family utils
inbo_rapport_template <- function(
  format = c("html", "epub"), lang = c("nl", "en")
) {
  lang <- match.arg(lang)
  format <- match.arg(format)
  source_dir <- system.file("css", package = "INBOmd")
  target_dir <- file.path(getwd(), "css")
  source_files <- list.files(
    file.path(source_dir, c("fonts", "img")),
    full.names = TRUE, recursive = TRUE
  )
  new_dirs <- gsub(source_dir, target_dir, unique(dirname(source_files)))
  vapply(
    new_dirs, dir.create, logical(1), showWarnings = FALSE, recursive = TRUE
  )
  file.copy(
    source_files, gsub(source_dir, target_dir, source_files), overwrite = TRUE
  )
  source_files <- list.files(
    file.path(source_dir, lang), full.names = TRUE, recursive = TRUE
  )
  file.copy(
    source_files, overwrite = TRUE,
    gsub(file.path(source_dir, lang), target_dir, source_files)
  )
  file.path(
    "css",
    sprintf(
      ifelse(format == "epub", "inbo_%s.epub3", "gitbook_%s.html"), lang
    )
  )
}

#' Deprecated
#'
#' Use `inbo_rapport_template()` instead.
#' @export
#' @inheritParams inbo_rapport_template
inbo_rapport_css <- function(format = "html") {
  .Deprecated(
    inbo_rapport_template(format = format),
    msg = "`inbo_rapport_css` is deprecated.
Use `inbo_rapport_template()` instead."
  )
}
