[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![License](http://img.shields.io/badge/license-GPL--3-blue.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html)
[![DOI](https://zenodo.org/badge/66824259.svg)](https://zenodo.org/badge/latestdoi/66824259)
[![wercker status](https://app.wercker.com/status/9088599e5217a85e3ed003956a05e2ee/s/master "wercker status")](https://app.wercker.com/project/byKey/9088599e5217a85e3ed003956a05e2ee)

# INBOmd

INBOmd contains templates to generate several types of documents with the corporate identity of INBO or the Flemish goverment. The table below indicates what is currently available.

| Document type   | Template | Rmd | Rnw | Tex |
| --------------- | -------- | --- | --- | --- |
| INBO report     |     X    |  X  |  X  |  X  |
| INBO slides     |     X    |  X  |  X  |  X  |
| INBO poster     |          |     |  X  |  X  |
| Flanders slides |     X    |  X  |  X  |  X  |

- Template
    - R Markdown template. 
    - Available in RStudio using `File` > `New file` > `R Markdown` > `From template`.
    - Available in R using `rmarkdown::draft(package = "INBOmd")`

- Rmd
    - Render function available for R Markdown documents

- Rnw and Tex
    - LaTeX package available. Currently only required for INBO poster. We recommend to use the templates with R Markdown where available.

## Installation

INBOmd requires a working installation of XeLaTeX. We highly recommend to use the TinyTeX. Close all open R sessions and start a fresh R session. Execute the commands below. This will install TinyTeX on your machine. No admin rights are required. Although TinyTeX is a lightweight installation, it still is several 100 MB large.

```R
install.packages("tinytex")
tinytex::install_tinytex()
```

Once TinyTeX you need to restart RStudio. Then you can proceed with the installation of `INBOmd`.

```R
install.packages("webshot")
# install.packages("devtools")
devtools::install_github("rstudio/bookdown")
devtools::install_github("thierryo/qrcode")
devtools::install_github("inbo/INBOtheme")
devtools::install_github("inbo/INBOmd")
tinytex::tlmgr_install(c(
  'inconsolata', 'times', 'tex', 'helvetic', 'dvips'
))
tinytex::tlmgr_conf(
  c("auxtrees", "add", system.file("local_tex", package = "INBOmd"))
)
```
