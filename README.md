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

INBOmd requires a working installation of XeLaTeX. We suggest to install MikTeX on Windows (http://miktex.org/download). On Linux you can use TeXLive (`sudo apt-get install texlive`).

After installing XeLaTeX, you can install INBOmd from github with:

```R
# install.packages("devtools")
devtools::install_github("inbo/INBOmd")
```

To active the corporate identity in XeLaTeX you need to perform a few more steps.

#### Windows

1. Push the _Start_ button and then _All programs_ --> _MikTex 2.9_ --> _Maintenance_ --> _Settings_
1. Go to the _Roots_ tab. The R command `system.file("local_tex", package = "INBOmd")` show a folder which must be in listed in the roots. If not, click _Add_, select the folder and click _OK_ and then _Apply_.
1. If the folder is not on top of the list in _Roots_, select the folder and click _Up_ until the folder is at the top.
1. Go to the _General_ tab. 
1. Click _Refresh FNDB_.
1. Click _Update formats_.
1. Click _OK_

#### Linux

1. Add a symbolic link from `/texmf` to the folder indicated by the R command `system.file("local_tex", package = "INBOmd")`.
1. Update the filename database by running `sudo texhash`
