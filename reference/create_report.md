# Create a template for an INBOmd bookdown report

This function is defunct. Use `flandersqmd::create_report()` instead.

## Usage

``` r
create_report(path = ".", shortname)
```

## Arguments

- path:

  The folder in which to create the folder containing the report.
  Defaults to the current working directory.

- shortname:

  The name of the report project. The location of the folder `shortname`
  depends on the content of `path`. When `path` is a subfolder of a git
  repository, it is changed to the root of that git repository. When
  `path` is a
  [`checklist::checklist`](https://inbo.github.io/checklist/reference/checklist.html)
  project, you will find the new report at `path/source/shortname`. When
  `path` is a
  [`checklist::checklist`](https://inbo.github.io/checklist/reference/checklist.html)
  package, you will find the new report at `path/inst/shortname`.
  Otherwise you will find the new report at `path/shortname`.

## See also

Other utils:
[`add_author()`](https://inbo.github.io/INBOmd/reference/add_author.md),
[`add_report_numbers()`](https://inbo.github.io/INBOmd/reference/add_report_numbers.md),
[`check_dependencies()`](https://inbo.github.io/INBOmd/reference/check_dependencies.md),
[`column_start()`](https://inbo.github.io/INBOmd/reference/column_start.md),
[`column_width()`](https://inbo.github.io/INBOmd/reference/column_width.md),
[`cover_info()`](https://inbo.github.io/INBOmd/reference/cover_info.md),
[`dyn_table()`](https://inbo.github.io/INBOmd/reference/dyn_table.md),
[`inbo_website()`](https://inbo.github.io/INBOmd/reference/inbo_website.md),
[`prepare_cover()`](https://inbo.github.io/INBOmd/reference/prepare_cover.md),
[`references()`](https://inbo.github.io/INBOmd/reference/references.md),
[`render_natbib()`](https://inbo.github.io/INBOmd/reference/render_natbib.md),
[`validate_doi()`](https://inbo.github.io/INBOmd/reference/validate_doi.md)
