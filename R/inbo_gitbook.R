#' INBO version of bookdown::gitbook
#' @param split_by How to name the HTML output files from the book:
#' \code{chapter+number} means split the file by the first-level headers;
#' \code{section+number} means the second-level headers.
#' For \code{chapter+number} and \code{section+number}, the HTML filenames will
#' be determined by the header ID's, e.g. the filename for the first chapter
#' with a chapter title \code{# Introduction} will be
#' \file{1-introduction.html}.
#' @inheritParams inbo_rapport_css
#' @export
#' @importFrom bookdown gitbook
#' @family output
inbo_gitbook <- function(
  split_by = c("chapter+number", "section+number"), language = c("nl", "en")
) {
  split_by <- match.arg(split_by)
  language <- match.arg(language)
  config <- gitbook(
    fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE,
    anchor_sections = TRUE, lib_dir = "libs", split_by = split_by,
    split_bib = TRUE, table_css = TRUE,
    pandoc_args = c(
      "--csl",
      system.file(
        "research-institute-for-nature-and-forest.csl", package = "INBOmd"
      )
    ),
    template = inbo_rapport_css(format = "html", language = language)
  )
  config$clean_supporting <- TRUE
  return(config)
}
