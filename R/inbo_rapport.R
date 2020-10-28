#' Create a report with the Flemish corporate identity
#' @param subtitle An optional subtitle.
#' @param reportnr The report number.
#'   Defaults to the date and time of compilation.
#' @param ordernr The optional order number.
#' @param floatbarrier Should float barriers be placed?
#'   Defaults to NA (only float barriers before starting a new chapter `#`).
#'   Options are "section" (`##`), "subsection" (`###`) and
#'   "subsubsection" (`####`).
#' @param style What template to use.
#'   Use "INBO" for an INBO report in Dutch.
#'   Use "Vlaanderen" for a report in Dutch written by more than one Flemish
#'   government agency.
#'   Use "Flanders" for a report in English.
#' @param fig_crop \code{TRUE} to automatically apply the \code{pdfcrop} utility
#'   (if available) to pdf figures.
#' @param pandoc_args Additional command line options to pass to pandoc
#' @inheritParams inbo_slides
#' @inheritParams rmarkdown::pdf_document
#' @param ... extra parameters: see details
#'
#' @details
#' Available extra parameters:
#' - `lof`: display a list of figures. Defaults to TRUE
#' - `lot`: display a list of tables. Defaults to TRUE
#' - `tocdepth`: which level headers to display.
#'     - 0: upto chapters (`#`)
#'     - 1: upto section (`##`)
#'     - 2: upto subsection (`###`)
#'     - 3: upto subsubsection (`####`) default
#' - `hyphenation`: the correct hyphenation for certain words.
#' - `cover`: an optional pdf file. The first two pages will be prepended to the
#' report.
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg includes_to_pandoc_args pandoc_version
#' @importFrom utils compareVersion
#' @family output
inbo_rapport <- function(
  subtitle,
  reportnr,
  ordernr,
  floatbarrier = c(NA, "section", "subsection", "subsubsection"),
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  style = c("INBO", "Vlaanderen", "Flanders"),
  keep_tex = FALSE,
  fig_crop = TRUE,
  includes = NULL,
  pandoc_args = NULL,
  ...
) {
  check_dependencies()
  floatbarrier <- match.arg(floatbarrier)
  style <- match.arg(style)
  extra <- list(...)
  codesize <- match.arg(codesize)

  template <- system.file("pandoc/inbo_rapport.tex", package = "INBOmd")
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")

  args <- c(
    "--template", template,
    pandoc_variable_arg("documentclass", "report"),
    pandoc_variable_arg("codesize", codesize),
    switch(
      style,
      Flanders = c(
        pandoc_variable_arg("style", "flanders_report"),
        pandoc_variable_arg("mylanguage", "french,dutch,english")
      ),
      Vlaanderen = c(
        pandoc_variable_arg("style", "vlaanderen_report"),
        pandoc_variable_arg("mylanguage", "french,english,dutch")
      ),
      INBO = c(
        pandoc_variable_arg("style", "inbo_report"),
        pandoc_variable_arg("mylanguage", "french,english,dutch")
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
      rep(missing(reportnr), 2), "", pandoc_variable_arg("reportnr", reportnr)
    ),
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
    appendix <- grep("\\\\appendix", text) #nolint
    startbib <- grep("%startbib", text)
    endbib <- grep("%endbib", text)
    if (length(appendix) & length(startbib)) {
      text <- text[
        c(
          1:(appendix - 1),              # mainmatter
          (startbib + 1):(endbib - 1),   # bibliography
          (appendix):(startbib - 1),     # appendix
          (endbib + 1):length(text)      # backmatter
        )
      ]
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
