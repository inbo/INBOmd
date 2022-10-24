#' Create a template for an INBOmd bookdown report
#'
#' @param path The folder in which to create the folder containing the report
#' @param shortname The name of the report project
#' @family utils
#' @export
#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs dir_create file_copy is_dir path
create_report <- function(path, shortname) {
  assert_that(is.string(path), noNA(path), is_dir(path))
  assert_that(is.string(shortname), noNA(shortname))
  assert_that(
    grepl("^[a-z0-9_]+$", shortname),
msg = "The report name folder may only contain lower case letters, digits and _"
  )
  assert_that(
    !is_dir(path(path, shortname)),
    msg = "The report name folder already exists."
  )
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
  if (
    !requireNamespace("rstudioapi", quietly = TRUE) ||
    rstudioapi::isAvailable()
  ) {
    return(invisible(NULL))
  }
  rstudioapi::openProject(path(path, shortname))
}
