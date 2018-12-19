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
RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff

## Install INBOmd depedencies
RUN  Rscript -e 'devtools::install_github("inbo/INBOtheme")' \
  && Rscript -e 'devtools::install_github("rstudio/bookdown")' \
  && Rscript -e 'devtools::install_github("thierryo/qrcode")'

## Install tools to check code coverage and coding style
RUN  Rscript -e 'devtools::install_github("r-lib/covr")' \
  && Rscript -e 'devtools::install_github("jimhester/lintr")'

## Install current version of INBOmd
RUN Rscript -e 'devtools::install_github("inbo/INBOmd")' \
 && export TEXMFHOME=/usr/local/lib/R/site-library/INBOmd/local_tex

## Install fonts
RUN mkdir ~/.fonts \
  && wget https://www.wfonts.com/download/data/2014/12/12/calibri/calibri.zip \
  && unzip calibri.zip -d ~/.fonts \
  && wget -O ~/.fonts/Inconsolatazi4-Regular.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Regular.otf \
  && wget -O ~/.fonts/Inconsolatazi4-Bold.otf http://mirrors.ctan.org/fonts/inconsolata/opentype/Inconsolatazi4-Bold.otf

## Install dependencies for INBOmd examples
RUN  apt-get update \
  && apt-get install bzip2 \
  && Rscript -e 'install.packages(c("DT", "leaflet", "webshot"))' \
  && Rscript -e 'webshot::install_phantomjs()'