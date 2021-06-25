#' pdf slides with an INBO or Flanders theme
#'
#' Returns an output format for [bookdown::render_book()].
#'
#' @param toc display a table of content after the title slide
#' @param ... currently ignored
#' @template yaml_generic
#' @template yaml_slide
#' @export
#' @importFrom bookdown pdf_book
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg pandoc_path_arg pandoc_version
#' @importFrom utils compareVersion
#' @importFrom assertthat assert_that is.string is.flag noNA
#' @family output
inbo_slides <- function(toc = TRUE, ...) {
  check_dependencies()
  dots <- list(...)
  assert_that(
    !has_name(dots, "number_sections"), msg =
"`number_sections` detected. Are you still using 'INBOmd::inbo_slides' as
`output_format` of `bookdown::pdf_book`?"
  )
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")
  template <- system.file(
    file.path("pandoc", "inbo_beamer.tex"), package = "INBOmd"
  )
  fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
  aspect <- ifelse(has_name(fm, "aspect"), fm$aspect, "16:9")
  assert_that(is.string(aspect))
  paper_dimensions <- rbind(
    "16:9" = c(160, 90), "16:10" = c(160, 100), "14:9" = c(140, 90),
    "1.4:1" = c(148.5, 105), "5:4" = c(125, 100), "4:3" = c(128, 96),
    "3:2" = c(135, 90)
  )
  assert_that(
    aspect %in% rownames(paper_dimensions),
    msg = paste(
      "available `aspect` ratios are:",
      paste(rownames(paper_dimensions), collapse = ", ")
    )
  )
  current_paperwidth <- paper_dimensions[aspect, 1]
  current_paperheight <- paper_dimensions[aspect, 2]
  aspect <- gsub("(:|\\.)", "", aspect)
  style <- ifelse(has_name(fm, "style"), fm$style, "INBO")
  assert_that(length(style) == 1)
  assert_that(
    style %in% c("INBO", "Vlaanderen", "Flanders"),
    msg = "`style` must be one of 'INBO', 'Vlaanderen' or 'Flanders'"
  )
  if (style == "Vlaanderen") {
    warning("Currently we have only the English logo's values for this style.
Please contact the maintainer when you require Dutch logo's.")
  }
  lang <- ifelse(
    has_name(fm, "lang"), fm$lang, ifelse(style == "Flanders", "en", "nl")
  )
  available_languages <- c(nl = "dutch", en = "english", fr = "french")
  assert_that(is.string(lang))
  assert_that(
    lang %in% names(available_languages),
    msg = paste(
      "lang must be one of:", paste(names(available_languages), collapse = ", ")
    )
  )
  slide_level <- ifelse(
    has_name(fm, "slide_level"), fm$slide_level, 2
  )
  theme <- ifelse(
    style == "INBO", ifelse(lang == "nl", "inbo", "inboenglish"), "vlaanderen"
  )
  args <- c(
    "--slide-level", as.character(slide_level),
    "--template", template,
    pandoc_variable_arg("mylanguage", available_languages[lang]),
    pandoc_variable_arg("aspect", aspect),
    pandoc_variable_arg("theme", theme)
  )
  args <- c(
    args,
    ifelse(
      compareVersion(as.character(pandoc_version()), "2") < 0,
      "--latex-engine",
      "--pdf-engine"
    ),
    "xelatex"
  )
  toc <- ifelse(has_name(fm, "toc"), as.logical(fm$toc), toc)
  assert_that(is.flag(toc))
  assert_that(noNA(toc))
  if (toc) {
    args <- c(args, pandoc_variable_arg("toc", "true"))
  }
  # citations
  args <- c(args, "--csl", pandoc_path_arg(csl))
  of <- output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 80,
        concordance = TRUE
      ),
      opts_chunk = list(
        dev = "pdf",
        dev.args = list(bg = "transparent"),
        dpi = 300,
        fig.width = (current_paperwidth - 13) / 25.4,
        fig.height = (current_paperheight - 28) / 25.4
      )
    ),
    pandoc = pandoc_options(
      to = "beamer",
      latex_engine = "xelatex",
      args = args,
      keep_tex = FALSE
    ),
    clean_supporting = TRUE
  )
  config <- pdf_book(
    toc = toc, number_sections = TRUE, fig_caption = TRUE,
    base_format = function(...) {
      of
    }
  )
  return(config)
}
