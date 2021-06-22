#' @section Available YAML headers options specific for slides:
#'
#' - `location`: optional text placed on the title slide below the (sub)title.
#' - `toc`: add a slide with the table of content.
#'   Defaults to `TRUE`.
#' - `toc_name`: slide title for the table of content.
#'   Defaults to "Overzicht" when missing.
#' - `cover_horizontal`: When omitted, scale the `cover_photo` so that it covers
#'   the full page vertically.
#'   When set to any value but `FALSE` or empty, scale the `cover_photo` so that
#'   it covers the full page horizontally.
#' - `cover_offset`: A measurement like `8mm` or `-1.5cm`.
#'   Positive values move the `cover_photo` upwards on the title slide.
#'   Negative values move the `cover_photo` downwards.
#' - `cover_hoffset`: Similar as `cover_offset` but moves `cover_photo`
#'   horizontally.
#'   Positive values move it to the right, negative values to the left.
#' - `aspect`: the required aspect ratio for the slides.
#'   Defaults to "16:9".
#'   See the section below for a list of the available aspect ratios.
#' - `fontsize`: Size of the normal text on the slides.
#'   Other elements are scaled accordingly.
#'   Defaults to "11pt".
#'   See the section _Aspect_ratio_ for more details.
#' - `codesize`: Relative size of R code compared to normal text.
#'   Defaults to "footnotesize".
#'   All options going from large to small are: "normalsize", "small",
#'   "footnotesize", "scriptsize", "tiny".
#'   "normalsize" implies `fontsize`.
#' - `website`: URL in the sidebar.
#'   Defaults to `www.vlaanderen.be/inbo`.
#'
#' @section Aspect ratio:
#'
#' The table below lists the available aspect ratios and their "paper size".
#' The main advantage of using a small “paper size” is that you can use all your
#' normal fonts at their natural sizes.
#' E.g. an 11pt font on a slide is as readable as an 11pt font on a A4 paper.
#'
#' | aspect | ratio | width | height |
#' | :----: | ----------: | ----: | -----: |
#' | 16:9 | 1.78 | 160.0 mm | 90 mm |
#' | 16:10 | 1.60 | 160.0 mm | 100 mm |
#' | 14:9 | 1.56| 140.0 mm | 90 mm |
#' | 3:2 | 1.50 | 135.0 mm | 90 mm |
#' | 1.4:1 | 1.41| 148.5 mm |105 mm |
#' | 4:3 | 1.33 | 128.0 mm | 96 mm |
#' | 5:4 | 1.25 | 125.0 mm | 100 mm |
