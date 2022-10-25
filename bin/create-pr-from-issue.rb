#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

# GitHub settings
owner = "ministryofjustice"

# Creates a branch and commits all changed files
def create_branch_for_pr
  # Init local Git
  g = Git.open(".")

  Git.global_config("user.name", "Operations Engineering Bot")
  Git.global_config("user.email", "dummy@email.com")

  # Generate random uuid for branch name
  branch_name = UUIDTools::UUID.timestamp_create.to_s

  # Create branch and checkout
  g.branch(branch_name).create
  g.checkout(branch_name)

  # Stage file
  g.add("terraform/*")

  # Commit
  g.commit("Pull request to add new outside collaborator")

  # Push
  g.push(g.remote("origin"), branch_name)

  # Cleanup
  g.checkout("main")

  # Return branch name for PR creation
  branch_name
end

# Body of the PR
def create_hash(branch_name)
  {
    title: "Outside Collaborator PR",
    head: branch_name,
    base: "main",
    body: <<~EOF
      Hi there
      
      Please merge this pull request to add the attached outside collaborator to GitHub.
      
      If you have any questions, please post in #ask-operations-engineering on Slack.
    EOF
  }
end

# Grab the new collaborators and insert them into file
GithubCollaborators::TerraformBlockCreator.new(JSON.parse(ENV.fetch("ISSUE"))).insert

branch_name = create_branch_for_pr
hash_data = create_hash(branch_name)

# Create branch and open PR
params = {
  owner: owner,
  repository: "github-collaborators",
  hash_body: hash_data
}

GithubCollaborators::PullRequestCreator.new(params).create
