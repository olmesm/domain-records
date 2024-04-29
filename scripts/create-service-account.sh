#!/usr/bin/env bash

PROJECT_ID=$1
ACCOUNT_NAME=${2:-"terraform-service-account"}

OUTPUT=tmp/service-account.json

mkdir -p $(dirname $OUTPUT)

gcloud auth application-default login --project $PROJECT_ID --no-launch-browser

gcloud iam service-accounts create $ACCOUNT_NAME \
  --project=$PROJECT_ID \
  --description="Terraform Service Account" \
  --display-name="Terraform Service Account"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --project=$PROJECT_ID \
  --member="serviceAccount:$ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"

gcloud iam service-accounts keys create $OUTPUT \
  --project=$PROJECT_ID \
  --iam-account="$ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --key-file-type=json

echo "\nBASE64_GOOGLE_APPLICATION_CREDENTIALS=$(cat $OUTPUT | base64)" >> .env
echo "GOOGLE_APPLICATION_CREDENTIALS=$OUTPUT" >> .env