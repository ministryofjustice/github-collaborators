#!/usr/bin/env ruby

require "erb"
require_relative "../lib/github_collaborators"

repository = ARGV.shift

collaborators = OrganizationExternalCollaborators.new(
  github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"),
  login: "ministryofjustice"
).for_repository(repository)

template = <<EOF
module "<%= repository %>" {
  source     = "./modules/repository"
  repository = "<%= repository %>"
  collaborators = {
  <% collaborators.each do |collab| %>
  <%= collab[:login] %> = "<%= collab[:permission] %>"
  <% end %>
}
}
EOF

renderer = ERB.new(template, 0, ">")
puts renderer.result()

