# INBOmd 0.6.1

* `slides()` no longer requires a reviewer.
* Bugfixes in `create_report()`.

# INBOmd 0.6.0

## Breaking changes

* Author and reviewer information must be given in an explicit format with
  mandatory `name` with mandatory sub-fields `given` and `family`.
  `corresponding: true` indicates the corresponding author.
  `email` is optional, except for the corresponding author.
  `orcid` is optional for all persons.

## Other changes

* Add `create_report()` to interactively create an empty report.
* Add `add_report_numbers()` to add the DOI, report number, ... to an existing
  report.
* Add `add_author()` to interactively add an author to an existing report.
* Add `validate_doi()` to validate a DOI.
  `pdf_report()`, `gitbook()` and `epub_book()` use this function to validate
  the optional DOI when set.

# INBOmd 0.5.3

* Rename `report()` to `pdf_report()` and `epub()` to `epub_book()`.
  `bookdown` requires the name of the generic output format to be in the name.
* Convert covers to `png` instead of `jpg` to avoid the typical artefacts around
  text.
* Automatically add an "Edit" to gitbook when the report is available in a git
  repository.

# INBOmd 0.5.2

* Templates now mention url `vlaanderen.be/inbo` instead of
  `https://www.vlaanderen.be/inbo` or `www.vlaanderen.be/inbo`.
* Bug fix website `"inbomd_examples"`.
* `gitbook()` uses the same reference title for chapter bibliographies as the
  main bibliography.
* `references()` takes `lang` into account for HTML formats.
* Bugfix in `Dockerfile`.

# INBOmd 0.5.1

* Add language French for style Flanders

# INBOmd 0.5.0

## Breaking changes

* Every output format has now its dedicated function using the English name.
  We no longer use prefixes.
  The YAML options are now uniform across the output formats.
  Please have a look at the documentation of the output format to find a list
  with the available options.
  Below is the list of the old output formats and their new name.
* `bookdown::pdf_book` with `INBOmd::inbo_rapport` -> `INBOmd::report`
* `bookdown::gitbook` -> `INBOmd::gitbook`
* `bookdown::epub_book` -> `INBOmd::ebook`
* `bookdown::pdf_book` with `INBOmd::inbo_slides` ->
  `INBOmd::slides` for the presentation, `INBOmd::handouts` for handouts,
  `INBOmd::report` for handouts with lots of R code and output (useful for
  R tutorials and courses)

## User visible changes

* Use pandoc to render citations with `report()` on pdf instead of natbib
  (#63, @ThierryO).
* `report()` supports custom languages when using `style = "Flanders"`
  (#64, @ThierryO).
* Update CSL style to most recent version (#63, @florisvdh).
* Add colophon to reports in pdf, gitbook and epub formats.
* Rendering the pdf reports generates a `cover.txt`.
  This files contains the required information to create the cover page.
* New function `references()` allows to define the location where to insert
  the bibliography.
  The optional appendix starts after the bibliography.
* `slides()` generates a visible table of content (#66).
* Update the `report()` RMarkdown [template](https://rstudio.github.io/rstudio-extensions/rmarkdown_templates.html).
  It contains all available options in the YAML header.
* Add a new template for a non-Dutch report with English as default language.
* Reports use Calibri as default font.
* Gitbook reports gains a thumbnail of the report on top of the table of content
  when the user provides a cover image.
* Gitbook and epub formats gain an English variant.

## Internal changes

* Setup quality assurance using [checklist](https://inbo.github.io/checklist/).

# INBOmd 0.4.9

* Update CSL style to most recent version (#61, @thierryo).
* Slides template allows different aspect ratios (#60, @thierryo).

# INBOmd 0.4.8 (2020-05-12)

* bugfix in `dyn_table()` function
* bugfix in `inbo_rapport()` function
* overhaul of the `csl` and `bst` citation styles
* minor tweaks in gitbook, epub and LaTeX styles for reports
* upgrade to Roxygen 7.1.0
* upgrade Docker image
* bugfix in CI

# INBOmd 0.4.7

* new `dyn_table()` function
* some tweaks to the report styles

# INBOmd 0.4.6

* slides gains a logo argument
* add report templates with Flemish corporate identity in Dutch and English
* update Flanders Art font

# INBOmd 0.4.5

* `inbo_rapport()` gains a `tocdepth` argument
* updated installation instructions

# INBOmd 0.4.4

* INBO theme for English presentation

# INBOmd 0.4.3

* add `inbo_poster()`
* add `inbo_report_css()`
* add report template for gitbook
* import report template for pdf
* create add-ins for RStudio

# INBOmd 0.4.2

* `inbo_rapport()` gains a `flandersfont` argument
* natbib citation style is updated
* hyperlinks have a bluish colour instead of fuchsia
* LaTeX style for `inbo_rapport()` updated
* draft of gitbook style for `inbo_rapport()`
* draft of epub style for `inbo_rapport()`

# INBOmd 0.4.1.1

* `inbo_rapport()` now handles UTF-8 strings (like éëèï...) correctly
* the package now displays at warning message at startup about the configuration
