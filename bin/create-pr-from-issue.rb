# #!/usr/bin/env ruby

# require_relative "../lib/github_collaborators"
# include HelperModule

# puts "Start"

# # Body of the PR
# def create_hash(branch_name)
#   {
#     title: "Outside Collaborator PR",
#     head: branch_name,
#     base: "main",
#     body: <<~EOF
#       Hi there

#       Please merge this pull request to add the attached outside collaborator to GitHub.

#       If you have any questions, please post in #ask-operations-engineering on Slack.
#     EOF
#   }
# end

# # Grab the new collaborators and write them into file/s
# tc = GithubCollaborators::TerraformBlockCreator.new
# tc.add_data_from_issue(JSON.parse(ENV.fetch("ISSUE")))
# tc.update_files

# # Create branch
# branch_name = "add-a-new-collaborator-#{tc.username}"
# bc = GithubCollaborators::BranchCreator.new.create_branch(branch_name)
# bc.add("terraform/*")
# bc.commit_and_push("Pull request to add new outside collaborator")

# sleep 5

# # Open PR
# create_pull_request(create_hash(branch_name))

# puts "Finished"
