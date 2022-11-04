class GithubCollaborators
  class OutsideCollaborators
    include Logging

    BASE_URL = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"

    def initialize(check_github)
      logger.debug "initialize"
      # Create a list of users that are outside collaborators ie not MoJ Organisation Members
      @collaborators = if check_github
        # Using the data from GitHub
        GithubCollaborators::OrganizationOutsideCollaborators.new(base_url: BASE_URL).fetch_users_with_issues
      else
        # Using the data from the terraform folder files
        fetch_collaborators_within_terraform_files
      end
      # Grab the GitHub-Collaborator repository open pull requests
      @repo_pull_requests = GithubCollaborators::PullRequests.new.get_pull_requests
    end

    def is_renewal_within_one_month
      logger.debug "is_renewal_within_one_month"
      @collaborators.each do |collaborator|
        params = {
          repository: collaborator["repository"],
          github_user: collaborator["login"]
        }

        # Create an issue on the repo when "Review after date is within a month" is true
        if collaborator["issues"].include? "Review after date is within a month"
          GithubCollaborators::IssueCreator.new(params).create_review_date_expires_soon_issue
        end
      end
    end

    def remove_unknown_collaborators
      logger.debug "remove_unknown_collaborators"
      removed_outside_collaborators = []
      @collaborators.each do |collaborator|
        params = {
          repository: collaborator["repository"],
          github_user: collaborator["login"]
        }

        if collaborator["defined_in_terraform"] == false
          logger.info "Removing collaborator #{collaborator["login"]} from repository #{collaborator["repository"]}"
          # We must create the issue before removing access, because the issue is
          # assigned to the removed collaborator, so that they (hopefully) get a
          # notification about it.
          GithubCollaborators::IssueCreator.new(params).create_unknown_user_issue
          GithubCollaborators::AccessRemover.new(params).remove
          removed_outside_collaborators.push(collaborator)
        end
      end

      if removed_outside_collaborators.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::Removed.new, removed_outside_collaborators).post_slack_message
      end
    end

    def has_review_date_expired
      logger.debug "has_review_date_expired"
      expired_users = find_users_who_have_expired

      if expired_users.length > 0

        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::Expired.new, expired_users).post_slack_message

        # Raise PRs
        create_remove_user_pull_requests(expired_users)
      end
    end

    def is_review_date_within_a_week
      logger.debug "is_review_date_within_a_week"
      users_who_expire_soon = find_users_who_expire_soon
      if users_who_expire_soon.length > 0

        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::ExpiresSoon.new, users_who_expire_soon).post_slack_message

        # Raise PRs
        create_extend_date_pull_requests(users_who_expire_soon)
      end
    end

    private

    # Get list of users whose review date have one week remaining
    def find_users_who_expire_soon
      logger.debug "find_users_who_expire_soon"
      users_who_expire_soon = []
      @collaborators.each do |collaborator|
        collaborator["issues"].each do |issue|
          if issue == "Review after date is within a week"
            users_who_expire_soon.push(collaborator)
            logger.info "Review after date is within a week for #{collaborator["login"]} on #{collaborator["review_date"]}"
          end
        end
      end

      if users_who_expire_soon.length > 0
        # Sort list based on username
        users_who_expire_soon.sort_by! { |user| user["login"] }
      end

      users_who_expire_soon
    end

    # Get list of users whose review date has passed
    def find_users_who_have_expired
      logger.debug "find_users_who_have_expired"
      users_who_have_expired = []
      @collaborators.each do |collaborator|
        collaborator["issues"].each do |issue|
          if issue == "Review after date has passed"
            users_who_have_expired.push(collaborator)
            logger.info "Review after date has passed for #{collaborator["login"]} on #{collaborator["review_date"]}"
          end
        end
      end

      if users_who_have_expired.length > 0
        # Sort list based on username
        users_who_have_expired.sort_by! { |user| user["login"] }
      end

      users_who_have_expired
    end

    def extend_date_in_file(file_name, user_name)
      logger.debug "extend_date_in_file"

      params = {
        repository: File.basename(file_name, ".tf"),
        login: user_name,
        base_url: nil,
        repo_url: nil
      }
      tc = TerraformCollaborator.new(params)
      tc.extend_review_date
    end

    def remove_user_from_file(file_name, user_name)
      logger.debug "remove_user_from_file"

      params = {
        repository: File.basename(file_name, ".tf"),
        login: user_name,
        base_url: nil,
        repo_url: nil
      }
      tc = TerraformCollaborator.new(params)
      tc.remove_user
    end

    def create_extend_date_pull_requests(users_who_expire_soon)
      logger.debug "create_extend_date_pull_requests"
      # Put users into groups to commit multiple files per branch
      user_groups = users_who_expire_soon.group_by { |user| user["login"] }
      user_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = ""
        user_name = ""
        edited_files = []

        # For each file that user has an upcoming expiry
        group[1].each do |outside_collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(outside_collaborator["href"])
          user_name = outside_collaborator["login"]
          title_message = "Extend review dates for #{user_name}"

          if !does_pr_already_exist(terraform_file_name, title_message)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            branch_name = "update-review-date-#{user_name}"
            extend_date_in_file(file_name, user_name)
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each user group commit any modified file/s
          branch_name = bc.check_branch_name_is_valid(branch_name)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Update review date for #{user_name}")

          # Create a pull request
          params = {
            repository: "github-collaborators",
            hash_body: extend_date_hash(user_name, branch_name)
          }

          GithubCollaborators::PullRequestCreator.new(params).create_pull_request
        end
      end
    end

    def create_remove_user_pull_requests(expired_users)
      logger.debug "create_remove_user_pull_requests"
      # Put users into groups to commit multiple files per branch
      user_groups = expired_users.group_by { |user| user["login"] }
      user_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = ""
        user_name = ""
        edited_files = []

        # For each file where user has expired
        group[1].each do |outside_collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(outside_collaborator["href"])
          user_name = outside_collaborator["login"]
          title_message = "Remove expired user #{user_name}"

          if !does_pr_already_exist(terraform_file_name, title_message)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            branch_name = "remove-expired-user-#{user_name}"
            remove_user_from_file(file_name, user_name)
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each user group commit any modified file/s
          branch_name = bc.check_branch_name_is_valid(branch_name)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Remove expired user #{user_name}")

          # Create a pull request
          params = {
            repository: "github-collaborators",
            hash_body: remove_user_hash(user_name, branch_name)
          }

          GithubCollaborators::PullRequestCreator.new(params).create_pull_request
        end
      end
    end

    def does_pr_already_exist(terraform_file_name, title_message)
      logger.debug "does_pr_already_exist"
      @repo_pull_requests.each do |pull_request|
        if (pull_request.title.include? title_message.to_s) &&
            (pull_request.files.include? "terraform/#{terraform_file_name}")
          logger.debug "For #{user_name} PR already open for #{terraform_file_name} file"
          return true
        end
      end
      false
    end

    def remove_user_hash(user_name, branch_name)
      logger.debug "remove_user_hash"
      {
        title: "Remove expired user #{user_name} from file/s",
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there

          This is the GitHub-Collaborator repository bot. 

          The user #{user_name} review date has expired for the file/s contained in this pull request.
          
          Either approve this pull request, modify it or delete it if it is no longer necessary.
        EOF
      }
    end

    def extend_date_hash(user_name, branch_name)
      logger.debug "extend_date_hash"
      {
        title: "Extend review dates for #{user_name}",
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          #{user_name} has review date/s that are close to expiring. 
          
          The review date/s have automatically been extended.

          Either approve this pull request, modify it or delete it if it is no longer necessary.
        EOF
      }
    end

    # Returns all the named collaborators in the terraform files
    # This function is used to check the collaborators data in the
    # files match with what is online on the Org/GitHub
    def fetch_collaborators_within_terraform_files
      params = {
        folder_path: Dir.getwd + "/terraform"
      }

      terraform_collaborators = GithubCollaborators::TerraformCollaborators.new(params)
      terraform_files = terraform_collaborators.fetch_terraform_files
      exclude_files = ["acronyms.tf", "main.tf", "variables.tf", "versions.tf", "backend.tf"]

      collaborators = []
      # Go through all the terraform files and get the collaborators
      terraform_files.each do |terraform_file|
        # Ignore the above named files
        if !exclude_files.include?(File.basename(terraform_file))
          collaborators_in_file = terraform_collaborators.return_collaborators_from_file(terraform_file)
          collaborators_in_file.each { |collaborator| collaborators.push(collaborator.to_hash) }
        end
      end
      collaborators.sort_by { |collaborator| collaborator["login"] }
    end
  end
end
