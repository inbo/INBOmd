#' Create a report with the INBO theme
#' @param subtitle An optional subtitle
#' @param reportnr The report number
#' @param ordernr The order number
#' @param year The year of publication
#' @param email The email of the corresponding author
#' @param shortauthor The abbreviation of the authors
#' @param office The office of the main author. Defaults to "Anderlecht"
#' @param client The name of the client
#' @param storagenr The storage number of the report
#' @param cover The filename of the cover image
#' @param cover_offset An optional offset for the cover image
#' @param cover_text A description of the cover image
#' @param natbib The bibliography file for natbib
#' @param floatbarrier Should float barriers be placed? Defaults to NA (no extra float barriers). Options are "section", "subsection" and "subsubsection".
#' @param lang The language of the document. Defaults to "dutch"
#' @param keep_tex Keep the tex file. Defaults to FALSE.
#' @param ... extra parameters
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg
inbo_rapport <- function(
  subtitle, reportnr, ordernr, year,
  email, shortauthor, office = c("Anderlecht", "Geraardsbergen"),
  client, storagenr,
  cover, cover_offset, cover_text, 
  natbib, 
  floatbarrier = c(NA, "section", "subsection", "subsubsection"), 
  lang = "dutch", keep_tex = FALSE, 
  ...
){
  floatbarrier <- match.arg(floatbarrier)
  office <- match.arg(office)
  extra <- list(...)
  
  template <- system.file("pandoc/inbo_rapport.tex", package = "INBOmd")
  csl <- system.file("inbo.csl", package = "INBOmd")
  args <- c(
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("documentclass", "report"),
    pandoc_variable_arg("lang", lang)
  )
  if(!missing(natbib)){
    args <- c(args, "--natbib", pandoc_variable_arg("natbibfile", natbib))
  } else {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  }
  if("usepackage" %in%names(extra)){
    tmp <- sapply(
      extra$usepackage,
      pandoc_variable_arg,
      name = "usepackage"
    )
    args <- c(args, tmp)
  }
  if(!missing(shortauthor)){
    args <- c(args, pandoc_variable_arg("auteurkort", shortauthor))
  }
  if(!missing(email)){
    args <- c(args, pandoc_variable_arg("email", email))
  }
  if(!missing(office)){
    args <- c(args, pandoc_variable_arg("vestiging", office))
  }
  if(!missing(client)){
    args <- c(args, pandoc_variable_arg("opdrachtgever", client))
  }
  if(!missing(storagenr)){
    args <- c(args, pandoc_variable_arg("depotnr", storagenr))
  }
  if(!missing(cover)){
    args <- c(args, pandoc_variable_arg("cover", cover))
  }
  if(!missing(cover_offset)){
    args <- c(args, pandoc_variable_arg("coveroffset", cover_offset))
  }
  if(!missing(cover_text)){
    args <- c(args, pandoc_variable_arg("covertekst", cover_text))
  }
  if(!missing(reportnr)){
    args <- c(args, pandoc_variable_arg("rapportnummer", reportnr))
  }
  if(!missing(reportnr)){
    args <- c(args, pandoc_variable_arg("jaar", year))
  }
  if(!missing(ordernr)){
    args <- c(args, pandoc_variable_arg("opdrachtnummer", ordernr))
  }
  if(!missing(subtitle)){
    args <- c(args, pandoc_variable_arg("ondertitel", subtitle))
  }
  if(!is.na(floatbarrier)){
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
