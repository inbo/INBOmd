#' Create a report with the Flemish corporate identity
#' @inheritParams slides
#' @inheritParams rmarkdown::pdf_document
#' @template yaml_generic
#' @template yaml_report
#' @template yaml_pdf
#' @export
#' @importFrom assertthat assert_that has_name is.string
#' @importFrom fs path
#' @importFrom rmarkdown output_format knitr_options pandoc_available
#' pandoc_options pandoc_variable_arg includes_to_pandoc_args
#' @family output
pdf_report <- function(
  fig_crop = "auto", includes = NULL, pandoc_args = NULL, ...
) {
  pandoc_available(version = "3.1.8", error = TRUE)
  dots <- list(...)
  assert_that(
    !has_name(dots, "number_sections"), msg =
      "`number_sections` detected. Are you still using 'INBOmd::inbo_rapport' as
`output_format` of `bookdown::pdf_book`?"
  )
  check_dependencies()
  path(getwd(), "index.Rmd") |>
    yaml_front_matter() |>
    validate_persons(reviewer = TRUE) |>
    validate_rightsholder() -> fm
  stopifnot(
    "`internal` option in yaml is not allowed" = !has_name(fm, "internal"),
    "`pagefootmessage` option in yaml is not allowed" =
      !has_name(fm, "pagefootmessage")
  )
  style <- list(INBO = "nl", Vlaanderen = "nl", Flanders = c("en", "fr"))
  languages <- c(nl = "dutch", en = "english", fr = "french")
  hide_defaults <- list(internal = FALSE, lof = FALSE, lot = FALSE)
  defaults <- c(
    hide_defaults, style = names(style)[1], public_report = TRUE,
# use the first language of the style when set
# otherwise use the first language of the first style
    lang = unlist(style[fm$style]) |>
      c(style[[1]]) |>
      head(1) |>
      unname(),
    floatbarrier = NA, watermark = NULL,
    other_lang = list(names(languages))
  )
  extra <- !names(defaults) %in% names(fm)
  fm <- c(fm, defaults[extra])

  assert_that(length(fm$floatbarrier) == 1)
  assert_that(
    fm$floatbarrier %in% c(NA, "section", "subsection", "subsubsection"),
    msg =
"Allowed options for `floatbarrier` are missing, 'section', 'subsection' and
'subsubsection'"
  )
  stopifnot(
    "`style` is not a string" = is.string(fm$style),
    "`style` is not a string" = noNA(fm$style),
    "`style` must be one of 'INBO', 'Vlaanderen', 'Flanders'" =
      fm$style %in% names(style)
  )
  assert_that(length(fm$lang) == 1)
  assert_that(
    fm$lang %in% names(languages),
    msg = paste(
      "`lang` must be one of:",
      paste(sprintf("'%s' (%s)", names(languages), languages), collapse = ", ")
    )
  )
  assert_that(
    fm$lang %in% style[[fm$style]],
    msg = vapply(
      names(style), FUN.VALUE = character(1), style = style,
      FUN = function(s, style) {
        sprintf("`%s`", style[[s]]) |>
          paste(collapse = ", ") |>
          sprintf(fmt = "%2$s: %1$s", s)
      }
    ) |>
      paste(collapse = "; ") |>
      sprintf(fmt = "Available combinations of `style` and `lang`\n%s")
  )
  fm$other_lang <- fm$other_lang[fm$other_lang != fm$lang]
  assert_that(
    all(fm$other_lang %in% names(languages)),
    msg = paste(
      "all `other_lang` must be in this list:",
      paste(sprintf("'%s' (%s)", names(languages), languages), collapse = ", ")
    )
  )

  path("pandoc", "inbo_rapport.tex") |>
    system.file(package = "INBOmd") -> template
  csl <- system.file(
    "research-institute-for-nature-and-forest.csl", package = "INBOmd"
  )

  args <- c(
    "--template", template, "--pdf-engine",
    "xelatex", pandoc_args, "--csl", pandoc_path_arg(csl),
    includes_to_pandoc_args(includes)
  )
  args <- args[args != ""]

  draft <- !all(c("cover_description", "year") %in% names(fm))
  if (!fm$public_report) {
    Sys.time() |>
      format("%Y-%m-%d %H:%M:%S") |>
      c(fm$reportnr) |>
      tail(1) -> fm$pagefootmessage
    fm$internal <- TRUE
  } else {
    if (has_name(fm, "doi")) {
      validate_doi(fm$doi)
      draft <- draft && !all(c("depotnr", "doi", "reportnr") %in% names(fm))
    } else {
      draft <- TRUE
      fm$doi <- "!!! missing DOI !!!"
    }
    fm$pagefootmessage <- fm$doi
  }
  if (draft) {
    c(en = "DRAFT", fr = "CONCEPTION", nl = "ONTWERP")[fm$lang] |>
      c(fm$watermark) |>
      paste(collapse = "\\\\") -> fm$watermark
  }

  fm[names(fm) %in% names(hide_defaults)] |>
    unlist() -> to_hide
  fm[names(to_hide)[!to_hide]] <- NULL
  var_arg <- c(
    documentclass = "report",
    style = c(
      Flanders_en = "flanders_report", Flanders_fr = "flandre_report",
      Vlaanderen_nl = "vlaanderen_report", INBO_nl = "inbo_report"
    )[paste(fm$style, fm$lang, sep = "_")] |>
      unname(),
    fm[
      c(
        "corresponding", "doi", "internal", "lof", "lot", "watermark",
        "pagefootmessage"
      )
    ],
    shortauthor = gsub("\\&", "\\\\&", fm$shortauthor),
    babel = paste(languages[c(fm$other_lang, fm$lang)], collapse = ",")
  )
  var_arg <- var_arg[!vapply(var_arg, is.null, logical(1))]
  vapply(
    seq_along(var_arg), FUN.VALUE = character(2), var_arg = var_arg,
    FUN = function(i, var_arg) {
      pandoc_variable_arg(names(var_arg)[i], var_arg[i])
    }
  ) |>
    as.vector() |>
    c(args) -> args

  vars <- switch(
    fm$floatbarrier, section = "", subsection = c("", "sub"),
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
    startbib <- grep("\\\\phantomsection\\\\label\\{refs\\}", text) # nolint: absolute_path_linter, line_length_linter.
    if (length(startbib)) {
      if (length(appendix)) {
        text <- c(
          head(text, appendix - 1),            # mainmatter
          "\\chapter*{\\bibname}",
          "\\addcontentsline{toc}{chapter}{\\bibname}",
          text[startbib],                      # bibliography
          "",
          text[startbib + 1],
          "",
          text[(startbib + 2):(length(text) - 1)],
          text[(appendix):(startbib - 1)],     # appendix
          tail(text, 1)                        # backmatter
        )
      } else {
        text <- c(
          head(text, startbib - 1),            # mainmatter
          "\\chapter*{\\bibname}",
          "\\addcontentsline{toc}{chapter}{\\bibname}",
          text[startbib],                      # bibliography
          "",
          text[startbib + 1],
          "",
          tail(text, -startbib - 1)
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

#' @importFrom assertthat assert_that is.flag noNA
validate_persons <- function(yaml, reviewer = TRUE) {
  assert_that(length(yaml$author) > 0, msg = "no author information found")
  assert_that(is.flag(reviewer), noNA(reviewer))
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
  assert_that(
    length(corresponding) == 1,
    msg = "A single corresponding author is required."
  )
  yaml$corresponding <- gsub(".*<(.*)>", "\\1", corresponding)
  assert_that(
    !reviewer || length(yaml$reviewer) > 0,
    msg = "no reviewer information found"
  )
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
  "(\\w)[\\w'\u00e1\u00e0\u00e9\u00e8\u00eb\u00f6\u00ef]*" |>
    gsub("\\1.", person$name$given, perl = TRUE) |>
    sprintf(fmt = "%2$s, %1$s", person$name$family) -> shortauthor
  if (!has_name(person, "orcid")) {
    if (is_inbo(person)) {
      sprintf(
        "`orcid` required for %s %s", person$name$given, person$name$family
      ) |>
        stop(call. = FALSE)
    }
    sprintf(
      "No `orcid` found for %s %s", person$name$given, person$name$family
    ) |>
      warning(call. = FALSE)
  }
  if (!has_name(person, "affiliation")) {
    if (is_inbo(person)) {
      sprintf(
        "`affiliation` required for %s %s.\nMust be one of %s",
        person$name$given, person$name$family,
        paste0("`", inbo_affiliation, "`", collapse = "; ")
      ) |>
        stop(call. = FALSE)
    }
    sprintf(
      "No `affiliation` found for %s %s", person$name$given, person$name$family
    ) |>
      warning(call. = FALSE)
  } else {
    if (is_inbo(person) && !person$affiliation %in% inbo_affiliation) {
      sprintf(
        "`affiliation` for %s %s must be one of %s", person$name$given,
        person$name$family, paste0("`", inbo_affiliation, "`", collapse = "; ")
      ) |>
        stop(call. = FALSE)
    }
  }
  if (is.null(person$corresponding) || !person$corresponding) {
    return(shortauthor)
  }
  assert_that(
    has_name(person, "email"),
    msg = "no `email` provided for the corresponding author."
  )
  sprintf("%s<%s>", shortauthor, person$email)
}

#' @importFrom assertthat assert_that has_name is.string noNA
#' @importFrom checklist organisation
validate_rightsholder <- function(yaml) {
  org <- organisation$new()
  aff <- org$get_organisation[["inbo.be"]]$affiliation
  stopifnot(
    "no `funder` found" = has_name(yaml, "funder"),
    "`funder` is not a string" = is.string(yaml$funder),
    "`funder` is not a string" = noNA(yaml$funder),
    "no `rightsholder` found" = has_name(yaml, "rightsholder"),
    "`rightsholder` is not a string" = is.string(yaml$rightsholder),
    "`rightsholder` is not a string" = noNA(yaml$rightsholder),
    "no `community` found" = has_name(yaml, "community"),
    "`community` must be a string separated by `; `" =
      is.string(yaml$community),
    "`community` must contain `inbo`" =
      "inbo" %in% strsplit(yaml$community, "; "),
    "no `keywords` found" = has_name(yaml, "keywords"),
    "`keywords` must be a string separated by `; `" = is.string(yaml$keywords)
  )
  assert_that(
    yaml$rightsholder %in% aff,
    msg = sprintf(
      "rightsholder must be one of the following\n%s",
      paste(aff, collapse = "\n")
    )
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

#' @importFrom assertthat has_name
is_inbo <- function(person) {
  if (!has_name(person, "email")) {
    return(FALSE)
  }
  grepl("inbo.be$", person$email, ignore.case = TRUE)
}
