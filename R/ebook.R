#' Style for e-book
#'
#' A version of [bookdown::epub_book()] with a different styling.
#' @template yaml_generic
#' @template yaml_report
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown epub_book
#' @importFrom fs file_exists path
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @family output
epub_book <- function() {
  path(getwd(), "index.Rmd") |>
    yaml_front_matter() |>
    validate_persons(reviewer = TRUE) |>
    validate_rightsholder() -> fm
  assert_that(
    has_name(fm, "reportnr"), has_name(fm, "year"),
    has_name(fm, "cover_description")
  )
  style <- ifelse(has_name(fm, "style"), fm$style, "INBO")
  assert_that(length(style) == 1)
  assert_that(style %in% c("INBO", "Vlaanderen", "Flanders"),
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

  pandoc_args <- c(
    "--csl",
    system.file(
      "research-institute-for-nature-and-forest.csl", package = "INBOmd"
    ),
    "--lua-filter",
    system.file(file.path("pandoc", "translations.lua"), package = "INBOmd")
  )
  if (
    has_name(fm, "public_report") && !fm$public_report
  ) {
    pandoc_variable_arg("pagefootmessage", fm$reportnr) |>
      c(pandoc_variable_arg("internal", "true")) |>
      c(pandoc_args) -> pandoc_args
  } else {
    assert_that(has_name(fm, "depotnr"), has_name(fm, "doi"))
    validate_doi(fm$doi)
  }
  file.path("css_styles", c("fonts", "img")) |>
    system.file(package = "INBOmd") |>
    list.files(full.names = TRUE) -> fonts
  pandoc_args <- c(
    pandoc_args, sprintf("--epub-embed-font=%s", fonts),
    pandoc_variable_arg("corresponding", fm$corresponding),
    pandoc_variable_arg("shortauthor", fm$shortauthor)
  )
  assert_that(
    file.exists(file.path(getwd(), "index.Rmd")),
    msg = "You need to render an inbo_ebook() from it's working directory"
  )
  cover_image <- NULL
  if (has_name(fm, "cover")) {
    cover_image <- gsub("\\.pdf$", ".png", fm$cover)
    if (!file_exists(cover_image)) {
      pdf_convert(
        pdf = fm$cover, format = "png", pages = 1, dpi = 770 * 25.4 / 210,
        filenames = cover_image
      )
    }
  }
  meta_author <- vapply(
    fm$author,
    function(current_author) {
      sprintf("%s %s", current_author$name$given, current_author$name$family)
    },
    character(1)
  )
  metadata <- c(
    title = ifelse(
      has_name(fm, "subtitle"),
      paste(fm$title, fm$subtitle, sep = ". "),
      fm$title
    ),
    creator = paste(meta_author, collapse = ", "),
    date = fm$year,
    publisher = ifelse(
      lang != "nl", "Research Institute for Nature and Forest (INBO)",
      "Instituut voor Natuur- en Bosonderzoek"
    ),
    series = ifelse(
      lang != "nl", "Reports of the Research Institute for Nature and Forest",
      "Rapporten van het Instituut voor Natuur- en Bosonderzoek"
    ),
    identifier = fm$doi,
    rights = "Creative Commons Attribution 4.0 Generic License",
    language = lang
  )
  metadata_file <- tempfile(fileext = ".xml")
  writeLines(
    c(
      "<?xml version=\"1.0\"?>",
      sprintf("<dc:%1$s>%2$s</dc:%1$s>", names(metadata), metadata)
    ),
    metadata_file
  )
  pandoc_args <- c(pandoc_args, sprintf("--epub-metadata=%s", metadata_file))

  check_license()

  resource_dir <- system.file(file.path("css_styles"), package = "INBOmd")
  template <- system.file(
    file.path("template", "report.epub3"), package = "INBOmd"
  )
  config <- bookdown::epub_book(
    fig_caption = TRUE, number_sections = TRUE, toc = TRUE,
    stylesheet = file.path(
      resource_dir,
      sprintf("%s_epub.css", ifelse(style == "INBO", "inbo", "flanders"))
    ), epub_version = "epub3", template = template, pandoc_args = pandoc_args,
    cover_image = cover_image
  )
  config$clean_supporting <- TRUE
  return(config)
}

#' @rdname deprecated
#' @family deprecated
#' @export
ebook <- function() {
  .Deprecated(
    epub_book(),
    msg = "`INBOmd::ebook` is deprecated. Use `INBOmd::epub_book` instead."
  )
}

#' @rdname deprecated
#' @family deprecated
#' @export
inbo_ebook <- function() {
  .Deprecated(
    epub_book(),
    msg = "`INBOmd::inbo_ebook` is deprecated. Use `INBOmd::epub_book` instead."
  )
}
