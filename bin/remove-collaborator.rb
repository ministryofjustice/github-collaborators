#!/usr/bin/env ruby

# Fetch the "insufficiently defined collaborators" report as JSON, and remove
# any collaborators who are not defined in terraform.

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

  pp params

  # We must create the issue before removing access, because the issue is
  # assigned to the removed collaborator, so that they (hopefully) get a
  # notification about it.
  puts "create issue:"
  pp GithubCollaborators::IssueCreator.new(params).create
  puts "remove collaborator:"
  pp GithubCollaborators::AccessRemover.new(params).remove
end

############################################################

json = %[
{
  "repository": "#{ENV.fetch("REPO")}",
  "login": "#{ENV.fetch("USERNAME")}",
  "status": "fail",
  "issues": [
    "Collaborator not defined in terraform"
  ],
  "href": "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/",
  "defined_in_terraform": false,
  "repo_url": "https://github.com/ministryofjustice/tax-tribunals-datacapture",
  "login_url": "https://github.com/jriga",
  "permission": "push",
  "last_commit": "2021-01-18T13:00:46Z"
}
]
c = JSON.parse(json)

remove_collaborator(c)
