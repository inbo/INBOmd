#' Render a Markdown file with `natbib` bibliography
#' @export
#' @importFrom rmarkdown render
#' @importFrom assertthat assert_that is.string is.flag noNA
#' @importFrom utils file_test
#' @param file the name of the `Rmd` file.
#' @param path the path of the `Rmd` file.
#' @param encoding the encoding of the `Rmd` file. Default to 'UTF-8'.
#' @param engine the LaTeX engine the compile the document.
#' Defaults to `"xelatex"`.
#' @param display open the pdf in a reader. Defaults to TRUE.
#' @param keep keep intermediate files after successful compilation.
#' Defaults to "none".
#' @param clean TRUE to clean intermediate files created during rendering of the
#' R markdown into `tex`.
#' @family utils
render_natbib <- function(
  file,
  path = ".",
  encoding = "UTF-8",
  engine = c("xelatex", "pdflatex"),
  display = TRUE,
  keep = c("none", "all", "tex"),
  clean = TRUE
) {
  engine <- match.arg(engine)
  keep <- match.arg(keep)
  assert_that(is.string(file))
  assert_that(is.string(path))
  assert_that(is.string(encoding))
  assert_that(file_test("-d", path))
  assert_that(file_test("-f", paste(path, file, sep = "/")))
  assert_that(grepl("\\.[Rr]md$", file))
  assert_that(is.flag(display))
  assert_that(noNA(display))
  assert_that(is.flag(clean))
  assert_that(noNA(clean))

  current <- getwd()
  setwd(path)
  output <- gsub("\\.[Rr]md$", "", file)
  render(
    file,
    output_file = paste0(output, ".tex"),
    encoding = encoding,
    clean = clean
  )
  log <- system(paste(engine, output))
  if (log == 1) {
    setwd(current)
    stop()
  }
  log <- system(paste("bibtex", output))
  if (log == 1) {
    setwd(current)
    stop()
  }
  log <- system(paste(engine, output))
  if (log == 1) {
    setwd(current)
    stop()
  }
  log <- system(paste(engine, output))
  if (log == 1) {
    setwd(current)
    stop()
  }
  if (display) {
    file.show(paste0(output, ".pdf"))
  }
  if (keep != "all") {
    file.remove(
      paste0(
        output,
        c(".aux", ".bbl", ".blg", ".toc", ".lof", ".log", ".lot", ".out")
      )
    )
    if (keep == "none") {
      file.remove(paste0(output, ".tex"))
      unlink(paste0(output, "_files"), recursive = TRUE)
    }
  }
  setwd(current)
}
