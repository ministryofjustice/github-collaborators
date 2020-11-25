#!/usr/bin/env ruby

# Script to compare repository collaborators in github against those in the
# terraform state, to identify collaborators who were added manually, rather
# than via the terraform code in this repository.  Any such collaborators will
# be invisible to terraform.

require "json"

OPS_ENG_REPORT_URL = "https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_collaborators"

# Use the Operations Engineering github collaborators report as the source of
# truth for external collaborators with access to any of our repositories, and
# return it as a list of "<repo>,<username>" strings
def repo_collaborators_from_github
  cmd = %[curl -sH "Accept: application/json" #{OPS_ENG_REPORT_URL}]
  json = `#{cmd}`
  github = JSON.parse(json)
  normalise github.fetch("data")
end

# Get all github collaborators defined in our terraform state, and return it as
# a list of "<repo>,<username>" strings

def repo_collaborators_from_terraform
  json = `bin/s3cat-terraform-state.sh`
  terraform_state = JSON.parse(json)

  data = terraform_state.fetch("resources").map do |resource|
    resource.fetch("instances").map do |collab|
      {
        "repository" => collab.dig("attributes", "repository"),
        "login" => collab.dig("attributes", "username"),
      }
    end
  end.flatten

  normalise data
end

def normalise(list)
  list.map { |i| [ i.fetch("repository"), i.fetch("login") ].join(",") }
end

github = repo_collaborators_from_github
terraform = repo_collaborators_from_terraform
unmanaged_collaborators = github - terraform

pp unmanaged_collaborators
