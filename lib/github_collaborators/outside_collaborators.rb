# The GithubCollaborators class namespace
class GithubCollaborators
  # The OutsideCollaborators class
  class OutsideCollaborators
    include Logging
    include Constants
    include HelperModule

    def initialize
      logger.debug "initialize"

      # Collects the Terraform files and collaborators
      @terraform_files = GithubCollaborators::TerraformFiles.new

      # [Array<GithubCollaborators::Collaborator>]
      @collaborators = []

      # Create Collaborator objects based on the collaborators within the Terraform files
      terraform_files = @terraform_files.get_terraform_files
      terraform_files.each do |terraform_file|
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, terraform_file.filename.downcase)
          collaborator.check_for_issues
          @collaborators.push(collaborator)
        end
      end

      # Get the github-collaborator repository open pull requests
      # [Array<[Hash{title => String, files => [Array<String>]}]>]
      @repo_pull_requests = get_pull_requests

      # Create a Organization object, which contains the Organization repositories,
      # Org outside collaborators and each repository collaborators
      @organization = GithubCollaborators::Organization.new

      # An array to store collaborators login names that are defined in Terraform but are not on GitHub
      # [Array<Hash{login => String, repository => String}>]
      @unknown_collaborators_on_github = []
    end

    # The entry point from Ruby bin/script, keep the order as-is
    def start
      remove_empty_files
      archived_repository_check
      deleted_repository_check
      compare_terraform_and_github
      collaborator_checks
    end

    # Find the collaborator differences between GitHub and Terraform files then
    # call the functions to print the mismatch and check repository invites
    def compare_terraform_and_github
      logger.debug "compare_terraform_and_github"

      # For each repository
      @organization.repositories.each do |repository|
        repository_name = repository.name.downcase

        # Get the GitHub collaborators for the repository
        collaborators_on_github = repository.outside_collaborators_names

        # Get the Terraform defined outside collaborators for the repository
        collaborators_in_file = @terraform_files.get_collaborators_in_file(repository_name)

        if collaborators_on_github.length == 0 && collaborators_in_file.length == 0
          # When no collaborators skip to next iteration
          next
        else
          collaborators_on_github.sort!
          collaborators_in_file.sort!

          if collaborators_in_file != collaborators_on_github
            # When collaborators arrays do not match

            print_comparison(collaborators_in_file, collaborators_on_github, repository_name)

            # Find any unknown collaborators
            unknown_collaborators = find_unknown_collaborators(collaborators_in_file, collaborators_on_github, repository_name)
            if unknown_collaborators.length > 0
              create_unknown_collaborators(unknown_collaborators, repository_name)
            end

            check_repository_invites(collaborators_in_file, repository_name)
          end
        end
      end

      if @unknown_collaborators_on_github.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::UnknownCollaborators.new, @unknown_collaborators_on_github).post_slack_message
      end
    end

    # Per repository with unknown collaborators: create new Collaborator objects and
    # add them to the collaborators array. Create the Collaborator object with missing
    # issue type.
    #
    # @param unknown_collaborators [Array<String>] the list of collaborator login names
    # @param repository_name [String] the name of the repository
    def create_unknown_collaborators(unknown_collaborators, repository_name)
      logger.debug "create_unknown_collaborators"
      unknown_collaborators.each do |collaborator_name|
        terraform_block = GithubCollaborators::TerraformBlock.new
        terraform_block.add_unknown_collaborator_data(collaborator_name)
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, repository_name.downcase)
        collaborator.add_issue(MISSING)
        @collaborators.push(collaborator)
      end
    end

    # Do the checks on the collaborators
    def collaborator_checks
      logger.debug "collaborator_checks"

      collaborators_with_issues = @collaborators.select { |collaborator| collaborator.issues.length > 0 }

      repositories = []
      collaborators_with_issues.each do |collaborator|
        repositories.push(collaborator.repository.downcase)
      end
      repositories.sort!
      repositories.uniq!

      @organization.get_repository_issues_from_github(repositories)

      # Raise GitHub issues if collaborator has these issues
      is_review_date_within_a_week(collaborators_with_issues)
      is_renewal_within_one_month(collaborators_with_issues)

      # Remove unknown collaborators from GitHub
      remove_unknown_collaborators(collaborators_with_issues)

      # Either extend the date or remove the collaborator from Terraform file/s
      has_review_date_expired(collaborators_with_issues)
    end

    # Call the function to raise a GitHub issue for collaborator whose review date have
    # an expiry within one month
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def is_renewal_within_one_month(collaborators)
      logger.debug "is_renewal_within_one_month"
      collaborators.each do |collaborator|
        repository_name = collaborator.repository.downcase
        collaborator_login = collaborator.login.downcase
        
        issues = @organization.read_repository_issues(repository_name)
        issue_exist = does_issue_already_exist(issues, COLLABORATOR_EXPIRES_SOON, repository_name, collaborator_login)

        if collaborator.issues.include?(REVIEW_DATE_WITHIN_MONTH) && issue_exist == false
          create_review_date_expires_soon_issue(collaborator_login, repository_name)
        end
      end
    end

    # Call the functions to remove collaborators from Terraform file/s whose review date have
    # expired and then call the function to raise a Slack message with the collaborators that
    # were modified
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def remove_expired_collaborators(collaborators)
      logger.debug "remove_expired_collaborators"

        if collaborators.length > 0
        removed_collaborators = remove_collaborator(collaborators)
          
        if removed_collaborators.length > 0
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::Expired.new, removed_collaborators).post_slack_message
        end
      end
    end

    # Call the functions to remove collaborators from Terraform file/s who are full Organization
    # members whose review date has expired then call the function to raise a Slack message
    # with the collaborators that were modified
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def remove_expired_full_org_members(collaborators)
      logger.debug "remove_expired_full_org_members"

      # Find the collaborators that have full org membership
      full_org_collaborators = collaborators.select { |collaborator| @organization.is_collaborator_an_org_member(collaborator.login.downcase) }

      if full_org_collaborators.length > 0
        removed_collaborators = remove_collaborator(full_org_collaborators)
        if removed_collaborators.length > 0
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::FullOrgMemberExpired.new, removed_collaborators).post_slack_message
        end
      end
    end

    # Find the collaborators whose review date has expired then call
    # the functions to remove the collaborator from the Terraform file/s
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def has_review_date_expired(collaborators)
      logger.debug "has_review_date_expired"
      all_collaborators = find_collaborators_who_have_expired(collaborators)
      remove_expired_collaborators(all_collaborators)
    end

    # Find the collaborators whose review date expires within the week
    # then call the functions that extend the date in the Terraform file/s
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def is_review_date_within_a_week(collaborators)
      logger.debug "is_review_date_within_a_week"
      collaborators_who_expire_soon = find_collaborators_who_expire_soon(collaborators)
      extend_collaborators_review_date(collaborators_who_expire_soon)
    end

    # Call the functions to extend the review date in Terraform file/s for collaborators then call
    # the function to raise a Slack message with collaborators that were modified
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def extend_collaborators_review_date(collaborators)
      logger.debug "extend_collaborators_review_date"

      # Filter out full org collaborators
      outside_collaborators = collaborators.select { |collaborator| !@organization.is_collaborator_an_org_member(collaborator.login.downcase) }

      if outside_collaborators.length > 0
        extended_collaborators = extend_date(outside_collaborators)
        if extended_collaborators.length > 0
          send_collaborator_notify_email(extended_collaborators)
          GithubCollaborators::SlackNotifier.new(GithubCollaborators::ExpiresSoon.new, extended_collaborators).post_slack_message
        end
      end
    end

    # Find and return a list of collaborators whose review date expires within a week
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    # @return [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
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

    # Find and return a list of collaborators whose review date has passed
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    # @return [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    def find_collaborators_who_have_expired(collaborators)
      logger.debug "find_collaborators_who_have_expired"
      collaborators_who_have_expired = []
      collaborators.each do |collaborator|
        collaborator.issues.each do |issue|
          if issue == REVIEW_DATE_PASSED
            collaborators_who_have_expired.push(collaborator)
            logger.info "Review after date, #{collaborator.review_after_date}, has passed for #{collaborator.login.downcase} on #{collaborator.repository.downcase}"
          end
        end
      end

      # Sort list based on login name
      collaborators_who_have_expired.sort_by! { |collaborator| collaborator.login.downcase }
    end

    # Call the functions to extend the review date in Terraform file/s for collaborators
    # then call the functions to create a new pull request on GitHub
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    # @return [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects that were extended
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
            file_name = "#{TERRAFORM_DIR}/#{terraform_file_name}"
            edited_files.push(file_name)
            collaborators_for_slack_message.push(collaborator)
          end
        end

        if edited_files.length > 0
          branch_name = "#{UPDATE_REVIEW_DATE_BRANCH_NAME}#{login}"
          type = TYPE_EXTEND
          edited_files.each do |file_name|
            logger.info "Extending review date for #{login} in #{file_name}"
          end
          create_branch_and_pull_request(branch_name, edited_files, pull_request_title, login, type)
          add_new_pull_request(pull_request_title, edited_files)
        end
      end

      collaborators_for_slack_message
    end

    # Find which repositories in the Terraform files the App tracks that have been
    # deleted on GitHub, delete those file/s, then call the functions to create a
    # new pull request on GitHub
    def deleted_repository_check
      logger.debug "deleted_repository_check"

      terraform_repositories = []
      terraform_files = @terraform_files.get_terraform_files
      terraform_files.each do |terraform_file|
        terraform_repositories.append(terraform_file.filename.downcase)
      end

      github_repositories = []
      @organization.repositories.each do |repository|
        github_repositories.append(repository.name.downcase)
      end

      terraform_repositories.sort!
      github_repositories.sort!

      repo_delta = (terraform_repositories - github_repositories)

      repo_delta.delete_if do |repository_name|
        http_code = GithubCollaborators::HttpClient.new.fetch_code("#{GH_API_URL}/#{repository_name}")
        if http_code == "200" || http_code == "403"
          true
        end
      end

      # Remove any files which are in an open pull request already
      repo_delta.delete_if { |repository_name| does_pr_already_exist("#{repository_name.downcase}.tf", DELETE_REPOSITORY_PR_TITLE) }

      # Delete matching Terrafom file
      edited_files = []
      repo_delta.each do |repository_name|
        @terraform_files.remove_file(repository_name.downcase)
        file_name = "terraform/#{repository_name.downcase}.tf"
        edited_files.push(file_name)
      end

      if edited_files.length > 0
        branch_name = DELETE_FILE_BRANCH_NAME
        type = TYPE_DELETE_FILE
        pull_request_title = DELETE_REPOSITORY_PR_TITLE
        collaborator_name = ""
        create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)

        # Remove the deleted file from any Collaborator objects
        edited_files.each do |deleted_repository_name|
          logger.info "Deleting Terraform file for deleted GitHub repository #{deleted_repository_name}"
          # Strip away prefix and file type
          repository_name = File.basename(deleted_repository_name, ".tf")
          @collaborators.delete_if do |collaborator|
            if collaborator.repository.downcase == repository_name.downcase
              true
            end
          end
        end
      end
    end

    # Find which repositories in the Terraform files the App tracks that have been
    # archived, delete those file/s then call the functions to create a new pull
    # request on GitHub
    def archived_repository_check
      logger.debug "archived_repository_check"

      archived_repositories = []

      # Find which repositories in Terraform files the App tracks that have been archived
      terraform_files = @terraform_files.get_terraform_files
      the_archived_repositories = @organization.get_org_archived_repositories
      terraform_files.each do |terraform_file|
        if the_archived_repositories.include?(terraform_file.filename.downcase)
          archived_repositories.push(terraform_file.filename.downcase)
        end
      end

      archived_repositories.sort!
      archived_repositories.uniq!

      # Remove any files which are in an open pull request already
      archived_repositories.delete_if { |archived_repository_name| does_pr_already_exist("#{archived_repository_name.downcase}.tf", ARCHIVED_REPOSITORY_PR_TITLE) }

      # Delete the archived repository matching Terrafom file
      edited_files = []
      archived_repositories.each do |archived_repository_name|
        @terraform_files.remove_file(archived_repository_name.downcase)
        file_name = "terraform/#{archived_repository_name.downcase}.tf"
        edited_files.push(file_name)
      end

      if edited_files.length > 0
        branch_name = DELETE_ARCHIVE_FILE_BRANCH_NAME
        type = TYPE_DELETE_ARCHIVE
        pull_request_title = ARCHIVED_REPOSITORY_PR_TITLE
        collaborator_name = ""
        create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)

        # Remove the archived file from any Collaborator objects
        edited_files.each do |archived_repository_name|
          logger.info "Deleting Terraform file for archived GitHub repository #{archived_repository_name}"
          # Strip away prefix and file type
          repository_name = File.basename(archived_repository_name, ".tf")
          @collaborators.delete_if do |collaborator|
            if collaborator.repository.downcase == repository_name.downcase
              true
            end
          end
        end
      end
    end

    # Find which Terraform files have no collaborators and delete those file/s
    # then call the functions to create a new pull request on GitHub
    def remove_empty_files
      logger.debug "remove_empty_files"

      empty_files = @terraform_files.get_empty_files

      # Remove any files which are in an open pull request already
      empty_files.delete_if { |empty_file_name| does_pr_already_exist("#{empty_file_name.downcase}.tf", EMPTY_FILES_PR_TITLE) }

      # Delete the empty files
      edited_files = []
      empty_files.each do |empty_file_name|
        @terraform_files.remove_file(empty_file_name.downcase)
        file_name = "#{TERRAFORM_DIR}/#{empty_file_name.downcase}.tf"
        edited_files.push(file_name)
      end

      if edited_files.length > 0
        branch_name = DELETE_EMPTY_FILE_BRANCH_NAME
        type = TYPE_DELETE_EMPTY_FILE
        pull_request_title = EMPTY_FILES_PR_TITLE
        collaborator_name = ""
        edited_files.each do |file_name|
          logger.info "Deleting empty Terraform file: #{file_name}"
        end
        create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
        add_new_pull_request(pull_request_title, edited_files)
      end
    end

    # Call the functions to remove a collaborator from Terraform file/s
    # then call the functions to create a new pull request on GitHub
    # @param expired_collaborators [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects
    # @return [Array<GithubCollaborators::Collaborator>] a list of Collaborator objects that were removed
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
            file_name = "#{TERRAFORM_DIR}/#{terraform_file_name}"
            @terraform_files.remove_collaborator_from_file(collaborator.repository.downcase, login)
            edited_files.push(file_name)
            collaborators_for_slack_message.push(collaborator)
          end
        end

        if edited_files.length > 0
          branch_name = "#{REMOVE_EXPIRED_COLLABORATORS_BRANCH_NAME}#{login}"
          type = TYPE_REMOVE
          edited_files.each do |file_name|
            logger.info "Removing expired collaborator #{login} from #{file_name}"
          end
          create_branch_and_pull_request(branch_name, edited_files, pull_request_title, login, type)
          add_new_pull_request(pull_request_title, edited_files)
        end
      end
      collaborators_for_slack_message
    end

    # Call the functions to get the repository invites, print the invite status,
    # find unknown invited collaborators and delete expired invites
    # @param collaborators_in_file [Array<String>] a list of collaborator login names
    # @param repository_name [String] name of the repository
    def check_repository_invites(collaborators_in_file, repository_name)
      logger.debug "check_repository_invites"

      repository_invites = get_repository_invites(repository_name)

      repository_invites.each do |invite|
        invite_login = invite[:login].downcase
        invite_expired = invite[:expired]

        # Compare Terraform file collaborators login names against an
        # open invite and print where an invite is pending
        if collaborators_in_file.include?(invite_login) && invite_expired == false
          logger.info "There is a pending invite for #{invite_login} on #{repository_name}."
        end

        if collaborators_in_file.include?(invite_login) && invite_expired
          logger.info "The invite for known collaborator #{invite_login} on #{repository_name} has expired."
        end

        # Store unknown invited collaborator login name to raise Slack message later on
        if !collaborators_in_file.include?(invite_login)
          @unknown_collaborators_on_github.push({login: invite_login, repository: repository_name})
          logger.warn "Unknown collaborator #{invite_login} invited to repository: #{repository_name}"
        end

        if invite_expired
          delete_expired_invite(repository_name, invite_login, invite[:invite_id])
        end
      end
    end

    # Check a repository pull requests for a matching title message and see if
    # the pull request contains the file to be modified
    # @param terraform_file_name [String] the name of the terraform file to check
    # @param title_message [String] expected pull request title
    # @return [Bool] true if a pull request is open with the same title and file
    def does_pr_already_exist(terraform_file_name, title_message)
      logger.debug "does_pr_already_exist"
      terraform_file_name = terraform_file_name.downcase
      @repo_pull_requests.each do |pull_request|
        if pull_request[:title].include?(title_message.to_s) &&
            (
              pull_request[:files].include?("#{TERRAFORM_DIR}/#{terraform_file_name}") ||
              pull_request[:files].include?(terraform_file_name)
            )
          logger.debug "PR already open for #{terraform_file_name} file"
          return true
        end
      end
      false
    end

    # Add a new pull request details to the pull request list
    # @param title [String] the title of the pull request
    # @param edited_files [Array<Strings>] a list of file names
    def add_new_pull_request(title, edited_files)
      logger.debug "add_new_pull_request"
      @repo_pull_requests.push({title: title.to_s, files: edited_files})
    end

    # Call the functions to create an issue on a repository that has an
    # unknown collaborator then remove that collaborator from the repository
    # after raise a Slack message with the collaborators that were removed
    # @param collaborators [Array<GithubCollaborators::Collaborator>] a list of collaborator objects
    def remove_unknown_collaborators(collaborators)
      logger.debug "remove_unknown_collaborators"
      removed_outside_collaborators = []

      collaborators.each do |collaborator|
        login = collaborator.login.downcase
        repository = collaborator.repository.downcase

        if collaborator.defined_in_terraform == false
          logger.info "Removing collaborator #{login} from GitHub repository #{repository}"
          # Unknown collaborator: create the issue before removing access because
          # the issue is assigned to the collaborator before they are removed
          create_unknown_collaborator_issue(login, repository)
          remove_access(repository, login)
          removed_outside_collaborators.push(collaborator)
        end
      end

      if removed_outside_collaborators.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::Removed.new, removed_outside_collaborators).post_slack_message
      end
    end
  end
end
