#' Output format for a web version of the report
#'
#' A version of [bookdown::gitbook()] with a different styling.
#' @template yaml_generic
#' @template yaml_report
#' @template yaml_gitbook
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown gitbook
#' @importFrom htmltools htmlDependency
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @importFrom utils head packageVersion tail
#' @family output
gitbook <- function() {
  fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
  style <- ifelse(has_name(fm, "style"), fm$style, "INBO")
  assert_that(length(style) == 1)
  assert_that(
    style %in% c("INBO", "Vlaanderen", "Flanders"),
    msg = "`style` must be one of 'INBO', 'Vlaanderen' or 'Flanders'"
  )
  lang <- ifelse(
    has_name(fm, "lang"), fm$lang, ifelse(style == "Flanders", "en", "nl")
  )
  assert_that(length(lang) == 1)
  languages <- c(nl = "dutch", en = "english", fr = "french")
  assert_that(
    lang %in% names(languages),
    msg = paste(
      "`lang` must be one of:",
      paste(sprintf("'%s' (%s)", names(languages), languages), collapse = ", ")
    )
  )
  assert_that(
    style != "Flanders" || lang != "nl",
    msg = "Use style: Vlaanderen when the language is nl"
  )
  assert_that(
    style == "Flanders" || lang == "nl",
    msg = "Use style: Flanders when the language is not nl"
  )
  split_by <- ifelse(has_name(fm, "split_by"), fm$split_by, "chapter+number")
  assert_that(length(split_by) == 1)
  assert_that(
    split_by %in% c("chapter+number", "section+number"),
    msg = "`split_by` must be either 'chapter+number' or `section+number`"
  )

  pandoc_args <- c(
    "--csl",
    system.file(
      "research-institute-for-nature-and-forest.csl", package = "INBOmd"
    )
  )
  assert_that(
    file.exists(file.path(getwd(), "index.Rmd")),
    msg = "You need to render an INBOmd::gitbook() from it's working directory"
  )
  if (has_name(fm, "cover")) {
    cover_path <- file.path(getwd(), "cover.jpeg")
    if (!file.exists(cover_path)) {
      pdf_convert(
        pdf = file.path(getwd(), fm$cover), format = "jpeg", pages = 1,
        dpi = 770 * 25.4 / 210, filenames = cover_path
      )
    }
    pandoc_args <- c(
      pandoc_args, pandoc_variable_arg("cover_image", cover_path)
    )
  }
  resource_dir <- system.file("css_styles", package = "INBOmd")
  inbomd_dep <- htmlDependency(
    name = "INBOmd", version = packageVersion("INBOmd"), src = resource_dir,
    stylesheet = sprintf(
      "%s_report.css", ifelse(style == "INBO", "inbo", "flanders")
    )
  )

  pandoc_args <- c(
    pandoc_args,
    pandoc_variable_arg(
      "csspath", file.path("libs", paste0("INBOmd-", packageVersion("INBOmd")))
    )
  )
  template <- system.file(
    file.path("template", sprintf("report_%s.html", lang)), package = "INBOmd"
  )
  config <- bookdown::gitbook(
    fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE,
    anchor_sections = TRUE, lib_dir = "libs", split_by = split_by,
    split_bib = TRUE, table_css = TRUE, pandoc_args = pandoc_args,
    template = template, extra_dependencies = list(inbomd_dep)
  )
  post <- config$post_processor  # in case a post processor have been defined
  config$post_processor <- function(metadata, input, output, clean, verbose) {
    x <- readLines(output, encoding = "UTF-8")
    i <- grep('^<div id="refs" class="references[^"]*"[^>]*>$', x)
    x <- c(head(x, i - 1), "", tail(x, -i + 1))
    writeLines(x, output)
    post(metadata, input, output, clean, verbose)
  }
  config$clean_supporting <- TRUE
  return(config)
}
