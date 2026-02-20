# INBOmd

INBOmd contains templates to generate several types of documents with
the corporate identity of INBO or the Flemish government. The current
package has following Rmarkdown templates:

- INBO pdf_report: reports rendered to pdf, html (gitbook style) and
  epub
- INBO slides: presentations rendered to pdf
- INBO poster: poster rendered to a A0 pdf
- Flanders slides: presentations using the Flemish corporate identity,
  rendered to pdf

The templates are available in RStudio using `File` \> `New file` \>
`R Markdown` \> `From template`.

More details, including instructions for installation and usage are
available at the [INBOmd
website](https://inbo.github.io/INBOmd/articles/inbomd.html).

## In the wild

Below are some documents created with INBOmd

1.  <https://inbo.github.io/inbomd_examples>
2.  <https://doi.org/10.21436/inbor.14030462>
3.  <https://doi.org/10.21436/inbop.14901626>
4.  <https://pureportal.inbo.be/portal/files/12819590/rbelgium_20170307.pdf>
5.  <https://doi.org/10.21436/inbor.12304086>

## Installation

INBOmd requires a working LaTeX distribution (for conversion of markdown
to pdf). We highly recommend to use the LaTeX distribution provided by R
package `tinytex`. Close all open R sessions and start a fresh R
session. Execute the commands below. This will install the R package
`tinytex` and the `TinyTex` LaTeX distribution on your machine. No admin
rights are required. Although `TinyTeX` is a lightweight installation,
it still is several 100 MB large.

    update.packages(ask = FALSE, checkBuilt = TRUE)
    if (!"tinytex" %in% rownames(installed.packages())) {
      install.packages("tinytex")
    }
    # install the TinyTeX LaTeX distribution
    if (!tinytex:::is_tinytex()) {
      tinytex::install_tinytex()
    }

In case the installation of `TinyTeX` fails on Windows, run the command
below and retry to install `TinyTex`.

    Sys.setenv(PATH = paste0(old_path, ";C:\\Windows\\system32"))

Once `TinyTeX` is installed, you need to restart RStudio. Then you can
proceed with the installation of `INBOmd`.

    # installation from inbo.r-universe
    install.packages("INBOmd", repos = "https://inbo.r-universe.dev")

    ## alternative: installation from github
    #if (!require("pak")) {
    #  install.packages("pak")
    #}
    #pak::pkg_install("inbo/INBOmd", dependencies = TRUE)

    # add the local latex package contained in INBOmd to the TinyTeX install
    tinytex::tlmgr_conf(
      c("auxtrees", "add", system.file("local_tex", package = "INBOmd"))
    )

    # install some other needed latex packages
    tinytex::tlmgr_install(c(
      "babel-dutch", "babel-english", "babel-french", "dvips", "helvetic",
      "hyphen-dutch", "hyphen-french", "inconsolata", "tex", "times"
    ))
