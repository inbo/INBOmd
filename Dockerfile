FROM ubuntu:20.04

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="RStable" \
      org.label-schema.description="A docker image with stable versions of R and a bunch of packages used to calculate indicators." \
      org.label-schema.license="MIT" \
      org.label-schema.url="e.g. https://www.inbo.be/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inbo/indicactoren" \
      org.label-schema.vendor="Research Institute for Nature and Forest" \
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

## Install pandoc
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    pandoc \
    pandoc-citeproc
#    gdebi-core \
#  && wget -O ${HOME}/pandoc.deb --no-check-certificate https://github.com/jgm/pandoc/releases/download/2.14.2/pandoc-2.14.2-1-amd64.deb \
#  && gdebi ${HOME}/pandoc.deb \
#  && rm ${HOME}/pandoc.deb

## R repo
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    software-properties-common \
    dirmngr \
  && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
  && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" \
  && add-apt-repository ppa:c2d4u.team/c2d4u4.0+

## R
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-base-dev

COPY docker/.Rprofile /usr/lib/R/etc/Rprofile.site

## R packages
RUN apt-get update \
  && apt-get install -y  --no-install-recommends \
    r-cran-assertthat \
    r-cran-bookdown \
    r-cran-digest \
    r-cran-dplyr \
    r-cran-fastmap \
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

## Install qrcode
RUN  Rscript -e 'remotes::install_cran("lipsum")'

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

## Get current version of the INBOmd examples
RUN git clone --single-branch --branch=master --depth=1 https://github.com/inbo/inbomd_examples /examples

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

ENTRYPOINT ["/entrypoint.sh"]

ENV PATH $PATH:/root/bin:/github/home/bin
