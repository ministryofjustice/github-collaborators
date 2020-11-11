#!/bin/sh

curl -vvv -H "X-API-KEY: ${OPERATIONS_ENGINEERING_REPORTS_API_KEY}" -d "$(bin/external-collaborators.rb)" ${OPS_ENG_REPORTS_URL}
