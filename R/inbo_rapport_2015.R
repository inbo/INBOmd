#' Create a report with the INBO theme version 2015
#' @param subtitle An optional subtitle
#' @param reportnr The report number
#' @param ordernr The order number
#' @param floatbarrier Should float barriers be placed? Defaults to NA (no extra float barriers). Options are "section", "subsection" and "subsubsection".
#' @param lang The language of the document. Defaults to "dutch"
#' @param fig_crop \code{TRUE} to automatically apply the \code{pdfcrop} utility
#'   (if available) to pdf figures
#' @param pandoc_args Additional command line options to pass to pandoc
#' @inheritParams inbo_slides
#' @param ... extra parameters: see details
#'
#' @details
#' Available extra parameters:
#' \itemize{
#'   \item lof: display a list of figures. Defaults to TRUE
#'   \item lot: display a list of tables. Defaults to TRUE
#'   \item hyphenation: the correct hyphenation for certain words
#' }
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg includes_to_pandoc_args
inbo_rapport_2015 <- function(
  subtitle,
  reportnr,
  ordernr,
  floatbarrier = c(NA, "section", "subsection", "subsubsection"),
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  lang = "dutch",
  keep_tex = FALSE,
  fig_crop = TRUE,
  citation_package = c("natbib", "none"),
  includes = NULL,
  pandoc_args = NULL,
  ...
){
  check_dependencies()
  floatbarrier <- match.arg(floatbarrier)
  extra <- list(...)
  codesize <- match.arg(codesize)

  template <- system.file("pandoc/inbo_rapport.tex", package = "INBOmd")
  csl <- system.file("inbo.csl", package = "INBOmd")
  args <- c(
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("documentclass", "report"),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("lang", lang)
  )
  args <- c(args, pandoc_args)

  # citations
  citation_package <- match.arg(citation_package)
  if (citation_package == "none") {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  } else {
    args <- c(args, paste0("--", citation_package))
  }
  # content includes
  args <- c(args, includes_to_pandoc_args(includes))

  if (!missing(reportnr)) {
    args <- c(args, pandoc_variable_arg("reportnr", reportnr))
  }
  if (!missing(ordernr)) {
    args <- c(args, pandoc_variable_arg("ordernr", ordernr))
  }
  if (!missing(subtitle)) {
    args <- c(args, pandoc_variable_arg("subtitle", subtitle))
  }
  if (!"lof" %in% names(extra)) {
    extra$lof <- TRUE
  }
  if (!"lot" %in% names(extra)) {
    extra$lot <- TRUE
  }
  if (extra$lof) {
    args <- c(args, pandoc_variable_arg("lof", TRUE))
  }
  if (extra$lot) {
    args <- c(args, pandoc_variable_arg("lot", TRUE))
  }
  if (extra$lof || extra$lot) {
    args <- c(args, pandoc_variable_arg("loft", TRUE))
  }
  extra <- extra[!names(extra) %in% c("lof", "lot")]
  if (length(extra) > 0) {
    args <- c(
      args,
      sapply(
        names(extra),
        function(x){
          pandoc_variable_arg(x, extra[[x]])
        }
      )
    )
  }
  if (!is.na(floatbarrier)) {
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
  }
  opts_chunk <- list(
    latex.options = "{}",
    dev = 'pdf',
    fig.align = "center",
    dpi = 300,
    fig.width = 4.5,
    fig.height = 2.9
  )
  crop <- fig_crop &&
    !identical(.Platform$OS.type, "windows") &&
    nzchar(Sys.which("pdfcrop"))
  if (crop) {
    knit_hooks = list(crop = knitr::hook_pdfcrop)
    opts_chunk$crop = TRUE
  } else {
    knit_hooks <- NULL
  }

  post_processor <- function(metadata, input, output, clean, verbose) {
    text <- readLines(output, warn = FALSE)

    # move frontmatter before toc
    mainmatter <- grep("\\\\mainmatter", text)
    if (length(mainmatter)) {
      starttoc <- grep("%starttoc", text)
      endtoc <- grep("%endtoc", text)
      new.order <- c(
        1:(starttoc - 1),              # preamble
        (endtoc + 1):(mainmatter - 1), # frontmatter
        (starttoc + 1):(endtoc - 1),   # toc
        (mainmatter + 1):length(text)  # mainmatter
      )
      text <- text[new.order]
    }

    # move appendix after bibliography
    appendix <- grep("\\\\appendix", text)
    startbib <- grep("%startbib", text)
    endbib <- grep("%endbib", text)
    if (length(appendix) & length(startbib)) {
      new.order <- c(
        1:(appendix - 1),              # mainmatter
        (startbib + 1):(endbib - 1),   # bibliography
        (appendix):(startbib - 1),     # appendix
        (endbib + 1):length(text)      # backmatter
      )
      text <- text[new.order]
    }

    writeLines(enc2utf8(text), output, useBytes = TRUE)
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
