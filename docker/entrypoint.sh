#!/bin/sh -l

export HOME=/root

cd $GITHUB_WORKSPACE
git config --global user.email "bmk@inbo.be"
git config --global user.name "INBO BMK"

if [ $GITHUB_REPOSITORY = 'inbo/INBOmd' ] ; then
  echo 'Test new version of INBOmd'
  apt-get update
  apt-get upgrade -y
  Rscript -e 'remotes::install_local(".", force = TRUE)'
  RUN git clone --single-branch --branch=$EXAMPLE_BRANCH --depth=1 https://oauth2:$GITHUB_TOKEN@github.com/inbo/inbomd_examples
else
  echo 'Test changes in inbomd_examples'
  if [ $GITHUB_EVENT_NAME = "push" ] ; then
    git clone --depth 1 -b $EXAMPLE_BRANCH https://oauth2:$GITHUB_TOKEN@github.com/inbo/inbomd_examples
  else
    git clone --depth 1 -b $GITHUB_HEAD_REF https://oauth2:$GITHUB_TOKEN@github.com/inbo/inbomd_examples
  fi
fi
cd inbomd_examples
Rscript source/render_all.R
if [ $? -ne 0 ]; then
  echo "\nRendering failed. Please check the error message above.\n";
  exit 1
fi
echo '\nAll Rmarkdown files rendered successfully\n'
mkdir $GITHUB_WORKSPACE/docs
cp -R $GITHUB_WORKSPACE/inbomd_examples/. $GITHUB_WORKSPACE/docs/.

if [ $GITHUB_EVENT_NAME = "push" ] ; then
  cd /
  git clone --depth 1 -b gh-pages https://oauth2:$GITHUB_TOKEN@github.com/inbo/inbomd_examples
  cd /inbomd_examples
  git rm -rf --quiet .
  cp -R $GITHUB_WORKSPACE/docs/. /inbomd_examples/.
  git add --all
  git commit --amend -m "Automated update of gh-pages with inbomd_examples"
  git push --force --set-upstream origin gh-pages
fi
