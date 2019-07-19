[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![License](http://img.shields.io/badge/license-GPL--3-blue.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
[![DOI](https://zenodo.org/badge/66824259.svg)](https://zenodo.org/badge/latestdoi/66824259)
[![wercker status](https://app.wercker.com/status/9088599e5217a85e3ed003956a05e2ee/s/master "wercker status")](https://app.wercker.com/project/byKey/9088599e5217a85e3ed003956a05e2ee)

# INBOmd

INBOmd contains templates to generate several types of documents with the corporate identity of INBO or the Flemish goverment. The current package as following Rmarkdown templates:

- INBO report: reports rendered to pdf, html (gitbook style) and epub
- INBO slides: presentations rendered to pdf
- INBO poster: poster rendered to a A0 pdf
- Flanders slides: presentations using the Flemish corporate identity, rendered to pdf

The templates are available in RStudio using `File` > `New file` > `R Markdown` > `From template`.

More details, including instructions for installation and usage are available at the [INBOmd website](https://inbomd.netlify.com/articles/introduction.html).

## In the wild

Below are some documents created with INBOmd

1. https://inbomd-examples.netlify.com
1. https://doi.org/10.21436/inbor.14030462
1. https://doi.org/10.21436/inbop.14901626
1. https://pureportal.inbo.be/portal/files/12819590/rbelgium_20170307.pdf
1. https://doi.org/10.21436/inbor.12304086

## Installation

INBOmd requires a working installation of XeLaTeX. We highly recommend to use the TinyTeX. Close all open R sessions and start a fresh R session. Execute the commands below. This will install TinyTeX on your machine. No admin rights are required. Although TinyTeX is a lightweight installation, it still is several 100 MB large.

```{r eval = FALSE}
update.packages(ask = FALSE, checkBuilt = TRUE)
if (!"tinytex" %in% rownames(installed.packages())) {
  install.packages("tinytex")
  tinytex::install_tinytex()
}
```

Once TinyTeX is installed, you need to restart RStudio. Then you can proceed with the installation of `INBOmd`.

```{r eval = FALSE}
if (!"remotes" %in% rownames(installed.packages())) {
  install.packages("remotes")
}
remotes::install_github("inbo/INBOmd", dependencies = TRUE, upgrade = FALSE)
tinytex::tlmgr_install(c(
  'inconsolata', 'times', 'tex', 'helvetic', 'dvips'
))
tinytex::tlmgr_conf(
  c("auxtrees", "add", system.file("local_tex", package = "INBOmd"))
)
tinytex::tlmgr_install(c("hyphen-dutch", "hyphen-french"))
```
