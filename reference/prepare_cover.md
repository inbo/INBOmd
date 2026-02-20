# Prepare a cover image from a PDF file

Extract the first page of a PDF file. Store this page as `cover.pdf` at
`path`. Also convert it to `cover.png`.

## Usage

``` r
prepare_cover(input, path = ".")
```

## Arguments

- input:

  Link to the PDF file which first becomes the cover.

- path:

  the path to the `index.Rmd` of the bookdown report.

## Value

Invisible `NULL`.

## See also

Other utils:
[`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md),
[`add_report_numbers()`](https://inbo.github.io/INBOmd/reference/add_report_numbers.md),
[`check_dependencies()`](https://inbo.github.io/INBOmd/reference/check_dependencies.md),
[`column_start()`](https://inbo.github.io/INBOmd/reference/column_start.md),
[`column_width()`](https://inbo.github.io/INBOmd/reference/column_width.md),
[`cover_info()`](https://inbo.github.io/INBOmd/reference/cover_info.md),
[`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md),
[`dyn_table()`](https://inbo.github.io/INBOmd/reference/dyn_table.md),
[`inbo_website()`](https://inbo.github.io/INBOmd/reference/inbo_website.md),
[`references()`](https://inbo.github.io/INBOmd/reference/references.md),
[`render_natbib()`](https://inbo.github.io/INBOmd/reference/render_natbib.md),
[`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
