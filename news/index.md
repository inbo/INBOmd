# Changelog

## INBOmd 0.6.5

- Use latest version of `citeme` and `checklist`.

## INBOmd 0.6.4

- Fix missing subtitle in citation in colophon of gitbook and epub.

## INBOmd 0.6.3

- [`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md)
  enforces pandoc \>= 3.1.8
- [`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md)
  fixed ([\#97](https://github.com/inbo/inbomd/issues/97))

## INBOmd 0.6.2

- [`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md),
  [`gitbook()`](https://inbo.github.io/INBOmd/reference/gitbook.md) and
  [`epub_book()`](https://inbo.github.io/INBOmd/reference/epub_book.md)
  gain an option to create internal reports with a different colophon.
- [`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md)
  and [`gitbook()`](https://inbo.github.io/INBOmd/reference/gitbook.md)
  gain a watermark argument. It adds a text watermark in the margin of
  every page. An automatic watermark appears when one of the required
  colophon fields is missing. Adding the information for all required
  colophon fields will remove this automatic watermark.
- All INBO personnel must display proper affiliation and ORCID.
- Bugfixes

## INBOmd 0.6.1

- INBO authors and reviewers now must use their `orcid` and a
  standardised `affiliation`. We infer INBO membership from the author’s
  email address.
- [`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md)
  and
  [`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md)
  will set the INBO author affiliation in the language of the report.
- [`slides()`](https://inbo.github.io/INBOmd/reference/slides.md) no
  longer requires a reviewer.
- Install missing `TinyTeX` installation or packages.
- Bugfixes in
  [`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md).

## INBOmd 0.6.0

### Breaking changes

- Author and reviewer information must be given in an explicit format
  with mandatory `name` with mandatory sub-fields `given` and `family`.
  `corresponding: true` indicates the corresponding author. `email` is
  optional, except for the corresponding author. `orcid` is optional for
  all persons.

### Other changes

- Add
  [`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md)
  to interactively create an empty report.
- Add
  [`add_report_numbers()`](https://inbo.github.io/INBOmd/reference/add_report_numbers.md)
  to add the DOI, report number, … to an existing report.
- Add
  [`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md)
  to interactively add an author to an existing report.
- Add
  [`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
  to validate a DOI.
  [`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md),
  [`gitbook()`](https://inbo.github.io/INBOmd/reference/gitbook.md) and
  [`epub_book()`](https://inbo.github.io/INBOmd/reference/epub_book.md)
  use this function to validate the optional DOI when set.

## INBOmd 0.5.3

- Rename
  [`report()`](https://inbo.github.io/INBOmd/reference/deprecated.md) to
  [`pdf_report()`](https://inbo.github.io/INBOmd/reference/pdf_report.md)
  and `epub()` to
  [`epub_book()`](https://inbo.github.io/INBOmd/reference/epub_book.md).
  `bookdown` requires the name of the generic output format to be in the
  name.
- Convert covers to `png` instead of `jpg` to avoid the typical
  artefacts around text.
- Automatically add an “Edit” to gitbook when the report is available in
  a git repository.

## INBOmd 0.5.2

- Templates now mention url `vlaanderen.be/inbo` instead of
  `https://www.vlaanderen.be/inbo` or `www.vlaanderen.be/inbo`.
- Bug fix website `"inbomd_examples"`.
- [`gitbook()`](https://inbo.github.io/INBOmd/reference/gitbook.md) uses
  the same reference title for chapter bibliographies as the main
  bibliography.
- [`references()`](https://inbo.github.io/INBOmd/reference/references.md)
  takes `lang` into account for HTML formats.
- Bugfix in `Dockerfile`.

## INBOmd 0.5.1

- Add language French for style Flanders

## INBOmd 0.5.0

### Breaking changes

- Every output format has now its dedicated function using the English
  name. We no longer use prefixes. The YAML options are now uniform
  across the output formats. Please have a look at the documentation of
  the output format to find a list with the available options. Below is
  the list of the old output formats and their new name.
- [`bookdown::pdf_book`](https://pkgs.rstudio.com/bookdown/reference/pdf_book.html)
  with
  [`INBOmd::inbo_rapport`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  -\>
  [`INBOmd::report`](https://inbo.github.io/INBOmd/reference/deprecated.md)
- [`bookdown::gitbook`](https://pkgs.rstudio.com/bookdown/reference/gitbook.html)
  -\>
  [`INBOmd::gitbook`](https://inbo.github.io/INBOmd/reference/gitbook.md)
- [`bookdown::epub_book`](https://pkgs.rstudio.com/bookdown/reference/epub_book.html)
  -\>
  [`INBOmd::ebook`](https://inbo.github.io/INBOmd/reference/deprecated.md)
- [`bookdown::pdf_book`](https://pkgs.rstudio.com/bookdown/reference/pdf_book.html)
  with
  [`INBOmd::inbo_slides`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  -\>
  [`INBOmd::slides`](https://inbo.github.io/INBOmd/reference/slides.md)
  for the presentation,
  [`INBOmd::handouts`](https://inbo.github.io/INBOmd/reference/handouts.md)
  for handouts,
  [`INBOmd::report`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  for handouts with lots of R code and output (useful for R tutorials
  and courses)

### User visible changes

- Use pandoc to render citations with
  [`report()`](https://inbo.github.io/INBOmd/reference/deprecated.md) on
  pdf instead of natbib
  ([\#63](https://github.com/inbo/inbomd/issues/63),
  [@ThierryO](https://github.com/ThierryO)).
- [`report()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  supports custom languages when using `style = "Flanders"`
  ([\#64](https://github.com/inbo/inbomd/issues/64),
  [@ThierryO](https://github.com/ThierryO)).
- Update CSL style to most recent version
  ([\#63](https://github.com/inbo/inbomd/issues/63),
  [@florisvdh](https://github.com/florisvdh)).
- Add colophon to reports in pdf, gitbook and epub formats.
- Rendering the pdf reports generates a `cover.txt`. This files contains
  the required information to create the cover page.
- New function
  [`references()`](https://inbo.github.io/INBOmd/reference/references.md)
  allows to define the location where to insert the bibliography. The
  optional appendix starts after the bibliography.
- [`slides()`](https://inbo.github.io/INBOmd/reference/slides.md)
  generates a visible table of content
  ([\#66](https://github.com/inbo/inbomd/issues/66)).
- Update the
  [`report()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  RMarkdown
  [template](https://rstudio.github.io/rstudio-extensions/rmarkdown_templates.html).
  It contains all available options in the YAML header.
- Add a new template for a non-Dutch report with English as default
  language.
- Reports use Calibri as default font.
- Gitbook reports gains a thumbnail of the report on top of the table of
  content when the user provides a cover image.
- Gitbook and epub formats gain an English variant.

### Internal changes

- Setup quality assurance using
  [checklist](https://inbo.github.io/checklist/).

## INBOmd 0.4.9

- Update CSL style to most recent version
  ([\#61](https://github.com/inbo/inbomd/issues/61),
  [@thierryo](https://github.com/thierryo)).
- Slides template allows different aspect ratios
  ([\#60](https://github.com/inbo/inbomd/issues/60),
  [@thierryo](https://github.com/thierryo)).

## INBOmd 0.4.8 (2020-05-12)

- bugfix in
  [`dyn_table()`](https://inbo.github.io/INBOmd/reference/dyn_table.md)
  function
- bugfix in
  [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  function
- overhaul of the `csl` and `bst` citation styles
- minor tweaks in gitbook, epub and LaTeX styles for reports
- upgrade to Roxygen 7.1.0
- upgrade Docker image
- bugfix in CI

## INBOmd 0.4.7

- new
  [`dyn_table()`](https://inbo.github.io/INBOmd/reference/dyn_table.md)
  function
- some tweaks to the report styles

## INBOmd 0.4.6

- slides gains a logo argument
- add report templates with Flemish corporate identity in Dutch and
  English
- update Flanders Art font

## INBOmd 0.4.5

- [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  gains a `tocdepth` argument
- updated installation instructions

## INBOmd 0.4.4

- INBO theme for English presentation

## INBOmd 0.4.3

- add
  [`inbo_poster()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
- add `inbo_report_css()`
- add report template for gitbook
- import report template for pdf
- create add-ins for RStudio

## INBOmd 0.4.2

- [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  gains a `flandersfont` argument
- natbib citation style is updated
- hyperlinks have a bluish colour instead of fuchsia
- LaTeX style for
  [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  updated
- draft of gitbook style for
  [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
- draft of epub style for
  [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)

## INBOmd 0.4.1.1

- [`inbo_rapport()`](https://inbo.github.io/INBOmd/reference/deprecated.md)
  now handles UTF-8 strings (like éëèï…) correctly
- the package now displays at warning message at startup about the
  configuration
