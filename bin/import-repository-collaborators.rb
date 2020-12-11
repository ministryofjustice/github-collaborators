#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

repositories = ARGV

raise "USAGE: #{$0} [repo name1] [repo name2] ..." if repositories.empty?

GithubCollaborators::RepositoryCollaboratorImporter.new(
  terraform_dir: "terraform",
  terraform_executable: ENV.fetch("TERRAFORM")
  org_ext_collabs: OrganizationExternalCollaborators.new(login: "ministryofjustice"),
).import(repositories)
