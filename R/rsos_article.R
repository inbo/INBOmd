#' Royal Society Open Science journal format.
#'
#' Format for creating submissions to Royal Society Open Science journals.
#'
#' @inheritParams rmarkdown::pdf_document
#' @param ... Additional arguments to \code{rmarkdown::pdf_document}
#'
#' @return R Markdown output format to pass to
#'   \code{\link[rmarkdown:render]{render}}
#'
#' @examples
#'
#' \dontrun{
#' library(rmarkdown)
#' draft("MyArticle.Rmd", template = "rsos_article", package = "rticles")
#' }
#'
#' @export
rsos_article <- function(..., keep_tex = TRUE) {
  inherit_pdf_document(
    ...,
    keep_tex = keep_tex,
    template = find_resource("rsos_article", "template.tex")
  )
}

find_file <- function(template, file) {
  template <- system.file(
    "rmarkdown", "templates", template, file,
    package = "INBOmd"
  )
  if (template == "") {
    stop("Couldn't find template file ", template, "/", file, call. = FALSE)
  }

  template
}

find_resource <- function(template, file) {
  find_file(template, file.path("resources", file))
}

#'@importFrom rmarkdown pdf_document
# Call rmarkdown::pdf_documet and mark the return value as inheriting pdf_document
inherit_pdf_document <- function(...) {
  fmt <- rmarkdown::pdf_document(...)
  fmt$inherits <- "pdf_document"
  fmt
}
