#' Use slides with the INBO theme
#' @param subtitle The subtitle.
#' @param location The date and place of the event.
#' @param institute The affiliation of the authors.
#' @param cover The filename of the cover image.
#' @param cover_offset An optional vertical offset for the cover image.
#' @param cover_hoffset An optional horizontal offset for the cover image.
#' @param cover_horizontal Scale the cover horizontal (`TRUE`) or vertical
#' (`FALSE`).
#' @param toc_name Name of the table of contents.
#' Defaults to `"Overzicht"`.
#' @param fontsize The fontsize of the document.
#' Defaults to `"10pt"`.
#' See the section on aspect ratio.
#' @param codesize The fontsize of the code, relative to the fontsize of the
#' text (= normal size).
#' Allowed values are `"normalsize"`, `"small"`, `"footnotesize"`,
#' `"scriptsize"` and `"tiny"`.
#' Defaults to `"footnotesize"`.
#' @param natbib_title The title of the bibliography
#' @param lang The language of the document.
#' Defaults to `"dutch"`
#' @param slide_level Indicate which heading level is used for the frame titles
#' @param keep_tex Keep the tex file.
#' Defaults to `FALSE`.
#' @param toc display a table of content after the title slide
#' @param website An optional URL to display on the left sidebar.
#' Defaults to `"www.INBO.be"`.
#' @param theme The theme to use.
#' Available options are `"inbo"`, `"inboenglish"` and `"vlaanderen"`.
#' @param flandersfont If `TRUE` use the Flanders Art font.
#' If `FALSE` use Calibri.
#' Defaults to `FALSE`.
#' @param aspect Defines the aspect ratio and the format of the slides.
#' Defaults to `"16:9"`.
#' See the section.
#' @param slide_logo the path to an optional logo displayed on each slide
#' @param ... extra parameters
#' @details
#' Aspect ratio
#'
#' The table below lists the available aspect ratios and their "paper size".
#' The main advantage of using a small “paper size” is that you can use all your
#' normal fonts at their natural sizes.
#'
#' | aspect | ratio | width | height |
#' | :----: | ----------: | ----: | -----: |
#' | 16:9 | 1.78 | 160.0 mm | 90 mm |
#' | 16:10 | 1.60 | 160.0 mm | 100 mm |
#' | 14:9 | 1.56| 140.0 mm | 90 mm |
#' | 3:2 | 1.50 | 135.0 mm | 90 mm |
#' | 1.4:1 | 1.41| 148.5 mm |105 mm |
#' | 4:3 | 1.33 | 128.0 mm | 96 mm |
#' | 5:4 | 1.25 | 125.0 mm | 100 mm |
#' @inheritParams rmarkdown::pdf_document
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg pandoc_path_arg pandoc_version
#' @importFrom utils compareVersion
#' @importFrom assertthat assert_that is.string is.flag noNA
#' @family output
inbo_slides <- function(
  subtitle,
  location,
  institute,
  cover,
  cover_offset,
  cover_hoffset,
  cover_horizontal = TRUE,
  slide_logo,
  toc_name,
  fontsize,
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  citation_package = c("natbib", "none"),
  natbib_title,
  lang = "dutch",
  slide_level = 2,
  keep_tex = FALSE,
  toc = TRUE,
  website = "www.INBO.be",
  theme = c("inbo", "vlaanderen", "inboenglish"),
  flandersfont = FALSE,
  aspect = c("16:9", "16:10", "14:9", "1.4:1", "5:4", "4:3", "3:2"),
  ...
) {
  check_dependencies()
  assert_that(is.flag(toc))
  assert_that(noNA(toc)) #nolint
  assert_that(is.string(website))
  theme <- match.arg(theme)
  assert_that(is.flag(flandersfont))
  assert_that(noNA(flandersfont)) #nolint
  aspect <- match.arg(aspect)
  current_paperwidth <- c(
    "16:9" = 160, "16:10" = 160, "14:9" = 140, "1.4:1" = 148.5, "5:4" = 125,
    "4:3" = 128, "3:2" = 135
  )[aspect]
  current_paperheight <- c(
    "16:9" = 90, "16:10" = 100, "14:9" = 90, "1.4:1" = 105, "5:4" = 100,
    "4:3" = 96, "3:2" = 90
  )[aspect]
  aspect <- gsub("(:|\\.)", "", aspect)

  codesize <- match.arg(codesize)
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")
  template <- system.file("pandoc/inbo_beamer.tex", package = "INBOmd")
  args <- c(
    "--slide-level", as.character(slide_level),
    "--template", template,
    pandoc_variable_arg("mylanguage", lang),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("website", website),
    pandoc_variable_arg("flandersfont", flandersfont),
    pandoc_variable_arg("aspect", aspect),
    pandoc_variable_arg("theme", theme)
  )
  if (compareVersion(as.character(pandoc_version()), "2") < 0) {
    args <- c(args, "--latex-engine", "xelatex") #nocov
  } else {
    args <- c(args, "--pdf-engine", "xelatex")
  }
  if (toc) {
    args <- c(args, pandoc_variable_arg("toc", "true"))
    if (!missing(toc_name)) {
      args <- c(args, pandoc_variable_arg("toc_name", toc_name))
    }
  }
  # citations
  citation_package <- match.arg(citation_package)
  if (citation_package == "none") {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  } else {
    args <- c(args, paste0("--", citation_package))
  }
  if (!missing(natbib_title)) {
    assert_that(is.string(natbib_title))
    args <- c(args, pandoc_variable_arg("natbibtitle", natbib_title))
  }
  if (!missing(subtitle)) {
    assert_that(is.string(subtitle))
    args <- c(args, pandoc_variable_arg("subtitle", subtitle))
  }
  if (!missing(location)) {
    assert_that(is.string(location))
    args <- c(args, pandoc_variable_arg("location", location))
  }
  if (!missing(fontsize)) {
    assert_that(is.string(fontsize))
    args <- c(args, pandoc_variable_arg("fontsize", fontsize))
  }
  if (!missing(institute)) {
    assert_that(is.string(institute))
    args <- c(args, pandoc_variable_arg("institute", institute))
  }
  if (!missing(cover)) {
    assert_that(is.string(cover))
    args <- c(args, pandoc_variable_arg("cover", cover))
    if (!missing(cover_offset)) {
      assert_that(is.string(cover_offset))
      args <- c(args, pandoc_variable_arg("coveroffset", cover_offset))
    }
    if (!missing(cover_hoffset)) {
      assert_that(is.string(cover_hoffset))
      args <- c(args, pandoc_variable_arg("coverhoffset", cover_hoffset))
    }
    if (!missing(cover_horizontal)) {
      assert_that(is.flag(cover_horizontal))
      assert_that(noNA(cover_horizontal)) #nolint
      args <- c(args, pandoc_variable_arg("coverhorizontal", cover_horizontal))
    }
  }
  if (!missing(slide_logo)) {
    assert_that(is.string(slide_logo))
    args <- c(args, pandoc_variable_arg("slidelogo", slide_logo))
  }
  output_format(
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
      keep_tex = keep_tex
    ),
    clean_supporting = !keep_tex
  )
}
