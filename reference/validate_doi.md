# validate a DOI

Checks the format of a DOI. The format must obey
https://www.doi.org/doi_handbook/2_Numbering.html#2.2 The DOI should the
minimal version. Hence no `doi:`, `https://doi.org` or other prefixes.
An example of a minimal version is `10.21436/inbor.70809860`. The part
before the forward slash consists of two or three sets of digits
separated by a dot. E.g. `10.21436` or `10.21436.1`. The part after the
forward slash consists either of only digits or of two sets of any
character separated by a dot.

## Usage

``` r
validate_doi(doi)
```

## Arguments

- doi:

  a string containing the DOI.

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
[`render_natbib()`](https://inbo.github.io/INBOmd/reference/render_natbib.md)
