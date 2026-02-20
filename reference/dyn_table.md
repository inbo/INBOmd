# Use a different table style depending on the output format

- **interactive session**:
  [`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html)

- **html**:
  [`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html)

- **other**:
  [`knitr::kable()`](https://rdrr.io/pkg/knitr/man/kable.html)

## Usage

``` r
dyn_table(x, caption = NULL, rownames = FALSE, escape = TRUE, align, ...)
```

## Arguments

- x:

  the dataframe

- caption:

  the table caption; a character vector or a tag object generated from
  `htmltools::tags$caption()`

- rownames:

  `TRUE` (show row names) or `FALSE` (hide row names) or a character
  vector of row names; by default, the row names are displayed in the
  first column of the table if exist (not `NULL`)

- escape:

  whether to escape HTML entities in the table: `TRUE` means to escape
  the whole table, and `FALSE` means not to escape it; alternatively,
  you can specify numeric column indices or column names to indicate
  which columns to escape, e.g. `1:5` (the first 5 columns),
  `c(1, 3, 4)`, or `c(-1, -3)` (all columns except the first and third),
  or `c('Species', 'Sepal.Length')`; since the row names take the first
  column to display, you should add the numeric column indices by one
  when using `rownames`

- align:

  Column alignment: a character vector consisting of `'l'` (left), `'c'`
  (center) and/or `'r'` (right). By default or if `align = NULL`,
  numeric columns are right-aligned, and other columns are left-aligned.
  If `length(align) == 1L`, the string will be expanded to a vector of
  individual letters, e.g. `'clc'` becomes `c('c', 'l', 'c')`, unless
  the output format is LaTeX.

- ...:

  Other arguments (see Examples and References).

## See also

Other utils:
[`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md),
[`add_report_numbers()`](https://inbo.github.io/INBOmd/reference/add_report_numbers.md),
[`check_dependencies()`](https://inbo.github.io/INBOmd/reference/check_dependencies.md),
[`column_start()`](https://inbo.github.io/INBOmd/reference/column_start.md),
[`column_width()`](https://inbo.github.io/INBOmd/reference/column_width.md),
[`cover_info()`](https://inbo.github.io/INBOmd/reference/cover_info.md),
[`create_report()`](https://inbo.github.io/INBOmd/reference/create_report.md),
[`inbo_website()`](https://inbo.github.io/INBOmd/reference/inbo_website.md),
[`prepare_cover()`](https://inbo.github.io/INBOmd/reference/prepare_cover.md),
[`references()`](https://inbo.github.io/INBOmd/reference/references.md),
[`render_natbib()`](https://inbo.github.io/INBOmd/reference/render_natbib.md),
[`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
