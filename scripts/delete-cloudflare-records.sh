#!/usr/bin/env bash

DNS_RECORD_ID=$1
CLOUDFLARE_ZONE_ID=${2:-$TF_VAR_cloudflare_zone_id}
OUTPUT=tmp/cloudflare-records.json

mkdir -p $(dirname $OUTPUT)

curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$DNS_RECORD_ID" \
     -H "Authorization: Bearer ${TF_VAR_cloudflare_api_token}" \
     -H "Content-Type: application/json"
