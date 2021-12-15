#!/bin/sh -l

export HOME=/root

cd $GITHUB_WORKSPACE

if [ $GITHUB_REPOSITORY = 'inbo/INBOmd' ] ; then
  echo 'Test new version of INBOmd'
  apt-get update
  apt-get upgrade -y
  Rscript -e 'remotes::install_local(".", force = TRUE)'
  cd /examples
else
  echo 'Test changes in inbomd_examples'
fi
Rscript source/render_all.R
if [ $? -ne 0 ]; then
  echo "\nRendering failed. Please check the error message above.\n";
  exit 1
fi
echo '\nAll Rmarkdown files rendered successfully\n'
if [ $GITHUB_REPOSITORY = "inbo/inbomd" ] ; then
  cp -R /examples/docs/. $GITHUB_WORKSPACE/docs/.
fi

if [ $GITHUB_EVENT_NAME = "push" ] ; then
  cd /
  git clone --depth 1 -b gh-pages https://$INPUT_TOKEN@github.com/inbo/inbomd_examples
  cd /inbomd_examples
  git rm -rf --quiet .
  cp -R $GITHUB_WORKSPACE/docs/. /inbomd_examples/.
  git add --all
  git config --global user.email "bwk@inbo.be"
  git config --global user.name "INBO BMK"
  git commit --amend -m "Automated update of gh-pages with inbomd_examples"
  git push --force --set-upstream origin gh-pages
fi
