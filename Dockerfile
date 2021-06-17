FROM rocker/r-ubuntu:20.04

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="INBOmd" \
      org.label-schema.description="Add tools required to build bookdown documents with INBOmd" \
      org.label-schema.license="GPL-3" \
      org.label-schema.url="https://www.vlaanderen.be/inbo" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inbo/INBOmd" \
      org.label-schema.vendor="Research Institute for Nature and Forest" \
      maintainer="Thierry Onkelinx <thierry.onkelinx@inbo.be>"

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

## Install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-1-amd64.deb \
  && dpkg -i pandoc-2.7.3-1-amd64.deb \
  && rm pandoc-2.7.3-1-amd64.deb

## Install git
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    git \
    openssh-client

## Install nano
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano

## Install ImageMagick
RUN  apt-get update \
  && apt-get install -y --no-install-recommends imagemagick

## Install remotes
RUN  Rscript -e 'install.packages("remotes")'

## Install tinytex
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
      curl \
      gpg \
      qpdf \
  && Rscript -e 'remotes::install_cran("tinytex")' \
  && Rscript -e 'if (tinytex:::is_tinytex()) {tinytex::reinstall_tinytex(repository = "http://ftp.snt.utwente.nl/pub/software/tex/")} else {tinytex::install_tinytex()}'

## add TinyTeX to path
ENV PATH="/root/bin:${PATH}"

## Install LaTeX packages
RUN  tlmgr install \
      babel-dutch \
      babel-english \
      babel-french \
      beamer \
      carlisle \
      colortbl \
      datetime \
      dvips \
      emptypage \
      eurosym \
      eso-pic \
      extsizes \
      fancyhdr \
      fmtcount \
      float \
      footmisc \
      helvetic \
      hyphen-dutch \
      hyphen-french \
      inconsolata \
      lastpage \
      lipsum \
      marginnote \
      mdframed \
      ms \
      multirow \
      pdfpages \
      pdftexcmds \
      placeins \
      needspace \
      tabu \
      tex \
      textpos \
      threeparttable \
      threeparttablex \
      titlesec \
      times \
      tocloft \
      translator \
      ulem \
      wrapfig \
      xcolor

## Install fonts
RUN  mkdir /root/.fonts \
  && wget https://www.wfonts.com/download/data/2014/12/12/calibri/calibri.zip \
  && unzip calibri.zip -d /root/.fonts \
  && rm calibri.zip \
  && wget -O /root/.fonts/Inconsolatazi4-Regular.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Regular.otf \
  && wget -O /root/.fonts/Inconsolatazi4-Bold.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Bold.otf \
  && fc-cache -fv \
  && updmap-sys

## Install bookdown
RUN  Rscript -e 'remotes::install_cran("bookdown")'

## Install pander
RUN  Rscript -e 'remotes::install_cran("dplyr")'

## Install pander
RUN  Rscript -e 'remotes::install_cran("pander")'

## Install webshot
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
      bzip2 \
  && Rscript -e 'remotes::install_cran("webshot")' \
  && Rscript -e 'webshot::install_phantomjs()'

## Install curl
RUN  apt-get update \
  && apt-get install -y --no-install-recommends libcurl4-openssl-dev \
  && Rscript -e 'remotes::install_cran("curl")'

## Install sysfonts
RUN  apt-get update \
  && apt-get install -y --no-install-recommends libfreetype6-dev \
  && Rscript -e 'remotes::install_cran("sysfonts")'

## Install INBOtheme
RUN  Rscript -e 'remotes::install_github("inbo/INBOtheme")'

## Install dependencies for INBOmd examples: DT
RUN  Rscript -e 'remotes::install_cran("DT")'

## Install dependencies for INBOmd examples: leaflet
RUN  Rscript -e 'remotes::install_cran("leaflet")'

## Install dependencies for INBOmd examples: lipsum
RUN  Rscript -e 'remotes::install_github("inbo/lipsum")'

## Install pdftools
RUN  apt-get update \
  && apt-get install -y --no-install-recommends libpoppler-cpp-dev \
  && Rscript -e 'remotes::install_cran("pdftools")'

## Install dependencies for INBOmd examples: openssl
RUN  apt-get update \
  && apt-get install -y --no-install-recommends libssl-dev \
  && Rscript -e 'remotes::install_cran("openssl")'

## Install dependencies for INBOmd examples: xml2
RUN  apt-get update \
  && apt-get install -y --no-install-recommends libxml2-dev \
  && Rscript -e 'remotes::install_cran("xml2")'

## Install dependencies for INBOmd examples: tidyverse
RUN  Rscript -e 'remotes::install_cran("tidyverse")'

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

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
