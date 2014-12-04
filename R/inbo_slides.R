#' Use slides with the INBO theme
#' @param subtitle The date and place of the event
#' @param location The date and place of the event
#' @param institute The aviliation of the authors
#' @param cover The filename of the cover image
#' @param cover_offset An optional offset for the cover image
#' @param toc_name Name of the table of contents. Defaults to "Overzicht".
#' @param fontsize The fontsite of the document. Defaults to 10pt.
#' @param lang The language of the document. Defaults to "dutch"
#' @param slide_level Indicate which heading level is used for the frame titles
#' @param keep_tex Keep the tex file. Defaults to FALSE.
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg
inbo_slides <- function(subtitle, location, institute, cover, cover_offset, toc_name, fontsize, lang = "dutch", slide_level = 2, keep_tex = FALSE){
  template <- system.file("pandoc/inbo_beamer2015.tex", package = "INBOmd")
  args <- c(
    "--slide-level", as.character(slide_level),
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("lang", lang)
  )
  if(!missing(toc_name)){
    args <- c(args, pandoc_variable_arg("tocname", toc_name))
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
    knitr = knitr_options(opts_chunk = list(dev = 'pdf')),
    pandoc = pandoc_options(
      to = "beamer",
      args = args,
      keep_tex = keep_tex
    ),
    clean_supporting = !keep_tex
  )
}
