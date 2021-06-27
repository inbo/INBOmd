#' Output format for a web version of the report
#'
#' A version of [bookdown::gitbook()] with a different styling.
#' @template yaml_generic
#' @template yaml_report
#' @template yaml_gitbook
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown gitbook
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @family output
inbo_gitbook <- function() {
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
  languages <- c(nl = "dutch", en = "english")
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
    style == "Flanders" || lang != "en",
    msg = "Use style: Flanders when the language is not nl"
  )
  split_by <- ifelse(has_name(fm, "split_by"), fm$split_by, "chapter+number")
  assert_that(length(split_by) == 1)
  assert_that(
    split_by %in% c("chapter+number", "section+number"),
    msg = "`split_by` must be either 'chapter+number' or `section+number`"
  )

  target_dir <- file.path(getwd(), "css")
  dir.create(target_dir, showWarnings = FALSE)
  pandoc_args <- c(
    "--csl",
    system.file(
      "research-institute-for-nature-and-forest.csl", package = "INBOmd"
    )
  )
  assert_that(
    file.exists(file.path(getwd(), "index.Rmd")),
    msg = "You need to render an inbo_gitbook() from it's working directory"
  )
  if (has_name(fm, "cover")) {
    if (!file.exists(file.path(getwd(), "cover.jpeg"))) {
      pdf_convert(
        pdf = file.path(getwd(), fm$cover), format = "jpeg", pages = 1,
        dpi = 770 * 25.4 / 210, filenames = file.path(getwd(), "cover.jpeg")
      )
    }
    pandoc_args <- c(
      pandoc_args,
      pandoc_variable_arg("cover_image", file.path(getwd(), "cover.jpeg"))
    )
  }

  css <- define_css(style = style)
  writeLines(css, file.path(target_dir, "report.css"))
  pandoc_args <- c(
    pandoc_args,
    pandoc_variable_arg("css", file.path(target_dir, "report.css"))
  )
  config <- gitbook(
    fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE,
    anchor_sections = TRUE, lib_dir = "libs", split_by = split_by,
    split_bib = TRUE, table_css = TRUE, pandoc_args = pandoc_args,
    template = inbo_rapport_template(format = "html", lang = lang)
  )
  config$clean_supporting <- TRUE
  return(config)
}

define_css <- function(style) {
  style_colors <- list(
    INBO = c(
      `heading-color` = "#356196", `link-color` = "#C04384",
      `link-toc-color` = "#356196", `link-toc-hover-color` = "#C04384",
      `header-color` = "#356196", `header-background-color` = "#FFFFFF",
      `alert-block-color` = "#C04384"
    ),
    level1 = c(
      `heading-color` = "#3C3D00", `link-color` = "#05C",
      `link-toc-color` = "#3C3D00", `link-toc-hover-color` = "#05C",
      `header-color` = "#3C3D00", `header-background-color` = "#FFEB00",
      `alert-block-color` = "#FFEB00"
    )
  )
  style_colors <- style_colors[[ifelse(style == "INBO", "INBO", "level1")]]
  style_colors <- sprintf("  --%s: %s;", names(style_colors), style_colors)
  css <- system.file(file.path("css", "report.css"), package = "INBOmd")
  c(readLines(css), ":root {", style_colors, "}")
}
