#!/bin/bash
set -x


# Gather constant vars
#REPONAME=${Test_REPO}
GITHUBUSER=$(git config github.user)
token=$1




# Get user input
#REPONAME=$1
for i in {1..4}
#INPUT="repo.txt"
# shellcheck disable=SC1068
#while IFS= read -r REPONAME
do
#  echo $REPONAME
#read -p "REPONAME? (enter repo name ${REPONAME}"
#read -p "USER?Git Username (enter for ${GITHUBUSER}):"
#read -p "DESCRIPTION?Repo Description:"

echo "Here we go..."

# Curl some json to the github API oh damn we so fancy
curl -H "Authorization: token ${token}" -H "Accept: application/vnd.github.v3+json"  https://api.github.com/user/repos -d "{\"name\": \"Test-REPO$i\", \"description\": \"Testing Repo\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

# Set the freshly created repo to the origin and push
# You'll need to have added your public key to your github account
# create empty README.md
echo "Creating README ..."
touch README.md
echo " done."

# push to remote repo
echo "Pushing to remote ..."
cd data
git init
git add repo.txt
git commit -m "first commit"
git remote rm origin
#git remote add origin https://github.com/$GITHUBUSER/$REPONAME.git
git remote add origin git@github.com:$GITHUBUSER/Test-REPO$i.git
git push -u origin master
echo " done."

done

#git remote set-url origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git
#git push --set-upstream origin master