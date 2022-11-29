class GithubCollaborators
  class OutsideCollaborators
    include Logging

    def initialize
      logger.debug "initialize"

      # Grab the Terraform files and collaborators
      @terraform_files = GithubCollaborators::TerraformFiles.new

      # Create Terraform file collaborators as Collaborator objects
      @collaborators = []
      @terraform_files.terraform_files.each do |terraform_file|
        terraform_file.terraform_blocks.each do |terraform_block|
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, terraform_file.filename.downcase)
          collaborator.check_for_issues
          @collaborators.push(collaborator)
        end
      end

      # Grab the GitHub-Collaborator repository open pull requests
      @repo_pull_requests = GithubCollaborators::PullRequests.new.get_pull_requests

      # Create a Organization object, which Contains the Org repositories, full
      # Org members, Org outside collaborators and each repository collaborators.
      @organization = GithubCollaborators::Organization.new
      @organization.create_full_org_members(@collaborators)

      # An array to store collaborators login names that are defined in Terraform but are not on GitHub
      @unknown_collaborators_on_github = []

      @invites = GithubCollaborators::Invites.new
    end

    # Entry point from Ruby script, keep the order as-is the compare function will ne
    def start
      remove_empty_files
      archived_repository_check
      compare_terraform_and_github
      collaborator_checks
      full_org_members_check
      print_full_org_member_collaborators
    end

    private

    # Print out any differences between GitHub and terraform files
    def compare_terraform_and_github
      logger.debug "compare_terraform_and_github"

      # For each repository
      @organization.repositories.each do |repository|
        # Get the GitHub collaborators for the repository
        collaborators_on_github = repository.outside_collaborators

        # Get the Terraform defined outside collaborators for the repository
        collaborators_in_file = @terraform_files.get_collaborators_in_file(repository.name.downcase)

        # Some Terraform collaborators have been upgraded to full organization members,
        # get them and add them to the collaborator GitHub array
        if collaborators_in_file.length > 0
          collaborators_in_file.each do |collaborator|
            if @organization.is_collaborator_an_org_member(collaborator)
              collaborators_on_github.push(collaborator)
            end
          end
        end

        # No collaborators skip to next iteration
        if collaborators_on_github.length == 0 && collaborators_in_file.length == 0
          next
        else
          # Print out the difference
          do_comparison(collaborators_in_file, collaborators_on_github, repository.name.downcase)
        end
      end
    end

    def collaborator_checks
      logger.debug "collaborator_checks"

      if @unknown_collaborators_on_github.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::UnknownCollaborators.new, @unknown_collaborators_on_github).post_slack_message
      end

      collaborators_with_issues = @collaborators.select { |collaborator| collaborator.issues.length > 0 }

      # Raise GitHub issues
      is_review_date_within_a_week(collaborators_with_issues)
      is_renewal_within_one_month(collaborators_with_issues)

      # Remove unknown collaborators from GitHub
      remove_unknown_collaborators(collaborators_with_issues)

      # Extend date or remove collaborator from Terraform file/s
      has_review_date_expired(collaborators_with_issues)
    end

    def print_full_org_member_collaborators
      logger.debug "print_full_org_member_collaborators"
      logger.info "There are #{@organization.full_org_members.length} full Org member / outside collaborators."
      @organization.full_org_members.each { |collaborator| logger.info "#{collaborator.login.downcase} is a full Org member / outside collaborator." }
    end

    # Find if full org members / collaborators are members of repositories but not defined in Terraform
    def full_org_members_check
      logger.debug "full_org_members_check"

      odd_full_org_members = []
      full_org_members_in_archived_repositories = []

      # Run full org member tests
      @organization.full_org_members.each do |full_org_member|
        login = full_org_member.login.downcase

        # Compare the GitHub and Terraform repositories
        if full_org_member.do_repositories_match == false
          # Where collaborator is not defined in Terraform, add collaborator to those files
          add_collaborator(full_org_member)
        end

        if full_org_member.check_repository_permissions_match(@terraform_files)
          # Where collaborator has difference in repository permission, create a PR using GitHub permission
          change_collaborator_permission(login, full_org_member.repository_permission_mismatches)
        end

        # Find the collaborators that are attached to no GitHub repositories
        if full_org_member.odd_full_org_member_check
          odd_full_org_members.push(login)
        end

        # Find which collaborators are attached to archived repositories in the files that we track
        full_org_member.attached_archived_repositories.each do |archived_repository|
          if @terraform_files.does_file_exist(archived_repository.downcase)
            full_org_members_in_archived_repositories.push({login: login, repository: archived_repository.downcase})
          end
        end
      end

      # Raise Slack message for collaborators that are attached to no Github repositories
      if odd_full_org_members.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::OddFullOrgMembers.new, odd_full_org_members).post_slack_message
      end

      # Raise Slack message for collaborators that are attached to archived repositories
      if full_org_members_in_archived_repositories.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::ArchivedRepositories.new, full_org_members_in_archived_repositories).post_slack_message
      end
    end

    def is_renewal_within_one_month(collaborators)
      logger.debug "is_renewal_within_one_month"
      # Check all collaborators
      collaborators.each do |collaborator|
        params = {
          repository: collaborator.repository.downcase,
          github_user: collaborator.login.downcase
        }

        if collaborator.issues.include?(REVIEW_DATE_WITHIN_MONTH)
          # Create an issue on the repository
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
          repository: collaborator.repository.downcase,
          github_user: collaborator.login.downcase
        }

        # Unknown collaborator
        if collaborator.defined_in_terraform == false
          logger.info "Removing collaborator #{collaborator.login.downcase} from GitHub repository #{collaborator.repository.downcase}"
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

    # Remove collaborators who have expired
    def remove_expired_collaborators(all_collaborators)
      logger.debug "remove_expired_collaborators"

      # Filter out full org collaborators
      expired_collaborators = all_collaborators.select { |collaborator| !@organization.is_collaborator_an_org_member(collaborator.login.downcase) }

      if expired_collaborators.length > 0
        # Remove collaborators from the files and raise PRs
        removed_collaborators = remove_collaborator(expired_collaborators)

        if removed_collaborators.length > 0
          # Raise Slack message
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::Expired.new, removed_collaborators).post_slack_message
        end
      end
    end

    def remove_expired_full_org_members(all_collaborators)
      logger.debug "remove_expired_full_org_members"

      # Find the collaborators that have full org membership
      full_org_collaborators = all_collaborators.select { |collaborator| @organization.is_collaborator_an_org_member(collaborator.login.downcase) }

      if full_org_collaborators.length > 0
        # Remove full org member from the files and raise PRs
        removed_collaborators = remove_collaborator(full_org_collaborators)

        if removed_collaborators.length > 0
          # Raise Slack message
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::FullOrgMemberExpired.new, removed_collaborators).post_slack_message
        end
      end
    end

    # Extend the review date for collaborators that are defined in Terraform files
    # who are all full org members
    def extend_full_org_member_review_date(all_collaborators)
      logger.debug "extend_full_org_member_review_date"
      # Find the collaborators that have full org membership
      full_org_collaborators = all_collaborators.select { |collaborator| @organization.is_collaborator_an_org_member(collaborator.login.downcase) }
      if full_org_collaborators.length > 0

        extended_collaborators = extend_date(full_org_collaborators)

        if extended_collaborators.length > 0
          # Raise Slack message
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::FullOrgMemberExpiresSoon.new, extended_collaborators).post_slack_message
        end
      end
    end

    # This function will remove collaborators whose review date has expired or
    # update the review date for collaborators who are full org members
    def has_review_date_expired(collaborators)
      logger.debug "has_review_date_expired"
      all_collaborators = find_collaborators_who_have_expired(collaborators)
      remove_expired_collaborators(all_collaborators)
      remove_expired_full_org_members(all_collaborators)
    end

    def is_review_date_within_a_week(collaborators)
      logger.debug "is_review_date_within_a_week"
      collaborators_who_expire_soon = find_collaborators_who_expire_soon(collaborators)
      extend_collaborators_review_date(collaborators_who_expire_soon)
      extend_full_org_member_review_date(collaborators_who_expire_soon)
    end

    def extend_collaborators_review_date(all_collaborators)
      logger.debug "extend_collaborators_review_date"

      # Filter out full org collaborators
      collaborators = all_collaborators.select { |collaborator| !@organization.is_collaborator_an_org_member(collaborator.login.downcase) }

      if collaborators.length > 0
        # Extend the date in the collaborator files and raise PRs

        extended_collaborators = extend_date(collaborators)

        if extended_collaborators.length > 0
          # Raise Slack message
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::ExpiresSoon.new, extended_collaborators).post_slack_message
        end
      end
    end

    # Get list of collaborators whose review date have one week remaining
    def find_collaborators_who_expire_soon(collaborators)
      logger.debug "find_collaborators_who_expire_soon"
      collaborators_who_expire_soon = []
      collaborators.each do |collaborator|
        collaborator.issues.each do |issue|
          if issue == REVIEW_DATE_EXPIRES_SOON
            collaborators_who_expire_soon.push(collaborator)
            logger.info "Review after date is within a week for #{collaborator.login.downcase} on #{collaborator.review_after_date}"
          end
        end
      end

      # Sort list based on username
      collaborators_who_expire_soon.sort_by { |collaborator| collaborator.login.downcase }
    end

    # Get list of collaborators whose review date has passed
    def find_collaborators_who_have_expired(collaborators)
      logger.debug "find_collaborators_who_have_expired"
      collaborators_who_have_expired = []
      collaborators.each do |collaborator|
        collaborator.issues.each do |issue|
          if issue == "Review after date has passed"
            collaborators_who_have_expired.push(collaborator)
            logger.info "Review after date, #{collaborator.review_after_date}, has passed for #{collaborator.login.downcase} on #{collaborator.repository.downcase}"
          end
        end
      end

      # Sort list based on login name
      collaborators_who_have_expired.sort_by! { |collaborator| collaborator.login.downcase }
    end

    def extend_date(collaborators)
      logger.debug "extend_date"
      collaborators_for_slack_message = []

      # Put collaborators into groups to commit multiple files per branch
      collaborator_groups = collaborators.group_by { |collaborator| collaborator.login.downcase }
      collaborator_groups.each do |group|
        # For each file that collaborator has an upcoming expiry
        login = ""
        edited_files = []
        pull_request_title = ""

        group[1].each do |collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(collaborator.href).downcase
          login = collaborator.login.downcase
          pull_request_title = EXTEND_REVIEW_DATE_PR_TITLE + " " + login

          if !does_pr_already_exist(terraform_file_name, pull_request_title)
            # No pull request exists, modify the file
            @terraform_files.extend_date_in_file(collaborator.repository.downcase, login)
            file_name = "terraform/#{terraform_file_name}"
            edited_files.push(file_name)
            collaborators_for_slack_message.push(collaborator)
          end
        end

        if edited_files.length > 0
          branch_name = "update-review-date-#{login}"
          type = "extend"
          GithubCollaborators::PullRequests.new.create_branch_and_pull_request(branch_name, edited_files, pull_request_title, login, type)
          add_new_pull_request(pull_request_title, edited_files)
        end
      end

      collaborators_for_slack_message
    end

    def archived_repository_check
      logger.debug "archived_repository_check"

      archived_repositories = []

      @terraform_files.terraform_files.each do |terraform_file|
        if @organization.archived_repositories.include?(terraform_file.filename.downcase)
          archived_repositories.push(terraform_file.filename.downcase)
        end
      end

      archived_repositories.sort!
      archived_repositories.uniq!

      # Delete the archived repository matching file
      edited_files = []
      archived_repositories.each do |archived_repository_name|
        @terraform_files.remove_file(archived_repository_name.downcase)
        file_name = "terraform/#{archived_repository_name.downcase}.tf"
        edited_files.push(file_name)
      end

      if edited_files.length > 0
        branch_name = "delete-archived-repository-file"
        type = "delete_archive_file"
        pull_request_title = ARCHIVED_REPOSITORY_PR_TITLE
        collaborator_name = ""
        GithubCollaborators::PullRequests.new.create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)

        # Remove the archived file from any Collaborator files objects
        edited_files.each do |archived_repository_name|
          @collaborators.each do |collaborator|
            if collaborator.repository.downcase == archived_repository_name.downcase
              index = @collaborators.index(collaborator)
              @collaborators.delete_at(index)
            end
          end
        end
      end
    end

    def remove_empty_files
      logger.debug "remove_empty_files"

      # Get empty files
      empty_files = @terraform_files.get_empty_files

      # Remove any files which are in an open pull request already
      empty_files.delete_if { |empty_file_name| does_pr_already_exist("#{empty_file_name.downcase}.tf", EMPTY_FILES_PR_TITLE) }

      # Delete the empty files
      edited_files = []
      empty_files.each do |empty_file_name|
        @terraform_files.remove_file(empty_file_name.downcase)
        file_name = "terraform/#{empty_file_name.downcase}.tf"
        edited_files.push(file_name)
      end

      if edited_files.length > 0
        branch_name = "delete-empty-files"
        type = "delete"
        pull_request_title = EMPTY_FILES_PR_TITLE
        collaborator_name = ""
        GithubCollaborators::PullRequests.new.create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)
      end
    end

    def remove_collaborator(expired_collaborators)
      logger.debug "remove_collaborator"

      collaborators_for_slack_message = []

      # Put collaborators into groups to commit multiple files per branch
      collaborators_groups = expired_collaborators.group_by { |collaborator| collaborator.login.downcase }
      collaborators_groups.each do |group|
        login = ""
        edited_files = []
        pull_request_title = ""

        # For each file where collaborator has expired
        group[1].each do |collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(collaborator.href).downcase
          login = collaborator.login.downcase
          pull_request_title = REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login

          if !does_pr_already_exist(terraform_file_name, pull_request_title)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            @terraform_files.remove_collaborator_from_file(collaborator.repository.downcase, login)
            edited_files.push(file_name)
            collaborators_for_slack_message.push(collaborator)
          end
        end

        if edited_files.length > 0
          branch_name = "remove-expired-collaborator-#{login}"
          type = "remove"
          GithubCollaborators::PullRequests.new.create_branch_and_pull_request(branch_name, edited_files, pull_request_title, login, type)
          add_new_pull_request(pull_request_title, edited_files)
        end
      end
      collaborators_for_slack_message
    end

    def change_collaborator_permission(collaborator_name, repositories)
      logger.debug "change_collaborator_permission"

      pull_request_title = CHANGE_PERMISSION_PR_TITLE + " " + collaborator_name.downcase

      # Remove the repository if an open pull request is already open with the modified permission
      repositories.delete_if { |repository| does_pr_already_exist("#{repository[:repository_name].downcase}.tf", pull_request_title) }

      edited_files = []
      repositories.each do |repository|
        # No pull request exists, modify the file/s
        repository_name = repository[:repository_name].downcase
        @terraform_files.ensure_file_exists(repository_name)
        @terraform_files.change_collaborator_permission_in_file(collaborator_name, repository_name, repository[:permission])
        edited_files.push("terraform/#{repository_name}.tf")
      end

      if edited_files.length > 0
        branch_name = "modify-collaborator-permission-#{collaborator_name}"
        type = "permission"
        GithubCollaborators::PullRequests.new.create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)
      end
    end

    # Add collaborators to Terraform file/s
    def add_collaborator(collaborator)
      logger.debug "add_collaborator"

      collaborator_name = collaborator.login.downcase
      repositories = collaborator.missing_from_repositories
      title_message = ADD_FULL_ORG_MEMBER_PR_TITLE + " " + collaborator_name

      # Remove the repository if an open pull request is already adding the full org member
      repositories.delete_if { |repository_name| does_pr_already_exist("#{repository_name.downcase}.tf", title_message) }

      edited_files = []
      repositories.each do |repository_name|
        repository_name = repository_name.downcase
        # No pull request exists, modify the file/s
        @terraform_files.ensure_file_exists(repository_name)
        # Get the github permission for that repository
        repository_permission = collaborator.get_repository_permission(repository_name)
        @terraform_files.add_collaborator_to_file(collaborator, repository_name, repository_permission)
        edited_files.push("terraform/#{repository_name}.tf")

        # Add repository name to this array because related Terraform file is not on the main
        # branch on GitHub, this array will exclude checking for this file name later on
        collaborator.add_ignore_repository(repository_name)
      end

      if edited_files.length > 0
        branch_name = "add-collaborator-#{collaborator_name}"
        type = "add"
        pull_request_title = ADD_FULL_ORG_MEMBER_PR_TITLE + " " + collaborator_name
        GithubCollaborators::PullRequests.new.create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)
      end
    end

    # Prints out the comparison of GitHub and Terraform collaborators when there is a mismatch
    def do_comparison(collaborators_in_file, collaborators_on_github, repository_name)
      logger.debug "do_comparison"

      collaborators_on_github.sort!
      collaborators_in_file.sort!
      repository_name = repository_name.downcase

      if collaborators_in_file != collaborators_on_github
        logger.warn "=" * 37
        logger.warn "There is a difference in Outside Collaborators for the #{repository_name} repository"
        logger.warn "GitHub Outside Collaborators: #{collaborators_on_github.length}"
        logger.warn "Terraform Outside Collaborators: #{collaborators_in_file.length}"
        logger.warn "Collaborators on GitHub:"
        collaborators_on_github.each { |gc_name| logger.warn "    #{gc_name.downcase}" }
        logger.warn "Collaborators in Terraform:"
        collaborators_in_file.each { |tc_name| logger.warn "    #{tc_name.downcase}" }

        find_unknown_collaborators(collaborators_on_github, collaborators_in_file, repository_name)

        # Get the repository invites
        repository_invites = @invites.get_repository_invites(repository_name)

        # Check the repository invites
        # using a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
        repository_invites.each do |invite|
          invite_login = invite[:login].downcase
          invite_expired = invite[:expired]

          # Compare Terraform file collaborators name against an open invite and
          # print where an invite is pending
          if collaborators_in_file.include?(invite_login) && invite_expired == false
            logger.info "There is a pending invite for #{invite_login} on #{repository_name}."
          end

          if collaborators_in_file.include?(invite_login) && invite_expired
            logger.info "The invite for known #{invite_login} on #{repository_name} has expired."
          end

          # Store unknown collaborator invite username to raise Slack message later on
          # Store as a hash like this { :login => "name", :repository => "repo_name" }
          if !collaborators_in_file.include?(invite_login)
            @unknown_collaborators_on_github.push({login: invite_login, repository: repository_name})
            logger.warn "Unknown collaborator #{invite_login} invited to repository: #{repository_name}"
          end

          # Delete expired invites
          if invite_expired
            @invites.delete_expired_invite(repository_name, invite_login)
          end
        end

        logger.warn "=" * 37
      end
    end

    # Compare each collaborator name on a Github repo against the Terraform file
    # collaborator names to find unknown collaborators
    def find_unknown_collaborators(collaborators_on_github, collaborators_in_file, repository_name)
      logger.debug "find_unknown_collaborators"

      # Loop through GitHub Collaborators
      collaborators_on_github.each do |gc_name|
        found_name = false

        # Loop through Terraform file collaborators
        collaborators_in_file.each do |tc_name|
          if tc_name.downcase == gc_name.downcase
            # Found a GitHub Collaborator name in Terraform collaborator name
            found_name = true
          end
        end

        if found_name == false
          # Didn't find a match ie unknown collaborator
          # Create a Collaborator object with an issue
          terraform_block = TerraformBlock.new
          terraform_block.add_unknown_collaborator_data(gc_name.downcase)
          collaborator = Collaborator.new(terraform_block, repository_name.downcase)
          collaborator.add_issue("missing")

          # Add unknown collaborator to the list of collaborators
          @collaborators.push(collaborator)
        end
      end
    end

    def does_pr_already_exist(terraform_file_name, title_message)
      logger.debug "does_pr_already_exist"
      terraform_file_name = terraform_file_name.downcase
      @repo_pull_requests.each do |pull_request|
        # Chek the PR title message and check if file in the PR list of files
        if pull_request[:title].include?(title_message.to_s) &&
            (
              pull_request[:files].include?("terraform/#{terraform_file_name}") ||
              pull_request[:files].include?(terraform_file_name)
            )
          logger.debug "PR already open for #{terraform_file_name} file"
          return true
        end
      end
      false
    end

    def add_new_pull_request(title, edited_files)
      logger.debug "add_new_pull_request"
      @repo_pull_requests.push({title: title.to_s, files: edited_files})
    end
  end
end
