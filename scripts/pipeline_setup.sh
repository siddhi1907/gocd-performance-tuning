#!/bin/bash
set -e
set -x


GITHUBUSER=$(git config github.user)
INPUT="repo.txt"

GOCD_URL=${GOCD_URL:-gocd.example.com}
PROJECT_NAME=simple-go-server
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

#while IFS= read -r REPONAME
## Build pipeline yaml file

for i in {1..4}
do
  echo "Test-REPO$i"
## Build pipeline yaml file
cd /Users/siddhi.kadam/REPO/gocd-server/repos/gocd-performance-tuning/scripts
yq d $PROJECT_NAME.gocd.yaml 'pipelines.*.stages' | \
    yq w - "pipelines.$PROJECT_NAME.template" "$template_name" | \
    sed "s/simple-go-server.git/Test-REPO$i.git/g;s/$PROJECT_NAME:/$PROJECT_NAME-release:/g" > "Test-REPO$i-release.gocd.yaml"
#    sed "s/simple-go-server.git/Test-REPO$i.git/g" >> "$PROJECT_NAME-release.gocd.yaml"

#   yq w - "pipelines.$PROJECT_NAME.materials.*.branch" "$BRANCH_NAME" | \
#done < $INPUT


#set +e
#ssh -o StrictHostKeyChecking=no git@github.com
#set -e
cd ../../../repos/
DIR=/Users/siddhi.kadam/REPO/gocd-server/repos/Testing-Pipelines
if [ -d  "$DIR" ]; then
  echo "$DIR exist"
else
git clone git@github.com:siddhi1907/Testing-Pipelines.git
fi
git config --global user.name "siddhi1907"
git config --global user.email "kadamsiddhi95@gmail.con"
git config --global push.default simple
#
cd Testing-Pipelines
mv ../gocd-performance-tuning/scripts/Test-REPO$i-release.gocd.yaml .


#mv "$PROJECT_NAME-release.gocd.yaml" ../../../repos/Testing-Pipelines


#if [ -z "$(git ls-remote --heads origin $BRANCH_NAME)" ]; then
#    git checkout -b $BRANCH_NAME
#    git push origin $BRANCH_NAME
#    git checkout master
#    git branch -D $BRANCH_NAME
#fi
#git checkout $BRANCH_NAME

#mv "../$PROJECT_NAME-release.gocd.yaml" .
git add .
#
if [ -z "$(git status --porcelain)" ]; then
    echo "Pipelines are upto date"
else
    git commit -m "AUTO: Add $PROJECT_NAME-release.gocd.yaml"
    git push
fi
done