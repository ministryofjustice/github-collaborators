#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

outside_collaborators = GithubCollaborators::OutsideCollaborators.new
outside_collaborators.start

puts "Finished"
