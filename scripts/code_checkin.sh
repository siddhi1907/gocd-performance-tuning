#!/bin/bash
set -x


# Gather constant vars
#REPONAME=${Test_REPO}

#function repo_setup() {

GITHUBUSER=$(git config github.user)
#token=$1
#GITHUBUSER=$(git config github.user)
#token=$1
#action=$2

for i in {3..10}
do
  echo Test-REPO$i

cd /Users/siddhi.kadam/REPO/gocd-server/repos/
DIR=/Users/siddhi.kadam/REPO/gocd-server/repos/Test-REPO$i
if [ -d  "$DIR" ]; then
  echo "$DIR exist"
else
  git clone -b master git@github.com:siddhi1907/Test-REPO$i.git
fi

cd Test-REPO$i

git config --global user.name "siddhi1907"
git config --global user.email "kadamsiddhi95@gmail.con"
git config --global push.default simple
#
pwd

touch Test-REPO$i.txt
echo "testing" >> Test-REPO$i.txt

#if [ "$action" == "create" ]; then

echo "Pushing to repo ..."


git add Test-REPO$i.txt

if [ -z "$(git status --porcelain)" ]; then
    echo "Pipelines are upto date"
else

    git commit -m "AUTO: commit performance testing for pipeline TEST-REPO$i"
    git remote set-url origin git@github.com:$GITHUBUSER/Test-REPO$i.git
    git push

fi
done
