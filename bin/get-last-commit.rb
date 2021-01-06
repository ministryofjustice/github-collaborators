#!/usr/bin/env ruby

# Given an org, repo and github username, output the date when that user last
# committed to the default branch of the repo.

require_relative "../lib/github_collaborators"

org, repo, username = ARGV

puts "org: #{org}"
puts "repo: #{repo}"
puts "username: #{username}"

graphql = GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))

date = GithubCollaborators::LastCommit.new(
  graphql: graphql,
  login: username,
  org: org,
  repo: repo
).date

puts "date: #{date}"
