#' Create a report with the Flemish corporate identity
#' @inheritParams slides
#' @inheritParams rmarkdown::pdf_document
#' @template yaml_generic
#' @template yaml_report
#' @template yaml_pdf
#' @export
#' @importFrom assertthat assert_that has_name is.string
#' @importFrom fs path
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg includes_to_pandoc_args pandoc_version
#' @importFrom utils compareVersion
#' @family output
pdf_report <- function(
  fig_crop = "auto", includes = NULL, pandoc_args = NULL, ...
) {
  dots <- list(...)
  assert_that(
    !has_name(dots, "number_sections"), msg =
      "`number_sections` detected. Are you still using 'INBOmd::inbo_rapport' as
`output_format` of `bookdown::pdf_book`?"
  )
  check_dependencies()
  path(getwd(), "index.Rmd") |>
    yaml_front_matter() |>
    validate_persons() |>
    validate_rightsholder() -> fm
  floatbarrier <- ifelse(has_name(fm, "floatbarrier"), fm$floatbarrier, NA)
  assert_that(length(floatbarrier) == 1)
  assert_that(
    floatbarrier %in% c(NA, "section", "subsection", "subsubsection"),
    msg =
"Allowed options for `floatbarrier` are missing, 'section', 'subsection' and
'subsubsection'"
  )
  style <- ifelse(has_name(fm, "style"), fm$style, "INBO")
  stopifnot(
    "`style` is not a string" = is.string(style),
    "`style` is not a string" = noNA(style),
    "`style` must be one of 'INBO', 'Vlaanderen' or 'Flanders'" =
      style %in% c("INBO", "Vlaanderen", "Flanders")
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
  validate_doi(ifelse(has_name(fm, "doi"), fm$doi, "1.1/1"))

  template <- system.file(
    file.path("pandoc", "inbo_rapport.tex"), package = "INBOmd"
  )
  csl <- system.file(
    "research-institute-for-nature-and-forest.csl", package = "INBOmd"
  )

  style <- ifelse(style == "Flanders" & lang == "fr", "Flandre", style)

  args <- c(
    "--template", template, pandoc_variable_arg("documentclass", "report"),
    switch(
      style,
      Flanders = pandoc_variable_arg("style", "flanders_report"),
      Flandre = pandoc_variable_arg("style", "flandre_report"),
      Vlaanderen = pandoc_variable_arg("style", "vlaanderen_report"),
      INBO = pandoc_variable_arg("style", "inbo_report")
    ),
    pandoc_variable_arg("corresponding", fm$corresponding),
    pandoc_variable_arg("shortauthor", gsub("\\&", "\\\\&", fm$shortauthor)),
    pandoc_variable_arg(
      "babel", paste(languages[c(other_lang, lang)], collapse = ",")
    ),
    ifelse(
      compareVersion(as.character(pandoc_version()), "2") < 0,
      "--latex-engine", "--pdf-engine"
    ),
    "xelatex", pandoc_args, c("--csl", pandoc_path_arg(csl)),
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
    floatbarrier, section = "", subsection = c("", "sub"),
    subsubsection = c("", "sub", "subsub")
  )
  floating <- lapply(
    sprintf("floatbarrier%ssection", vars), pandoc_variable_arg, value = TRUE
  )
  args <- c(args, unlist(floating))
  opts_chunk <- list(
    latex.options = "{}", dev = "cairo_pdf", fig.align = "center", dpi = 300,
    fig.width = 4.5, fig.height = 2.9
  )
  knit_hooks <- NULL
  check_license()

  post_processor <- function(metadata, input, output, clean, verbose) {
    text <- readLines(output, warn = FALSE)
    cover_info(gsub("\\.tex$", ".Rmd", output, ignore.case = TRUE))

    # move frontmatter before toc
    mainmatter <- grep("\\\\mainmatter", text)
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
    appendix <- grep("\\\\appendix", text)
    startbib <- grep("\\\\hypertarget\\{refs\\}\\{\\}", text) # nolint: absolute_path_linter, line_length_linter.
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

#' @rdname deprecated
#' @family deprecated
#' @inheritParams slides
#' @inheritParams rmarkdown::pdf_document
#' @export
inbo_rapport <- function(
  fig_crop = "auto", includes = NULL, pandoc_args = NULL, ...
) {
  .Deprecated(
    report(
      fig_crop = fig_crop, includes = includes, pandoc_args = pandoc_args, ...
    ),
    msg = "`inbo_rapport` is deprecated. Use `pdf_report` instead."
  )
}

#' @rdname deprecated
#' @family deprecated
#' @inheritParams slides
#' @inheritParams rmarkdown::pdf_document
#' @export
report <- function(
    fig_crop = "auto", includes = NULL, pandoc_args = NULL, ...
) {
  .Deprecated(
    pdf_report(
      fig_crop = fig_crop, includes = includes, pandoc_args = pandoc_args, ...
    ),
    msg = "`report` is deprecated. Use `pdf_report` instead."
  )
}

#' @importFrom assertthat assert_that
validate_persons <- function(yaml) {
  assert_that(length(yaml$author) > 0, msg = "no author information found")
  shortauthor <- vapply(yaml$author, contact_person, character(1))
  corresponding <- shortauthor[grep(".*<.*>", shortauthor)]
  shortauthor <- gsub("<.*>", "", shortauthor)
  if (length(shortauthor) > 3) {
    yaml$shortauthor <- paste0(shortauthor[1], ", et. al.")
  } else {
    head(shortauthor, -1) |>
      paste(collapse = "; ") -> short_tmp
    short_tmp[short_tmp != ""] |>
      c(tail(shortauthor, 1)) |>
      paste(collapse = " & ") -> yaml$shortauthor
  }
  shortauthor <- paste(shortauthor, "<test.inbo.be>")
  assert_that(
    length(corresponding) == 1,
    msg = "A single corresponding author is required."
  )
  yaml$corresponding <- gsub(".*<(.*)>", "\\1", corresponding)
  assert_that(length(yaml$reviewer) > 0, msg = "no reviewer information found")
  vapply(yaml$reviewer, contact_person, character(1))
  return(yaml)
}

#' @importFrom assertthat assert_that
contact_person <- function(person) {
  assert_that(
    "name" %in% names(person),
    msg = "person information in yaml header has no `name` field."
  )
  assert_that(
    "given" %in% names(person$name),
    msg = "person information in yaml header has no `given` field under name."
  )
  assert_that(
    "family" %in% names(person$name),
    msg = "person information in yaml header has no `family` field under name."
  )
  gsub("(\\w)\\w* ?", "\\1.", person$name$given, perl = TRUE) |>
    sprintf(fmt = "%2$s, %1$s", person$name$family) -> shortauthor
  if (!has_name(person, "orcid")) {
    sprintf(
      "No `orcid` found for %s %s", person$name$given, person$name$family
    ) |>
      warning(call. = FALSE)
  }
  if (!has_name(person, "affiliation")) {
    sprintf(
      "No `affiliation` found for %s %s", person$name$given, person$name$family
    ) |>
      warning(call. = FALSE)
  }
  if (is.null(person$corresponding) || !person$corresponding) {
    return(shortauthor)
  }
  assert_that(
    "email" %in% names(person),
    msg = "no `email` provided for the corresponding author."
  )
  sprintf("%s<%s>", shortauthor, person$email)
}

#' @importFrom assertthat assert_that has_name is.string noNA
validate_rightsholder <- function(yaml) {
  stopifnot(
    "no `funder` found" = has_name(yaml, "funder"),
    "`funder` is not a string" = is.string(yaml$funder),
    "`funder` is not a string" = noNA(yaml$funder),
    "no `rightsholder` found" = has_name(yaml, "rightsholder"),
    "`rightsholder` is not a string" = is.string(yaml$rightsholder),
    "`rightsholder` is not a string" = noNA(yaml$rightsholder),
"Research Institute for Nature and Forest (INBO) not defined as rightsholder" =
      yaml$rightsholder == "Research Institute for Nature and Forest (INBO)",
    "no `community` found" = has_name(yaml, "community"),
    "`community` must be a string separated by `; `" =
      is.string(yaml$community),
    "`community` must contain `inbo`" =
      "inbo" %in% strsplit(yaml$community, "; "),
    "no `keywords` found" = has_name(yaml, "keywords"),
    "`keywords` must be a string separated by `; `" = is.string(yaml$keywords)
  )
  return(yaml)
}

#' @importFrom fs file_copy path
check_license <- function() {
  license_file <- "LICENSE.md"
  if (!is_file(license_file)) {
    path("generic_template", "cc_by_4_0.md") |>
      system.file(package = "checklist") |>
      file_copy(license_file)
    return(invisible(NULL))
  }
  current <- readLines(license_file)
  path("generic_template", "cc_by_4_0.md") |>
    system.file(package = "checklist") |>
    readLines() -> original
  if (!identical(current, original)) {
    path("generic_template", "cc_by_4_0.md") |>
      system.file(package = "checklist") |>
      file_copy(license_file, overwrite = TRUE)
  }
  return(invisible(NULL))
}
