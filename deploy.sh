#!/bin/sh
# Deploy this site to AWS Amplify (app d348k633qx8l8h, branch main).
set -e
cd "$(dirname "$0")"
if [ ! -f assets/scr-feed.jpg ]; then echo "ERROR: assets/ missing — aborting"; exit 1; fi
zip -q -r site.zip index.html assets -x '*.DS_Store'
out=$(aws amplify create-deployment --app-id d348k633qx8l8h --branch-name main --output json)
job=$(printf '%s' "$out" | python3 -c 'import sys,json;print(json.load(sys.stdin)["jobId"])')
url=$(printf '%s' "$out" | python3 -c 'import sys,json;print(json.load(sys.stdin)["zipUploadUrl"])')
curl -sf -T site.zip "$url"
aws amplify start-deployment --app-id d348k633qx8l8h --branch-name main --job-id "$job" --query 'jobSummary.status' --output text
rm -f site.zip
echo "deployed: https://hexaduoventures.dev"
