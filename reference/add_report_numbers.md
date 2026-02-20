# Add the report numbers to a bookdown report

Add the report numbers to a bookdown report

## Usage

``` r
add_report_numbers(
  path = ".",
  doi,
  year,
  reportnr,
  depotnr,
  photo,
  description,
  embargo = Sys.Date(),
  ordernr,
  copies,
  motivation,
  pages
)
```

## Arguments

- path:

  the path to the `index.Rmd` of the bookdown report.

- doi:

  a string containing the DOI.

- year:

  Publication year

- reportnr:

  Report number assigned by the INBO library.

- depotnr:

  Report number assigned by the INBO library.

- photo:

  Link to an image to used on the cover.

- description:

  Description of `photo`, including author information.

- embargo:

  The earliest date at which the report can be made public on the INBO
  website. Defaults to today.

- ordernr:

  Optional reference number specified by the client.

- copies:

  Set the required number of copies in case you really need a printed
  version of the report. Omit in case you only require a digital
  version. Keep in mind that the INBO policy is to be "radically
  digital". Which implies to only print a report if it is mandatory.

- motivation:

  Required motivation in case `copies` is set to a non-zero number.

- pages:

  Number of pages of the report. Only required in case `copies` is set
  to a non-zero number.

## See also

Other utils:
[`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md),
[`check_dependencies()`](https://inbo.github.io/INBOmd/reference/check_dependencies.md),
[`column_start()`](https://inbo.github.io/INBOmd/reference/column_start.md),
[`column_width()`](https://inbo.github.io/INBOmd/reference/column_width.md),
[`cover_info()`](https://inbo.github.io/INBOmd/reference/cover_info.md),
[`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md),
[`dyn_table()`](https://inbo.github.io/INBOmd/reference/dyn_table.md),
[`inbo_website()`](https://inbo.github.io/INBOmd/reference/inbo_website.md),
[`prepare_cover()`](https://inbo.github.io/INBOmd/reference/prepare_cover.md),
[`references()`](https://inbo.github.io/INBOmd/reference/references.md),
[`render_natbib()`](https://inbo.github.io/INBOmd/reference/render_natbib.md),
[`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
