#' Render a Markdown file with natbib bibliography
#' @export
#' @importFrom rmarkdown render
#' @importFrom assertthat assert_that is.string is.flag noNA
#' @param file the name of the Rmd file
#' @param path the path of the Rmd file
#' @param enconding the encoding of the Rmd file. Default to 'UTF-8'
#' @param engine the LaTeX engine the compile the document. Defaults to "xelatex".
#' @param display open the pdf in a reader. Defaults to TRUE
#' @param keep keep intermediate files after succesful compilation. Defaults to "none"
render_natbib <- function(
  file,
  path = ".",
  encoding = "UTF-8",
  engine = c("xelatex", "pdflatex"),
  display = TRUE,
  clean = c("none", "all", "tex")
){
  engine <- match.arg(engine)
  clean <- match.arg(clean)
  assert_that(is.string(file))
  assert_that(is.string(path))
  assert_that(is.string(encoding))
  assert_that(file_test("-d", path))
  assert_that(file_test("-f", paste(path, file, sep = "/")))
  assert_that(grepl("\\.[Rr]md$", file))
  assert_that(is.flag(display))
  assert_that(noNA(display))

  current <- getwd()
  setwd(path)
  output <- gsub("\\.[Rr]md$", "", file)
  render(
    file,
    output_file = paste0(output, ".tex"),
    encoding = encoding
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
    file.remove(paste0(output, c(".aux", ".bbl", ".blg", ".toc", ".lof", ".log", ".out")))
  }
  setwd(current)
}
