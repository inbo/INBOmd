FROM ubuntu:22.04

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="INBOmd" \
      org.label-schema.description="A docker image with examples files for INBOmd." \
      org.label-schema.license="GPL-3.0" \
      org.label-schema.url="e.g. https://www.inbo.be/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inbo/INBOmd" \
      org.label-schema.vendor="Research Institute for Nature and Forest (INBO)" \
      maintainer="Thierry Onkelinx <thierry.onkelinx@inbo.be>"

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

WORKDIR /github/workspace

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    locales \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen nl_BE.utf8 \
  && /usr/sbin/update-locale LANG=nl_BE.UTF-8

ENV LC_ALL nl_BE.UTF-8
ENV LANG nl_BE.UTF-8

## Install wget
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    wget

## Install nano
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano

## Install ImageMagick
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    imagemagick

## Install git
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    git

## Install gpg
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    gnupg

## R repo
RUN apt-get update -qq \
  && apt-get install -y  --no-install-recommends \
    software-properties-common \
    dirmngr \
  && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
  && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" \
  && add-apt-repository ppa:c2d4u.team/c2d4u4.0+

## R
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-base-dev

## Install pandoc
RUN  wget https://github.com/jgm/pandoc/releases/download/3.1.8/pandoc-3.1.8-1-amd64.deb \
  && dpkg -i pandoc-3.1.8-1-amd64.deb \
  && rm pandoc-3.1.8-1-amd64.deb

COPY docker/.Rprofile /usr/lib/R/etc/Rprofile.site

## R packages
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-cran-assertthat \
    r-cran-bookdown \
    r-cran-digest \
    r-cran-dplyr \
    r-cran-fastmap \
    r-cran-fs \
    r-cran-ggplot2 \
    r-cran-htmltools \
    r-cran-knitr \
    r-cran-pander \
    r-cran-pdftools \
    r-cran-qpdf \
    r-cran-remotes \
    r-cran-rmarkdown \
    r-cran-rstudioapi \
    r-cran-stringi \
    r-cran-tibble \
    r-cran-tidyverse \
    r-cran-tinytex \
    r-cran-webshot

## Install textshape
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    libfribidi-dev \
    libharfbuzz-dev \
  && Rscript -e 'remotes::install_cran("textshape")'

## Install ragg
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff5-dev \
  && Rscript -e 'remotes::install_cran("ragg")'

## Install xml2
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
    libxml2-dev \
  && Rscript -e 'remotes::install_cran("xml2")'

## Install checklist
RUN  apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-cran-codetools \
    r-cran-crul \
    r-cran-curl \
    r-cran-desc \
    r-cran-devtools \
    r-cran-htmlwidgets \
    r-cran-hunspell \
    r-cran-lazyeval \
    r-cran-pingr \
    r-cran-pkgdown \
    r-cran-profvis \
    r-cran-rcmdcheck \
    r-cran-renv \
    r-cran-rex \
    r-cran-roxygen2 \
    r-cran-rprojroot \
    r-cran-shiny \
    r-cran-xtable \
  && Rscript -e 'remotes::install_github("inbo/checklist")'

## Install DT
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-cran-crosstalk \
    r-cran-htmlwidgets \
    r-cran-later \
    r-cran-lazyeval \
    r-cran-promises \
  && Rscript -e 'remotes::install_cran("DT")'

## Install INBOtheme
RUN  apt-get update \
  && apt-get install -y  --no-install-recommends \
    libfreetype6-dev \
  && Rscript -e 'remotes::install_cran("INBOtheme")'

## Install qrcode
RUN  apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-cran-stringr \
    r-cran-R.utils \
  && Rscript -e 'remotes::install_cran("qrcode")'

## Install lipsum
RUN  Rscript -e 'remotes::install_cran("lipsum")'

## Install here
RUN  Rscript -e 'remotes::install_cran("here")'

## Install gert
RUN  apt-get update \
  && apt-get install -y  --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
  && Rscript -e 'remotes::install_cran("gert")'

## Install webshot dependency
RUN  Rscript -e 'webshot::install_phantomjs()'

## Install tinytex
RUN  Rscript -e 'tinytex::install_tinytex()'

## Install LaTeX packages
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    ghostscript \
  && Rscript -e 'tinytex::tlmgr_install(c("babel-dutch", "babel-english", "babel-french", "beamer", "beamerswitch", "booktabs", "carlisle", "colortbl", "datetime", "dvips", "emptypage", "environ", "epstopdf", "eso-pic", "eurosym", "extsizes", "fancyhdr", "fancyvrb", "fmtcount", "float", "fontspec", "footmisc", "framed", "helvetic", "hyphen-dutch", "hyphen-french", "inconsolata", "lastpage", "lipsum", "makecell", "marginnote", "mdframed", "ms", "multirow", "parskip", "pdflscape", "pdfpages", "pdftexcmds", "placeins", "needspace", "tabu", "tex", "textpos", "threeparttable", "threeparttablex", "titlesec", "times", "tocloft", "translator", "trimspaces", "ulem", "upquote", "wrapfig", "xcolor", "xstring", "zref"))'

## Install fonts
RUN  mkdir ${HOME}/.fonts \
  && wget https://www.wfonts.com/download/data/2014/12/12/calibri/calibri.zip \
  && unzip calibri.zip -d ${HOME}/.fonts \
  && rm calibri.zip \
  && wget -O ${HOME}/.fonts/Inconsolatazi4-Regular.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Regular.otf \
  && wget -O ${HOME}/.fonts/Inconsolatazi4-Bold.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Bold.otf \
  && fc-cache -fv \
  && Rscript -e 'tinytex:::updmap()'

## Install kableExtra
RUN  Rscript -e 'remotes::install_cran("kableExtra")'

## Install current version of INBOmd
COPY .Rbuildignore inbomd/.Rbuildignore
COPY DESCRIPTION inbomd/DESCRIPTION
COPY inst inbomd/inst
COPY man inbomd/man
COPY NAMESPACE inbomd/NAMESPACE
COPY NEWS.md inbomd/NEWS.md
COPY R inbomd/R
COPY README.md inbomd/README.md
COPY vignettes inbomd/vignettes

RUN  Rscript -e 'remotes::install_local("inbomd")' \
  && Rscript -e 'tinytex::tlmgr_conf(c("auxtrees", "add", system.file("local_tex", package = "INBOmd")))'

COPY docker/entrypoint.sh /entrypoint.sh

ENV PATH $PATH:/root/bin:/github/home/bin

ENTRYPOINT ["/entrypoint.sh"]
