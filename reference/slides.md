# pdf slides with an INBO or Flanders theme

Returns an output format for
[`bookdown::render_book()`](https://pkgs.rstudio.com/bookdown/reference/render_book.html).

## Usage

``` r
slides(toc = TRUE, ...)
```

## Arguments

- toc:

  display a table of content after the title slide

- ...:

  currently ignored

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

## Available YAML headers options specific for slides

- `location`: optional text placed on the title slide below the
  (sub)title.

- `institute`: optional text placed on the title slide below the author.

- `toc`: add a slide with the table of content. Defaults to `TRUE`.

- `toc_name`: slide title for the table of content. Defaults to
  `Overzicht` when missing.

- `cover_photo`: the relative path to the image you want on the cover.
  When missing, you get a default picture.

- `cover_horizontal`: When omitted, scale the `cover_photo` so that it
  covers the full page vertically. When set to any value but `FALSE` or
  empty, scale the `cover_photo` so that it covers the full page
  horizontally.

- `cover_offset`: A measurement like `8mm` or `-1.5cm`. Positive values
  move the `cover_photo` upwards on the title slide. Negative values
  move the `cover_photo` downwards.

- `cover_hoffset`: Similar as `cover_offset` but moves `cover_photo`
  horizontally. Positive values move it to the right, negative values to
  the left.

- `aspect`: the required aspect ratio for the slides. Defaults to
  "16:9". See the section below for a list of the available aspect
  ratios.

- `fontsize`: Size of the normal text on the slides. Other elements are
  scaled accordingly. Defaults to "11pt". See the section *Aspect_ratio*
  for more details.

- `website`: URL in the sidebar. Defaults to `vlaanderen.be/inbo`.

## Aspect ratio

The table below lists the available aspect ratios and their "paper
size". The main advantage of using a small “paper size” is that you can
use all your normal fonts at their natural sizes. E.g. an 11pt font on a
slide is as readable as an 11pt font on a A4 paper.

|        |       |          |        |
|--------|-------|----------|--------|
| aspect | ratio | width    | height |
| 16:9   | 1.78  | 160.0 mm | 90 mm  |
| 16:10  | 1.60  | 160.0 mm | 100 mm |
| 14:9   | 1.56  | 140.0 mm | 90 mm  |
| 3:2    | 1.50  | 135.0 mm | 90 mm  |
| 1.4:1  | 1.41  | 148.5 mm | 105 mm |
| 4:3    | 1.33  | 128.0 mm | 96 mm  |
| 5:4    | 1.25  | 125.0 mm | 100 mm |

## See also

Other output:
[`epub_book()`](https://inbo.github.io/INBOmd/reference/epub_book.md),
[`gitbook()`](https://inbo.github.io/INBOmd/reference/gitbook.md),
[`handouts()`](https://inbo.github.io/INBOmd/reference/handouts.md),
[`minutes()`](https://inbo.github.io/INBOmd/reference/minutes.md),
[`mission()`](https://inbo.github.io/INBOmd/reference/mission.md),
[`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md),
[`poster()`](https://inbo.github.io/INBOmd/reference/poster.md)
