#' Create a template for an INBOmd bookdown report
#'
#' This function is defunct.
#' Use `flandersqmd::create_report()` instead.
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
create_report <- function(path = ".", shortname) {
  .Defunct(
    "create_report",
    package = "INBOmd",
    msg = "Use `flandersqmd::create_report()` instead."
  )
}

#' @importFrom assertthat assert_that
author2yaml <- function(author, corresponding = FALSE) {
  assert_that(is.flag(corresponding), noNA(corresponding))
  c(
    "  - name:",
    sprintf("      given: \"%s\"", author$given),
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
    noNA(author$email),
    author$email != "",
    msg = "please provide an email for the corresponding author"
  )
  paste(c(yaml, "    corresponding: true"), collapse = "\n")
}

#' @importFrom citeme select_individual
check_author <- function(lang = "nl") {
  person <- select_individual(lang = lang)
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
      "Please update the author information.",
      "\n",
      sep = " "
    )
    person <- check_author(lang = "nl")
  }
  return(person)
}
