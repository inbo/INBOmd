# Create a cover.txt from the YAML header

You need to provide information to create the cover image and
(optionally) print the report. Add the information to the YAML header of
the report. Then run this function to covert the information into a
`cover.txt` and send that file along the other files to the review
process.

## Usage

``` r
cover_info(path = "index.Rmd")
```

## Arguments

- path:

  The path to the main `.Rmd` file.

## See also

Other utils:
[`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md),
[`add_report_numbers()`](https://inbo.github.io/INBOmd/reference/add_report_numbers.md),
[`check_dependencies()`](https://inbo.github.io/INBOmd/reference/check_dependencies.md),
[`column_start()`](https://inbo.github.io/INBOmd/reference/column_start.md),
[`column_width()`](https://inbo.github.io/INBOmd/reference/column_width.md),
[`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md),
[`dyn_table()`](https://inbo.github.io/INBOmd/reference/dyn_table.md),
[`inbo_website()`](https://inbo.github.io/INBOmd/reference/inbo_website.md),
[`prepare_cover()`](https://inbo.github.io/INBOmd/reference/prepare_cover.md),
[`references()`](https://inbo.github.io/INBOmd/reference/references.md),
[`render_natbib()`](https://inbo.github.io/INBOmd/reference/render_natbib.md),
[`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
