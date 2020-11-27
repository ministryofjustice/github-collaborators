#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

list = GithubCollaborators::OrganizationExternalCollaborators.new(
  github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"),
  login: "ministryofjustice"
).list

output = {
  data: list,
  updated_at: Time.now.strftime("%Y-%m-%d %H:%M:%S")
}

puts output.to_json
