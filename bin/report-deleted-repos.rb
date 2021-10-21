#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

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

# Get list of Terraform defined repos
terraform_repos = Dir.glob("#{terraform_dir}/*.tf").map { |file_name| File.basename(file_name, File.extname(file_name)) }

# Get live list of all GitHub repos
repositories_json = GithubCollaborators::Repositories.new(login: "ministryofjustice").current
repositories = repositories_json.map(&:name).sort

# Get repos that are not on GitHub and remove files required by Terraform
repo_delta = (terraform_repos - repositories) - ["main", "variables", "versions"]

# Check to make sure the repo isn't in redirect mode
repo_delta.delete_if { |repo|
  repo_name = get_repo_name("#{terraform_dir}/#{repo}.tf")
  GithubCollaborators::HttpClient.new.fetch_json("https://api.github.com/repos/ministryofjustice/#{repo}").code == "301" ||
    GithubCollaborators::HttpClient.new.fetch_json("https://api.github.com/repos/ministryofjustice/#{repo_name}").code != "404"
}

puts repo_delta
