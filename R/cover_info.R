#' Create a cover.txt from the YAML header
#'
#' You need to provide information to create the cover image and (optionally)
#' print the report.
#' Add the information to the YAML header of the report.
#' Then run this function to covert the information into a `cover.txt` and
#' send that file along the other files to the review process.
#' @param path The path to the main `.Rmd` file.
#' @family utils
#' @export
#' @importFrom assertthat assert_that has_name is.count is.number
#' @importFrom rmarkdown yaml_front_matter
cover_info <- function(path = "index.Rmd") {
  path <- normalizePath(path)
  yaml_header <- yaml_front_matter(path)
  assert_that(
    has_name(
      yaml_header,
      c("title", "author", "corresponding", "embargo", "cover_photo")
    )
  )
  yaml_header$title <- paste0(
    yaml_header$title, "\nSubtitel: ", yaml_header$subtitle
  )
  yaml_header$author <- paste(
    vapply(yaml_header$author, format_author, character(1)), collapse = ", "
  )
  yaml_header$print <- format_print_order(yaml_header)
  cover_txt <- sprintf(
    "Titel: %s\nAuteur(s): %s\nContactpersoon: %s\nAfbeelding voor cover: %s
Embargo tot: %s\n%s",
    yaml_header$title, yaml_header$author, yaml_header$corresponding,
    yaml_header$cover_photo, yaml_header$embargo, yaml_header$print
  )
  if (has_name(yaml_header, "client_logo")) {
    cover_txt <- c(cover_txt, paste("Logo klant:", yaml_header$client_logo))
  }
  if (has_name(yaml_header, "cooperation_logo")) {
    cover_txt <- c(
      cover_txt, paste("Logo samenwerking:", yaml_header$cooperation_logo)
    )
  }
  writeLines(cover_txt, file.path(dirname(path), "cover.txt"))
  return(invisible(NULL))
}

format_author <- function(author) {
  ifelse(
    is.list(author),
    ifelse(
      has_name(author, "firstname"),
      paste(author$firstname, author$name),
      author$name
    ),
    author
  )
}

format_print_order <- function(yaml_header) {
  if (!has_name(yaml_header, "print")) {
    return("Geen druk")
  }
  assert_that(
    has_name(yaml_header$print, "copies"), is.number(yaml_header$print$copies)
  )
  if (yaml_header$print$copies == 0) {
    return("Geen druk")
  }
  assert_that(
    has_name(yaml_header$print, c("motivation", "pages")),
    is.count(yaml_header$print$copies),
    is.count(yaml_header$print$pages)
  )
  sprintf(
    "Aantal gedrukte examplaren: %i\nMotivatie: %s\nAantal bladzijden: %i",
    yaml_header$print$copies, yaml_header$print$motivation,
    yaml_header$print$pages
  )
}
