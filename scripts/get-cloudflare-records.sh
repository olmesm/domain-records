#!/usr/bin/env bash

CLOUDFLARE_ZONE_ID=${1:-$TF_VAR_cloudflare_zone_id}
OUTPUT=tmp/cloudflare-records.json
mkdir -p $(dirname $OUTPUT)

curl -X GET "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
     -H "Authorization: Bearer ${TF_VAR_cloudflare_api_token}" \
     -H "Content-Type: application/json" > $OUTPUT