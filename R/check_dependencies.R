#' Check if the required dependencies of INBOmd are installed
#' Missing dependencies will be installed automatically
#' @export
#' @importFrom tinytex check_installed install_tinytex is_tinytex tlmgr_conf
#' @importFrom utils install.packages
#' @family utils
check_dependencies <- function() {
  if (!is_tinytex()) {
    install_tinytex(
      extra_packages = c(
        "babel-dutch", "babel-english", "babel-french", "beamer",
        "beamerswitch", "booktabs", "carlisle", "colortbl", "datetime", "dvips",
        "emptypage", "environ", "epstopdf", "eso-pic", "eurosym", "extsizes",
        "fancyhdr", "fancyvrb", "fmtcount", "float", "fontspec", "footmisc",
        "framed", "helvetic", "hyphen-dutch", "hyphen-french", "inconsolata",
        "lastpage", "lipsum", "makecell", "marginnote", "mdframed", "ms",
        "multirow", "parskip", "pdflscape", "pdfpages", "pdftexcmds",
        "placeins", "needspace", "tabu", "tex", "textpos", "threeparttable",
        "threeparttablex", "titlesec", "times", "tocloft", "translator",
        "trimspaces", "ulem", "upquote", "wrapfig", "xcolor", "xstring", "zref"
      )
    )
  }
  stopifnot("unable to install TinyTeX" = is_tinytex())
  if (
    !any(grepl(
      system.file("local_tex", package = "INBOmd"),
      tlmgr_conf(c("auxtrees", "show"), .quiet = TRUE, stdout = TRUE)
    ))
  ) {
    tlmgr_conf(
      c(
        "auxtrees", "add", system.file("local_tex", package = "INBOmd"),
        .quiet = TRUE
      )
    )
  }

  dependencies <- c("bookdown", "webshot")
  available <- basename(find.package(dependencies, quiet = TRUE))
  to_install <- dependencies[!dependencies %in% available]
  if (length(to_install) > 0) {
    install.packages(
      to_install,
      repos = c("https://cloud.r-project.org/", getOption("repos"))
    )
    available <- basename(find.package(dependencies, quiet = TRUE))
    problem <- to_install[!to_install %in% available]
    if (length(problem) > 0) {
      stop(
        "Failing to install following required packages: ",
        paste(problem, collapse = ", ")
      )
    }
  }
  if (is.null(find_phantom())) {
    webshot::install_phantomjs()
  }
  if (.Platform$OS.type == "unix") {
    Sys.setenv(OPENSSL_CONF = "/dev/null") # nolint: absolute_path_linter.
  }
  return(TRUE)
}
