class GithubCollaborators
  class OutsideCollaborators
    include Logging
    POST_TO_GH = ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
    GITHUB_COLLABORATORS = "github-collaborators"

    def initialize
      logger.debug "initialize"

      # Grab the Terraform files and collaborators
      @terraform_files = GithubCollaborators::TerraformFiles.new

      # Create Terraform file collaborators as Collaborator objects
      @collaborators = []
      @terraform_files.terraform_files.each do |terraform_file|
        terraform_file.terraform_blocks.each do |terraform_block|
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, terraform_file.filename)
          collaborator.check_for_issues
          @collaborators.push(collaborator)
        end
      end

      # Grab the GitHub-Collaborator repository open pull requests
      @repo_pull_requests = GithubCollaborators::PullRequests.new.get_pull_requests

      # Contains the Org repositories, full Org members, Org outside collaborators and each repository collaborators.
      @organization = GithubCollaborators::Organization.new

      # An array to store collaborators login names that are defined in Terraform but are not on GitHub
      @collaborators_missing_on_github = []
    end

    # Entry point from Ruby script, keep the order as-is the compare function will ne
    def start
      compare_terraform_and_github
      collaborator_checks
      full_org_members
      remove_empty_files
    end

    private

    def remove_empty_files
      logger.debug "remove_empty_files"
      empty_files = []

      # Get empty files
      @terraform_files.terraform_files.each do |terraform_file|
        if terraform_file.terraform_blocks.length == 0
          empty_files.push(terraform_file.filename)
        end
      end

      # Remove any files which are in an open pull request already
      empty_files.delete_if { |empty_file_name| does_pr_already_exist("#{empty_file_name}.tf", EMPTY_FILES_PR_TITLE) }

      # Delete the empty files
      edited_files = []
      empty_files.each do |empty_file_name|
        @terraform_files.remove_empty_file(empty_file_name)
        file_name = "terraform/#{empty_file_name}.tf"
        edited_files.push(file_name)
      end

      if edited_files.length > 0
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = "delete-empty-files"
        branch_name = bc.check_branch_name_is_valid(branch_name, "")
        bc.create_branch(branch_name)

        # Add, commit and push the changes
        edited_files.each { |file_name| bc.add(file_name) }
        bc.commit_and_push(EMPTY_FILES_PR_TITLE)

        # Create a pull request
        params = {
          repository: GITHUB_COLLABORATORS,
          hash_body: delete_empty_files_hash(branch_name)
        }

        GithubCollaborators::PullRequestCreator.new(params).create_pull_request

        pull_request = PullRequest.new
        pull_request.add_local_data(EMPTY_FILES_PR_TITLE, edited_files)
        @repo_pull_requests.push(pull_request)
      end
    end

    def collaborator_checks
      logger.debug "collaborator_checks"

      if @collaborators_missing_on_github.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::MissingCollaborators.new, @collaborators_missing_on_github).post_slack_message
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

    def full_org_members
      logger.debug "full_org_members"
      # Print full org members
      full_org_members_check
      logger.info "There are #{@organization.collaborators_and_org_members.length} full Org member / outside collaborators."
      @organization.collaborators_and_org_members.each { |collaborator| logger.info "#{collaborator} is a full Org member / outside collaborator." }
    end

    # Print out any differences between GitHub and terraform files
    def compare_terraform_and_github
      logger.debug "compare_terraform_and_github"

      # For each repository
      @organization.repositories.each do |repository|
        # Get the GitHub collaborators for the repository
        collaborators_on_github = repository.outside_collaborators

        # Get the Terraform defined outside collaborators for the repository
        collaborators_in_file = get_collaborators_in_file(repository.name)

        # No collaborators skip to next iteration
        if collaborators_in_file.length == 0 && collaborators_on_github.length == 0
          next
        else
          # Some Terraform collaborators have been upgraded to full organization members,
          # get them and add them to the GitHub collaborator array
          collaborators_in_file.each do |collaborator|
            if is_collaborator_org_member(collaborator)
              collaborators_on_github.push(collaborator)
            end
          end

          # Then print out the difference
          do_comparison(collaborators_in_file, collaborators_on_github, repository.name)
        end
      end
    end

    # Query the all_org_members team and return its repositories
    def get_all_org_members_team_repositories
      logger.debug "get_all_org_members_team_repositories"
      all_org_members_team_repositories = []
      url = "https://api.github.com/orgs/ministryofjustice/teams/all-org-members/repos?per_page=100"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(json)
        .find_all { |repository| repository["name"] }
        .map { |repository| all_org_members_team_repositories.push(repository["name"]) }
      all_org_members_team_repositories
    end

    def get_full_org_members
      logger.debug "get_full_org_members"
      full_org_members = []

      # Get the all org members team repositories
      all_org_members_team_repositories = get_all_org_members_team_repositories

      # Collect the GitHub and Terraform repositories for each full org member
      @organization.collaborators_and_org_members.each do |collaborator|
        full_org_member = GithubCollaborators::FullOrgMember.new(collaborator)

        # Exclude the all org members team repositories
        full_org_member.add_excluded_repositories(all_org_members_team_repositories)

        # Get the GitHub repositories
        full_org_member.get_full_org_member_repositories

        # Get the collaborator repositories as defined in Terraform files
        collaborator_repositories = @collaborators.select { |terraform_collaborator| terraform_collaborator.login == collaborator }

        # Extract just the repository names
        tc_repositories = []
        collaborator_repositories.each do |collaborator|
          tc_repositories.push(collaborator.repository)
        end

        # Add the repositories names to the object
        full_org_member.add_terraform_repositories(tc_repositories)
        full_org_members.push(full_org_member)
      end

      full_org_members
    end

    # Find if full org members / collaborators are members of repositories but not defined in Terraform
    def full_org_members_check
      logger.debug "full_org_members_check"

      odd_full_org_members = []

      # Run full org member tests
      get_full_org_members.each do |full_org_member|
        # Compare the GitHub and Terraform repositories
        if full_org_member.do_repositories_match == false
          # Where collaborator is not defined in Terraform, create a PR with collaborator added to those files
          create_add_collaborator_pull_requests(full_org_member.login, full_org_member.missing_repositories)
        end

        # Find the collaborators that are attached to no GitHub repositories
        if full_org_member.odd_full_org_member_check
          odd_full_org_members.push(full_org_member.login)
        end
      end

      # Raise Slack message for collaborators that are attached to no Github repositories
      if odd_full_org_members.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::OddFullOrgMembers.new, odd_full_org_members).post_slack_message
      end
    end

    def is_renewal_within_one_month(collaborators)
      logger.debug "is_renewal_within_one_month"
      # Check all collaborators
      collaborators.each do |collaborator|
        params = {
          repository: collaborator.repository,
          github_user: collaborator.login
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
          repository: collaborator.repository,
          github_user: collaborator.login
        }

        # Unknown collaborator
        if collaborator.defined_in_terraform == false
          logger.info "Removing collaborator #{collaborator.login} from GitHub repository #{collaborator.repository}"
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
      expired_collaborators = all_collaborators.select { |collaborator| !is_collaborator_org_member(collaborator.login) }

      if expired_collaborators.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::Expired.new, expired_collaborators).post_slack_message

        # Remove collaborators from the files and raise PRs
        create_remove_collaborator_pull_requests(expired_collaborators)
      end
    end

    # Extend the review date for collaborators that are defined in Terraform files
    # but are all full org members
    def extend_full_org_member_collaborators(all_collaborators)
      logger.debug "extend_full_org_member_collaborators"
      # Find the collaborators that have full org membership
      full_org_collaborators = all_collaborators.select { |collaborator| is_collaborator_org_member(collaborator.login) }
      if full_org_collaborators.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::FullOrgMemberExpiresSoon.new, full_org_collaborators).post_slack_message

        # For the full Org members extend the review date in the collaborator files and raise PRs
        create_extend_date_pull_requests(full_org_collaborators)
      end
    end

    # This function will remove collaborators whose review date has expired or
    # update the review date for collaborators who are full org members
    def has_review_date_expired(collaborators)
      logger.debug "has_review_date_expired"
      all_collaborators = find_collaborators_who_have_expired(collaborators)
      remove_expired_collaborators(all_collaborators)
      extend_full_org_member_collaborators(all_collaborators)
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

    def is_collaborator_org_member(login)
      logger.debug "is_collaborator_org_member"
      if @organization.is_collaborator_an_org_member(login)
        return true
      end
      false
    end

    # Get list of collaborators whose review date have one week remaining
    def find_collaborators_who_expire_soon(collaborators)
      logger.debug "find_collaborators_who_expire_soon"
      collaborators_who_expire_soon = []
      collaborators.each do |collaborator|
        collaborator.issues.each do |issue|
          if issue == REVIEW_DATE_EXPIRES_SOON
            collaborators_who_expire_soon.push(collaborator)
            logger.info "Review after date is within a week for #{collaborator.login} on #{collaborator.review_after_date}"
          end
        end
      end

      # Sort list based on username
      collaborators_who_expire_soon.sort_by { |collaborator| collaborator.login }
    end

    # Get list of collaborators whose review date has passed
    def find_collaborators_who_have_expired(collaborators)
      logger.debug "find_collaborators_who_have_expired"
      collaborators_who_have_expired = []
      collaborators.each do |collaborator|
        collaborator.issues.each do |issue|
          if issue == "Review after date has passed"
            collaborators_who_have_expired.push(collaborator)
            logger.info "Review after date, #{collaborator.review_after_date}, has passed for #{collaborator.login} on #{collaborator.repository}"
          end
        end
      end

      # Sort list based on login name
      collaborators_who_have_expired.sort_by! { |collaborator| collaborator.login }
    end

    def extend_date_in_file(repository_name, login)
      logger.debug "extend_date_in_file"
      @terraform_files.terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.extend_review_date(login)
          terraform_file.write_to_file
        end
      end
    end

    def remove_collaborator_from_file(repository_name, login)
      logger.debug "remove_collaborator_from_file"
      @terraform_files.terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          terraform_file.remove_collaborator(login)
          terraform_file.write_to_file
        end
      end
    end

    def add_collaborator_to_file(repository_name, login)
      logger.debug "add_collaborator_to_file"
      @terraform_files.terraform_files.each do |terraform_file|
        if terraform_file.filename == GithubCollaborators.tf_safe(repository_name)
          # Add the collaborator to the file
          terraform_file.add_org_member_collaborator(login)
          terraform_file.write_to_file
        end
      end
    end

    def create_extend_date_pull_requests(collaborators_who_expire_soon)
      logger.debug "create_extend_date_pull_requests"
      # Put collaborators into groups to commit multiple files per branch
      collaborator_groups = collaborators_who_expire_soon.group_by { |collaborator| collaborator.login }
      collaborator_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        login = ""
        edited_files = []
        pull_request_title = ""

        # For each file that collaborator has an upcoming expiry
        group[1].each do |collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(collaborator.href)
          login = collaborator.login
          pull_request_title = EXTEND_REVIEW_DATE_PR_TITLE + " " + login

          if !does_pr_already_exist(terraform_file_name, pull_request_title)
            # No pull request exists, modify the file
            extend_date_in_file(collaborator.repository, login)
            file_name = "terraform/#{terraform_file_name}"
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each collaborator group commit any modified file/s
          branch_name = "update-review-date-#{login}"
          branch_name = bc.check_branch_name_is_valid(branch_name, login)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push(EXTEND_REVIEW_DATE_PR_TITLE + " " + login)

          # Create a pull request
          params = {
            repository: GITHUB_COLLABORATORS,
            hash_body: extend_date_hash(login, branch_name)
          }

          GithubCollaborators::PullRequestCreator.new(params).create_pull_request

          pull_request = PullRequest.new
          pull_request.add_local_data(pull_request_title, edited_files)
          @repo_pull_requests.push(pull_request)
        end
      end
    end

    def create_remove_collaborator_pull_requests(expired_collaborators)
      logger.debug "create_remove_collaborator_pull_requests"
      # Put collaborators into groups to commit multiple files per branch
      collaborators_groups = expired_collaborators.group_by { |collaborator| collaborator.login }
      collaborators_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        login = ""
        edited_files = []
        pull_request_title = ""

        # For each file where collaborator has expired
        group[1].each do |collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(collaborator.href)
          login = collaborator.login
          pull_request_title = REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login

          if !does_pr_already_exist(terraform_file_name, pull_request_title)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            remove_collaborator_from_file(collaborator.repository, login)
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each collaborator group commit any modified file/s
          branch_name = "remove-expired-collaborator-#{login}"
          branch_name = bc.check_branch_name_is_valid(branch_name, login)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push(REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login)

          # Create a pull request
          params = {
            repository: GITHUB_COLLABORATORS,
            hash_body: remove_collaborator_hash(login, branch_name)
          }

          GithubCollaborators::PullRequestCreator.new(params).create_pull_request

          pull_request = PullRequest.new
          pull_request.add_local_data(pull_request_title, edited_files)
          @repo_pull_requests.push(pull_request)
        end
      end
    end

    def does_pr_already_exist(terraform_file_name, title_message)
      logger.debug "does_pr_already_exist"
      @repo_pull_requests.each do |pull_request|
        # Chek the PR title message and check if file in the PR list of files
        if pull_request.title.include?(title_message.to_s)
          if (pull_request.files.include?("terraform/#{terraform_file_name}")) ||
              (pull_request.files.include?(terraform_file_name))
            logger.debug "PR already open for #{terraform_file_name} file"
            return true
          end
        end
      end
      false
    end

    def check_repository_file_exist(repository_name)
      logger.debug "check_repository_file_exist"
      file_exists = false
      @terraform_files.terraform_files.each do |terraform_file|
        if terraform_file == repository_name
          file_exists = true
          break
        end
      end

      if file_exists == false
        # It doesn't so create a new file
        @terraform_files.create_new_file(repository_name)
      end
    end

    # Add collaborators to Terraform file/s
    def create_add_collaborator_pull_requests(collaborator_name, repositories)
      logger.debug "create_add_collaborator_pull_requests"

      title_message = ADD_FULL_ORG_MEMBER_PR_TITLE + " " + collaborator_name

      # Remove the repository if an open pull request is already adding the full org member
      repositories.delete_if { |repository_name| does_pr_already_exist("#{repository_name}.tf", title_message) }

      edited_files = []
      repositories.each do |repository_name|
        # No pull request exists, modify the file/s
        check_repository_file_exist(repository_name)
        add_collaborator_to_file(repository_name, collaborator_name)
        edited_files.push("terraform/#{repository_name}.tf")
      end

      if edited_files.length > 0
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = "add-collaborator-#{collaborator_name}"
        branch_name = bc.check_branch_name_is_valid(branch_name, collaborator_name)
        bc.create_branch(branch_name)
        edited_files.each { |file_name| bc.add(file_name) }
        bc.commit_and_push(title_message)

        # Create a pull request
        params = {
          repository: GITHUB_COLLABORATORS,
          hash_body: add_collaborator_hash(collaborator_name, branch_name)
        }

        GithubCollaborators::PullRequestCreator.new(params).create_pull_request

        pull_request = PullRequest.new
        pull_request.add_local_data(title_message, edited_files)
        @repo_pull_requests.push(pull_request)
      end
    end

    def get_collaborators_in_file(repository_name)
      logger.debug "get_collaborators_in_file"
      collaborators_in_file = []
      @collaborators.each do |collaborator|
        if collaborator.repository == GithubCollaborators.tf_safe(repository_name)
          collaborators_in_file.push(collaborator.login)
        end
      end
      collaborators_in_file
    end

    # Prints out the comparison of GitHub and Terraform collaborators when there is a mismatch
    def do_comparison(collaborators_in_file, collaborators_on_github, repository_name)
      logger.debug "do_comparison"

      # When there is a difference between Github and Terraform§
      if collaborators_in_file.length != collaborators_on_github.length
        logger.warn "=" * 37
        logger.warn "There is a difference in Outside Collaborators for the #{repository_name} repository"
        logger.warn "GitHub Outside Collaborators: #{collaborators_on_github.length}"
        logger.warn "Terraform Outside Collaborators: #{collaborators_in_file.length}"
        logger.warn "Collaborators on GitHub:"
        collaborators_on_github.each { |gc_name| logger.warn "    #{gc_name}" }
        logger.warn "Collaborators in Terraform:"
        collaborators_in_file.each { |tc_name| logger.warn "    #{tc_name}" }

        find_unknown_collaborators(collaborators_on_github, collaborators_in_file, repository_name)

        # Get the repository invites
        repository_invites = get_repository_invites(repository_name)

        # Check the repository invites
        # using a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
        repository_invites.each do |invite|
          invite_login = invite[:login]
          # Compare Terraform file collaborators name against Open invites
          if collaborators_in_file.include?(invite_login)
            if invite[:expired]
              # Invite expired
              collaborator_invite_expired(repository_name, invite)
            else
              # When invite is pending
              logger.info "There is a pending invite for #{invite_login} on #{repository_name}."
            end
          else
            # When no invite exists, this means the collaborator is not found on the GitHub repository
            # Collaborator is not defined on GitHub, add to the array for a Slack message below
            # Store as a hash like this { :login => "name", :repository => "repo_name" }
            @collaborators_missing_on_github.push({login: invite_login, repository: repository_name})
            logger.warn "#{invite_login} is not defined on the GitHub repository: #{repository_name}."
          end
        end

        logger.warn "=" * 37
      end
    end

    # Compare each collaborator name on a Github repo against the Terraform file name
    # collaborator names to find unknown collaborators
    def find_unknown_collaborators(collaborators_on_github, collaborators_in_file, repository_name)
      logger.debug "find_unknown_collaborators"

      # Loop through GitHub Collaborators
      collaborators_on_github.each do |gc_name|
        found_name = false

        # Loop through Terraform file collaborators
        collaborators_in_file.each do |tc_name|
          if tc_name == gc_name
            # Found a GitHub Collaborator name in Terraform collaborator name
            found_name = true
          end
        end

        if found_name == false
          # Didn't find a match ie unknown collaborator
          # Create a Collaborator object with an issue
          terraform_block = TerraformBlock.new
          terraform_block.add_unknown_collaborator_data(gc_name)
          collaborator = Collaborator.new(terraform_block, repository_name)
          collaborator.add_issue("missing")

          # Add unknown collaborator to the list of collaborators
          @collaborators.push(collaborator)
        end
      end
    end

    # Called when an invite has expired
    def collaborator_invite_expired(repository_name, invite)
      logger.debug "collaborator_invite_expired"
      logger.warn "The invite for #{invite[:login]} on #{repository_name} has expired. Deleting the invite."
      if POST_TO_GH
        url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/invitations/#{invite[:invite_id]}"
        GithubCollaborators::HttpClient.new.delete(url)
        sleep 1
      else
        logger.debug "Didn't delete collaborator repository invite, this is a dry run"
      end
    end

    # Get the collaborator invites for the repository and store the data as
    # a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
    def get_repository_invites(repository_name)
      logger.debug "get_repository_invites"
      repository_invites = []
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/invitations"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(json)
        .find_all { |invite| invite["invitee"]["login"] }
        .map { |invite| repository_invites.push({login: invite["invitee"]["login"], expired: invite["expired"], invite_id: invite["id"]}) }
      repository_invites
    end

    def remove_collaborator_hash(login, branch_name)
      logger.debug "remove_collaborator_hash"
      {
        title: REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there

          This is the GitHub-Collaborator repository bot. 

          The collaborator #{login} review date has expired for the file/s contained in this pull request.
          
          Either approve this pull request, modify it or delete it if it is no longer necessary.
        EOF
      }
    end

    def extend_date_hash(login, branch_name)
      logger.debug "extend_date_hash"
      {
        title: EXTEND_REVIEW_DATE_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          #{login} has review date/s that are close to expiring. 
          
          The review date/s have automatically been extended.

          Either approve this pull request, modify it or delete it if it is no longer necessary.
        EOF
      }
    end

    def delete_empty_files_hash(branch_name)
      logger.debug "delete_empty_files_hash"
      {
        title: EMPTY_FILES_PR_TITLE,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot.

          The Terraform files in this pull request are empty and serve no purpose, please remove them.

        EOF
      }
    end

    def add_collaborator_hash(login, branch_name)
      logger.debug "add_collaborator_hash"
      {
        title: ADD_FULL_ORG_MEMBER_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          #{login} was found to be missing from the file/s in this pull request.

          This is because the collaborator is a full organization member and is able to join repositories outside of Terraform.

          This pull request ensures we keep track of those collaborators and which repositories they are accessing.

          Edit the pull request file/s because Terraform requires the collaborators repository permission.

          Permission can either be admin, push, maintain, pull or triage.

        EOF
      }
    end
  end
end
