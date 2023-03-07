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

    permission = the_data["permission"][0]
    org = the_data["org"][0]
    reason = the_data["reason"][0]
    added_by = the_data["added_by"][0]
    review_after = the_data["review_after"][0]

    repositories = []
    the_data["repositories"].each do |repository|
      # Remove any spaces, new lines, tabs, etc
      repositories.push(repository.delete(" \t\r\n"))
    end

    # Remove any spaces, new lines, tabs, etc
    requested_permission = permission.delete(" \t\r\n")
    org = org.delete("\t\r\n")
    reason = reason.delete("\t\r\n")
    added_by = added_by.delete("\t\r\n")
    review_after = review_after.delete("\t\r\n")

    usernames = []
    the_data["usernames"].each do |username|
      # Remove any spaces, new lines, tabs, etc
      usernames.push(username.delete(" \t\r\n"))
    end

    names = []
    the_data["names"].each do |name|
      # Remove any new lines, tabs, etc
      names.push(name.delete("\t\r\n"))
    end

    emails = []
    the_data["emails"].each do |email|
      # Remove any spaces, new lines, tabs, etc
      emails.push(email.delete(" \t\r\n"))
    end

    if emails.length != names.length || names.length != usernames.length
      warn("Items in the emails, names and usernames sections are not equal")
      exit(1)
    end

    permissions = ["admin", "pull", "push", "maintain", "triage"]
    if permissions.include?(requested_permission.downcase) == false
      warn("Incorrect permission used in Issue")
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
    
    if names.nil?
      warn("No names in Issue")
      exit(1)
    end

    if emails.nil?
      warn("No email addresses in Issue")
      exit(1)
    end

    if usernames.nil?
      warn("No usernames in Issue")
      exit(1)
    end

    emails.each do |email|
      temp_email = email.delete(" \t\r\n")
      if email == "" || temp_email == ""
        warn("Found an empty email in Issue")
        exit(1)
      end
    end

    usernames.each do |username|
      temp_username = username.delete(" \t\r\n")
      if username == "" || temp_username == ""
        warn("Found an empty username in Issue")
        exit(1)
      end

      url = "https://api.github.com/users/#{username}"
      http_code = GithubCollaborators::HttpClient.new.fetch_code(url)
      if http_code != "200"
        warn("Username #{username} not found on GitHub")
        exit(1)
      end
    end

    names.each do |name|
      temp_name = name.delete(" \t\r\n")
      if name == "" || temp_name == ""
        warn("Found an empty name in Issue")
        exit(1)
      end
    end

    if repositories.nil?
      warn("No repositories in Issue")
      exit(1)
    end

    repositories.each do |repository_name|
      temp_repository_name = repository_name.delete(" \t\r\n")
      if repository_name == "" || temp_repository_name == ""
        warn("Found an empty repository name in Issue")
        exit(1)
      end

      http_code = GithubCollaborators::HttpClient.new.fetch_code("#{GH_API_URL}/#{repository_name}")
      if http_code == "404"
        warn("The repository #{repository_name} in the Issue does not exist on GitHub")
        exit(1)
      end
    end

    collaborators = []
    for i in 0..usernames.length
      collaborators.push(
        {
          login: usernames[i].downcase,
          permission: requested_permission.downcase,
          name: names[i],
          email: emails[i],
          org: org,
          reason: reason,
          added_by: added_by,
          review_after: review_after
        }
      )
    end

    # Add user/s to Terraform file/s
    edited_files = []
    terraform_files = @terraform_files.get_terraform_files
    repositories.each do |repository_name|
      @terraform_files.ensure_file_exists_in_memory(repository_name)
      terraform_files.each do |terraform_file|
        if terraform_file.filename == repository_name
          collaborators.each do |collaborator|
            terraform_file.add_collaborator_from_issue(collaborator)
          end
          terraform_file.write_to_file
          edited_files.push("terraform/#{repository_name}.tf")
        end
      end
    end

    if edited_files.length > 0
      type = TYPE_ADD_FROM_ISSUE

      if usernames.length == 1
        collaborator_name = usernames[0]
        collaborator_name = collaborator_name.downcase
        branch_name = "add-collaborator-from-issue-#{collaborator_name}"
        pull_request_title = "#{ADD_COLLAB_FROM_ISSUE} #{collaborator_name}"
        create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
      else
        branch_name = "add-multiple-collaborators-from-issue"
        pull_request_title = "Add multiple collaborators from issue"
        collaborator_name = "multiple-collaborators"
        create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
      end
    end
  end
end

puts "Start"
CreatePrFromIssue.new.start
puts "Finished"
