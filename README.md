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

INBOmd requires a working installation of XeLaTeX.

- On Windows, we suggest to install MikTeX (http://miktex.org/download).
- On Mac, we suggest to install MacTeX (https://www.tug.org/mactex).
- On Linux you can use TeXLive: `sudo apt-get install texlive markdown pandoc pandoc-data perl-tk texlive-xetex xzdec lmodern texlive-fonts-extra texlive-lang-european texlive-lang-french && sudo tlmgr init-usertree`

  _Note for Linux: Installing from Ubuntu repositories is typically not compatible with updating TeX packages from [CTAN](https://www.ctan.org). Also, Ubuntu LTS versions typically don't keep TeXLive at its latest version from CTAN. However, first having installed `texlive` using `apt-get` is most convenient, as `apt-get` takes care of package dependencies on your system. You can therefore take a two-step [process](https://askubuntu.com/questions/486170/upgrade-from-tex-live-from-2013-to-2014-on-ubuntu-14-04): first install `texlive` from the Ubuntu repositories, and then install TeXLive from CTAN. By extending the PATH variable of your Linux OS, both for yourself and for root, and also in [Rprofile.site](https://stackoverflow.com/questions/17480157/how-to-teach-r-find-the-texlive-directory-when-using-rstudio), you make sure that you always use the most recent binaries (typically under `/usr/local/texlive/<2016>/bin/x86_64-linux`). You enjoy CTAN updates by regularly issuing `sudo tlmgr update --self && sudo tlmgr update --all`._

After installing XeLaTeX, you can install INBOmd from GitHub with:

```R
# install.packages("devtools")
devtools::install_github("inbo/INBOmd")
```

To activate the corporate identity in XeLaTeX you need to perform a few more steps.

#### Windows

1. Push the _Start_ button and then _All programs_ --> _MikTex 2.9_ --> _Maintenance_ --> _Settings_
1. Go to the _Roots_ tab. The R command `system.file("local_tex", package = "INBOmd")` show a folder which must be in listed in the roots. If not, click _Add_, select the folder and click _OK_ and then _Apply_.
1. If the folder is not on top of the list in _Roots_, select the folder and click _Up_ until the folder is at the top.
1. Go to the _General_ tab. 
1. Click _Refresh FNDB_.
1. Click _Update formats_.
1. Click _OK_

#### Mac

No further action required.

#### Linux

1. Either add a symbolic link from `~/texmf` to the folder indicated by the R command `system.file("local_tex", package = "INBOmd")`, or follow the more generic approach of extending  the `TEXMFHOME` variable:
    - this can be done interactively when TeXLive is installed from CTAN: change the TEXMFHOME variable into `{/home/<username>/texmf,/home/<username>/lib/R/library/INBOmd/local_tex}` (change `<username>` into your username).
    The second directory must be the folder indicated by the R command `system.file("local_tex", package = "INBOmd")` -- it may be different in your case.
    - or you can do the same, in all cases and anytime, by entering `TEXMFHOME={/home/<username>/texmf,/home/<username>/lib/R/library/INBOmd/local_tex}` into a new file `/etc/texmf/texmf.d/10mytexmf.cnf` (change `<username>` into your username). Then issue `sudo update-texmf`.
    The second directory must be the folder indicated by the R command `system.file("local_tex", package = "INBOmd")` -- it may be different in your case.
1. Make the CTAN `inconsolata` font package available to the system, so that XeLaTeX can use it. Make a new file `/etc/fonts/conf.d/09-inconsolata.conf` with these contents (change directories as necessary):

    ```
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
    <fontconfig>
      <dir>/usr/local/texlive/2016/texmf-dist/fonts/opentype/public/inconsolata</dir>
    </fontconfig>
    ```
    and run `sudo fc-cache -fv`.
1. If you need other specific fonts which are not present on the system, e.g. Calibri or Flanders Art, you can install them:
    - either system-wide, by copying them under an appropriate subfolder of `/usr/local/share/fonts/truetype/`,
    - or for the current user, by copying them under `~/.fonts`,

    and issuing `sudo fc-cache -fv`.
1. Update the filename database by running `sudo mktexlsr`.
1. Check your settings with `tlmgr conf`.
