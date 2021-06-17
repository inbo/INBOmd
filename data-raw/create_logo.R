checklist::create_hexsticker(
  package_name = "INBOmd", scale = 0.5, x = 130, y = -100,
  filename = file.path("man", "figures", "logo.svg"),
  icon = file.path("data-raw", "markdown-mark-solid.svg")
)
pkgdown::build_favicons(overwrite = TRUE)
