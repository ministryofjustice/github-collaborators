#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

def remove_collaborator(hash)
  repository = hash.fetch("repository")
  github_user = hash.fetch("login")

  puts "Removing collaborator #{github_user} from repository #{repository}"

  params = {
    owner: ENV.fetch("OWNER"),
    repository: repository,
    github_user: github_user
  }

  # We must create the issue before removing access, because the issue is
  # assigned to the removed collaborator, so that they (hopefully) get a
  # notification about it.
  GithubCollaborators::IssueCreator.new(params).create
  GithubCollaborators::AccessRemover.new(params).remove
end

############################################################

remove_collaborator(
  "repository" => ENV.fetch("REPO").to_s,
  "login" => ENV.fetch("USERNAME").to_s
)
