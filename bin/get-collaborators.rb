#!/usr/bin/env ruby

require "pry-byebug"
require_relative "../lib/github_collaborators"

# org = Organization.new(
#   github_token: ENV.fetch("GITHUB_TOKEN"),
#   login: "ministryofjustice"
# )
#
# collabs = RepositoryCollaborators.new(
#   github_token: ENV.fetch("GITHUB_TOKEN"),
#   owner: "ministryofjustice",
#   repository: "testing-external-collaborators"
# )

repositories = Repositories.new(
  github_token: ENV.fetch("GITHUB_TOKEN"),
  login: "ministryofjustice"
)

# list = collabs.list

list = repositories.list

binding.pry

puts "done"
