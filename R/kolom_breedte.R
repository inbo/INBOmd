#' Bereken de breedte van een A0 kolom
#' @param aantal het gewenste aantal kolommen van dezelfde breedte
#' @param marge de breedte van de afstand tussen de kolommen in mm
#' @param witrand de breedte van de rand rond de poster in mm
#' @export
#' @family utils
kolom_breedte <- function(aantal = 3, marge = 20, witrand = 10) {
  (839.6 - 2 * witrand - (aantal + 1) * marge) / aantal
}

#' Bereken de startpositie van een A0 kolom
#' @param start het nummer van de kolom
#' @inheritParams kolom_breedte
#' @export
#' @family utils
kolom_start <- function(aantal = 3, start = 1, marge = 20, witrand = 10) {
  breed <- kolom_breedte(aantal = aantal, marge = marge, witrand = witrand)
  (start - 1) * (breed + marge)
}
