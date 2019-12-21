#!/bin/sh
set -eu

# git setting
git config --global user.name github-actions
git config --global user.email noreply@github.com

export GIT_BRANCH="$(git symbolic-ref HEAD --short 2>/dev/null)"
if [ "$GIT_BRANCH" = "" ] ; then
  GIT_BRANCH="$(git branch -a --contains HEAD | sed -n 2p | awk '{ printf $1 }')";
  export GIT_BRANCH=${GIT_BRANCH#remotes/origin/};
fi

git remote set-url origin https://team-lab:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git
git checkout $GIT_BRANCH

# replace old jar
rm -f ./code-gen/openapi-generator-cli.jar
cp -f ./modules/openapi-generator-cli/target/openapi-generator-cli.jar ./code-gen/openapi-generator-cli.jar

# push if diff exists
set +e
git diff --exit-code --quiet
if [ $? -eq 1 ]; then
  git add .
  git commit -m "add generated code"
  git push origin $GIT_BRANCH
else
  echo "nothing to commit"
fi