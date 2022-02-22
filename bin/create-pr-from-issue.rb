#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

# Grab GitHub token
token = ENV.fetch("ADMIN_GITHUB_TOKEN")

# GitHub settings
owner = "ministryofjustice"
repository = "github-collaborators"

# Creates a branch and commits all changed files
# This probably deserves its own class but keeping it here for now until we need more major functionality in this area
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
  g.add(paths = "terraform/*")

  # Commit
  g.commit("Pull request to add new outside collaborator")

  # Push
  g.push(
    remote = g.remote("origin"),
    branch = branch_name
  )

  # Cleanup
  g.checkout("main")

  # Return branch name for PR creation
  branch_name
end

# Returns string for PR body
def pull_hash(branch)
  {
    title: "Outside Collaborator PR",
    head: branch,
    base: "main",
    body: <<~EOF
      Hi there
      
      Please merge this pull request to add the attached outside collaborator to GitHub.
      
      If you have any questions, please post in #ask-operations-engineering on Slack.
    EOF
  }
end

# Grab the new collaborators and insert them into file
new_terraform_blocks = GithubCollaborators::TerraformBlockCreator.new(JSON.parse(ENV.fetch("ISSUE"))).insert

# Create branch and open PR
params = {
  owner: owner,
  repository: "github-collaborators",
  pull_file: nil,
  branch: create_branch_for_pr
}

GithubCollaborators::PullRequestCreator.new(params).create(pull_hash = pull_hash(params.fetch(:branch)))
