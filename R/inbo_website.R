#' Render the report into a zip file for the INBO website
#' @param path The path to the directory where the report is located
#' @family utils
#' @export
#' @importFrom assertthat assert_that is.string noNA
#' @importFrom fs dir_create dir_delete dir_ls file_delete is_dir is_file path
#' path_abs path_ext_remove path_rel
#' @importFrom rmarkdown clean_site render_site
#' @importFrom utils zip
#' @importFrom withr defer
inbo_website <- function(path = ".") {
  assert_that(is.string(path), noNA(path))
  path <- normalizePath(path, mustWork = FALSE)
  assert_that(is_dir(path), msg = "`path` is not an existing directory")
  assert_that(
    is_file(path(path, "index.Rmd")), msg = "index.Rmd not found in `path`"
  )
  assert_that(
    is_file(path(path, "_bookdown.yml")),
    msg = "_bookdown.yml not found in `path`"
  )

  path(path, "_bookdown.yml") |>
    file(encoding = "UTF-8") -> con
  bookdown_yml <- readLines(con)
  close(con)
  bookname <- bookdown_yml[grepl("book_filename", bookdown_yml)]
  gsub("book_filename:\\s*\"(.*)\"", "\\1", bookname) |>
    path_ext_remove() -> bookname
  bookdown_yml[grepl("output_dir:", bookdown_yml)] |>
    gsub(pattern = "output_dir: \"(.*)\"", replacement = "\\1") -> output_dir
  stopifnot(
    "no `output_dir:` found in `_bookdown.yml`" = length(output_dir) > 0,
    "multiple `output_dir:` found in `_bookdown.yml`" = length(output_dir) < 2
  )

  yml <- yaml_front_matter(path(path, "index.Rmd"))
  formats <- names(yml[["output"]])
  formats <- formats[grepl("INBOmd::", formats)]
  stopifnot(
    "No `INBOmd` formats found" = length(formats) > 0,
    "At least output `INBOmd::gitbook` must be present" =
      "INBOmd::gitbook" %in% formats
  )
  formats <- c(
    formats[formats != "INBOmd::gitbook"], formats[formats == "INBOmd::gitbook"]
  )
  cit <- citation_meta$new(path)
  if (
    !is.null(cit$get_errors) &&
    !all(grepl("\\.zenodo.json is modified", cit$get_errors))
  ) {
    return(cit)
  }

  file_scope <- getOption("bookdown.render.file_scope")
  options(bookdown.render.file_scope = FALSE)
  defer(options(bookdown.render.file_scope = file_scope))
  old_wd <- getwd()
  defer(setwd(old_wd))

  path(path, output_dir) |>
    path_abs(output_dir) -> output_dir
  dir_create(output_dir)

  setwd(path)
  clean_site(path, preview = FALSE, quiet = TRUE)

  # render report
  for (this_format in formats) {
    sprintf("output_format = \"%s\", quiet = FALSE", this_format) |>
      paste0(", envir = new.env(), encoding = \"UTF-8\"") |>
      sprintf(fmt = "'rmarkdown::render_site(%s)'") -> arg
    system2(
      command = "Rscript", stdout = TRUE, stderr = TRUE, wait = TRUE,
      args = c("-e", arg)
    ) -> out
    cat(out, sep = "\n")
  }

  # copy .zenodo.json to output directory
  list.files(path, pattern = ".zenodo.json", all.files = TRUE) |>
    file.copy(output_dir, overwrite = TRUE)

  # pack report into a zip archive
  dir_ls(
    output_dir, recurse = TRUE, regexp = "\\.zip", invert = TRUE, all = TRUE
  ) |>
    path_rel(output_dir) -> files
  setwd(output_dir)
  path(output_dir, bookname, ext = "zip") |>
    zip(files = files, flags = "-r9XqT")
  # remove output except zip archive
  dir_ls(output_dir, type = "dir") |>
    dir_delete()
  dir_ls(output_dir, type = "file", regexp = "\\.zip", invert = TRUE) |>
    file_delete()
  return(invisible(NULL))
}
