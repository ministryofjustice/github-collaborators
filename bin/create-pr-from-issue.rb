#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

# GitHub settings
owner = "ministryofjustice"

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
tc = GithubCollaborators::TerraformBlockCreator.new(JSON.parse(ENV.fetch("ISSUE"))).insert

# Create branch
branch_name = "add-a-new-collaborator-#{tc.username}"
bc = GithubCollaborators::BranchCreator::new.create_branch(branch_name)
bc.add("terraform/*")
bc.commit_and_push("Pull request to add new outside collaborator")

params = {
  owner: owner,
  repository: "github-collaborators",
  hash_body: create_hash(branch_name)
}

sleep 5

# Open PR
GithubCollaborators::PullRequestCreator.new(params).create_pull_request

puts "Finished"