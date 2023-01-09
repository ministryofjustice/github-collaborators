#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

class CreatePrFromIssue
  include Logging
  include HelperModule

  def initialize
    # Collects the Terraform files and collaborators
    @terraform_files = GithubCollaborators::TerraformFiles.new
  end

  def start
    # This functions takes the body generated from a GitHub ticket
    # created within /.github/ISSUE_TEMPLATE/create-pr-from-issue.yaml
    # Creates a hash of arrays with field: [0] value
    # From a GitHub issues reponse created from an issue template
    # Example:
    # username: Array (1 element)
    #   [0]: 'al-ben
    # repositories: Array (4 elements)
    #   [0]: 'repo1'
    #   [1]: 'repo2'
    the_data = JSON.parse(ENV.fetch("ISSUE"))
      # Fetch the body var and split on field seperator
      .fetch("body").split("###")
      # Remove empty lines
      .map { |line| line.strip }.map { |str| str.gsub(/^$\n/, "") }
      # Split on \n characters to have field name and field value in seperator hash
      .map { |line| line.split("\n") }
      # Drop first hash element as not needed
      .drop(1)
      # Map values into array
      .map { |field| [field[0], field.drop(1)] }.to_h

    username = the_data["username"][0]
    permission = the_data["permission"][0]
    email = the_data["email"][0]
    name = the_data["name"][0]
    org = the_data["org"][0]
    reason = the_data["reason"][0]
    added_by = the_data["added_by"][0]
    review_after = the_data["review_after"][0]
    repositories = the_data["repositories"]

    collaborator = {
      login: username.downcase,
      permission: permission,
      name: name,
      email: email,
      org: org,
      reason: reason,
      added_by: added_by,
      review_after: review_after
    }

    if repositories.nil?
      warn("No repositories in Issue")
      exit(1)
    end

    # Add user to Terraform file/s
    edited_files = []
    terraform_files = @terraform_files.get_terraform_files
    repositories.each do |repository_name|
      if @terraform_files.ensure_file_exists_in_memory(repository_name)
        terraform_files.each do |terraform_file|
          if terraform_file == repository_name
            terraform_file.add_collaborator_from_issue(collaborator)
            terraform_file.write_to_file
            edited_files.push("terraform/#{repository_name}.tf")
          end
        end
      end
    end

    if edited_files.length > 0
      collaborator_name = username.downcase
      branch_name = "add-collaborator-from-issue-#{collaborator_name}"
      pull_request_title = "#{ADD_COLLAB_FROM_ISSUE} #{collaborator_name}"
      type = TYPE_ADD_FROM_ISSUE
      create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
    end
  end
end

puts "Start"
CreatePrFromIssue.new.start
puts "Finished"
