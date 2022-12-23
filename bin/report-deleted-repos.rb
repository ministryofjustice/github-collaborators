# #!/usr/bin/env ruby
# include HelperModule

# require_relative "../lib/github_collaborators"

# puts "Start"

# terraform_dir = "terraform"

# # Returns the repo name from within a repo file
# # This is to deal with a difference in file name and defined repo name inside the Terraform modules
# def get_repo_name(repo_file)
# if(File.exist?('Hello.rb'))
#   puts 'file or directory exists'
# else
#   puts 'file or directory not found'
# end
#   File.open repo_file do |file|
#     # Grab repo line
#     line = file.find_all { |line| line =~ /\s{1}repository/ }
#     # Extract name
#     /(?<=(["']))(?:(?=(\\?))\2.)*?(?=\1)/.match(line[0])
#   end
# end

# # Body of the PR
# def create_hash(pull_file, branch)
#   {
#     title: "Remove #{pull_file} as repository being deleted ",
#     head: branch,
#     base: "main",
#     body: <<~EOF
#       Hi there

#       The repository that is maintained by the file #{pull_file} has been deleted/archived

#       Please merge this pull request to delete the file.

#       If you have any questions, please post in #ask-operations-engineering on Slack.
#     EOF
#   }
# end

# # Get list of Terraform defined repos
# terraform_repos = Dir.glob("#{terraform_dir}/*.tf").map { |file_name| File.basename(file_name, File.extname(file_name)) }

# # Get all GitHub repos
# repositories = get_active_repositories

# # Get repos that are not on GitHub and remove files required by Terraform
# repo_delta = (terraform_repos - repositories) - ["main", "variables", "versions", "backend"]

# # Check to make sure the repo isn't in redirect mode or replacing . with - in the filename for Terraform
# repo_delta.delete_if { |repo|
#   repo_name = get_repo_name("#{terraform_dir}/#{repo}.tf")
#   GithubCollaborators::HttpClient.new.fetch_json("#{GH_API_URL}/#{repo}").code == "301" ||
#     GithubCollaborators::HttpClient.new.fetch_json("#{GH_API_URL}/#{repo_name}").code != "404"
# }

# puts "Current repo files that need deleting"
# puts repo_delta

# # -------------------------
# # Report section over
# # -------------------------

# # Open PRs for all the deleted repos

# # Grab current open PRs
# pull_requests = get_pull_requests

# # Delete from actionable array if PR already created
# # Two scenarios:
# #   a. we have already created a PR to remove
# #   b. for some reason there is a PR currently open with this file included
# # In both scenarios we do not want to create a PR
# repo_delta.delete_if { |repo|
#   pull_requests.map(&:file).include?("#{terraform_dir}/#{repo}.tf")
# }

# # Report files that need PRs
# puts "Current repo files that need deleting but do not have a PR"
# puts repo_delta

# repo_delta.each { |repo|
#   file_name = "#{terraform_dir}/#{repo}.tf"

#   # Create branch
#   branch_name = "remove-#{repo}-tf-file"
#   bc = GithubCollaborators::BranchCreator.new
#   branch_name = bc.check_branch_name_is_valid(branch_name)
#   bc.create_branch(branch_name)
#   bc.remove(file_name)
#   bc.commit_and_push("Remove #{file_name} as repository has been deleted/archived.")

#   sleep 5

#   # Create PR
#   create_pull_request(create_hash(file_name, branch_name))
# }

# puts "Finished"
