#!/bin/sh

# Fetch the remote terraform.tfstate file and dump it to stdout This
# will enable a ruby script to parse and inspect the JSON content.

set -euo pipefail

source="s3://${S3_BUCKET_NAME}/terraform.tfstate"

TEMPFILE="tempfile"

output=$(
  docker run --rm \
    -e AWS_REGION="eu-west-2" \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e S3_BUCKET_NAME=${S3_BUCKET_NAME} \
    -v ${PWD}:/app \
    -w /app \
    amazon/aws-cli s3 cp ${source} ${TEMPFILE}
)
cat ${TEMPFILE}
rm ${TEMPFILE}
