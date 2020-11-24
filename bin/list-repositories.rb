#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

repositories = Repositories.new(
  github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"),
  login: "ministryofjustice",
).current

repositories.map(&:name).sort.each { |repo| puts repo }
