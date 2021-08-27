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
ebook <- function() {
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
    style == "Flanders" || lang != "en",
    msg = "Use style: Flanders when the language is not nl"
  )

  target_dir <- file.path(getwd(), "css")
  dir.create(target_dir, showWarnings = FALSE)
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
    if (!file.exists(file.path(getwd(), "cover.jpeg"))) {
      pdf_convert(
        pdf = file.path(getwd(), fm$cover), format = "jpeg", pages = 1,
        dpi = 770 * 25.4 / 210, filenames = file.path(getwd(), "cover.jpeg")
      )
    }
    cover_image <- "cover.jpeg"
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

  css <- define_css(style = style)
  css <- gsub("(url\\(\"?)(fonts|img)", "\\1../fonts", css)
  writeLines(css, file.path(target_dir, "epub.css"))
  config <- epub_book(
    fig_caption = TRUE, number_sections = TRUE, toc = TRUE,
    stylesheet = file.path(target_dir, "epub.css"), epub_version = "epub3",
    template = report_template(format = "epub", lang = lang),
    pandoc_args = pandoc_args, cover_image = cover_image
  )
  config$clean_supporting <- TRUE
  return(config)
}