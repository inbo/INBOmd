#' Style for e-book
#'
#' A version of [bookdown::epub_book()] with a different styling.
#' @template yaml_generic
#' @template yaml_report
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown epub_book
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @family output
epub_book <- function() {
  fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
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
    )
  )
  fonts <- system.file(file.path("css", c("fonts", "img")), package = "INBOmd")
  fonts <- list.files(fonts, full.names = TRUE)
  pandoc_args <- c(
    pandoc_args, sprintf("--epub-embed-font=%s", fonts)
  )
  assert_that(
    file.exists(file.path(getwd(), "index.Rmd")),
    msg = "You need to render an inbo_ebook() from it's working directory"
  )
  cover_image <- NULL
  if (has_name(fm, "cover")) {
    cover_path <- file.path(getwd(), "cover.png")
    if (!file.exists(cover_path)) {
      pdf_convert(
        pdf = file.path(getwd(), fm$cover), format = "png", pages = 1,
        dpi = 770 * 25.4 / 210, filenames = cover_path
      )
    }
    cover_image <- basename(cover_path)
  }
  meta_author <- vapply(
    fm$author,
    function(current_author) {
      ifelse(
        has_name(current_author, "name"),
        ifelse(
          has_name(current_author, "firstname"),
          sprintf("%s %s", current_author$firstname, current_author$name),
          current_author$name
        ),
        current_author
      )
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

  resource_dir <- system.file(file.path("css_styles"), package = "INBOmd")
  template <- system.file(
    file.path("template", sprintf("report_%s.epub3", lang)), package = "INBOmd"
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
