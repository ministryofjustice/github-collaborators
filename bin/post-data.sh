#!/bin/sh

curl -vvv \
  -H "Content-Type: application/json" \
  -H "X-API-KEY: ${OPERATIONS_ENGINEERING_REPORTS_API_KEY}" \
  -d "$(bin/external-collaborators.rb)" \
  ${OPS_ENG_REPORTS_URL}
