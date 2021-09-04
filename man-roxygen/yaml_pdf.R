#' @section Available YAML headers options specific for reports in pdf format:
#'
#' Bold items are required.
#' Omitting them results in an ugly warning in the rendered document.
#' This is deliberate done so you can prepare the document without adding the
#' information.
#' But the ugly warnings nudges you to add the required information before
#' publication.
#'
#' - **`embargo`**: The date at which the report is made public on the INBO
#'   website.
#' - `print`: section only required in case you need a number of printed copies.
#'   When set it requires the following sub items:
#'     - `copies`: the number of copies
#'     - `motivation`: motivate why you need printed copies as the INBO policy
#'       is to use only digital publications.
#'     - `pages`: the number of pages in the full document.
#' - `tocdepth`: which level headers to display.
#'     - 0: up to chapters (`#`)
#'     - 1: up to section (`##`)
#'     - 2: up to subsection (`###`)
#'     - 3: up to subsubsection (`####`) default
#' - `lof`: Adds a list of figures to the pdf after the table of content when
#'   set to `TRUE`.
#'   Omits the list of figures when missing or set to `FALSE`.
#' - `lot`: Adds a list of tables to the pdf after the table of content and the
#'   list of figures when set to `TRUE`.
#'   Omits the list of tables when missing or set to `FALSE`.
#' - `hyphenation`: An optional list of words with a specified hyphenation
#'   pattern.
#'   E.g. `hyphenation: "fortran, ergo-no-mic"` forces the word "fortran" to
#'   remain as a single word.
#'   "ergonomic" can be either the entire word, split into "ergo" and "nomic" or
#'   split into "ergono" and "mic".
#' - `floatbarrier`: A float barrier forces to place all floating figures and
#'   tables before placing the remainder of the document.
#'   You can place them manually by setting `\floatbarrier`.
#'   This option allows you to set the automatically before a heading.
#'   Defaults to NA (only float barriers before starting a new chapter `#`).
#'   Options are "section" (before `#` and `##`), "subsection" (before `#`, `##`
#'   and `###`) and "subsubsection" (before `#`, `##`, `###` and `####`).
#' - `other_lang`: the other languages you want to use in the pdf version.
#'   Available options are 'nl', 'en' and 'fr'.
#'   Defaults to all available languages except the main language.
#'
#' @section Multiple languages in pdf:
#'
#' You can define some parts of the text to be in a different language than the
#' main language (e.g. an abstract in a different language).
#' This is currently limited to Dutch, English and French.
#' Use `\bdutch` before and `\edutch` after the text in Dutch.
#' Use `\benglish` before and `\eenglish` after the text in English.
#' Use `\bfrench` before and `\efrench` after the text in French.
#' The styles "INBO" and "Vlaanderen" have French and English as optional
#' languages.
#' The `Flanders` style has by default Dutch and French as optional languages.
#'
#' Setting the language affects the hyphenation pattern and the names of items
#' like figures, tables, table of contents, list of figures, list of tables,
#' references, page numbers, ...
