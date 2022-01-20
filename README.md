# INBOmd <img src="man/figures/logo.svg" align="right" alt="A hexagon with the word INBOmd and the Markdown logo" width="120" />

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle: stable](https://lifecycle.r-lib.org/articles/figures/lifecycle-stable.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
![License](https://img.shields.io/github/license/inbo/INBOmd)
[![R build status](https://github.com/inbo/inbomd/workflows/check%20package%20on%20main/badge.svg)](https://github.com/inbo/inbomd/actions)
[![Codecov test coverage](https://app.codecov.io/gh/inbo/inbomd/branch/main/graph/badge.svg)](https://app.codecov.io/gh/inbo/inbomd?branch=main)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/inbo/inbomd.svg)
![GitHub repo size](https://img.shields.io/github/repo-size/inbo/inbomd.svg)
[![DOI](https://zenodo.org/badge/66824259.svg)](https://zenodo.org/badge/latestdoi/66824259)

INBOmd contains templates to generate several types of documents with the corporate identity of INBO or the Flemish government.
The current package has following Rmarkdown templates:

- INBO report: reports rendered to pdf, html (gitbook style) and epub
- INBO slides: presentations rendered to pdf
- INBO poster: poster rendered to a A0 pdf
- Flanders slides: presentations using the Flemish corporate identity, rendered to pdf

The templates are available in RStudio using `File` > `New file` > `R Markdown` > `From template`.

More details, including instructions for installation and usage are available at the [INBOmd website](https://inbo.github.io/INBOmd/articles/introduction.html).

## In the wild

Below are some documents created with INBOmd

1. https://inbo.github.io/inbomd_examples
1. https://doi.org/10.21436/inbor.14030462
1. https://doi.org/10.21436/inbop.14901626
1. https://pureportal.inbo.be/portal/files/12819590/rbelgium_20170307.pdf
1. https://doi.org/10.21436/inbor.12304086

## Installation

INBOmd requires a working LaTeX distribution (for conversion of markdown
to pdf).
We highly recommend to use the LaTeX distribution provided by R
package TinyTeX.
Close all open R sessions and start a fresh R session.
Execute the commands below.
This will install the R package TinyTeX and the TinyTex LaTeX distribution
on your machine.
No admin rights are required.
Although TinyTeX is a lightweight installation, it still is several 100 MB large.

```
update.packages(ask = FALSE, checkBuilt = TRUE)
if (!"tinytex" %in% rownames(installed.packages())) {
  install.packages("tinytex")
}
# install the TinyTeX LaTeX distribution
if (!tinytex:::is_tinytex()) {
  tinytex::install_tinytex()
}
```

Once TinyTeX is installed, you need to restart RStudio.
Then you can proceed with the installation of `INBOmd`.

```
# installation from inbo.r-universe
install.packages("INBOmd", repos = "https://inbo.r-universe.dev")

## alternative: installation from github
#if (!"remotes" %in% rownames(installed.packages())) {
#  install.packages("remotes")
#}
#remotes::install_github("inbo/INBOmd", dependencies = TRUE)

# add the local latex package contained in INBOmd to the TinyTeX install 
tinytex::tlmgr_conf(
  c("auxtrees", "add", system.file("local_tex", package = "INBOmd"))
)

# install some other needed latex packages 
tinytex::tlmgr_install(c(
  "inconsolata", "times", "tex", "helvetic", "dvips", "hyphen-dutch",
  "hyphen-french"
))
```
