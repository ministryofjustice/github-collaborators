#!/usr/bin/env ruby

require "erb"
require_relative "../lib/github_collaborators"

def main(repository)
  collaborators = external_collaborators(repository)
  terraform = render_template(repository, collaborators)
  output_file = "terraform/#{repository}.tf"
  File.write(output_file, terraform)
  puts "Generated terraform file: #{output_file}"
end

def external_collaborators(repository)
  OrganizationExternalCollaborators.new(
    github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"),
    login: "ministryofjustice"
  ).for_repository(repository)
end

def render_template(repository, collaborators)
  template = <<EOF
module "<%= repository %>" {
  source     = "./modules/repository-collaborators"
  repository = "<%= repository %>"
  collaborators = {
  <% collaborators.each do |collab| %>
  <%= collab[:login] %> = "<%= collab[:permission] %>"
  <% end %>
}
}
EOF
  renderer = ERB.new(template, 0, ">")
  renderer.result(binding)
end

repository = ARGV.shift
raise "USAGE: #{$0} [repository name]" if repository.nil?
main(repository)


