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
RUN  Rscript -e '
    install.packages(c("bookdown", "webshot"))
    webshot::install_phantomjs()
    remotes::install_github("inbo/INBOtheme")
'

## Install tools to check code coverage and coding style
RUN  Rscript -e '
    remotes::install_github("r-lib/covr")
    remotes::install_github("jimhester/lintr")
'

## Install current version of INBOmd
RUN Rscript -e '
    remotes::install_github("inbo/INBOmd")
    tinytex::tlmgr_install(c(
      "inconsolata", "times", "tex", "helvetic", "dvips"
    ))
    tinytex::tlmgr_conf(
      c("auxtrees", "add", system.file("local_tex", package = "INBOmd"))
    )
'

## Install fonts
RUN mkdir ~/.fonts \
  && wget https://www.wfonts.com/download/data/2014/12/12/calibri/calibri.zip \
  && unzip calibri.zip -d ~/.fonts

## Install dependencies for INBOmd examples
RUN  apt-get update \
  && apt-get install -y --no-install-recommends
    bzip2 \
    curl \
  && Rscript -e 'install.packages(c("DT", "leaflet")'

## Install LaTeX packages
RUN  apt-get update \
  && apt-get install -y --no-install-recommends gpg \
  && tlmgr install \
      beamer \
      carlisle \
      datetime \
      babel-english \
      babel-french \
      babel-dutch \
      emptypage \
      eurosym \
      extsizes \
      fancyhdr \
      fmtcount \
      footmisc \
      lastpage \
      lipsum \
      marginnote \
      mdframed \
      ms \
      multirow \
      placeins \
      needspace \
      textpos \
      tocloft \
      translator \
      ulem \
      xcolor
