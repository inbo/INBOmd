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
#'   Used in the same places as `shortauthor`.
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
#' - `client`: Optionally the name, address and website of the client.
#' - `client_logo`: Optionally the logo of the client.
#'   Only used when `client` is set.
#' - `cooperation`: Optionally the name, address and website of the organisation
#'   you collaborated with.
#' - `cooperation_logo`: Optionally the logo of the collaborator.
#'   Only used when `cooperation` is set.
#' - `geraardsbergen`: Set this to `TRUE` to add the address of INBO
#'   Geraardsbergen to the colophon.
#'   If not set or set to `FALSE` add the address of INBO Brussel.
