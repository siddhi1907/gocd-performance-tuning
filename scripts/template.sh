#!/usr/bin/env bash
set -e

GOCD_URL=${GOCD_URL:-gocd.example.com}


curl -s -k "https://$GOCD_URL/go/api/admin/pipelines/testing-pipelines" \
-u 'goadmin:goadmin' -H 'Accept: application/vnd.go.cd.v11+json' | jq '. | {name: .name, stages: .stages}' > template.gocd.json