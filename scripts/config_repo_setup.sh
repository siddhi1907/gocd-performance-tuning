#!/bin/bash

#INPUT="repo.txt"
for i in {1..4}
#while IFS= read -r id
do

curl 'https://gocd.example.com/go/api/admin/config_repos' \
  -u 'goadmin:goadmin' \
  -H 'Accept:application/vnd.go.cd.v4+json' \
  -H 'Content-Type:application/json' \
  -X POST -d "{
    \"id\": \"$id\",
    \"plugin_id\": \"yaml.config.plugin\",
    \"material\": {
      \"type\": \"git\",
      \"attributes\": {
        \"url\": \"https://github.com/siddhi1907/$id.git\",
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
done < $INPUT