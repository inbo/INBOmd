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
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown gitbook
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @family output
inbo_gitbook <- function(
  split_by = c("chapter+number", "section+number"), language = c("nl", "en")
) {
  split_by <- match.arg(split_by)
  language <- match.arg(language)
  pandoc_args = c(
    "--csl",
    system.file(
      "research-institute-for-nature-and-forest.csl", package = "INBOmd"
    )
  )
  assert_that(
    file.exists(file.path(getwd(), "index.Rmd")),
    msg = "You need to render an inbo_gitbook() from it's working directory"
  )
  fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
  if (
    has_name(fm, "cover") & !has_name(fm, "cover_image")
  ) {
    if (!file.exists(file.path(getwd(), "cover.jpeg"))) {
      pdf_convert(
        pdf = file.path(getwd(), fm$cover), format = "jpeg", pages = 1,
        dpi = 770 * 25.4 / 210, filenames = file.path(getwd(), "cover.jpeg")
      )
    }
    pandoc_args = c(
      pandoc_args,
      pandoc_variable_arg("cover_image", file.path(getwd(), "cover.jpeg"))
    )
  }

  config <- gitbook(
    fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE,
    anchor_sections = TRUE, lib_dir = "libs", split_by = split_by,
    split_bib = TRUE, table_css = TRUE, pandoc_args = pandoc_args,
    template = inbo_rapport_css(format = "html", language = language)
  )
  config$clean_supporting <- TRUE
  return(config)
}
