#!/usr/bin/env ruby

require "erb"
require_relative "../lib/github_collaborators"

repository = ARGV.shift

raise "USAGE: #{$0} [repository name]" if repository.nil?

RepositoryCollaboratorImporter.new(
  terraform_dir: "terraform",
  terraform_executable: ENV.fetch("TERRAFORM"),
  github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"),
).import(repository)
