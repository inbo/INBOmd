#' @section Available YAML headers options shared among output formats:
#'
#' - **`title`**: the main title
#' - `subtitle`: the optional subtitle
#' - **`author`**: the authors formatted as indicated in the section below.
#' - `flandersfont`: if set to `TRUE`, use the Flanders Art Sans font.
#'   When not set, or set to `FALSE` or empty, use the Calibri font.
#' - `style`: Defaults to "INBO" when missing.
#'     - `"INBO"` for the INBO style.
#'     - `"Vlaanderen"` for the generic style of the Flemish Government in
#'        Dutch.
#'     - `"Flanders"` for the generic style of the Flemish Government in a
#'        language other than Dutch.
#' - `lang`: the main language of the document as [RFC 5646](https://datatracker.ietf.org/doc/html/rfc5646) tags.
#'   `style` `"INBO"` and `"Vlaanderen"` require `"nl"` as `lang`.
#'   `style` `"Flanders"` uses `"en"` as default and can use other languages
#'   (but not `"nl"`).
#'     - `"nl"` for Dutch
#'     - `"en"` for English
#'     - `"fr"` for French
#' - `codesize`: Relative size of R code compared to normal text.
#'   Defaults to `"footnotesize"`.
#'   All options going from large to small are: `"normalsize"`, `"small"`,
#'   `"footnotesize"`, `"scriptsize"`, `"tiny"`.
#'   `"normalsize"` implies the same size as normal text.
#' @section Formatting author information:
#'
#' Quotes are required when a part contains spaces.
#' If the author doesn't have an ORCID, you can omit that line.
#' However, note that the INBO policy is that all scientific personnel is
#' required to obtain an ORCID from https://orcid.org.
#' Add `corresponding: true` to the corresponding author.
#'
#' ```
#'   - name:
#'      given: "Authors first name"
#'      family: "Authors last name"
#'     email: "local-part@domain.com"
#'     orcid: 0000-0002-1825-0097
#'     corresponding: true
#' ```
