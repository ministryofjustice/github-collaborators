require_relative "../lib/github_collaborators"

PR_LOGIN = 0
PR_NAME = 1
PR_EMAIL = 2

class CreatePrFromIssue
  include Logging
  include HelperModule

  def initialize(json_data)
    # This class takes the body generated from a GitHub ticket
    # created within /.github/ISSUE_TEMPLATE/create-pr-from-issue.yaml
    the_json_data = JSON.parse(json_data)
    # Get Issue number so can close issue
    @issue_number = the_json_data.fetch("number")
    # Fetch the body var
    body = the_json_data.fetch("body")
    # Split on field seperator
    @the_data = body.split("###")
      # Remove empty lines
      .map { |line| line.strip }
      .map { |str| str.gsub(/^$\n/, "") }
      # Split on \n characters to have field name and field value in seperator hash
      .map { |line| line.split("\n") }
      # Drop first hash element as not needed
      .drop(1)
      # Map values into array
      .map { |field| [field[0], field.drop(1)] }.to_h

    @http_client = GithubCollaborators::HttpClient.new
  end

  def start
    emails = get_emails
    usernames = get_usernames
    names = get_names

    if emails.length != names.length || names.length != usernames.length
      warn("Items in the emails, names and usernames sections are not equal")
      exit(1)
    end

    usernames_emails_names = []
    (0..(usernames.length - 1)).each do |i|
      usernames_emails_names.push([usernames[i], names[i], emails[i]])
    end

    requested_permission = get_permission
    org = get_org
    reason = get_reason
    added_by = get_added_by
    review_after = get_review_after

    collaborators = []

    usernames_emails_names.each do |user|
      collaborators.push(
        {
          login: user[PR_LOGIN],
          permission: requested_permission,
          name: user[PR_NAME],
          email: user[PR_EMAIL],
          org: org,
          reason: reason,
          added_by: added_by,
          review_after: review_after
        }
      )
    end

    edited_files = add_users_to_files(collaborators)

    if edited_files.length > 0
      if collaborators.length == 1
        create_single_user_pull_request(edited_files, collaborators[0])
      else
        create_multiple_users_pull_request(edited_files)
      end
    end

    remove_issue(REPO_NAME, @issue_number)
  end

  def remove_characters_from_string_except_space(value)
    value.delete("\t\r\n")
  end

  def remove_characters_from_string(value)
    value.delete(" \t\r\n")
  end

  def get_permission
    permission = @the_data["permission"][0]
    if permission.nil? || permission.length == 0
      warn("Incorrect permission in Issue")
      exit(1)
    end

    requested_permission = remove_characters_from_string(permission)

    permissions = ["admin", "pull", "push", "maintain", "triage"]
    if permissions.include?(requested_permission.downcase) == false
      warn("Incorrect permission used in Issue")
      exit(1)
    end
    requested_permission
  end

  def get_repositories
    repositories = []

    @the_data["repositories"].each do |repository|
      repository = remove_characters_from_string(repository)
      repositories.push(repository)
    end

    if repositories.nil? || repositories.length == 0
      warn("No repositories in Issue")
      exit(1)
    end

    repositories.each do |repository_name|
      http_code = @http_client.fetch_code("#{GH_API_URL}/#{repository_name}")
      if http_code == "404"
        warn("The repository #{repository_name} in the Issue does not exist on GitHub")
        exit(1)
      end
    end
    repositories
  end

  def get_usernames
    usernames = []

    @the_data["usernames"].each do |username|
      username = remove_characters_from_string(username)
      usernames.push(username)
    end

    if usernames.nil? || usernames.length == 0
      warn("No usernames in Issue")
      exit(1)
    end

    usernames.each do |username|
      url = "#{GH_URL}/users/#{username}"
      http_code = @http_client.fetch_code(url)
      if http_code != "200"
        warn("Username #{username} not found on GitHub")
        exit(1)
      end
    end

    usernames
  end

  def get_names
    names = []

    @the_data["names"].each do |name|
      name = remove_characters_from_string_except_space(name)
      names.push(name)
    end

    if names.nil? || names.length == 0
      warn("No names in Issue")
      exit(1)
    end

    names
  end

  def get_emails
    emails = []

    @the_data["emails"].each do |email|
      email = remove_characters_from_string(email)
      emails.push(email)
    end

    if emails.nil? || emails.length == 0
      warn("No email addresses in Issue")
      exit(1)
    end

    emails
  end

  def get_org
    org = @the_data["org"][0]

    if org.nil? || org.length == 0
      warn("Incorrect org in Issue")
      exit(1)
    end

    org = remove_characters_from_string_except_space(org)
    temp_org = remove_characters_from_string(org)
    if org.nil? || org == "" || temp_org == ""
      warn("No organisation in Issue")
      exit(1)
    end

    org
  end

  def get_reason
    reason = @the_data["reason"][0]

    if reason.nil? || reason.length == 0
      warn("Incorrect reason in Issue")
      exit(1)
    end

    reason = remove_characters_from_string_except_space(reason)
    temp_reason = remove_characters_from_string(reason)
    if reason.nil? || reason == "" || temp_reason == ""
      warn("No reason in Issue")
      exit(1)
    end
    reason
  end

  def get_added_by
    added_by = @the_data["added_by"][0]

    if added_by.nil? || added_by.length == 0
      warn("Incorrect added_by in Issue")
      exit(1)
    end

    added_by = remove_characters_from_string_except_space(added_by)
    temp_added_by = remove_characters_from_string(added_by)
    if added_by.nil? || added_by == "" || temp_added_by == ""
      warn("No added_by in Issue")
      exit(1)
    end

    added_by
  end

  def get_review_after
    review_after = @the_data["review_after"][0]

    if review_after.nil? || review_after.length == 0
      warn("Incorrect review_after in Issue")
      exit(1)
    end

    review_after = remove_characters_from_string_except_space(review_after)
    temp_review_after = remove_characters_from_string(review_after)
    if review_after.nil? || review_after == "" || temp_review_after == ""
      warn("No review_after in Issue")
      exit(1)
    end

    review_after_date = Date.parse(review_after)
    one_year_from_now = Date.today + 366

    if review_after_date > one_year_from_now
      warn("The review_after date in the Issue is longer than one year")
      exit(1)
    end

    if review_after_date < Date.today
      warn("The review_after date in the Issue is in the past")
      exit(1)
    end

    # Overwrite the format of the date in case user enters the date in the incorrect way.
    review_after_date.strftime(DATE_FORMAT).to_s
  end

  def add_users_to_files(collaborators)
    edited_files = []
    # Collects the Terraform files and collaborators
    terraform_files = GithubCollaborators::TerraformFiles.new
    the_terraform_files = terraform_files.get_terraform_files
    get_repositories.each do |repository_name|
      terraform_files.ensure_file_exists_in_memory(repository_name)
      the_terraform_files.each do |terraform_file|
        if terraform_file.filename == repository_name
          collaborators.each do |collaborator|
            if terraform_files.is_user_in_file(repository_name.downcase, collaborator[:login]) == true
              warn("The user #{collaborator[:login]} already exists in the file #{repository_name.downcase}.tf")
              exit(1)
            end
            terraform_file.add_collaborator_from_issue(collaborator)
          end
          if collaborators.length > 0
            terraform_file.write_to_file
            edited_files.push("terraform/#{repository_name}.tf")
          end
        end
      end
    end
    edited_files
  end

  def create_single_user_pull_request(edited_files, collaborator)
    collaborator_name = collaborator[:login].downcase
    branch_name = "add-collaborator-from-issue-#{collaborator_name}"
    pull_request_title = "#{ADD_COLLAB_FROM_ISSUE} #{collaborator_name}"
    create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, TYPE_ADD_FROM_ISSUE)
  end

  def create_multiple_users_pull_request(edited_files)
    collaborator_name = "multiple-collaborators"
    branch_name = "add-multiple-collaborators-from-issue"
    create_branch_and_pull_request(branch_name, edited_files, MULITPLE_COLLABORATORS_PR_TITLE, collaborator_name, TYPE_ADD_FROM_ISSUE)
  end
end
