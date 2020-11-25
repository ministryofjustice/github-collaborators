#!/usr/bin/env ruby

# Script to compare repository collaborators in github against those in the
# terraform state, to identify collaborators who were added manually, rather
# than via the terraform code in this repository.  Any such collaborators will
# be invisible to terraform.

require "json"

json = `bin/s3cat-terraform-state.sh`
terraform_state = JSON.parse(json)

data = terraform_state.fetch("resources").map do |resource|
  resource.fetch("instances").map do |collab|
    {
      repository: collab.dig("attributes", "repository"),
      login: collab.dig("attributes", "username"),
    }
  end
end.flatten

pp data
