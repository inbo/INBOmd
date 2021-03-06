% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inbo_handouts.R
\name{inbo_handouts}
\alias{inbo_handouts}
\title{Use the handout version of slides with the INBO theme
The only difference between inbo_slides() and inbo_handouts() is that
inbo_slides() can have progressive slides whereas inbo_handouts() only
displays the final slide.}
\usage{
inbo_handouts(
  subtitle,
  location,
  institute,
  cover,
  cover_offset,
  cover_hoffset,
  cover_horizontal = TRUE,
  toc_name,
  fontsize,
  codesize = c("footnotesize", "scriptsize", "tiny", "small", "normalsize"),
  citation_package = c("natbib", "none"),
  natbib_title,
  lang = "dutch",
  slide_level = 2,
  keep_tex = FALSE,
  toc = TRUE,
  website = "www.INBO.be",
  theme = c("inbo", "vlaanderen"),
  flandersfont = FALSE,
  ...
)
}
\arguments{
\item{subtitle}{The subtitle.}

\item{location}{The date and place of the event.}

\item{institute}{The affiliation of the authors.}

\item{cover}{The filename of the cover image.}

\item{cover_offset}{An optional vertical offset for the cover image.}

\item{cover_hoffset}{An optional horizontal offset for the cover image.}

\item{cover_horizontal}{Scale the cover horizontal (\code{TRUE}) or vertical
(\code{FALSE}).}

\item{toc_name}{Name of the table of contents.
Defaults to \code{"Overzicht"}.}

\item{fontsize}{The fontsize of the document.
Defaults to \code{"10pt"}.
See the section on aspect ratio.}

\item{codesize}{The fontsize of the code, relative to the fontsize of the
text (= normal size).
Allowed values are \code{"normalsize"}, \code{"small"}, \code{"footnotesize"},
\code{"scriptsize"} and \code{"tiny"}.
Defaults to \code{"footnotesize"}.}

\item{citation_package}{The LaTeX package to process citations, \code{natbib}
or \code{biblatex}. Use \code{none} if neither package is to be used.}

\item{natbib_title}{The title of the bibliography}

\item{lang}{The language of the document.
Defaults to \code{"dutch"}}

\item{slide_level}{Indicate which heading level is used for the frame titles}

\item{keep_tex}{Keep the tex file.
Defaults to \code{FALSE}.}

\item{toc}{display a table of content after the title slide}

\item{website}{An optional URL to display on the left sidebar.
Defaults to \code{"www.INBO.be"}.}

\item{theme}{The theme to use.
Available options are \code{"inbo"}, \code{"inboenglish"} and \code{"vlaanderen"}.}

\item{flandersfont}{If \code{TRUE} use the Flanders Art font.
If \code{FALSE} use Calibri.
Defaults to \code{FALSE}.}

\item{...}{extra parameters}
}
\description{
Use the handout version of slides with the INBO theme
The only difference between inbo_slides() and inbo_handouts() is that
inbo_slides() can have progressive slides whereas inbo_handouts() only
displays the final slide.
}
\seealso{
Other output: 
\code{\link{inbo_poster}()},
\code{\link{inbo_rapport}()},
\code{\link{inbo_slides}()},
\code{\link{inbo_verslag}()},
\code{\link{inbo_zending}()}
}
\concept{output}
