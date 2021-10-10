#!/bin/bash
set -x


# Gather constant vars
#REPONAME=${Test_REPO}
GITHUBUSER=$(git config github.user)
token=$1




# Get user input
#REPONAME=$1
#INPUT="repo.txt"
# shellcheck disable=SC1068
for i {1..4}
#while IFS= read -r REPONAME
do
  echo "Test-REPO$i"
#  echo $REPONAME
#read -p "REPONAME? (enter repo name ${REPONAME}"
#read -p "USER?Git Username (enter for ${GITHUBUSER}):"
#read -p "DESCRIPTION?Repo Description:"

echo "Here we go..."

# Curl some json to the github API oh damn we so fancy
curl -X DELETE -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${token}" https://api.github.com/repos/${GITHUBUSER}/Test-REPO$i

done
