#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

login = "ministryofjustice"
base_url = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"

# Create a list of users that are outside collaborators ie not MoJ Organisation Members
outside_collaborator_list = GithubCollaborators::OrganizationOutsideCollaborators.new(
  login: login,
  base_url: base_url
).list

# Loop through the list of outside collaborators
outside_collaborator_list.each do |x|
  # If issue has been raised and a grace period has expired then close issue
  params = {
    owner: login,
    repository: x["repository"],
    github_user: x["login"]
  }
  # Look into removing expired issues
  GithubCollaborators::IssueCreator.new(params).close_expired_issues

  # If issues include review date being within a month, create an issue on the repo
  if x["issues"].include? "Review after date is within a month"
    # Create issue
    GithubCollaborators::IssueCreator.new(params).create_review_date
  end
end
