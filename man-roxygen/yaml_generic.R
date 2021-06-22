#' @section Available YAML headers options shared among output formats:
#'
#' - `title`: the main title
#' - `subtitle`: the optional subtitle
#' - `author`: the authors formatted as indicated in the section below.
#' - `cover_photo`: the relative path to the image you want on the cover.
#' - `flandersfont`: if set to `TRUE`, use the Flanders Art Sans font.
#'   When not set, or set to `FALSE` or empty, use the Calibri font.
#' - `style`
#'     - 'INBO' for the INBO style.
#'     - 'Vlaanderen' for the generic style of the Flemish Goverment in Dutch.
#'     - 'Flanders' for the generic style of the Flemish Goverment in a language
#'        other than Dutch.
#' - `lang`: the main language of the document as [RFC 5646](https://datatracker.ietf.org/doc/html/rfc5646) tags.
#'     - `nl` for Dutch
#'     - `en` for English
#'     - `fr` for French
#' @section Formatting author information:
#'
#' Quotes are required when a part contains spaces.
#' If the author doesn't have an ORCID, you can omit that line.
#' However, note that the INBO policy is that all scientific personnel is
#' required to obtain an ORCID from https://orcid.org.
#'
#' ```
#'   - firstname: "Authors first name"
#'     name: "Authors last name"
#'     email: "local-part@domain.com"
#'     orcid: 0000-0002-1825-0097
#' ```
