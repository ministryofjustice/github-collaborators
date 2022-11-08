#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

outside_collaborators = GithubCollaborators::OutsideCollaborators.new
outside_collaborators.compare_terraform_and_github
outside_collaborators.collaborator_checks
outside_collaborators.full_org_members

puts "Finished"
