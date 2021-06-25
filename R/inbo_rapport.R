#' Create a report with the Flemish corporate identity
#' @inheritParams inbo_slides
#' @inheritParams rmarkdown::pdf_document
#' @template yaml_generic
#' @template yaml_report
#' @export
#' @importFrom assertthat assert_that has_name is.string
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg includes_to_pandoc_args pandoc_version
#' @importFrom utils compareVersion
#' @family output
inbo_rapport <- function(
  fig_crop = "auto", includes = NULL, pandoc_args = NULL, ...
) {
  dots <- list(...)
  assert_that(
    !has_name(dots, "number_sections"), msg =
      "`number_sections` detected. Are you still using 'INBOmd::inbo_rapport' as
`output_format` of `bookdown::pdf_book`?"
  )
  check_dependencies()
  fm <- yaml_front_matter(file.path(getwd(), "index.Rmd"))
  floatbarrier <- ifelse(has_name(fm, "floatbarrier"), fm$floatbarrier, NA)
  assert_that(length(floatbarrier) == 1)
  assert_that(
    floatbarrier %in% c(NA, "section", "subsection", "subsubsection"),
    msg =
"Allowed options for `floatbarrier` are missing, 'section', 'subsection' and
'subsubsection'"
  )
  style <- ifelse(has_name(fm, "style"), fm$style, "INBO")
  assert_that(length(style) == 1)
  assert_that(
    style %in% c("INBO", "Vlaanderen", "Flanders"),
    msg = "`style` must be one of 'INBO', 'Vlaanderen' or 'Flanders'"
  )
  lang <- ifelse(
    has_name(fm, "lang"), fm$lang, ifelse(style == "Flanders", "en", "nl")
  )
  assert_that(length(lang) == 1)
  languages <- c(nl = "dutch", en = "english", fr = "french")
  assert_that(
    lang %in% names(languages),
    msg = paste(
      "`lang` must be one of:",
      paste(sprintf("'%s' (%s)", names(languages), languages), collapse = ", ")
    )
  )
  assert_that(
    style != "Flanders" || lang != "nl",
    msg = "Use style: Vlaanderen when the main language is Dutch"
  )
  other_lang <- fm$other_lang
  if (is.null(other_lang)) {
    other_lang <- names(languages)
  }
  other_lang <- other_lang[other_lang != lang]
  assert_that(
    all(other_lang %in% names(languages)),
    msg = paste(
      "all `other_lang` must be in this list:",
      paste(sprintf("'%s' (%s)", names(languages), languages), collapse = ", ")
    )
  )

  template <- system.file(
    file.path("pandoc", "inbo_rapport.tex"), package = "INBOmd"
  )
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")

  args <- c(
    "--template", template,
    pandoc_variable_arg("documentclass", "report"),
    switch(
      style,
      Flanders = pandoc_variable_arg("style", "flanders_report"),
      Vlaanderen = pandoc_variable_arg("style", "vlaanderen_report"),
      INBO = pandoc_variable_arg("style", "inbo_report")
    ),
    pandoc_variable_arg(
      "babel", paste(languages[c(other_lang, lang)], collapse = ",")
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
    includes_to_pandoc_args(includes)
  )
  args <- args[args != ""]

  if (has_name(fm, "lof") && isTRUE(fm$lof)) {
    args <- c(args, pandoc_variable_arg("lof", TRUE))
  }
  if (has_name(fm, "lot") && isTRUE(fm$lot)) {
    args <- c(args, pandoc_variable_arg("lot", TRUE))
  }
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

  post_processor <- function(metadata, input, output, clean, verbose) {
    text <- readLines(output, warn = FALSE)
    cover_info(gsub("\\.tex$", ".Rmd", output, ignore.case = TRUE))

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
    appendix <- grep("\\\\appendix", text) # nolint
    startbib <- grep("\\\\hypertarget\\{refs\\}\\{\\}", text) # nolint
    if (length(startbib)) {
      if (length(appendix)) {
        text <- c(
          text[1:(appendix - 1)],              # mainmatter
          "\\chapter*{\\bibname}",
          "\\addcontentsline{toc}{chapter}{\\bibname}",
          text[startbib],                      # bibliography
          "",
          text[startbib + 1],
          "",
          text[(startbib + 2):(length(text) - 1)],
          text[(appendix):(startbib - 1)],     # appendix
          text[length(text)]                   # backmatter
        )
      } else {
        text <- c(
          text[1:(startbib - 1)],              # mainmatter
          "\\chapter*{\\bibname}",
          "\\addcontentsline{toc}{chapter}{\\bibname}",
          text[startbib],                      # bibliography
          "",
          text[startbib + 1],
          "",
          text[(startbib + 2):length(text)]
        )
      }
    }

    writeLines(enc2utf8(text), output, useBytes = FALSE)
    output
  }
  of <- output_format(
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
      keep_tex = FALSE
    ),
    post_processor = post_processor,
    clean_supporting = TRUE
  )
  config <- pdf_book(
    toc = TRUE, number_sections = TRUE, fig_caption = TRUE, fig_crop = fig_crop,
    base_format = function(...) {
      of
    }
  )
  return(config)
}
