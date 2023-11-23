#' Output format for a web version of the report
#'
#' A version of [bookdown::gitbook()] with a different styling.
#' @template yaml_generic
#' @template yaml_report
#' @template yaml_gitbook
#' @inheritParams rmarkdown::html_document
#' @export
#' @importFrom assertthat assert_that has_name
#' @importFrom bookdown gitbook
#' @importFrom fs file_exists path
#' @importFrom htmltools htmlDependency
#' @importFrom pdftools pdf_convert
#' @importFrom rmarkdown pandoc_variable_arg yaml_front_matter
#' @importFrom utils head packageVersion tail
#' @family output
gitbook <- function(code_folding = c("none", "show", "hide")) {
  code_folding <- match.arg(code_folding, c("none", "show", "hide"))
  gitbook_edit_button(getwd())
  path(getwd(), "index.Rmd") |>
    yaml_front_matter() |>
    validate_persons(reviewer = TRUE) |>
    validate_rightsholder() -> fm
  assert_that(
    !has_name(fm, "nocolophon"), msg = "Legacy option `nocolophon` detected.
    Please use the `public_report` option."
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
    msg = "Use style: Vlaanderen when the language is nl"
  )
  assert_that(
    style == "Flanders" || lang == "nl",
    msg = "Use style: Flanders when the language is not nl"
  )
  split_by <- ifelse(has_name(fm, "split_by"), fm$split_by, "chapter+number")
  assert_that(length(split_by) == 1)
  assert_that(
    split_by %in% c("chapter+number", "section+number"),
    msg = "`split_by` must be either 'chapter+number' or `section+number`"
  )

  pandoc_args <- c(
    "--csl",
    system.file(
      "research-institute-for-nature-and-forest.csl", package = "INBOmd"
    ),
    "--lua-filter",
    system.file(file.path("pandoc", "translations.lua"), package = "INBOmd")
  )
  validate_doi(ifelse(has_name(fm, "doi"), fm$doi, "1.1/1"))
  if (has_name(fm, "public_report") && !fm$public_report) {
    c(
      nl = "onuitgeven rapport", en = "unpublished report",
      fr = "rapport non publi\u00e9"
    )[lang] |>
      pandoc_variable_arg(name = "doi") |>
      c(pandoc_variable_arg("nocolophon", "true")) |>
      c(pandoc_args) -> pandoc_args
  }

  assert_that(
    getwd() |>
      path("index.Rmd") |>
      file_exists(),
    msg = "You need to render an INBOmd::gitbook() from it's working directory"
  )
  if (has_name(fm, "cover")) {
    cover_path <- gsub("\\.pdf$", ".png", fm$cover)
    if (!file_exists(cover_path)) {
      pdf_convert(
        pdf = fm$cover, format = "png", pages = 1, dpi = 770 * 25.4 / 210,
        filenames = cover_path
      )
    }
    pandoc_args <- c(
      pandoc_args, pandoc_variable_arg("cover_image", cover_path)
    )
  }
  inbomd_dep <- htmlDependency(
    name = "INBOmd", version = packageVersion("INBOmd"),
    src = system.file("css_styles", package = "INBOmd"),
    meta = c(creator = "Research Institute for Nature and Forest (INBO)"),
    stylesheet = sprintf(
      "%s_report.css", ifelse(style == "INBO", "inbo", "flanders")
    )
  )

  check_license()

  pandoc_args <- c(
    pandoc_args,
    pandoc_variable_arg(
      "csspath", file.path("libs", paste0("INBOmd-", packageVersion("INBOmd")))
    ),
    pandoc_variable_arg("corresponding", fm$corresponding),
    pandoc_variable_arg("shortauthor", fm$shortauthor)
  )
  template <- system.file(
    file.path("template", "report.html"), package = "INBOmd"
  )
  config <- bookdown::gitbook(
    fig_caption = TRUE, number_sections = TRUE, self_contained = FALSE,
    anchor_sections = TRUE, lib_dir = "libs", split_by = split_by,
    split_bib = TRUE, table_css = TRUE, pandoc_args = pandoc_args,
    template = template, extra_dependencies = list(inbomd_dep),
    code_folding = code_folding
  )
  old_post <- config$post_processor  # in case a post processor have been defined
  config$post_processor <- function(metadata, input, output, clean, verbose) {
    file(output, encoding = "UTF-8") |>
      readLines() -> x
    i <- head(grep('^<div id="refs" class="references[^"]*"[^>]*>$', x), 1)
    if (length(i) > 0) {
      x <- c(head(x, i - 1), "", tail(x, -i + 1))
    }
    writeLines(x, output)
    old_post(metadata, input, output, clean, verbose)
  }
  config$clean_supporting <- TRUE
  return(config)
}

#' @importFrom assertthat assert_that is.string
#' @importFrom gert git_branch_exists git_find git_remote_info git_remote_list
#' @importFrom utils file_test
gitbook_edit_button <- function(path) {
  root <- try(git_find(path), silent = TRUE)
  if (
    inherits(root, "try-error") ||
    nrow(git_remote_list(root)) == 0 ||
    !file_test("-f", file.path(path, "_bookdown.yml"))
  ) {
    return(invisible(FALSE))
  }
  url <- git_remote_info(repo = root)$url
  url <- gsub("^.*@(.*?):", "https://\\1/", url)
  url <- paste("edit:", gsub("\\.git$", "", url))
  url <- file.path(
    fsep = "/", url, "edit",
    ifelse(git_branch_exists("main", repo = path), "main", "master")
  )
  rel_path <- gsub(root, "", path)
  url <- ifelse(
    rel_path == "", file.path(url, "%s", fsep = "/"),
    file.path(url, gsub("^.", "", rel_path), "%s", fsep = "/")
  )
  yaml <- readLines(file.path(path, "_bookdown.yml"))
  writeLines(
    c(yaml[!grepl("^edit: ", yaml)], url), file.path(path, "_bookdown.yml")
  )
  return(invisible(TRUE))
}
