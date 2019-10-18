#' Check if the required dependencies of INBOmd are installed
#' Missing dependencies will be installed automatically
#' @export
#' @importFrom utils install.packages
#' @family utils
check_dependencies <- function() {
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
  return(TRUE)
}
