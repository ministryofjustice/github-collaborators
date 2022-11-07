class GithubCollaborators
  class OutsideCollaborators
    include Logging

    def initialize
      logger.debug "initialize"

      # Grab the Org members
      @organization_members = OrganizationMembers.new.get_org_members

      # Grab the Org repositories
      @repositories = Repositories.new.get_active_repositories

      # Grab the GitHub-Collaborator repository open pull requests
      @repo_pull_requests = GithubCollaborators::PullRequests.new.get_pull_requests

      params = {
        org: @organization_members,
        repositories: @repositories
      }
      @organization = GithubCollaborators::Organization.new(params)

      @terraform_collaborators = GithubCollaborators::TerraformCollaborators.new(folder_path: Dir.getwd + "/terraform").fetch_all_terraform_collaborators
    end

    def check_collaborators_from_github
      logger.debug "check_collaborators_from_github"
      # Create a list of outside collaborators using the data from GitHub
      @organization.add_outside_collaborators_to_repositories
      collaborators = @organization.get_collaborators_with_issues
      is_review_date_within_a_week(collaborators)
      is_renewal_within_one_month(collaborators)
      remove_unknown_collaborators(collaborators)
      has_review_date_expired(collaborators)
    end

    def check_collaborators_in_files
      logger.debug "check_collaborators_in_files"
      # Filter out the collaborators that do not have an issue
      collaborators_with_issues = @terraform_collaborators.select { |collaborator| collaborator["issues"].length > 0 }
      has_review_date_expired(collaborators_with_issues)
    end

    private

    def is_renewal_within_one_month(collaborators)
      logger.debug "is_renewal_within_one_month"
      # Check all collaborators
      collaborators.each do |collaborator|
        params = {
          repository: collaborator["repository"],
          github_user: collaborator["login"]
        }

        # Create an issue on the repository when "Review after date is within a month" is true
        if collaborator["issues"].include? "Review after date is within a month"
          GithubCollaborators::IssueCreator.new(params).create_review_date_expires_soon_issue
        end
      end
    end

    def remove_unknown_collaborators(collaborators)
      logger.debug "remove_unknown_collaborators"
      removed_outside_collaborators = []
      # Check all collaborators
      collaborators.each do |collaborator|
        params = {
          repository: collaborator["repository"],
          github_user: collaborator["login"]
        }

        # Unknown collaborator
        if collaborator["defined_in_terraform"] == false
          logger.info "Removing collaborator #{collaborator["login"]} from repository #{collaborator["repository"]}"
          # We must create the issue before removing access, because the issue is
          # assigned to the removed collaborator, so that they (hopefully) get a
          # notification about it.
          GithubCollaborators::IssueCreator.new(params).create_unknown_collaborator_issue
          GithubCollaborators::AccessRemover.new(params).remove_access
          removed_outside_collaborators.push(collaborator)
        end
      end

      if removed_outside_collaborators.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::Removed.new, removed_outside_collaborators).post_slack_message
      end
    end

    # This function will remove collaborators whose review date has expired or
    # update the review date for collaborators who are full org members
    def has_review_date_expired(collaborators)
      logger.debug "has_review_date_expired"
      all_collaborators = find_collaborators_who_have_expired(collaborators)

      # Filter out the collaborators that have full org membership and those that dont
      full_org_collaborators = all_collaborators.select { |collaborator| is_collaborator_org_member(collaborator["login"]) }
      expired_collaborators = all_collaborators.select { |collaborator| !is_collaborator_org_member(collaborator["login"]) }

      # Non org member collaborators
      if expired_collaborators.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::Expired.new, expired_collaborators).post_slack_message

        # Remove collaborators from the files and raise PRs
        create_remove_collaborator_pull_requests(expired_collaborators)
      end

      # Org member collaborators
      if full_org_collaborators.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::FullOrgMemberExpiresSoon.new, full_org_collaborators).post_slack_message

        # For the full Org members extend the review date in the collaborator files and raise PRs
        create_extend_date_pull_requests(full_org_collaborators)
      end
    end

    def is_review_date_within_a_week(collaborators)
      logger.debug "is_review_date_within_a_week"
      collaborators_who_expire_soon = find_collaborators_who_expire_soon(collaborators)
      if collaborators_who_expire_soon.length > 0

        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::ExpiresSoon.new, collaborators_who_expire_soon).post_slack_message

        # Extend the date in the collaborator files and raise PRs
        create_extend_date_pull_requests(collaborators_who_expire_soon)
      end
    end

    def is_collaborator_org_member(user_name)
      logger.debug "is_collaborator_org_member"

      if @organization.is_collaborator_an_org_member(user_name)
        logger.info "Collaborator #{user_name} is a full Org member and an outside collaborator."
        return true
      end
      false
    end

    # Get list of collaborators whose review date have one week remaining
    def find_collaborators_who_expire_soon(collaborators)
      logger.debug "find_collaborators_who_expire_soon"
      collaborators_who_expire_soon = []
      collaborators.each do |collaborator|
        collaborator["issues"].each do |issue|
          if issue == "Review after date is within a week"
            collaborators_who_expire_soon.push(collaborator)
            logger.info "Review after date is within a week for #{collaborator["login"]} on #{collaborator["review_date"]}"
          end
        end
      end

      # Sort list based on username
      collaborators_who_expire_soon.sort_by! { |user| user["login"] }
    end

    # Get list of collaborators whose review date has passed
    def find_collaborators_who_have_expired(collaborators)
      logger.debug "find_collaborators_who_have_expired"
      collaborators_who_have_expired = []
      collaborators.each do |collaborator|
        collaborator["issues"].each do |issue|
          if issue == "Review after date has passed"
            collaborators_who_have_expired.push(collaborator)
            logger.info "Review after date has passed for #{collaborator["login"]} on #{collaborator["review_date"]}"
          end
        end
      end

      # Sort list based on username
      collaborators_who_have_expired.sort_by! { |user| user["login"] }
    end

    def extend_date_in_file(file_name, user_name)
      logger.debug "extend_date_in_file"
      TerraformCollaborator.new(
        repository: File.basename(file_name, ".tf"),
        login: user_name
      ).extend_review_date
    end

    def remove_collaborator_from_file(file_name, user_name)
      logger.debug "remove_collaborator_from_file"
      tc = TerraformCollaborator.new(
        repository: File.basename(file_name, ".tf"),
        login: user_name
      ).remove_collaborator
    end

    def create_extend_date_pull_requests(collaborators_who_expire_soon)
      logger.debug "create_extend_date_pull_requests"
      # Put collaborators into groups to commit multiple files per branch
      collaborator_groups = collaborators_who_expire_soon.group_by { |user| user["login"] }
      collaborator_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = ""
        user_name = ""
        edited_files = []

        # For each file that collaborator has an upcoming expiry
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
          # At the end of each collaborator group commit any modified file/s
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

    def create_remove_collaborator_pull_requests(expired_collaborators)
      logger.debug "create_remove_collaborator_pull_requests"
      # Put collaborators into groups to commit multiple files per branch
      collaborators_groups = expired_collaborators.group_by { |user| user["login"] }
      collaborators_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = ""
        user_name = ""
        edited_files = []

        # For each file where collaborator has expired
        group[1].each do |outside_collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(outside_collaborator["href"])
          user_name = outside_collaborator["login"]
          title_message = "Remove expired collaborator #{user_name}"

          if !does_pr_already_exist(terraform_file_name, title_message)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            branch_name = "remove-expired-collaborator-#{user_name}"
            remove_collaborator_from_file(file_name, user_name)
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each collaborator group commit any modified file/s
          branch_name = bc.check_branch_name_is_valid(branch_name)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Remove expired collaborator #{user_name}")

          # Create a pull request
          params = {
            repository: "github-collaborators",
            hash_body: remove_collaborator_hash(user_name, branch_name)
          }

          GithubCollaborators::PullRequestCreator.new(params).create_pull_request
        end
      end
    end

    def does_pr_already_exist(terraform_file_name, title_message)
      logger.debug "does_pr_already_exist"
      @repo_pull_requests.each do |pull_request|
        # Chek the PR title message and check if file in the PR list of files
        if (pull_request.title.include? title_message.to_s) &&
            (pull_request.files.include? "terraform/#{terraform_file_name}")
          logger.debug "For #{user_name} PR already open for #{terraform_file_name} file"
          return true
        end
      end
      false
    end

    def remove_collaborator_hash(user_name, branch_name)
      logger.debug "remove_collaborator_hash"
      {
        title: "Remove expired collaborator #{user_name} from file/s",
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there

          This is the GitHub-Collaborator repository bot. 

          The collaborator #{user_name} review date has expired for the file/s contained in this pull request.
          
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

    # TODO: Rewrite this code
    def compare_terraform_against_github
      logger.debug "compare_terraform_against_github"

      collaborators_who_are_members = []

      @organization.add_outside_collaborators_to_repositories

      # For each repository
      @repositories.each do |repository|
        # Get the GitHub outside collaborators for repository
        collaborators_on_github = repository.get_all_outside_collaborators

        # Get the Terraform outside collaborators for repository
        terraform_collaborators = GithubCollaborators::TerraformCollaborators.new(folder_path: Dir.getwd + "/terraform")
        collaborators_in_file = terraform_collaborators.return_collaborators_from_file(terraform_file)
        collaborators_in_file.each { |collaborator| collaborators.push(collaborator.to_hash) }

        # Edge cases
        if collaborators_on_github.nil? || collaborators_in_file.nil?
          next
        end

        if (collaborators_on_github.length == 0) && (collaborators_in_file.length == 0)
          next
        end

        if tc.length == 0
          logger.debug "=" * 37
          logger.debug "Repository: #{repository.name}"
          logger.debug "Number of Outside Collaborators: #{gc.length}"
          logger.debug "These Outside Collaborator/s are not defined in Terraform:"
          gc.each do |gc_collaborator|
            puts gc_collaborator.fetch(:login)
          end
          logger.debug "=" * 37
          logger.debug ""
        elsif gc.length != tc.length

          # Some collaborators have been upgraded to full organization members, this checks for them.
          tc.each do |tc_collaborator|
            if org_members.is_an_org_member(tc_collaborator.login) == true
              collaborators_who_are_members.push(tc_collaborator.login)
              gc.push(
                {
                  login: tc_collaborator.login
                }
              )
            end
          end

          # Do the check again with the new value added above
          if gc.length != tc.length
            # Report when collaborator/s are defined in Terraform but not GitHub.
            logger.debug "====================================="
            logger.debug "Difference in repository: #{repository.name}"
            logger.debug "Number of Outside Collaborators: #{gc.length}"
            logger.debug "Defined in Terraform: #{tc.length}"
            logger.debug "The Outside Collaborator/s not attached to the repository but defined in Terraform:"

            # Get the pending collaborator invites for the repository
            pending_invites = []
            url = "https://api.github.com/repos/ministryofjustice/#{repository.name}/invitations"
            json = GithubCollaborators::HttpClient.new.fetch_json(url)
            JSON.parse(json)
              .find_all { |collaborator| collaborator["invitee"]["login"] }
              .map { |collaborator| pending_invites.push(collaborator) }

            # Print collaborator name + pending invite or name only
            tc.each do |tc_collaborator|
              if pending_invites.length != 0
                logger.debug tc_collaborator.login.to_s unless gc.any? { |collaborator| collaborator.fetch(:login) == tc_collaborator.login }
                pending_invites.each do |collaborator|
                  if collaborator["invitee"]["login"] == tc_collaborator.login
                    logger.debug ": Has a pending invite \n"
                  end
                end
              else
                logger.debug tc_collaborator.login unless gc.any? { |collaborator| collaborator.fetch(:login) == tc_collaborator.login }
              end
            end

            # Print all the repository outside collaborators if any exist
            if gc.length > 0
              logger.debug "-" * 37
              logger.debug "The #{gc.length} Outside Collaborator/s for this repository are:"
              gc.each do |collaborator|
                logger.debug collaborator.fetch(:login)
              end
            end
            logger.debug "=" * 37
            logger.debug ""
          end
        end
      end

      # Print collaborator login who are also a member of the org
      logger.info "These Outside Collaborators are defined within Terraform and are full Organization Members:"
      collaborators_who_are_members = collaborators_who_are_members.uniq
      collaborators_who_are_members.each do |collaborator|
        logger.info collaborator.to_s
      end
    end
  end
end
