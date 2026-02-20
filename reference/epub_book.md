# Style for e-book

A version of
[`bookdown::epub_book()`](https://pkgs.rstudio.com/bookdown/reference/epub_book.html)
with a different styling.

## Usage

``` r
epub_book()
```

## Available YAML headers options shared among output formats

- **`title`**: the main title

- `subtitle`: the optional subtitle

- **`author`**: the authors formatted as indicated in the section below.

- `flandersfont`: if set to `TRUE`, use the Flanders Art Sans font. When
  not set, or set to `FALSE` or empty, use the Calibri font.

- `style`: Defaults to "INBO" when missing.

  - `"INBO"` for the INBO style.

  - `"Vlaanderen"` for the generic style of the Flemish Government in
    Dutch.

  - `"Flanders"` for the generic style of the Flemish Government in a
    language other than Dutch.

- `lang`: the main language of the document as [RFC
  5646](https://datatracker.ietf.org/doc/html/rfc5646) tags. `style`
  `"INBO"` and `"Vlaanderen"` require `"nl"` as `lang`. `style`
  `"Flanders"` uses `"en"` as default and can use other languages (but
  not `"nl"`).

  - `"nl"` for Dutch

  - `"en"` for English

  - `"fr"` for French

- `codesize`: Relative size of R code compared to normal text. Defaults
  to `"footnotesize"`. All options going from large to small are:
  `"normalsize"`, `"small"`, `"footnotesize"`, `"scriptsize"`, `"tiny"`.
  `"normalsize"` implies the same size as normal text.

## Formatting author information

Quotes are required when a part contains spaces. If the author doesn't
have an ORCID, you can omit that line. However, note that the INBO
policy is that all scientific personnel is required to obtain an ORCID
from https://orcid.org. Add `corresponding: true` to the corresponding
author.

      - name:
         given: "Authors first name"
         family: "Authors last name"
        email: "local-part@domain.com"
        orcid: 0000-0002-1825-0097
        corresponding: true

## Available YAML headers options specific for reports

Bold items are required when creating a public report. Omitting them
results in an ugly warning in the rendered document. This is deliberate
done so you can prepare the document without adding the information. But
the ugly warnings nudges you to add the required information before
publication.

- `public_report`: A logical value indicating whether the report will be
  published or not. Setting `public_report: FALSE` will alter the
  colophon. Omitting `public_report` is equivalent to
  `public_report: TRUE`. An internal report can't have a DOI. Setting a
  DOI is equivalent to `public_report: TRUE`.

- **`reviewer`**: names of the reviewers. Use the same syntax as for the
  authors.

- **`year`**: year of publication. Used in the same places as
  `shortauthor`.

- **`cover_photo`**: the relative path to the image you want on the
  cover.

- **`cover_description`**: Description of the cover photo, including
  information on the author of the picture and license information.

- `cover` the relative path to a pdf with the cover provided by the
  graphical designer. The first page of this pdf will be prepended to
  the pdf version of the report. It becomes the title page in the web
  and e-book version of the report. And also shows as a thumbnail in the
  floating table of content in the web version.

- **`doi`**: the Digital Object Identifier of the report. Used in
  conjunction with `shortauthor` and `year`.

- **`reportnr`**: Report number assigned by the INBO library.

- `ordernr`: Optional reference number specified by the client.

- **`depotnr`**: Report number assigned by the INBO library.

- `client`: Optionally the name, address and website of the client.

- `client_logo`: Optionally the logo of the client. Only used when
  `client` is set.

- `cooperation`: Optionally the name, address and website of the
  organisation you collaborated with.

- `cooperation_logo`: Optionally the logo of the collaborator. Only used
  when `cooperation` is set.

- `geraardsbergen`: Set this to `TRUE` to add the address of INBO
  Geraardsbergen to the colophon. If not set or set to `FALSE` add the
  address of INBO Brussels.

- `watermark`: an optional text to display as a watermark on the pdf or
  html. Note that omitting any of the required element will
  automatically generate a watermark with the text `"DRAFT"`. Fill all
  required fields to get ride of this automatic watermark.

## See also

Other output:
[`gitbook()`](https://inbo.github.io/INBOmd/reference/gitbook.md),
[`handouts()`](https://inbo.github.io/INBOmd/reference/handouts.md),
[`minutes()`](https://inbo.github.io/INBOmd/reference/minutes.md),
[`mission()`](https://inbo.github.io/INBOmd/reference/mission.md),
[`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md),
[`poster()`](https://inbo.github.io/INBOmd/reference/poster.md),
[`slides()`](https://inbo.github.io/INBOmd/reference/slides.md)
