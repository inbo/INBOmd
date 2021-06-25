#' @section Available YAML headers options specific for reports:
#'
#' Bold items are required.
#' Omitting them results in an ugly warning in the rendered document.
#' This is deliberate done so you can prepare the document without adding the
#' information.
#' But the ugly warnings nudges you to add the required information before
#' publication.
#'
#' - **`shortauthor`**: abbreviated list of authors.
#'   Required for the citation in the colophon.
#'   Also displayed at the bottom of each page in the web version of the report.
#' - **`corresponding`**: e-mail of the corresponding author.
#'   Required for the colophon.
#' - **`reviewer`**: names of the reviewers.
#'   Use the same syntax as for the authors.
#' - **`year`**: year of publication.
#'   Used in the same places as `shortauthor`
#' - **`cover_photo`**: the relative path to the image you want on the cover.
#' - **`cover_description`**: Description of the cover photo, including information
#'   on the author of the picture and license information.
#' - `cover` the relative path to a pdf with the cover provided by the graphical
#'   designer.
#'   The first page of this pdf will be prepended to the pdf version of the
#'   report.
#'   It becomes the title page in the web and e-book version of the report.
#'   And also shows as a thumbnail in the floating table of content in the web
#'   version.
#' - **`doi`**: the Digital Object Identifier of the report.
#'   Used in conjunction with `shortauthor` and `year`.
#' - **`reportnr`**: Report number assigned by the INBO library.
#' - `ordernr`: Optional reference number specified by the client.
#' - **`depotnr`**: Report number assigned by the INBO library.
#' - **`embargo`**: The date at which the report is made public on the INBO
#'   website.
#' - `print`: section only required in case you need a number of printed copies.
#'   When set it requires the following sub items:
#'     - `copies`: the number of copies
#'     - `motivation`: motivate why you need printed copies as the INBO policy
#'       is to use only digital publications.
#'     - `pages`: the number of pages in the full document.
#' - `client`: Optionally the name, address and website of the client.
#' - `client_logo`: Optionally the logo of the client.
#'   Only used when `client` is set.
#' - `cooperation`: Optionally the name, address and website of the organisation
#'   you collaborated with.
#' - `cooperation_logo`: Optionally the logo of the collaborator.
#'   Only used when `cooperation` is set.
#' - `geraardsbergen`: Set this to `TRUE` to add the address of INBO
#'   Geraardsbergen to the colophon.
#'   If not set or set to `FALSE` add the address of INBO Brussels.
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
#' - `github-repo`: You can optionally set the github repo in
#'   `organisation/repository` format (e.g. `inbo/INBOmd`).
#'   This will add an 'edit' button to the source file on GitHub.
#'   Note that only people with write access can edit the files directly in the
#'   repository.
#'   Others can only edit the source code in a fork of the repository and
#'   suggest the changes through a pull request.
#'
#' @section Multiple languages:
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

