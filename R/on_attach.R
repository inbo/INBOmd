.onAttach <- function(libname, pkgname) {
  paste(
    "WARNING: INBOmd requires some additional configuration steps after",
    "install or upgrade. Please visit",
    "https://github.com/inbo/INBOmd/blob/main/README.md for instructions.",
    "\n\nCAUTION: `INBOmd` is now deprecated and will be no longer maintained",
    "after 2027.",
    "Switch to `flandersqmd` for longer support."
  ) |>
    packageStartupMessage()
}
