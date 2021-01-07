#!/bin/bash

# Given a repository name and a github username, use the GitHub REST API to
# remove that collaborator from the repository. The GraphQL API does not have
# the capability to do this yet.
#
# This should only be used for collaborators who are not defined in
# terraform code.
#
# If you remove a collaborator who *is* defined in terraform, they will
# be replaced on the next `terraform apply`.

set -euo pipefail

OWNER=ministryofjustice

repo=$1
username=$2

url="https://api.github.com/repos/${OWNER}/${repo}/collaborators/${username}"

# exit with an error if $username is not a collaborator on $repo
is_collaborator() {
  echo "Checking if ${username} is a collaborator on ${repo}..."
  curl --fail \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${ADMIN_GITHUB_TOKEN}" \
    ${url}
}

remove_collaborator() {
  echo "Removing ${username} as a collaborator from ${repo}..."
  curl -X DELETE \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${ADMIN_GITHUB_TOKEN}" \
    ${url}
}

is_collaborator && remove_collaborator && echo "Removed"
