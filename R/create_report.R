#' Create a template for an INBOmd bookdown report
#'
#' @param path The folder in which to create the folder containing the report.
#'  Defaults to the current working directory.
#' @param shortname The name of the report project.
#' The location of the folder `shortname` depends on the content of `path`.
#' When `path` is a subfolder of a git repository, it is changed to the root
#' of that git repository.
#' When `path` is a `checklist::checklist` project, you will find the new report
#' at `path/source/shortname`.
#' When `path` is a `checklist::checklist` package, you will find the new report
#' at `path/inst/shortname`.
#' Otherwise you will find the new report at `path/shortname`.
#' @family utils
#' @export
#' @importFrom assertthat assert_that is.string noNA
#' @importFrom checklist ask_yes_no menu_first organisation read_checklist
#' use_author
#' @importFrom fs dir_create file_copy is_dir is_file path
#' @importFrom gert git_find
create_report <- function(path = ".", shortname) {
  assert_that(is.string(path), noNA(path), is_dir(path))
  assert_that(is.string(shortname), noNA(shortname))
  assert_that(
    grepl("^[a-z0-9_]+$", shortname),
msg = "The report name folder may only contain lower case letters, digits and _"
  )
  root <- try(git_find(path), silent = TRUE)
  path <- ifelse(inherits(root, "try-error"), path, root)
  if (is_file(path(path, "checklist.yml"))) {
    x <- read_checklist(path)
    path <- path(path, ifelse(x$package, "inst", "source"))
    dir_create(path)
  }

  assert_that(
    !is_dir(path(path, shortname)),
    msg = "The report name folder already exists."
  )

  lang <- c(nl = "Dutch", en = "English", fr = "French")
  lang <- names(lang)[
    menu_first(lang, title = "What is the main language of the report?")
  ]
  style <- c("INBO", "Vlaanderen")
  style <- ifelse(
    lang != "nl", "Flanders",
    style[menu_first(style, title = "Which style to use?")]
  )

  # build new yaml
  readline(prompt = "Enter the title: ") |>
    gsub(pattern = "[\"|']", replacement = "") |>
    sprintf(fmt = "title: \"%s\"") -> yaml
  readline(
    prompt = "Enter the optional subtitle (leave empty to omit): "
  ) |>
    gsub(pattern = "[\"|']", replacement = "") -> subtitle
  yaml <- c(yaml, paste("subtitle:", subtitle)[subtitle != ""])
  cat("Please select the corresponding author")
  authors <- check_author(lang = lang)
  c(yaml, "author:", author2yaml(authors, corresponding = TRUE)) -> yaml
  while (isTRUE(ask_yes_no("Add another author?", default = FALSE))) {
    author <- check_author(lang = lang)
    authors[, c("given", "family", "email")] |>
      rbind(author[, c("given", "family", "email")]) |>
      anyDuplicated() -> duplo
    if (duplo > 0) {
      cat(
        paste(author$given, author$family, "is already listed as author")
      )
      next
    }
    c(yaml, author2yaml(author, corresponding = FALSE)) -> yaml
    authors <- rbind(authors, author)
  }
  cat("Please select the reviewer")
  duplo <- 1
  while (duplo > 0) {
    author <- check_author(lang = lang)
    authors[, c("given", "family", "email")] |>
      rbind(author[, c("given", "family", "email")]) |>
      anyDuplicated() -> duplo
    if (duplo > 0) {
      cat(
        paste(author$given, author$family, "is already listed as author")
      )
    }
  }
  lang <- c(nl = "Dutch", en = "English", fr = "French")
  lang <- names(lang)[
    menu_first(lang, title = "What is the main language of the report?")
  ]
  org <- organisation$new()
  aff <- org$get_organisation[["inbo.be"]]$affiliation[lang]
  style <- c("INBO", "Vlaanderen")
  style <- ifelse(
    lang != "nl", "Flanders",
    style[menu_first(style, title = "Which style to use?")]
  )
  readline(prompt = "Enter one or more keywords separated by `;`") |>
    gsub(pattern = "[\"|']", replacement = "") |>
    strsplit(";") |>
    unlist() |>
    gsub(pattern = "^\\s+", replacement = "") |>
    gsub(pattern = "\\s+$", replacement = "") |>
    paste(collapse = "; ") |>
    sprintf(fmt = "keywords: \"%s\"") -> keywords
  c(
    yaml, "reviewer:", author2yaml(author, corresponding = FALSE),
    paste("lang:", lang), paste("style:", style), add_address("client"),
    add_address("cooperation"), "floatbarrier: subsubsection",
    "geraardsbergen: true"[
      ask_yes_no(
        "Do you want INBO Geraardsbergen as address instead of INBO Brussels?",
        default = FALSE
      )
    ],
    "lof: TRUE"[ask_yes_no("Do you want a list of figures?", default = FALSE)],
    "lot: TRUE"[ask_yes_no("Do you want a list of tables?", default = FALSE)],
    keywords, "community: \"inbo\"", "publication_type: report",
    paste("funder:", aff), paste("rightsholder:", aff),
    "bibliography: references.bib", "link-citations: TRUE",
    "site: bookdown::bookdown_site", "output:", "  INBOmd::gitbook: default",
    "  INBOmd::pdf_report: default", "  INBOmd::epub_book: default",
    "# Don't run the format below.",
  "# Only required for RStudio to recognise the project as a bookdown project.",
    "# Hence don't use 'Build all formats'.", "  bookdown::dontrun: default"
  ) -> yaml

  dir_create(path(path, shortname))
  writeLines(
    text = c(
      "Version: 1.0", "", "RestoreWorkspace: No", "SaveWorkspace: No",
      "AlwaysSaveHistory: No", "", "EnableCodeIndexing: Yes",
      "UseSpacesForTab: Yes", "NumSpacesForTab: 2", "Encoding: UTF-8", "",
      "RnwWeave: knitr", "LaTeX: XeLaTeX", "", "AutoAppendNewline: Yes",
      "StripTrailingWhitespace: Yes", "LineEndingConversion: Posix", "",
      "BuildType: Website", "", "MarkdownWrap: Sentence",
      "MarkdownReferences: Document", "MarkdownCanonical: Yes"
    ),
    con = path(path, shortname, shortname, ext = "Rproj")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton", "skeleton.Rmd",
      package = "INBOmd"
    ),
    path(path, shortname, "index.Rmd")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton", "000_abstract.Rmd",
      package = "INBOmd"
    ),
    path(path, shortname, "000_abstract.Rmd")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton", "01_inleiding.Rmd",
      package = "INBOmd"
    ),
    path(path, shortname, "01_inleiding.Rmd")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton", "001_resume.Rmd",
      package = "INBOmd"
    ),
    path(path, shortname, "001_resume.Rmd")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton", "_bookdown.yml",
      package = "INBOmd"
    ),
    path(path, shortname, "_bookdown.yml")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton", "references.bib",
      package = "INBOmd"
    ),
    path(path, shortname, "references.bib")
  )
  file_copy(
    system.file(
      "rmarkdown", "templates", "report", "skeleton",
      "zzz_references_and_appendix.Rmd", package = "INBOmd"
    ),
    path(path, shortname, "zzz_references_and_appendix.Rmd")
  )

  path("generic_template", "cc_by_4_0.md") |>
    system.file(package = "checklist") |>
    file_copy(path(path, shortname, "LICENSE.md"))

  # read index template
  path(path, shortname, "index.Rmd") |>
    readLines() -> index
  # remove existing yaml
  index <- tail(index, -grep("---", index)[2])
  # add new yaml
  index <- c("---", yaml, "---", index)
  writeLines(index, path(path, shortname, "index.Rmd"))

  # update _bookdown.yml
  path(path, shortname, "_bookdown.yml") |>
    readLines() -> bookdown_yml
  yaml[grep("^title", yaml)] |>
    gsub(pattern = "title: \"(.*)\"", replacement = "\\1") |>
    tolower() |>
    abbreviate(minlength = 20) |>
    gsub(pattern = " ", replacement = "_") |>
    sprintf(
      fmt = "book_filename: \"%2$s_%1$s.Rmd\"",
      ifelse(
        nrow(authors) > 2,
        gsub("[ -]", "_", authors$family[1]) |>
          sprintf(fmt = "%s_et_al"),
        gsub("[ -]", "_", authors$family) |>
          paste(collapse = "_")
      ) |>
        tolower()
  ) |>
    gsub(pattern = "book_filename: \"(.*)\"", x = bookdown_yml) |>
    gsub(
      pattern = "delete_merged_file: FALSE",
      replacement = "delete_merged_file: TRUE"
    ) -> bookdown_yml
    ifelse(basename(path) == "source", "../..", "..") |>
      path("output", shortname) |>
      sprintf(fmt = "output_dir: \"%s\"") |>
      gsub(pattern = "output_dir: \"../output\"", bookdown_yml) |>
      writeLines(path(path, shortname, "_bookdown.yml"))

  if (
    !requireNamespace("rstudioapi", quietly = TRUE) ||
    !rstudioapi::isAvailable()
  ) {
    return(invisible(NULL))
  }
  rstudioapi::openProject(path(path, shortname), newSession = TRUE)
}

#' @importFrom assertthat assert_that
author2yaml <- function(author, corresponding = FALSE) {
  assert_that(is.flag(corresponding), noNA(corresponding))
  c(
    "  - name:", sprintf("      given: \"%s\"", author$given),
    sprintf("      family: \"%s\"", author$family)
  ) -> yaml
  if (!is.na(author$email) && author$email != "") {
    yaml <- c(yaml, sprintf("    email: \"%s\"", author$email))
  }
  if (!is.na(author$orcid) && author$orcid != "") {
    yaml <- c(yaml, sprintf("    orcid: \"%s\"", author$orcid))
  }
  if (!is.na(author$affiliation) && author$affiliation != "") {
    yaml <- c(yaml, sprintf("    affiliation: \"%s\"", author$affiliation))
  }
  if (!corresponding) {
    return(paste(yaml, collapse = "\n"))
  }
  assert_that(
    noNA(author$email), author$email != "",
    msg = "please provide an email for the corresponding author"
  )
  paste(c(yaml, "    corresponding: true"), collapse = "\n")
}

add_address <- function(type = "client") {
  address <- character(0)
  while (TRUE) {
    sprintf(
      "Add line %i of the %s name and address (leave empty to stop): ",
      length(address) + 1, type
    ) |>
      readline() -> extra
    if (extra == "") {
      break
    }
    address <- c(address, extra)
  }
  if (length(address) == 0) {
    return(address)
  }
  sprintf("optional filename of the %s logo: ", type) |>
    readline() -> logo
  c(
    sprintf("%s:", type), sprintf("  - %s", address),
    sprintf("%s_logo: %s", type, logo)[logo != ""]
  )
}

#' @importFrom checklist use_author
check_author <- function(lang = "nl") {
  person <- use_author()
  if (is_inbo(person) && !person$affiliation %in% inbo_affiliation) {
    paste0("`", inbo_affiliation, "`", collapse = "; ") |>
      sprintf(fmt = "INBO staff must use one of %s as affiliation.") |>
      cat("Please update the author information.", "\n", sep = " ")
    person <- check_author(lang = "nl")
    person$affiliation <- inbo_affiliation[lang]
  }
  if (is_inbo(person) && is.na(person$orcid)) {
    cat(
      "INBO staff must provide an ORCID.",
      "Please update the author information.", "\n", sep = " "
    )
    person <- check_author(lang = "nl")
  }
  return(person)
}
