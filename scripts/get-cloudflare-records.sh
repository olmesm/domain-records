#!/usr/bin/env bash

OUTPUT=tmp/cloudflare-records.json

mkdir -p $(dirname $OUTPUT)

curl -X GET "https://api.cloudflare.com/client/v4/zones/$TF_VAR_cloudflare_zone_id/dns_records" \
     -H "X-Auth-Email: $TF_VAR_cloudflare_email" \
     -H "X-Auth-Key: $TF_VAR_cloudflare_api_key" \
     -H "Content-Type: application/json" > $OUTPUT