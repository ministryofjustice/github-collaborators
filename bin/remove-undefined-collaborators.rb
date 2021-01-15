#!/usr/bin/env ruby

# Fetch the "insufficiently defined collaborators" report as JSON, and remove
# any collaborators who are not defined in terraform.

require_relative "../lib/github_collaborators"

OWNER = "ministryofjustice"
REPORT_URL = "https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_collaborators"

def remove_collaborator(hash)
  repository = hash.fetch("repository")
  github_user = hash.fetch("login")

  puts "Removing collaborator #{login} from repository #{repository}"

  params = {
    owner: OWNER,
    repository: repository,
    github_user: login,
  }

  # We must create the issue before removing access, because the issue is
  # assigned to the removed collaborator, so that they (hopefully) get a
  # notification about it.
  GithubCollaborators::IssueCreator.new(params).create
  GithubCollaborators::AccessRemover.new(params).remove
end

json = GithubCollaborators::HttpClient.new.fetch_json(REPORT_URL).body

JSON.parse(json)
  .fetch("data")
  .filter { |c| !c["defined_in_terraform"] }
  .map { |c| remove_collaborator(c) }
