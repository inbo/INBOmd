#' Create a meeting report with the INBO corporate identity
#' @param present names of all persons who attended the meeting
#' @param absent names of all persons who couldn't make it
#' @param chair chair of the meeting
#' @inheritParams inbo_slides
#' @inheritParams inbo_rapport
#' @inheritParams rmarkdown::pdf_document
#' @param ... extra parameters: see details
#'
#' @details
#' Available extra parameters:
#' \itemize{
#'   \item hyphenation: the correct hyphenation for certain words
#' }
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg pandoc_version
#' @importFrom utils compareVersion
#' @family output
inbo_verslag <- function(
  present = "",
  absent = "",
  chair = "",
  floatbarrier = c(NA, "section", "subsection", "subsubsection"),
  includes = NULL,
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  lang = "dutch",
  keep_tex = FALSE,
  fig_crop = TRUE,
  pandoc_args = NULL,
  ...
) {
  check_dependencies()
  floatbarrier <- match.arg(floatbarrier)
  extra <- list(...)
  codesize <- match.arg(codesize)

  template <- system.file(
    file.path("pandoc", "inbo_verslag.tex"), package = "INBOmd"
  )
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")
  args <- c(
    "--template", template,
    pandoc_variable_arg("present", present),
    pandoc_variable_arg("absent", absent),
    pandoc_variable_arg("chair", chair),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("mylanguage", lang)
  )
  if (compareVersion(as.character(pandoc_version()), "2") < 0) {
    args <- c(args, "--latex-engine", "xelatex", pandoc_args) #nocov
  } else {
    args <- c(args, "--pdf-engine", "xelatex", pandoc_args)
  }
  # citations
  args <- c(args, "--csl", pandoc_path_arg(csl))
  # content includes
  args <- c(args, includes_to_pandoc_args(includes))
  if (length(extra) > 0) {
    args <- c(
      args,
      sapply(
        names(extra),
        function(x) {
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
    dev = "pdf",
    dpi = 300,
    fig.width = 4.5,
    fig.height = 2.9
  )
  crop <- fig_crop &&
    !identical(.Platform$OS.type, "windows") &&
    nzchar(Sys.which("pdfcrop"))
  if (crop) {
    knit_hooks <- list(crop = knitr::hook_pdfcrop)
    opts_chunk$crop <- TRUE
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
