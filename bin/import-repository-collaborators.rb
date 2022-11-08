#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

repositories = ARGV

raise "USAGE: #{$0} [repo name1] [repo name2] ..." if repositories.empty?

GithubCollaborators::RepositoryCollaboratorImporter.new(
  terraform_dir: "terraform",
  terraform_executable: ENV.fetch("TERRAFORM"),
  org_outside_collabs: GithubCollaborators::OrganizationOutsideCollaborators.new(
    login: "ministryofjustice",
    base_url: "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"
  )
).import(repositories)

puts "Finished"
