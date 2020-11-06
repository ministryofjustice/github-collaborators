#!/usr/bin/env ruby

require "pry-byebug"
require_relative "../lib/github_collaborators"

collabs = RepositoryCollaborators.new(
  github_token: ENV.fetch("GITHUB_TOKEN"),
  owner: "ministryofjustice",
  repository: "testing-external-collaborators"
)

list = collabs.list

binding.pry

puts "done"
