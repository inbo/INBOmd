#' Calculate the width of an A0 column
#' @param number The desired number of columns with equal width.
#' @param margin the horizontal distance between columns in mm.
#' @param edge the width of the whitespace edge around the poster in mm.
#' @export
#' @family utils
column_width <- function(number = 3, margin = 20, edge = 10) {
  (839.6 - 2 * edge - (number + 1) * margin) / number
}

#' Calculate the starting position of an A0 column
#' @param start the number of the column
#' @inheritParams column_width
#' @export
#' @family utils
column_start <- function(number = 3, start = 1, margin = 20, edge = 10) {
  width <- column_width(number = number, margin = margin, edge = edge)
  (start - 1) * (width + margin)
}

#' @rdname deprecated
#' @family deprecated
#' @param aantal The desired number of columns with equal width.
#' @param marge the horizontal distance between columns in mm.
#' @param witruimte the width of the whitespace edge around the poster in mm.
#' @export
kolom_breedte <- function(aantal = 3, marge = 20, witruimte = 10) {
  .Deprecated(
    column_width(number = aantal, margin = marge, edge = witruimte),
    msg =
    "`INBOmd::kolom_breedte` is deprecated. Use `INBOmd::column_width` instead."
  )
}

#' @rdname deprecated
#' @inheritParams kolom_breedte
#' @inheritParams column_start
#' @family deprecated
#' @export
kolom_start <- function(aantal = 3, start = 1, marge = 20, witruimte = 10) {
  .Deprecated(
    column_start(
      number = aantal, start = start, margin = marge, edge = witruimte
    ),
    msg =
      "`INBOmd::kolom_start` is deprecated. Use `INBOmd::column_start` instead."
  )
}
