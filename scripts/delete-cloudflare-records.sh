#!/usr/bin/env bash

DNS_RECORD_ID=$1
CLOUDFLARE_ZONE_ID=${2:-TF_VAR_cloudflare_zone_id}
OUTPUT=tmp/cloudflare-records.json

mkdir -p $(dirname $OUTPUT)

curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/dns_records/$DNS_RECORD_ID" \
     -H "X-Auth-Email: $TF_VAR_cloudflare_email" \
     -H "X-Auth-Key: $TF_VAR_cloudflare_api_key" \
     -H "Content-Type: application/json"
