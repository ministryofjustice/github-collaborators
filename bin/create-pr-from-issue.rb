#!/usr/bin/env ruby

require_relative "../lib/create_pr_from_issue"

puts "Start"
GithubCollaborators::CreatePrFromIssue.new(ENV.fetch("ISSUE")).start
puts "Finished"
