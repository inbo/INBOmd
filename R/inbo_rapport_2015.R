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
#'   \item dankwoord: path to LaTeX file with dankwoord
#'   \item voorwoord: path to LaTeX file with voorwoord
#'   \item samenvatting: path to LaTeX file with samenvatting
#'   \item abstract: path to LaTeX file with english abstract
#'   \item appendix: path to LaTeX file with appendices
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
  output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 60,
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
    clean_supporting = !keep_tex
  )
}
