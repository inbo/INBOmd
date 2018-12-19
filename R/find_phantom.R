# taken from https://github.com/wch/webshot because webshot:::find_phantom() is not exported

# Find PhantomJS from PATH, APPDATA, system.file("webshot"), ~/bin, etc
find_phantom <- function() {
  path <- Sys.which("phantomjs")
  if (path != "") return(path)

  for (d in phantom_paths()) {
    exec <- if (is_windows()) "phantomjs.exe" else "phantomjs"
    path <- file.path(d, exec)
    if (utils::file_test("-x", path)) break else path <- ""
  }

  if (path == "") {
    # It would make the most sense to throw an error here. However, that would
    # cause problems with CRAN. The CRAN checking systems may not have phantomjs
    # and may not be capable of installing phantomjs (like on Solaris), and any
    # packages which use webshot in their R CMD check (in examples or vignettes)
    # will get an ERROR. We'll issue a message and return NULL; other
    message(
"PhantomJS not found. You can install it with webshot::install_phantomjs(). ",
"If it is installed, please make sure the phantomjs executable ",
"can be found via the PATH variable."
    )
    return(NULL)
  }
  path.expand(path)
}

# Possible locations of the PhantomJS executable
phantom_paths <- function() {
  if (is_windows()) {
    path <- Sys.getenv("APPDATA", "")
    path <- if (dir_exists(path)) file.path(path, "PhantomJS")
  } else if (is_osx()) {
    path <- "~/Library/Application Support" #nolint
    path <- if (dir_exists(path)) file.path(path, "PhantomJS")
  } else {
    path <- "~/bin" #nolint
  }
  path <- c(path, system.file("PhantomJS", package = "webshot"))
  path
}

dir_exists <- function(path) utils::file_test("-d", path)

is_windows <- function() .Platform$OS.type == "windows"
is_osx     <- function() Sys.info()[["sysname"]] == "Darwin"
