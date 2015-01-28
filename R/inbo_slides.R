#' Use slides with the INBO theme
#' @param subtitle The date and place of the event
#' @param location The date and place of the event
#' @param institute The aviliation of the authors
#' @param cover The filename of the cover image
#' @param cover_offset An optional offset for the cover image
#' @param toc_name Name of the table of contents. Defaults to "Overzicht".
#' @param fontsize The fontsite of the document. Defaults to 10pt.
#' @param codesize The fontsize of the code, relative to the fontsize of the text (= normal size). Allowed values are "normalsize", "small", "footnotesize", "scriptsize" and  "tiny". Defaults to "footnotesize".
#' @param natbib The bibliography file for natbib
#' @param natbib_title The title of the bibliography
#' @param natbib_style The style of the bibliography
#' @param lang The language of the document. Defaults to "dutch"
#' @param slide_level Indicate which heading level is used for the frame titles
#' @param keep_tex Keep the tex file. Defaults to FALSE.
#' @param ... extra parameters
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg pandoc_path_arg
inbo_slides <- function(subtitle, location, institute, cover, cover_offset, toc_name, fontsize, codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"), natbib, natbib_title, natbib_style, lang = "dutch", slide_level = 2, keep_tex = FALSE, ...){
  extra <- list(...)
  codesize <- match.arg(codesize)
  csl <- system.file("inbo.csl", package = "INBOmd")
  template <- system.file("pandoc/inbo_beamer2015.tex", package = "INBOmd")
  args <- c(
    "--slide-level", as.character(slide_level),
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("lang", lang),
    pandoc_variable_arg("codesize", codesize)
  )
  if("usepackage" %in%names(extra)){
    tmp <- sapply(
      extra$usepackage,
      pandoc_variable_arg,
      name = "usepackage"
    )
    args <- c(args, tmp)
  }
  if(!missing(toc_name)){
    args <- c(args, pandoc_variable_arg("tocname", toc_name))
  }
  if(!missing(natbib)){
    args <- c(args, "--natbib", pandoc_variable_arg("natbibfile", natbib))
  } else {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  }
  if(!missing(natbib_title)){
    args <- c(args, pandoc_variable_arg("natbibtitle", natbib_title))
  }
  if(!missing(natbib_style)){
    args <- c(args, pandoc_variable_arg("natbibstyle", natbib_style))
  }
  if(!missing(subtitle)){
    args <- c(args, pandoc_variable_arg("subtitle", subtitle))
  }
  if(!missing(location)){
    args <- c(args, pandoc_variable_arg("location", location))
  }
  if(!missing(fontsize)){
    args <- c(args, pandoc_variable_arg("fontsize", fontsize))
  }
  if(!missing(institute)){
    args <- c(args, pandoc_variable_arg("institute", institute))
  }
  if(!missing(cover)){
    args <- c(args, pandoc_variable_arg("cover", cover))
  }
  if(!missing(cover_offset)){
    args <- c(args, pandoc_variable_arg("coveroffset", cover_offset))
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
        fig.height = 2.9
      )
    ),
    pandoc = pandoc_options(
      to = "beamer",
      args = args,
      keep_tex = keep_tex | !missing(natbib)
    ),
    clean_supporting = !keep_tex
  )
}
