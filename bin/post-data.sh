#!/bin/sh

bin/external-collaborators.rb > data.json

curl -vvv \
  -H "Content-Type: application/json" \
  -H "X-API-KEY: ${OPERATIONS_ENGINEERING_REPORTS_API_KEY}" \
  -d @data.json \
  ${OPS_ENG_REPORTS_URL}
