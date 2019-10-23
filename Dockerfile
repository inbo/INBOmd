FROM rocker/verse

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="INBOmd" \
      org.label-schema.description="Add tools required to build bookdown documents with INBOmd" \
      org.label-schema.license="GPL-3" \
      org.label-schema.url="e.g. https://www.inbo.be/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/inbo/INBOmd" \
      org.label-schema.vendor="Research Institute for Nature and Forest" \
      maintainer="Thierry Onkelinx <thierry.onkelinx@inbo.be>"

## for apt to be noninteractive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true


## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN  useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

## Install INBOmd depedencies
RUN  apt-get update \
  && apt-get install -y --no-install-recommends \
      bzip2 \
      curl \
  && Rscript -e 'install.packages(c("bookdown", "tinytex", "webshot", "pander"))' \
  && Rscript -e 'webshot::install_phantomjs()' \
  && Rscript -e 'remotes::install_github("inbo/INBOtheme")'

## Install tools to check code coverage and coding style
RUN  Rscript -e 'install.packages(c("covr", "lintr"))'

## Install current version of INBOmd
RUN  Rscript -e 'remotes::install_github("inbo/INBOmd")' \
  && Rscript -e 'tinytex::tlmgr_conf(c("auxtrees", "add", system.file("local_tex", package = "INBOmd")))'

## Install fonts
RUN  mkdir /root/.fonts \
  && wget https://www.wfonts.com/download/data/2014/12/12/calibri/calibri.zip \
  && unzip calibri.zip -d /root/.fonts \
  && rm calibri.zip \
  && wget -O /root/.fonts/Inconsolatazi4-Regular.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Regular.otf \
  && wget -O /root/.fonts/Inconsolatazi4-Bold.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Bold.otf \
  && wget -O /root/.fonts/FlandersArtSans-Regular.ttf https://www.inbo.be/sites/all/themes/bootstrap_inbo/fonts/FlandersArtSans-Regular.ttf \
  && wget -O /root/.fonts/FlandersArtSans-Light.ttf https://www.inbo.be/sites/all/themes/bootstrap_inbo/fonts/FlandersArtSans-Light.ttf \
  && wget -O /root/.fonts/FlandersArtSans-Medium.ttf https://www.inbo.be/sites/all/themes/bootstrap_inbo/fonts/FlandersArtSans-Medium.ttf \
  && wget -O /root/.fonts/FlandersArtSans-Bold.ttf https://www.inbo.be/sites/all/themes/bootstrap_inbo/fonts/FlandersArtSans-Bold.ttf \
  && fc-cache -fv \
  && updmap-sys


## Install dependencies for INBOmd examples
RUN  Rscript -e 'install.packages(c("DT", "leaflet"))' \
  && Rscript -e 'remotes::install_github("inbo/lipsum")'

## Install LaTeX packages
RUN  apt-get update \
  && apt-get install -y --no-install-recommends gpg \
  && tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet \
  && tlmgr update --self --all \
  && tlmgr install \
      babel-dutch \
      babel-english \
      babel-french \
      beamer \
      carlisle \
      datetime \
      dvips \
      emptypage \
      eurosym \
      eso-pic \
      extsizes \
      fancyhdr \
      fmtcount \
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
      placeins \
      needspace \
      tex \
      textpos \
      titlesec \
      times \
      tocloft \
      translator \
      ulem \
      xcolor

## Install pkgdown
RUN  Rscript -e 'install.packages("pkgdown")'

## Install ImageMagick
RUN  apt-get update \
  && apt-get install -y --no-install-recommends imagemagick
