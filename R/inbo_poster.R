#' Create a poster with the INBO theme version 2015
#' @param subtitle An optional subtitle
#' @param email The email address to display at the bottom.
#' Defaults to info@inbo.be
#' @param lang The language of the document. Defaults to "english".
#' @param fig_crop \code{TRUE} to automatically apply the \code{pdfcrop} utility
#'   (if available) to pdf figures
#' @param pandoc_args Additional command line options to pass to pandoc
#' @inheritParams inbo_slides
#' @inheritParams rmarkdown::pdf_document
#' @param ... extra parameters: see details
#'
#' @details
#' Available extra parameters:
#'    - hyphenation: the correct hyphenation for certain words
#'    - flandersfont: Use the Flanders Art Sans font. Defaults to FALSE.
#'    Note that this requires the font to be present on the system.
#'    - ORCID: a list of authors. For each author there must a `name` and an
#'    `ID`. The `ID` is the author's ORCID ID , ee https://orcid.org.
#'    This information will be displayed with QR code at the bottom of the
#'    poster.
#'    - DOI: a list of documents. For each documentr there must a `name` and an
#'    `ID`. The `ID` is the documents's DOI, see https://doi.org.
#'    This information will be displayed with QR code at the bottom of the
#'    poster.
#' @export
#' @importFrom rmarkdown output_format knitr_options pandoc_options
#' pandoc_variable_arg includes_to_pandoc_args pandoc_version
#' @importFrom utils compareVersion
#' @importFrom grDevices pdf dev.off
#' @importFrom graphics par image
#' @importFrom qrcode qrcode_gen
#' @family output
inbo_poster <- function(
  subtitle,
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  lang = "english",
  email = "info@inbo.be",
  keep_tex = FALSE,
  fig_crop = TRUE,
  citation_package = c("natbib", "none"),
  includes = NULL,
  pandoc_args = NULL,
  ...
) {
  check_dependencies()
  extra <- list(...)
  codesize <- match.arg(codesize)

  template <- system.file("pandoc/inbo_poster.tex", package = "INBOmd")
  csl <- system.file("research-institute-for-nature-and-forest.csl",
                     package = "INBOmd")

  args <- c(
    "--template", template,
    pandoc_variable_arg("documentclass", "report"),
    pandoc_variable_arg("codesize", codesize),
    pandoc_variable_arg("lang", lang),
    pandoc_variable_arg("email", email)
  )
  if (compareVersion(as.character(pandoc_version()), "2") < 0) {
    args <- c(args, "--latex-engine", "xelatex", pandoc_args) #nocov
  } else {
    args <- c(args, "--pdf-engine", "xelatex", pandoc_args)
  }

  # citations
  citation_package <- match.arg(citation_package)
  if (citation_package == "none") {
    args <- c(args, "--csl", pandoc_path_arg(csl))
  } else {
    args <- c(args, paste0("--", citation_package))
  }
  # content includes
  args <- c(args, includes_to_pandoc_args(includes))

  if (!missing(subtitle)) {
    args <- c(args, pandoc_variable_arg("subtitle", subtitle))
  }
  if (!"flandersfont" %in% names(extra)) {
    extra$flandersfont <- FALSE
  }
  if (extra$flandersfont) {
    args <- c(args, pandoc_variable_arg("flandersfont", TRUE))
  }
  extra <- extra[!names(extra) %in% c("flandersfont")]
  if (any(c("ORCID", "DOI") %in% names(extra))) {
    if (!"ORCID" %in% names(extra)) {
      orcidqr <- matrix(character(0), nrow = 3)
    } else {
      orcidqr <- sapply(
        extra$ORCID,
        function(this_orcid) {
          url <- paste0("https://orcid.org/", this_orcid$ID)
          qr <- qrcode_gen(url, plotQRcode = FALSE, dataOutput = TRUE)
          qr_file <- sprintf("orcid-qr-%s.pdf", gsub(" ", "-", this_orcid$name))
          pdf(qr_file, width = 1.4, height = 1.4)
          par(mai = rep(0, 4), mar = rep(0, 4))
          image(qr, asp = 1, col = c("#C04384", "#FFFFFF"), axes = FALSE)
          dev.off()
          c(
            this_orcid$name,
            sprintf("\\includegraphics[height=12pt]{orcid.png} %s", url),
            sprintf("\\includegraphics{%s}", qr_file)
          )
        }
      )
    }
    if (!"DOI" %in% names(extra)) {
      doiqr <- matrix(character(0), nrow = 3)
    } else {
      doiqr <- sapply(
        extra$DOI,
        function(this_doi) {
          url <- paste0("https://doi.org/", this_doi$ID)
          qr <- qrcode_gen(url, plotQRcode = FALSE, dataOutput = TRUE)
          qr_file <- sprintf("doi-qr-%s.pdf", gsub(" ", "-", this_doi$name))
          pdf(qr_file, width = 1.4, height = 1.4)
          par(mai = rep(0, 4), mar = rep(0, 4))
          image(qr, asp = 1, col = c("#C04384", "#FFFFFF"), axes = FALSE)
          dev.off()
          c(
            this_doi$name,
            sprintf("%s", url),
            sprintf("\\includegraphics{%s}", qr_file)
          )
        }
      )
    }
    qr <- cbind(doiqr, orcidqr)
    cols <- ncol(qr)
    qr <- apply(qr, 1, paste, collapse = " & ")
    qr <- paste(paste(qr, "\\\\"), collapse = "\n")
    qr <- sprintf(
      "\\begin{tabular}{%s}\n%s\n\\end{tabular}",
      paste(rep("l", cols), collapse = ""),
      qr
    )
    args <- c(args, pandoc_variable_arg("qr", qr))
  }
  extra <- extra[!names(extra) %in% c("ORCID", "DOI")]
  if (length(extra) > 0) {
    args <- c(
      args,
      sapply(
        names(extra),
        function(x) {
          pandoc_variable_arg(x, extra[[x]])
        }
      )
    )
  }
  opts_chunk <- list(
    latex.options = "{}",
    dev = "pdf",
    fig.align = "center",
    dpi = 300,
    fig.width = 4.5,
    fig.height = 2.9
  )
  crop <- fig_crop &&
    !identical(.Platform$OS.type, "windows") &&
    nzchar(Sys.which("pdfcrop"))
  if (crop) {
    knit_hooks <- list(crop = knitr::hook_pdfcrop)
    opts_chunk$crop <- TRUE
  } else {
    knit_hooks <- NULL
  }

  post_processor <- function(metadata, input, output, clean, verbose) {
    text <- readLines(output, warn = FALSE)

    #nolint start
    text <- gsub("\\\\b(.*)block", "\\\\begin{\\1block}", text)
    text <- gsub("\\\\e(.*)block", "\\\\end{\\1block}", text)
    text <- gsub("\\\\bmulticols", "\\\\begin{multicols}", text)
    text <- gsub("\\\\emulticols", "\\\\end{multicols}", text)
    #nolint end

    writeLines(enc2utf8(text), output, useBytes = FALSE)
    output
  }

  output_format(
    knitr = knitr_options(
      opts_knit = list(
        width = 96,
        concordance = TRUE
      ),
      opts_chunk = opts_chunk,
      knit_hooks = knit_hooks
    ),
    pandoc = pandoc_options(
      to = "latex",
      latex_engine = "xelatex",
      args = args,
      keep_tex = keep_tex
    ),
    post_processor = post_processor,
    clean_supporting = !keep_tex
  )
}
