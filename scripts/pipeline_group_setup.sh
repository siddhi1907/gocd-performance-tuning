#!/bin/bash

# Add pipeline to pipeline group
for i in {76..78}
do
  echo "Test-REPO$i"

#cd /Users/siddhi.kadam/REPO/gocd-server/repos
DIR=/Users/siddhi.kadam/REPO/gocd-server/repos/testing-pipelines
if [ -d  "$DIR" ]; then
  echo "$DIR exist"
else
  cd /Users/siddhi.kadam/REPO/gocd-server/repos
  git clone -b master git@github.com:siddhi1907/testing-pipelines.git
fi

cd /Users/siddhi.kadam/REPO/gocd-server/repos/testing-pipelines/
#yq d environments/infra.gocd.yaml  "environments.infra.pipelines[*]"
#yq w -i environments/infra.gocd.yaml "environments.infra.pipelines[+]" "$PROJECT_NAME"
yq w -i environments/infra.gocd.yaml "environments.infra.pipelines[+]" "Test-REPO$i-release"
git add environments/infra.gocd.yaml
git commit -m "AUTO: Add Test-REPO$i pipeline to infra env"
git push
done
