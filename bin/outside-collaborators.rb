#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

outside_collaborators = GithubCollaborators::OutsideCollaborators.new
outside_collaborators.check_collaborators_from_github
# terraform_files_outside_collaborators.check_collaborators_in_files

puts "Finished"