#' @section Available YAML headers options specific for `gitbook`:
#'
#' - `github-repo`: You can optionally set the `github` repo in
#'   `organisation/repository` format (e.g. `inbo/INBOmd`).
#'   This will add an 'edit' button to the source file on GitHub.
#'   Note that only people with write access can edit the files directly in the
#'   repository.
#'   Others can only edit the source code in a fork of the repository and
#'   suggest the changes through a pull request.
#' - `split_by`: How to name the HTML output files from the book:
#'     - \code{chapter+number} means split the file by the first-level headers;
#'      - \code{section+number} means the second-level headers.
#'   For \code{chapter+number} and \code{section+number}, the HTML file names
#'   will be determined by the header ID's, e.g. the file name for the first
#'   chapter with a chapter title \code{# Introduction} will be
#'   \file{1-introduction.html}.
#'   Note that you need to place at least one level 1 heading in `index.Rmd`.
#'   Otherwise you don't get an `index.html` file.
