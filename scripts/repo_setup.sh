#!/bin/bash
set -x


# Gather constant vars
#REPONAME=${Test_REPO}

function repo_setup() {

local GITHUBUSER=$(git config github.user)
local token=$1
local action=$2
#GITHUBUSER=$(git config github.user)
#token=$1
#action=$2

for i in {76..100}
do
  echo Test-REPO$i
  echo $action

if [ "$action" == "create" ]; then
echo "Here we go..."

# Curl some json to the github API oh damn we so fancy
curl -H "Authorization: token ${token}" -H "Accept: application/vnd.github.v3+json"  https://api.github.com/user/repos -d "{\"name\": \"Test-REPO$i\", \"description\": \"Testing Repo\", \"private\": false, \"has_issues\": true, \"has_downloads\": true, \"has_wiki\": false}"

# Set the freshly created repo to the origin and push
# create empty README.md
echo "Creating README ..."
touch README.md
echo "Test-REPO$i" > README.md


echo "Pushing to remote ..."
git init
git add README.md
git commit -m "Initial commit"
git remote rm origin
git remote add origin git@github.com:$GITHUBUSER/Test-REPO$i.git
git push -u origin master
echo " done."


## config repository setup on gocd server

curl 'https://gocd.example.com/go/api/admin/config_repos' \
  -u 'goadmin:goadmin' \
  -H 'Accept:application/vnd.go.cd.v4+json' \
  -H 'Content-Type:application/json' \
  -X POST -d "{
    \"id\": \"Test-REPO$i\",
    \"plugin_id\": \"yaml.config.plugin\",
    \"material\": {
      \"type\": \"git\",
      \"attributes\": {
        \"url\": \"https://github.com/siddhi1907/Test-REPO$i.git\",
        \"username\": \"goadmin\",
        \"password\": \"goadmin\",
        \"branch\": \"master\",
        \"auto_update\": true
      }
    },
    \"rules\": [
      {
        \"directive\": \"allow\",
        \"action\": \"refer\",
        \"type\": \"pipeline_group\",
        \"resource\": \"*\"
      }
    ]
  }"

elif [ "$action" == "" ]; then
    echo "please provide action..."
    exit 1
else
echo "Deleting Test-REPO$i..."

# Curl some json to the github API oh damn we so fancy
curl -X DELETE -H "Accept: application/vnd.github.v3+json" -H "Authorization: token ${token}" https://api.github.com/repos/${GITHUBUSER}/Test-REPO$i


# Delete config repository on gocd-server
curl "https://gocd.example.com/go/api/admin/config_repos/Test-REPO$i" \
      -u "goadmin:goadmin" \
      -H 'Accept: application/vnd.go.cd.v4+json' \
      -X DELETE
fi
done
}

repo_setup "$@"



#git remote set-url origin git@github.com:${USER:-${GITHUBUSER}}/${REPONAME:-${CURRENTDIR}}.git
#git push --set-upstream origin master