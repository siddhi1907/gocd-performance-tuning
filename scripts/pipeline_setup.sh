#!/bin/bash
set -e
set -x

#token=$1
#action=$2

#source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/repo_setup.sh

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/template.sh

function pipeline_setup() {



local GITHUBUSER=$(git config github.user)
local GOCD_URL=${GOCD_URL:-gocd.example.com}
local PROJECT_NAME=testing-pipelines
export VERSION=${VERSION:-1.2}
export BRANCH_NAME="release-$VERSION"



# Update version in the template
body=$(cat template.gocd.json | jq '. | {name: (.name + "-" + $ENV.VERSION), stages: .stages}')
template_name=$(echo $body | jq -r '.name')
curl -s -k -u "goadmin:goadmin" -D - "https://$GOCD_URL/go/api/admin/templates/$template_name" -H 'Accept: application/vnd.go.cd.v7+json'  > response

# Create or update template
status_code=$(grep 'HTTP/1.1' response | awk '{print $2}')
etag=$(grep 'ETag:' response | awk '{print $2}')

if [ "$status_code" == "404" ]; then
    curl -s -k -u "goadmin:goadmin" -X POST "https://$GOCD_URL/go/api/admin/templates" \
    -H 'Accept: application/vnd.go.cd.v7+json' \
    -H 'Content-Type: application/json' \
    -d "$(echo $body)"
else
    curl -s -k -u "goadmin:goadmin" -X PUT "https://$GOCD_URL/go/api/admin/templates/$template_name" \
    -H 'Accept: application/vnd.go.cd.v7+json' \
    -H 'Content-Type: application/json' \
    -H "If-Match: $etag" \
    -d "$(echo $body)"
fi

## Build pipeline yaml file
for i in {76..100}
do
  echo "Test-REPO$i"
## Build pipeline yaml file
cd /Users/siddhi.kadam/REPO/gocd-server/scripts
yq d $PROJECT_NAME.gocd.yaml 'pipelines.*.stages' | \
    yq w - "pipelines.$PROJECT_NAME.template" "$template_name" | \
    sed "s/testing-pipelines.git/Test-REPO$i.git/g;s/$PROJECT_NAME:/Test-REPO$i-release:/g" > "Test-REPO$i-release.gocd.yaml"

#set +e
#ssh -o StrictHostKeyChecking=no git@github.com
#set -e
cd ../repos
DIR=/Users/siddhi.kadam/REPO/gocd-server/repos/Test-REPO$i
if [ -d  "$DIR" ]; then
  echo "$DIR exist"
else
  pwd
  git clone -b master git@github.com:siddhi1907/Test-REPO$i.git
fi

git config --global user.name "siddhi1907"
git config --global user.email "kadamsiddhi95@gmail.con"
git config --global push.default simple
#
cd Test-REPO$i
mv ../../scripts/Test-REPO$i-release.gocd.yaml .

#if [ -z "$(git ls-remote --heads origin $BRANCH_NAME)" ]; then
#    git checkout -b $BRANCH_NAME
#    git push origin $BRANCH_NAME
#    git checkout master
#    git branch -D $BRANCH_NAME
#fi
#git checkout $BRANCH_NAME

#mv "../$PROJECT_NAME-release.gocd.yaml" .
git add Test-REPO$i-release.gocd.yaml

if [ -z "$(git status --porcelain)" ]; then
    echo "Pipelines are upto date"
else
    git commit -m "AUTO: Add Test-REPO$i-release.gocd.yaml"
    git remote set-url origin git@github.com:$GITHUBUSER/Test-REPO$i.git
    git push

fi



done
}

pipeline_setup