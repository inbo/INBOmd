#!/bin/sh -l

echo 'repository: ' $GITHUB_REPOSITORY
echo 'example_branch: ' $1

if [ $GITHUB_REPOSITORY = "inbo/inbomd" ] ; then
  cd ..
  Rscript -e 'remotes::install_local("workspace")'
  git clone --single-branch --branch=$1 --depth=1 https://github.com/inbo/inbomd_examples /examples
else
  ln -s $GITHUB_WORKSPACE /examples
fi
cd /examples
Rscript source/render_all.R
if [ $? -ne 0 ]; then
  echo "\nRendering failed. Please check the error message above.\n";
  exit 1
fi
echo '\nAll Rmarkdown files rendered successfully\n'

echo $GITHUB_EVENT_NAME

if [ $GITHUB_EVENT_NAME -eq "push" ]; then
  echo 'Done.\n'
  exit 0
fi

echo 'Publishing the rendered files...\n'
git clone --branch=gh-pages https://$GITHUB_TOKEN@github.com/inbo/inbomd_examples /gh-pages
git config --global user.email "info@inbo.be"
git config --global user.name "INBO"
cd /gh-pages
git rm -r .
cp -R /examples/docs/. .
if ! git diff-index --quiet HEAD --; then
    git add --all
    git commit --amend --message="Voorbeelden voor INBOmd"
    git push -f
    echo '\nNew version published...'
else
  echo '\nNothing to update...'
fi
