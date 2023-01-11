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

    repositories = []
    the_data["repositories"].each do |repository|
      # Remove any spaces, new lines, tabs, etc
      repositories.push(repository.delete(" \t\r\n"))
    end

    # Remove any spaces, new lines, tabs, etc
    username = username.delete(" \t\r\n")
    requested_permission = permission.delete(" \t\r\n")
    email = email.delete(" \t\r\n")
    name = name.delete("\t\r\n")
    org = org.delete("\t\r\n")
    reason = reason.delete("\t\r\n")
    added_by = added_by.delete("\t\r\n")
    review_after = review_after.delete("\t\r\n")

    url = "https://api.github.com/users/#{username}"
    http_code = GithubCollaborators::HttpClient.new.fetch_code(url)
    if http_code != "200"
      warn("Username is not valid in Issue")
      exit(1)
    end

    permissions = ["admin", "pull", "push", "maintain", "triage"]
    if permissions.include?(requested_permission.downcase) == false
      warn("Incorrect permission used in Issue")
      exit(1)
    end

    temp_name = name.delete(" \t\r\n")
    if name.nil? || name == "" || temp_name == ""
      warn("No name in Issue")
      exit(1)
    end

    temp_email = email.delete(" \t\r\n")
    if email.nil? || email == "" || temp_email == ""
      warn("No email in Issue")
      exit(1)
    end

    temp_org = org.delete(" \t\r\n")
    if org.nil? || org == "" || temp_org == ""
      warn("No organisation in Issue")
      exit(1)
    end

    temp_reason = reason.delete(" \t\r\n")
    if reason.nil? || reason == "" || temp_reason == ""
      warn("No reason in Issue")
      exit(1)
    end

    temp_added_by = added_by.delete(" \t\r\n")
    if added_by.nil? || added_by == "" || temp_added_by == ""
      warn("No added_by in Issue")
      exit(1)
    end

    temp_review_after = review_after.delete(" \t\r\n")
    if review_after.nil? || review_after == "" || temp_review_after == ""
      warn("No review_after in Issue")
      exit(1)
    end

    review_after_date = Date.parse(review_after)
    one_year_from_now = Date.today + 365

    if review_after_date > one_year_from_now
      warn("The review_after date in the Issue is longer than one year")
      exit(1)
    end

    if review_after_date < Date.today
      warn("The review_after date in the Issue is in the past")
      exit(1)
    end

    # Overwrite the format of the date in case user enters the date in the incorrect way.
    review_after = review_after_date.strftime(DATE_FORMAT).to_s

    if repositories.nil?
      warn("No repositories in Issue")
      exit(1)
    end

    repositories.each do |repository_name|
      http_code = GithubCollaborators::HttpClient.new.fetch_code("#{GH_API_URL}/#{repository_name}")
      if http_code == "404"
        warn("The repository in the Issue does not exist on GitHub")
        exit(1)
      end
    end

    collaborator = {
      login: username.downcase,
      permission: requested_permission.downcase,
      name: name,
      email: email,
      org: org,
      reason: reason,
      added_by: added_by,
      review_after: review_after
    }

    # Add user to Terraform file/s
    edited_files = []
    terraform_files = @terraform_files.get_terraform_files
    repositories.each do |repository_name|
      @terraform_files.ensure_file_exists_in_memory(repository_name)
      terraform_files.each do |terraform_file|
        if terraform_file.filename == repository_name
          terraform_file.add_collaborator_from_issue(collaborator)
          terraform_file.write_to_file
          edited_files.push("terraform/#{repository_name}.tf")
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
