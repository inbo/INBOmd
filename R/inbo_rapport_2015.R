#' Create a report with the INBO theme version 2015
#' @param subtitle An optional subtitle
#' @param reportnr The report number
#' @param ordernr The order number
#' @param floatbarrier Should float barriers be placed? Defaults to NA (no extra float barriers). Options are "section", "subsection" and "subsubsection".
#' @param natbib The bibliography file for natbib
#' @param lang The language of the document. Defaults to "dutch"
#' @param keep_tex Keep the tex file. Defaults to FALSE.
#' @param ... extra parameters: see details
#'
#' @details
#' Available extra parameters:
#' \itemize{
#'   \item hyphenation: the correct hyphenation for certain words
#'   \item dankwoord: path to LaTeX file with dankwoord
#'   \item voorwoord: path to LaTeX file with voorwoord
#'   \item samenvatting: path to LaTeX file with samenvatting
#'   \item abstract: path to LaTeX file with english abstract
#'   \item appendix: path to LaTeX file with appendices
#' }
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg
inbo_rapport_2015 <- function(
  subtitle,
  reportnr,
  ordernr,
  floatbarrier = c(NA, "section", "subsection", "subsubsection"),
  natbib,
  lang = "dutch",
  keep_tex = FALSE,
  ...
){
  floatbarrier <- match.arg(floatbarrier)
  extra <- list(...)

  template <- system.file("pandoc/inbo_rapport_2015.tex", package = "INBOmd")
  csl <- system.file("inbo.csl", package = "INBOmd")
  args <- c(
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("documentclass", "report"),
    pandoc_variable_arg("lang", lang)
  )
  if (!missing(natbib)) {
    args <- c(args, "--natbib", pandoc_variable_arg("natbibfile", natbib))
  } else {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  }
  if ("usepackage" %in% names(extra)) {
    tmp <- sapply(
      extra$usepackage,
      pandoc_variable_arg,
      name = "usepackage"
    )
    args <- c(args, tmp)
    extra <- extra[!names(extra) %in% "usepackage"]
  }
  if (!missing(reportnr)) {
    args <- c(args, pandoc_variable_arg("reportnr", reportnr))
  }
  if (!missing(ordernr)) {
    args <- c(args, pandoc_variable_arg("ordernr", ordernr))
  }
  if (!missing(subtitle)) {
    args <- c(args, pandoc_variable_arg("subtitle", subtitle))
  }
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
  output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 60,
        concordance = TRUE
      ),
      opts_chunk = list(
        dev = 'pdf',
        dpi = 300,
        fig.width = 4.5,
        fig.height = 2.9
      )
    ),
    pandoc = pandoc_options(
      to = "latex",
      args = args,
      keep_tex = keep_tex | !missing(natbib)
    ),
    clean_supporting = !keep_tex
  )
}
