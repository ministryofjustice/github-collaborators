#!/bin/bash

# Script to run a targeted plan against only those repositories' terraform
# files which are changed by the current PR. A full `terraform plan` takes
# several minutes, so this should enable people to get faster feedback on
# proposed changes.
#
# NB: This is quite brittle, because it depends on the module name exactly
# matching the `terraform/*.tf` filename

set -euo pipefail

main() {
  cd terraform
  echo "Running terraform init"
  # Suppress init output, unless it fails
  output=$(${TERRAFORM} init -input=false 2>&1) || (echo "$output" && false)

  for r in $(changed_repositories); do
    echo "Running terraform plan for ${r}"
    ${TERRAFORM} plan -target=module.${r} -lock-timeout=660s
  done
}

changed_repositories() {
  git fetch origin main:refs/remotes/origin/main # Ensure we have the `main` branch
  git diff origin/main --name-only -- terraform/ | sed 's/^terraform.\(.*\)\.tf$/\1/'
}

main
