#!/bin/sh
set -e

rm -f ./code-gen/openapi-generator-cli.jar
cp -f ./modules/openapi-generator-cli/target/openapi-generator-cli.jar ./code-gen/openapi-generator-cli.jar

git config --global user.name u-nation
git config --global user.email Endooooooo7@gmail.com
git remote set-url origin https://u-nation:${GITHUB_TOKEN}@github.com/u-nation/openapi-generator.git

export GIT_BRANCH="$(git symbolic-ref HEAD --short 2>/dev/null)"
if [ "$GIT_BRANCH" = "" ] ; then
  GIT_BRANCH="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
  export GIT_BRANCH=${GIT_BRANCH#remotes/origin/};
fi

git checkout $GIT_BRANCH
git branch -a
git add .
git commit -m "add generated code"
git push origin $GIT_BRANCH
