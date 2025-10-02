#' Prepare a cover image from a PDF file
#'
#' Extract the first page of a PDF file.
#' Store this page as `cover.pdf` at `path`.
#' Also convert it to `cover.png`.
#' @inheritParams add_report_numbers
#' @param input Link to the PDF file which first becomes the cover.
#' @returns Invisible `NULL`.
#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs is_dir is_file
#' @importFrom pdftools pdf_convert pdf_subset
#' @export
#' @family utils
prepare_cover <- function(input, path = ".") {
  assert_that(
    is.string(input),
    noNA(input),
    is.string(input),
    noNA(path),
    is_file(input),
    is_dir(path)
  )
  stopifnot("`input` must have a `pdf` extension" = grepl("\\.pdf$", input))
  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(path)
  pdf_subset(input = input, pages = 1, output = "cover.pdf")
  suppressWarnings(
    pdf_convert(
      pdf = "cover.pdf",
      format = "png",
      pages = 1,
      dpi = 770 * 25.4 / 210,
      filenames = "cover.png",
      verbose = FALSE
    )
  )
  return(invisible(NULL))
}
