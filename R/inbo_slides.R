#' Use slides with the INBO theme
#' @param subtitle The date and place of the event
#' @param location The date and place of the event
#' @param institute The aviliation of the authors
#' @param cover The filename of the cover image
#' @param cover_offset An optional vertical offset for the cover image
#' @param cover_hoffset An optional horizontal offset for the cover image
#' @param cover_horizontal Scale the cover horizontal (TRUE) or vertical (FALSE)
#' @param toc_name Name of the table of contents. Defaults to "Overzicht".
#' @param fontsize The fontsite of the document. Defaults to 10pt.
#' @param codesize The fontsize of the code, relative to the fontsize of the text (= normal size). Allowed values are "normalsize", "small", "footnotesize", "scriptsize" and  "tiny". Defaults to "footnotesize".
#' @param natbib The bibliography file for natbib
#' @param natbib_title The title of the bibliography
#' @param natbib_style The style of the bibliography
#' @param lang The language of the document. Defaults to "dutch"
#' @param slide_level Indicate which heading level is used for the frame titles
#' @param keep_tex Keep the tex file. Defaults to FALSE.
#' @param toc display a table of content after the title slide
#' @param website An optional URL to display on the left sidebar. Defaults to www.INBO.be.
#' @param theme The theme to use. Available options are "inbo" and "vlaanderen"
#' @param flandersfont If TRUE use the Flanders Art font. If FALSE use Calibri. Defaults to FALSE.
#' @param ... extra parameters
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg pandoc_path_arg
#' @importFrom assertthat assert_that is.string is.flag noNA
inbo_slides <- function(
  subtitle,
  location,
  institute,
  cover,
  cover_offset,
  cover_hoffset,
  cover_horizontal = TRUE,
  toc_name,
  fontsize,
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  natbib,
  natbib_title,
  natbib_style,
  lang = "dutch",
  slide_level = 2,
  keep_tex = FALSE,
  toc = TRUE,
  website = "www.INBO.be",
  theme = c("inbo", "vlaanderen"),
  flandersfont = FALSE,
  ...
){
  check_dependencies()
  assert_that(is.flag(toc))
  assert_that(noNA(toc))
  assert_that(is.string(website))
  theme <- match.arg(theme)
  assert_that(is.flag(flandersfont))
  assert_that(noNA(flandersfont))

  extra <- list(...)
  codesize <- match.arg(codesize)
  csl <- system.file("inbo.csl", package = "INBOmd")
  template <- system.file("pandoc/inbo_beamer.tex", package = "INBOmd")
  args <- c(
    "--slide-level", as.character(slide_level),
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("lang", lang),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("website", website),
    pandoc_variable_arg("flandersfont", flandersfont),
    pandoc_variable_arg("theme", theme)
  )
  if ( "usepackage" %in% names(extra)) {
    tmp <- sapply(
      extra$usepackage,
      pandoc_variable_arg,
      name = "usepackage"
    )
    args <- c(args, tmp)
  }
  if (toc) {
    args <- c(args, pandoc_variable_arg("toc", "true"))
    if (!missing(toc_name)) {
      args <- c(args, pandoc_variable_arg("toc_name", toc_name))
    }
  }
  if (!missing(natbib)) {
    assert_that(is.string(natbib))
    args <- c(args, "--natbib", pandoc_variable_arg("natbibfile", natbib))
  } else {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  }
  if (!missing(natbib_title)) {
    assert_that(is.string(natbib_title))
    args <- c(args, pandoc_variable_arg("natbibtitle", natbib_title))
  }
  if (!missing(natbib_style)) {
    assert_that(is.string(natbib_style))
    args <- c(args, pandoc_variable_arg("natbibstyle", natbib_style))
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
      assert_that(noNA(cover_horizontal))
      args <- c(args, pandoc_variable_arg("coverhorizontal", cover_horizontal))
    }
  }
  output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 60,
        concordance = TRUE
      ),
      opts_chunk = list(
        dev = 'pdf',
        dev.args = list(bg = 'transparent'),
        dpi = 300,
        fig.width = 4.5,
        fig.height = 2.8
      )
    ),
    pandoc = pandoc_options(
      to = "beamer",
      latex_engine = "xelatex",
      args = args,
      keep_tex = keep_tex | !missing(natbib)
    ),
    clean_supporting = !keep_tex
  )
}
