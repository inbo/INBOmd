.onAttach <- function(libname, pkgname) { # nolint
  packageStartupMessage(
"WARNING: INBOmd requires some additional configuration steps after install or
upgrade. Please visit https://github.com/inbo/INBOmd/blob/main/README.md for
instructions"
  )
}
