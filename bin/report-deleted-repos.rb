#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

login = "ministryofjustice"
base_url = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"

# Set repo Terraform directory
terraform_dir = "terraform"

# Returns the repo name from within a repo file
# This is to deal with a difference in file name and defined repo name inside the Terraform modules
def get_repo_name(repo_file)
  File.open repo_file do |file|
    # Grab repo line
    line = file.find_all { |line| line =~ /\s{1}repository/ }
    # Extract name
    /(?<=(["']))(?:(?=(\\?))\2.)*?(?=\1)/.match(line[0])
  end
end

# Creates a branch to remove a singular file
# This probably deserves its own class but keeping it here for now until we need more major functionality in this area
def create_branch_for_file(file)
  # Init local Git
  g = Git.open(".")

  g.config("user.name", "Operations Engineering Bot")
  g.config("user.email", "dummy@email.com")

  # Generate random uuid for branch name
  branch_name = UUIDTools::UUID.timestamp_create.to_s

  # Create branch and checkout
  g.branch(branch_name).create
  g.checkout(branch_name)

  # Stage file
  g.remove(file)

  # Commit
  g.commit("Remove #{file} as repository has been deleted/archived")

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

# Get list of Terraform defined repos
terraform_repos = Dir.glob("#{terraform_dir}/*.tf").map { |file_name| File.basename(file_name, File.extname(file_name)) }

# Get live list of all GitHub repos
repositories_json = GithubCollaborators::Repositories.new(login: login).current
repositories = repositories_json.map(&:name).sort

# Get repos that are not on GitHub and remove files required by Terraform
repo_delta = (terraform_repos - repositories) - ["main", "variables", "versions", "backend"]

# Check to make sure the repo isn't in redirect mode or replacing . with - in the filename for Terraform
repo_delta.delete_if { |repo|
  repo_name = get_repo_name("#{terraform_dir}/#{repo}.tf")
  GithubCollaborators::HttpClient.new.fetch_json("https://api.github.com/repos/#{login}/#{repo}").code == "301" ||
    GithubCollaborators::HttpClient.new.fetch_json("https://api.github.com/repos/#{login}/#{repo_name}").code != "404"
}

puts "Current repo files that need deleting"
puts repo_delta

# -------------------------
# Report section over
# -------------------------

# Open PRs for all the deleted repos

# Grab current open PRs
pull_requests = GithubCollaborators::PullRequests.new(login: login).list

# Delete from actionable array if PR already created
# Two scenarios:
#   a. we have already created a PR to remove
#   b. for some reason there is a PR currently open with this file included
# In both scenarios we do not want to create a PR
repo_delta.delete_if { |repo|
  pull_requests.map(&:file).include? "#{terraform_dir}/#{repo}.tf"
}

# Report files that need PRs
puts "Current repo files that need deleting but do not have a PR"
puts repo_delta

# Create PRs
repo_delta.each { |repo|
  branch_name = create_branch_for_file("#{terraform_dir}/#{repo}.tf")

  # Give GitHub some time
  sleep 5

  params = {
    owner: login,
    repository: "github-collaborators",
    pull_file: "#{terraform_dir}/#{repo}.tf",
    branch: branch_name
  }

  GithubCollaborators::PullRequestCreator.new(params).create
}
