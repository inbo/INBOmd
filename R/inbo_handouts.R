#' Use the handout version of slides with the INBO theme
#' The only difference between inbo_slides() and inbo_handouts() is that inbo_slides() can have progressive slides whereas inbo_handouts() only displays the final slide.
#' @inheritParams inbo_slides
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options pandoc_variable_arg pandoc_path_arg
#' @importFrom assertthat assert_that is.string is.flag noNA
inbo_handouts <- function(
  subtitle,
  location,
  institute,
  cover,
  cover_offset,
  cover_hoffset,
  cover_horizontal = TRUE,
  toc_name,
  fontsize,
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  citation_package = c("natbib", "none"),
  natbib_title,
  lang = "dutch",
  slide_level = 2,
  keep_tex = FALSE,
  toc = TRUE,
  website = "www.INBO.be",
  theme = c("inbo", "vlaanderen"),
  flandersfont = FALSE,
  ...
){
  check_dependencies()
  assert_that(is.flag(toc))
  assert_that(noNA(toc))
  assert_that(is.string(website))
  theme <- match.arg(theme)
  assert_that(is.flag(flandersfont))
  assert_that(noNA(flandersfont))

  extra <- list(...)
  codesize <- match.arg(codesize)
  csl <- system.file("inbo.csl", package = "INBOmd")
  template <- system.file("pandoc/inbo_beamer.tex", package = "INBOmd")
  args <- c(
    "--slide-level", as.character(slide_level),
    "--template", template,
    "--latex-engine", "xelatex",
    pandoc_variable_arg("lang", lang),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("website", website),
    pandoc_variable_arg("flandersfont", flandersfont),
    pandoc_variable_arg("theme", theme),
    pandoc_variable_arg("handout", 1)
  )
  if ("usepackage" %in% names(extra)) {
    tmp <- sapply(
      extra$usepackage,
      pandoc_variable_arg,
      name = "usepackage"
    )
    args <- c(args, tmp)
  }
  if (!missing(toc_name)) {
    args <- c(args, pandoc_variable_arg("tocname", toc_name))
  }
  # citations
  citation_package <- match.arg(citation_package)
  if (citation_package == "none") {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  } else {
    args <- c(args, paste0("--", citation_package))
  }
  if (!missing(natbib_title)) {
    args <- c(args, pandoc_variable_arg("natbibtitle", natbib_title))
  }
  if (!missing(subtitle)) {
    args <- c(args, pandoc_variable_arg("subtitle", subtitle))
  }
  if (!missing(location)) {
    args <- c(args, pandoc_variable_arg("location", location))
  }
  if (!missing(fontsize)) {
    args <- c(args, pandoc_variable_arg("fontsize", fontsize))
  }
  if (!missing(institute)) {
    args <- c(args, pandoc_variable_arg("institute", institute))
  }
  if (!missing(cover)) {
    args <- c(args, pandoc_variable_arg("cover", cover))
  }
  if (!missing(cover_offset)) {
    args <- c(args, pandoc_variable_arg("coveroffset", cover_offset))
  }
  output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 80,
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
      latex_engine = "xelatex",
      args = args,
      keep_tex = keep_tex | !missing(natbib)
    ),
    clean_supporting = !keep_tex
  )
}
