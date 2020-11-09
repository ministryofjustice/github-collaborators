#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

list = OrganizationExternalCollaborators.new(
  github_token: ENV.fetch("GITHUB_TOKEN"),
  login: "ministryofjustice"
).list

puts list.to_json
