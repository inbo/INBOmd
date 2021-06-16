#' INBO version of bookdown::epub_book
#' @inheritParams inbo_rapport_template
#' @inheritParams inbo_rapport
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown epub_book
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @family output
inbo_ebook <- function(
  lang = c("nl", "en"), style = c("INBO", "Vlaanderen", "Flanders")
) {
  lang <- match.arg(lang)
  style <- match.arg(style)
  source_dir <- system.file("css", package = "INBOmd")
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
    cover_image <- "cover.jpeg"
  } else {
    cover_image <- NULL
  }
  lang <- ifelse(
    has_name(fm$output$`INBOmd::inbo_ebook`, "lang"),
    fm$output$`INBOmd::inbo_ebook`$lang,
    ifelse(has_name(fm, "lang"), fm$lang, lang)
  )
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
    identifier = fm$doi,
    rights = "Creative Commons Attribution-ShareAlike 4.0 Generic License",
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
  pandoc_args <- c(
    pandoc_args, sprintf("--epub-metadata=%s", metadata_file)
  )

  lang <- ifelse(lang != "nl", "en", "nl")
  assert_that(
    style != "Flanders" || lang != "nl",
    msg = "Use style: Vlaanderen when the language is nl"
  )
  assert_that(
    style == "Flanders" || lang != "en",
    msg = "Use style: Flanders when the language is not nl"
  )
  css <- define_css(style = style)
  css <- gsub("(url\\(\"?)(fonts|img)", "\\1../fonts", css)
  writeLines(css, file.path(target_dir, "epub.css"))
  config <- epub_book(
    fig_caption = TRUE, number_sections = TRUE, toc = TRUE,
    stylesheet = file.path(target_dir, "epub.css"), epub_version = "epub3",
    template = inbo_rapport_template(format = "epub", lang = lang),
    pandoc_args = pandoc_args, cover_image = cover_image
  )
  config$clean_supporting <- TRUE
  return(config)
}
