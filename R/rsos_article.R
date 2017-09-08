#' Royal Society Open Science journal format.
#'
#' Format for creating submissions to Royal Society Open Science journals.
#'
#' @inheritParams rmarkdown::pdf_document
#' @param ... Additional arguments to \code{rmarkdown::pdf_document}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "rsos_article", package = "rticles")
#' }
#'
#' @export
rsos_article <- function(
  ...,
  citation_package = "natbib",
  pandoc_args = NULL,
  includes = NULL,
  fig_crop = TRUE
) {
  template <- system.file(
    "rmarkdown/templates/rsos_article/resources/template.tex",
    package = "INBOmd"
  )

  args <- c("--template", template, pandoc_args)

  # citations
  citation_package <- match.arg(citation_package)
  if (citation_package == "natbib") {
    args <- c(args, paste0("--", citation_package))
  }
  # content includes
  args <- c(args, includes_to_pandoc_args(includes))

  extra <- list(...)
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
  opts_chunk <- list(
    latex.options = "{}",
    dev = "pdf",
    fig.align = "center",
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

  post_processor <- function(
    metadata, input_file, output_file, clean, verbose
  ) {
    text <- readLines(output_file, warn = FALSE)

    # set correct text in fmtext environment
    end_first_page <- grep("^\\\\EndFirstPage", text) #nolint
    if (length(end_first_page)) {
      maketitle <- grep("\\\\maketitle", text) #nolint
      text <- c(
        text[1:(maketitle - 1)],
        "\\begin{fmtext}",
        text[(maketitle + 1):(end_first_page - 1)],
        "\\end{fmtext}",
        "\\maketitle",
        text[(end_first_page + 1):length(text)]
      )
    }
    writeLines(enc2utf8(text), output_file, useBytes = TRUE)
    output_file
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
      keep_tex = TRUE
    ),
    post_processor = post_processor,
    clean_supporting = FALSE
  )
}
