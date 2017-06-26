#' Check if the required dependencies of INBOmd are installed
#' Missing dependencies will be installed automatically
#' @export
#' @importFrom utils installed.packages install.packages
check_dependencies <- function(){
  dependencies <- c("bookdown", "webshot")
  available <- installed.packages()
  to_install <- dependencies[!dependencies %in% available[, "Package"]]
  if (length(to_install) > 0) {
    install.packages(
      to_install,
      repos = c("https://cloud.r-project.org/", getOption("repos"))
    )
    available <- installed.packages()
    problem <- to_install[!to_install %in% available[, "Package"]]
    if (length(problem) > 0) {
      stop(
        "Failing to install following required packages: ",
        paste(problem, collapse = ", ")
      )
    }
  }
  if (is.null(webshot:::find_phantom())) {
    webshot::install_phantomjs()
  }
  return(TRUE)
}
