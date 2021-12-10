#!/bin/sh -l

echo 'repository:     ' $GITHUB_REPOSITORY
echo 'ref:            ' $GITHUB_REF
echo 'head_ref:       ' $GITHUB_HEAD_REF
echo 'Event:          ' $GITHUB_EVENT_NAME

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
else
  cp -R docs ../docs
  if [ -z  "$(git branch -r | grep origin/gh-pages)" ]; then
    git checkout --orphan gh-pages
    git rm -rf --quiet .
    git commit --allow-empty -m "Initializing gh-pages branch"
  else
    git checkout -b gh-pages
    git rm -rf --quiet .
    rm -R *
  fi
  cp -R ../docs/. .
  git add --all
  git commit --amend -m "Automated update of gh-pages with inbomd_examples"
  git push --force --set-upstream origin gh-pages
fi
