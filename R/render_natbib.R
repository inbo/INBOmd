#' Render a Markdown file with natbib bibliography
#' @export
#' @importFrom rmarkdown render
#' @importFrom assertthat assert_that is.string
#' @param file the name of the Rmd file
#' @param path the path of the Rmd file
#' @param enconding the encoding of the Rmd file. Default to 'UTF-8'
#' @param engine the LaTeX engine the compile the document. Defaults to "xelatex".
render_natbib <- function(
  file,
  path = ".",
  encoding = "UTF-8",
  engine = c("xelatex", "pdflatex")
){
  engine <- match.arg(engine)
  assert_that(is.string(file))
  assert_that(is.string(path))
  assert_that(is.string(encoding))
  assert_that(file_test("-d", path))
  assert_that(file_test("-f", paste(path, file, sep = "/")))
  assert_that(grepl("\\.[Rr]md$", file))

  current <- getwd()
  setwd(path)
  output <- gsub("\\.[Rr]md$", "", file)
  render(
    file,
    output_file = paste0(output, ".tex"),
    encoding = encoding
  )
  system(paste(engine, output))
  system(paste("bibtex", output))
  system(paste(engine, output))
  system(paste(engine, output))
  file.show(paste0(output, ".pdf"))
  setwd(current)
}
