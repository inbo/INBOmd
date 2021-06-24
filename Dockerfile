FROM rocker/verse

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
RUN mkdir -p /github/home
ENV HOME /github/home

## Install nano
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    nano

## Install ImageMagick
RUN  apt-get update \
  && apt-get install -y --no-install-recommends imagemagick

## Install LaTeX packages
RUN  tlmgr install \
      babel-dutch \
      babel-english \
      babel-french \
      beamer \
      beamerswitch \
      carlisle \
      colortbl \
      datetime \
      dvips \
      emptypage \
      environ \
      epstopdf \
      eso-pic \
      eurosym \
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
      makecell \
      marginnote \
      mdframed \
      ms \
      multirow \
      parskip \
      pdflscape \
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
      trimspaces \
      ulem \
      upquote \
      wrapfig \
      xcolor \
      zref

## Install fonts
RUN  mkdir ${HOME}/.fonts \
  && wget https://www.wfonts.com/download/data/2014/12/12/calibri/calibri.zip \
  && unzip calibri.zip -d ${HOME}/.fonts \
  && rm calibri.zip \
  && wget -O ${HOME}/.fonts/Inconsolatazi4-Regular.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Regular.otf \
  && wget -O ${HOME}/.fonts/Inconsolatazi4-Bold.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Bold.otf \
  && fc-cache -fv \
  && updmap-sys

## Install pander
RUN  Rscript -e 'remotes::install_cran("pander")'

## Install webshot
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
      bzip2 \
  && Rscript -e 'remotes::install_cran("webshot")' \
  && Rscript -e 'webshot::install_phantomjs()'

## Install sysfonts
RUN  apt-get update \
  && apt-get install -y --no-install-recommends libfreetype6-dev \
  && Rscript -e 'remotes::install_cran("sysfonts")'

## Install qrcode
RUN  Rscript -e 'remotes::install_github("thierryo/qrcode")'

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
