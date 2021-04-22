#' Create a report with the Flemish corporate identity
#' @param subtitle An optional subtitle.
#' @param ordernr The optional order number.
#' @param floatbarrier Should float barriers be placed?
#'   Defaults to NA (only float barriers before starting a new chapter `#`).
#'   Options are "section" (`##`), "subsection" (`###`) and
#'   "subsubsection" (`####`).
#' @param style What template to use.
#'   Use `"INBO"` for an INBO report in Dutch.
#'   Use `"Vlaanderen"` for a report in Dutch written by more than one Flemish
#'   government agency.
#'   Use `"Flanders"` for a report in another language.
#' @param fig_crop \code{TRUE} to automatically apply the \code{pdfcrop} utility
#'   (if available) to pdf figures.
#' @param pandoc_args Additional command line options to pass to pandoc
#' @param main_language The main language of the document.
#' Defaults to `"english"`.
#' See the details for more information.
#' @param other_languages A vector of other languages you want to use within the
#' document.
#' Defaults to `c("dutch", "french")`.
#' See the details for more information.
#' @inheritParams inbo_slides
#' @inheritParams rmarkdown::pdf_document
#' @param ... extra parameters: see details
#'
#' @details
#' Available extra parameters:
#' - `lof`: display a list of figures.
#' Defaults to `FALSE`.
#' - `lot`: display a list of tables.
#' Defaults to `FALSE`.
#' - `tocdepth`: which level headers to display.
#'     - 0: up to chapters (`#`)
#'     - 1: up to section (`##`)
#'     - 2: up to subsection (`###`)
#'     - 3: up to subsubsection (`####`) default
#' - `hyphenation`: the correct hyphenation for certain words.
#' - `cover`: an optional pdf file.
#' The first two pages will be prepended to the report.
#'
#' # Language
#'
#' The main language is hard-coded to Dutch for the styles `INBO` and
#' `Vlaanderen`.
#' It is set by default to English for the style `Flanders` and can be set to
#' another language by setting `main_language` in the YAML header.
#'
#' You can define some parts of the text to be in different language than the
#' main language (e.g. an abstract in a different language).
#' This is currently limited to Dutch, English and French.
#' Use `\bdutch` before and `\edutch` after the text in Dutch.
#' Use `\benglish` before and `\eenglish` after the text in English.
#' Use `\bfrench` before and `\efrench` after the text in French.
#' The styles `INBO` and `Vlaanderen` have French and English as optional
#' languages.
#' The `Flanders` has by default Dutch and French as optional languages.
#'
#' Setting the language affects the hyphenation pattern and the names of items
#' like figures, tables, table of contents, list of figures, list of tables,
#' references, page numbers, ...
#' @export
#' @importFrom assertthat assert_that is.string
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg includes_to_pandoc_args pandoc_version
#' @importFrom utils compareVersion
#' @family output
inbo_rapport <- function(
  subtitle,
  ordernr,
  floatbarrier = c(NA, "section", "subsection", "subsubsection"),
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  style = c("INBO", "Vlaanderen", "Flanders"),
  main_language = "english",
  other_languages = c("french", "dutch"),
  keep_tex = FALSE,
  fig_crop = TRUE,
  includes = NULL,
  pandoc_args = NULL,
  flandersfont = FALSE,
  ...
) {
  assert_that(is.string(main_language))
  assert_that(is.character(other_languages))
  assert_that(
    all(other_languages %in% c("french", "dutch", "english")),
    msg = "other_languages can only contain french, dutch and english"
  )
  check_dependencies()
  floatbarrier <- match.arg(floatbarrier)
  style <- match.arg(style)
  extra <- list(...)
  codesize <- match.arg(codesize)

  template <- system.file(
    file.path("pandoc", "inbo_rapport.tex"), package = "INBOmd"
  )
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")

  args <- c(
    "--template", template,
    pandoc_variable_arg("documentclass", "report"),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("flandersfont", flandersfont),
    switch(
      style,
      Flanders = c(
        pandoc_variable_arg("style", "flanders_report"),
        pandoc_variable_arg(
          "babel", paste(c(other_languages, main_language), collapse = ",")
        ),
        pandoc_variable_arg("lang", "en")
      ),
      Vlaanderen = c(
        pandoc_variable_arg("style", "vlaanderen_report"),
        pandoc_variable_arg("babel", "french,english,dutch"),
        pandoc_variable_arg("lang", "nl")
      ),
      INBO = c(
        pandoc_variable_arg("style", "inbo_report"),
        pandoc_variable_arg("babel", "french,english,dutch"),
        pandoc_variable_arg("lang", "nl")
      )
    ),
    ifelse(
      compareVersion(as.character(pandoc_version()), "2") < 0,
      "--latex-engine",
      "--pdf-engine"
    ),
    "xelatex", pandoc_args,
    # citations
    c("--csl", pandoc_path_arg(csl)),
    # content includes
    includes_to_pandoc_args(includes),
    ifelse(
      rep(missing(ordernr), 2), "", pandoc_variable_arg("ordernr", ordernr)
    ),
    ifelse(
      rep(missing(subtitle), 2), "", pandoc_variable_arg("subtitle", subtitle)
    )
  )
  args <- args[args != ""]

  if ("lof" %in% names(extra) && extra$lof) {
    args <- c(args, pandoc_variable_arg("lof", TRUE))
  }
  if ("lot" %in% names(extra) && extra$lot) {
    args <- c(args, pandoc_variable_arg("lot", TRUE))
  }
  extra <- extra[!names(extra) %in% c("lof", "lot")]
  args <- c(
    args,
    sapply(
      names(extra),
      function(x) {
        pandoc_variable_arg(x, extra[[x]])
      }
    )
  )
  vars <- switch(
    floatbarrier,
    section = "",
    subsection = c("", "sub"),
    subsubsection = c("", "sub", "subsub")
  )
  floating <- lapply(
    sprintf("floatbarrier%ssection", vars),
    pandoc_variable_arg,
    value = TRUE
  )
  args <- c(args, unlist(floating))
  opts_chunk <- list(
    latex.options = "{}",
    dev = "cairo_pdf",
    fig.align = "center",
    dpi = 300,
    fig.width = 4.5,
    fig.height = 2.9
  )
  knit_hooks <- NULL
  crop <- fig_crop &&
    !identical(.Platform$OS.type, "windows") &&
    nzchar(Sys.which("pdfcrop"))
  if (crop) {
    knit_hooks <- list(crop = knitr::hook_pdfcrop)
    opts_chunk$crop <- TRUE
  }

  post_processor <- function(metadata, input, output, clean, verbose) {
    text <- readLines(output, warn = FALSE)
    cover_info(gsub("\\.tex$", ".Rmd", output, ignore.case = TRUE))

    # move frontmatter before toc
    mainmatter <- grep("\\\\mainmatter", text) #nolint
    if (length(mainmatter)) {
      starttoc <- grep("%starttoc", text)
      endtoc <- grep("%endtoc", text)
      text <- text[
        c(
          1:(starttoc - 1),              # preamble
          (endtoc + 1):(mainmatter - 1), # frontmatter
          (starttoc + 1):(endtoc - 1),   # toc
          (mainmatter + 1):length(text)  # mainmatter
        )
      ]
    }

    # move appendix after bibliography
    appendix <- grep("\\\\appendix", text) # nolint
    startbib <- grep("\\\\hypertarget\\{refs\\}\\{\\}", text) # nolint
    if (length(startbib)) {
      if (length(appendix)) {
        text <- c(
          text[1:(appendix - 1)],              # mainmatter
          "\\chapter*{\\bibname}",
          "\\addcontentsline{toc}{chapter}{\\bibname}",
          text[startbib],                      # bibliography
          "",
          text[startbib + 1],
          "",
          text[(startbib + 2):(length(text) - 1)],
          text[(appendix):(startbib - 1)],     # appendix
          text[length(text)]                   # backmatter
        )
      } else {
        text <- c(
          text[1:(startbib - 1)],              # mainmatter
          "\\chapter*{\\bibname}",
          "\\addcontentsline{toc}{chapter}{\\bibname}",
          text[startbib],                      # bibliography
          "",
          text[startbib + 1],
          "",
          text[(startbib + 2):length(text)]
        )
      }
    }

    writeLines(enc2utf8(text), output, useBytes = FALSE)
    output
  }
  output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 96,
        concordance = TRUE
      ),
      opts_chunk = opts_chunk,
      knit_hooks = knit_hooks
    ),
    pandoc = pandoc_options(
      to = "latex",
      latex_engine = "xelatex",
      args = args,
      keep_tex = keep_tex
    ),
    post_processor = post_processor,
    clean_supporting = !keep_tex
  )
}
