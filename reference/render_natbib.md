# Render a Markdown file with `natbib` bibliography

Render a Markdown file with `natbib` bibliography

## Usage

``` r
render_natbib(
  file,
  path = ".",
  encoding = "UTF-8",
  engine = c("xelatex", "pdflatex"),
  display = TRUE,
  keep = c("none", "all", "tex"),
  clean = TRUE
)
```

## Arguments

- file:

  the name of the `Rmd` file.

- path:

  the path of the `Rmd` file.

- encoding:

  the encoding of the `Rmd` file. Default to 'UTF-8'.

- engine:

  the LaTeX engine the compile the document. Defaults to `"xelatex"`.

- display:

  open the pdf in a reader. Defaults to TRUE.

- keep:

  keep intermediate files after successful compilation. Defaults to
  "none".

- clean:

  TRUE to clean intermediate files created during rendering of the R
  markdown into `tex`.

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
[`prepare_cover()`](https://inbo.github.io/INBOmd/reference/prepare_cover.md),
[`references()`](https://inbo.github.io/INBOmd/reference/references.md),
[`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
