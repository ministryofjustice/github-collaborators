#!/usr/bin/env ruby

require "pry-byebug"
require_relative "../lib/github_collaborators"

org = Organization.new(
  github_token: ENV.fetch("GITHUB_TOKEN"),
  login: "ministryofjustice"
)

members = org.members
puts members.size
pp members.first
pp members.last
