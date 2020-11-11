#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

list = OrganizationExternalCollaborators.new(
  github_token: ENV.fetch("GITHUB_TOKEN"),
  login: "ministryofjustice"
).list

output = {
  data: list,
  updated_at: Time.now.strftime("%Y-%m-%d %H:%M:%S")
}

puts output.to_json
