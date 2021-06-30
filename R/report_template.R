#' set correct css file and bookdown template
#' @param format the required output format. Either "html" or "epub".
#' @param lang the language used in the colophon.
#' @export
#' @family utils
report_template <- function(
  format = c("html", "epub"), lang = c("nl", "en")
) {
  lang <- match.arg(lang)
  format <- match.arg(format)
  source_dir <- system.file("css", package = "INBOmd")
  target_dir <- file.path(getwd(), "css")
  dir.create(
    file.path(target_dir, "fonts"), recursive = TRUE, showWarnings = FALSE
  )
  dir.create(
    file.path(target_dir, "img"), recursive = TRUE, showWarnings = FALSE
  )
  source_files <- list.files(
    file.path(source_dir, c("fonts", "img")),
    full.names = TRUE, recursive = TRUE
  )
  file.copy(
    source_files, gsub(source_dir, target_dir, source_files), overwrite = TRUE
  )
  file.copy(
    system.file(
      file.path(
        "resources", "gitbook", "css", "fontawesome", "fontawesome-webfont.ttf"
      ),
      package = "bookdown"
    ),
    file.path(target_dir, "fonts")
  )
  source_files <- list.files(
    file.path(source_dir, lang), full.names = TRUE, recursive = TRUE
  )
  file.copy(
    source_files, file.path(target_dir, basename(source_files)),
    overwrite = TRUE
  )
  file.path(
    "css",
    sprintf(
      ifelse(format == "epub", "inbo_%s.epub3", "gitbook_%s.html"), lang
    )
  )
}

#' Deprecated functions
#'
#' | old function | new function |
#' | ------------------- | ------------------- |
#' | `ìnbo_handouts()` | `handouts()` |
#' | `ìnbo_poster()` | `poster()` |
#' | `ìnbo_rapport()` | `report()` |
#' | `inbo_rapport_css()` | `report_template()` |
#' | `ìnbo_slides()` | `slides()` |
#' | `ìnbo_verslag()` | `minutes()` |
#' @rdname deprecated
#' @family deprecated
#' @export
#' @inheritParams report_template
inbo_rapport_css <- function(format = "html") {
  .Deprecated(
    report_template(format = format),
    msg = "`inbo_rapport_css` is deprecated.
Use `report_template()` instead."
  )
}
