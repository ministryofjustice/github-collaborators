#!/usr/bin/env ruby

# Fetch the data as JSON from the Operations Engineering Collaborator Report website,
# and remove any collaborators who are not defined in terraform.

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

url = ENV.fetch("OPS_ENG_REPORTS_URL")
json = GithubCollaborators::HttpClient.new.fetch_json(url).body

if json == ""
  return
end

JSON.parse(json)
  .fetch("data")
  .find_all { |c| !c["defined_in_terraform"] }
  .map { |c| remove_collaborator(c) }
