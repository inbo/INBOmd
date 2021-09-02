#!/bin/sh -l

echo 'repository:     ' $GITHUB_REPOSITORY
echo 'ref:            ' $GITHUB_REF
echo 'head_ref:       ' $GITHUB_HEAD_REF
echo 'Event:          ' $GITHUB_EVENT_NAME

export HOME=/root

cd $GITHUB_WORKSPACE

if [ $GITHUB_REPOSITORY = "inbo/inbomd" ] ; then
  echo 'Test new version of INBOmd'
  apt-get update
  apt-get upgrade -y
  Rscript -e 'remotes::install_local(".", force = TRUE)'
  cd /examples
else
  echo 'Test changes in inbomd_examples'
fi
Rscript source/render_all.R
echo 'Path:           ' $PATH
if [ $? -ne 0 ]; then
  echo "\nRendering failed. Please check the error message above.\n";
  exit 1
fi
echo '\nAll Rmarkdown files rendered successfully\n'

if [ $GITHUB_EVENT_NAME != "push" ]; then
  echo 'Done.\n'
  exit 0
fi

echo 'Publishing the rendered files...\n'
git clone --branch=gh-pages https://$1@github.com/inbo/inbomd_examples/ /gh-pages
git config --global user.email "info@inbo.be"
git config --global user.name "INBO"
cd /gh-pages
git rm -r .
if [ $GITHUB_REPOSITORY = "inbo/inbomd" ] ; then
  cp -R /examples/docs/. .
else
  cp -R $GITHUB_WORKSPACE/docs/. .
fi
if ! git diff-index --quiet HEAD --; then
    git add --all
    git commit --amend --message="Voorbeelden voor INBOmd"
    git push -f
    echo '\nNew version published...'
else
  echo '\nNothing to update...'
fi
