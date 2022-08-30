#!/usr/bin/env bash

PARENT="$(basename $(pwd))"
PROJECT_ID=$1
BUCKET_NAME=${2:-$PARENT}

gsutil mb -p $PROJECT_ID gs://$BUCKET_NAME
