class GithubCollaborators
  class OutsideCollaborators
    include Logging
    POST_TO_GH = ENV.fetch("REALLY_POST_TO_GH", 0) == "1"

    def initialize
      logger.debug "initialize"

      # Grab the GitHub-Collaborator repository open pull requests
      pull_requests = GithubCollaborators::PullRequests.new
      @repo_pull_requests = pull_requests.get_pull_requests

      # Contains the Org repositories, full Org members, Org outside collaborators and each repository collaborators.
      @organization = GithubCollaborators::Organization.new

      # An array of TerraformCollaborator objects as hash variables, see the to_hash function for structure.
      @terraform_collaborators = GithubCollaborators::TerraformCollaborators.new(folder_path: Dir.getwd + "/terraform").fetch_all_terraform_collaborators
    end

    # Entry point from Ruby script
    def collaborator_checks
      logger.debug "collaborator_checks"
      collaborators_with_issues = collect_collaborators_with_issues
      is_review_date_within_a_week(collaborators_with_issues)
      is_renewal_within_one_month(collaborators_with_issues)
      remove_unknown_collaborators(collaborators_with_issues)
      has_review_date_expired(collaborators_with_issues)
    end

    def full_org_members
      logger.debug "full_org_members"
      # Print full org members
      logger.info "There are #{@organization.collaborators_and_org_members.length} full Org member / outside collaborators."
      @organization.collaborators_and_org_members.each { |collaborator| logger.info "#{collaborator} is a full Org member / outside collaborator." }
      full_org_members_check
    end

    # Print out any differences between GitHub and terraform files
    def compare_terraform_and_github
      logger.debug "compare_terraform_and_github"

      # An array to store collaborators login names that are defined in Terraform but are not on GitHub
      collaborators_missing_on_github = []

      # For each repository
      @organization.repositories.each do |repository|
        # Get the GitHub outside collaborators for the repository
        collaborators_on_github = repository.outside_collaborators

        # Get the Terraform defined outside collaborators for the repository
        collaborators_in_file = []
        @terraform_collaborators.each do |tc|
          if tc["repository"] == GithubCollaborators.tf_safe(repository.name)
            collaborators_in_file.push(tc["login"])
          end
        end

        if collaborators_in_file.length == 0 && collaborators_in_file.length == 0
          next
        else
          # Some terraform collaborators have been upgraded to full organization members, this finds them.
          collaborators_in_file.each do |collaborator|
            if is_collaborator_org_member(collaborator)
              # And adds those collaborator to the GitHub list
              collaborators_on_github.push(collaborator)
            end
          end

          if collaborators_in_file.length != collaborators_on_github.length
            # There is a difference between Terraform and Github
            logger.warn "=" * 37
            logger.warn "There is a difference in Outside Collaborators for the #{repository.name} repository"
            logger.warn "GitHub Outside Collaborators: #{collaborators_on_github.length}"
            logger.warn "Terraform Outside Collaborators: #{collaborators_in_file.length}"
            logger.warn "Collaborators on GitHub:"
            collaborators_on_github.each { |gc| logger.warn "    #{gc}" }
            logger.warn "Collaborators in Terraform:"
            collaborators_in_file.each { |tc| logger.warn "    #{tc}" }

            # Get the collaborator invites for the repository and store the data as
            # a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
            repository_invites = []
            url = "https://api.github.com/repos/ministryofjustice/#{repository.name}/invitations"
            json = GithubCollaborators::HttpClient.new.fetch_json(url)
            JSON.parse(json)
              .find_all { |invite| invite["invitee"]["login"] }
              .map { |invite| repository_invites.push({login: invite["invitee"]["login"], expired: invite["expired"], invite_id: invite["id"]}) }

            # Check the repository invites
            # using a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
            repository_invites.each do |invite|
              if collaborators_in_file.include?(invite[:login])
                if invite[:expired]
                  # When invite has expired
                  logger.warn "The invite for #{invite[:login]} on #{repository.name} has expired. Deleting the invite."
                  if POST_TO_GH
                    url = "https://api.github.com/repos/ministryofjustice/#{repository.name}/invitations/#{invite[:invite_id]}"
                    GithubCollaborators::HttpClient.new.delete(url)
                    sleep 1
                  else
                    logger.debug "Didn't delete collaborator repository invite, this is a dry run"
                  end
                else
                  # When invite is pending
                  logger.info "There is a pending invite for #{invite[:login]} on #{repository.name}."
                end
              else
                # When no invite exists, this means the collaborator is not found on GitHub repository
                # Collaborator is not defined on GitHub, add to the array for a Slack message below
                # Store as a hash like this { :login => "name", :repository => "repo_name" }
                collaborators_missing_on_github.push({login: (invite[:login]).to_s, repository: repository.name.to_s})
                logger.warn "#{invite[:login]} is not defined on the GitHub repository: #{repository.name}."
              end
            end

            logger.warn "=" * 37
          end
        end
      end

      if collaborators_missing_on_github.length > 0
        # Raise Slack message
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::MissingCollaborators.new, collaborators_missing_on_github).post_slack_message
      end
    end

    private

    # Find if full org members / collaborators are members of repositories but not defined in Terraform
    def full_org_members_check
      logger.debug "full_org_members_check"

      full_org_members = []

      # Get the all org team repositories
      all_org_team_repositories = []
      url = "https://api.github.com/orgs/ministryofjustice/teams/all-org-members/repos?per_page=100"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(json)
        .find_all { |repository| repository["name"] }
        .map { |repository| all_org_team_repositories.push(repository["name"]) }

      # Collect the GitHub and Terraform repositories for each full org member
      @organization.collaborators_and_org_members.each do |collaborator| 
        full_org_member = GithubCollaborators::FullOrgMember.new(collaborator)
        full_org_member.add_excluded_repositories(all_org_team_repositories)
        # GitHub repositories
        full_org_member.get_full_org_member_repositories
        # Filter array to get collaborator related elements
        tc = @terraform_collaborators.select { |terraform_collaborator| terraform_collaborator["login"] == collaborator }
        tc.each do |collaborator|
          # Terraform repositories
          full_org_member.add_terraform_repository(collaborator["repository"])
        end
        full_org_members.push(full_org_member)
      end

      # Run full org member tests
      odd_full_org_members = []
      full_org_members.each do |full_org_member|
        
        # Compare the GitHub and Terraform repositories
        if full_org_member.do_repositories_match == false
          # Where collaborator is not defined in Terraform, create a PR with collaborator added to those files
          create_add_collaborator_pull_requests(full_org_member.login, full_org_member.missing_repositories)
        end

        # Find the collaborators attached to no GitHub repositories
        if full_org_member.odd_full_org_member_check
          odd_full_org_members.push(full_org_member.login)
        end
      end

      # Raise Slack message for collaborators attached to no Github repositories
      if odd_full_org_members.length > 0
        GithubCollaborators::SlackNotifier.new(GithubCollaborators::OddFullOrgMembers.new, odd_full_org_members).post_slack_message
      end
    end

    def collect_collaborators_with_issues
      logger.debug "collect_collaborators_with_issues"

      # Find the collaborators with issues
      those_with_issues = []
      github_collaborators_with_issues = @organization.get_collaborators_with_issues
      terraform_collaborators_with_issues = @terraform_collaborators.select { |collaborator| collaborator["issues"].length > 0 }

      # Combine the issues, Filter out duplicates
      # Use the github_collaborators_with_issues first as they have the repo url for Slack message later on
      those_with_issues = github_collaborators_with_issues
      terraform_collaborators_with_issues.each do |collaborator|
        is_duplicate = false
        those_with_issues.each do |collaborator_with_issue|
          if collaborator["login"] == collaborator_with_issue["login"] &&
              collaborator["repository"] == collaborator_with_issue["repository"] &&
              collaborator["issues"] == collaborator_with_issue["issues"]
            is_duplicate = true
          end
        end
        if is_duplicate
          next
        else
          those_with_issues.push(collaborator)
        end
      end

      those_with_issues
    end

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
          logger.info "Removing collaborator #{collaborator["login"]} from GitHub repository #{collaborator["repository"]}"
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
        collaborator["issues"].each do |issue|
          if issue == "Review after date is within a week"
            collaborators_who_expire_soon.push(collaborator)
            logger.info "Review after date is within a week for #{collaborator["login"]} on #{collaborator["review_date"]}"
          end
        end
      end

      # Sort list based on username
      collaborators_who_expire_soon.sort_by { |collaborator| collaborator["login"] }
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

      # Sort list based on login name
      collaborators_who_have_expired.sort_by! { |collaborator| collaborator["login"] }
    end

    def extend_date_in_file(file_name, login)
      logger.debug "extend_date_in_file"
      TerraformCollaborator.new(
        repository: File.basename(file_name, ".tf"),
        login: login
      ).extend_review_date
    end

    def remove_collaborator_from_file(file_name, login)
      logger.debug "remove_collaborator_from_file"
      tc = TerraformCollaborator.new(
        repository: File.basename(file_name, ".tf"),
        login: login
      ).remove_collaborator
    end

    def create_extend_date_pull_requests(collaborators_who_expire_soon)
      logger.debug "create_extend_date_pull_requests"
      # Put collaborators into groups to commit multiple files per branch
      collaborator_groups = collaborators_who_expire_soon.group_by { |collaborator| collaborator["login"] }
      collaborator_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = ""
        login = ""
        edited_files = []

        # For each file that collaborator has an upcoming expiry
        group[1].each do |outside_collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(outside_collaborator["href"])
          login = outside_collaborator["login"]
          title_message = "Extend review dates for #{login} in Terraform file/s"

          if !does_pr_already_exist(terraform_file_name, title_message)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            branch_name = "update-review-date-#{login}"
            extend_date_in_file(file_name, login)
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each collaborator group commit any modified file/s
          branch_name = bc.check_branch_name_is_valid(branch_name)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Extend review dates for #{login} in Terraform file/s")

          # Create a pull request
          params = {
            repository: "github-collaborators",
            hash_body: extend_date_hash(login, branch_name)
          }

          GithubCollaborators::PullRequestCreator.new(params).create_pull_request
        end
      end
    end

    def create_remove_collaborator_pull_requests(expired_collaborators)
      logger.debug "create_remove_collaborator_pull_requests"
      # Put collaborators into groups to commit multiple files per branch
      collaborators_groups = expired_collaborators.group_by { |collaborator| collaborator["login"] }
      collaborators_groups.each do |group|
        # Ready a new branch
        bc = GithubCollaborators::BranchCreator.new
        branch_name = ""
        login = ""
        edited_files = []

        # For each file where collaborator has expired
        group[1].each do |outside_collaborator|
          # Check if a pull request is already pending
          terraform_file_name = File.basename(outside_collaborator["href"])
          login = outside_collaborator["login"]
          title_message = "Remove expired collaborator #{login} from Terraform file/s"

          if !does_pr_already_exist(terraform_file_name, title_message)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            branch_name = "remove-expired-collaborator-#{login}"
            remove_collaborator_from_file(file_name, login)
            edited_files.push(file_name)
          end
        end

        if edited_files.length > 0
          # At the end of each collaborator group commit any modified file/s
          branch_name = bc.check_branch_name_is_valid(branch_name)
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Remove expired collaborator #{login} from Terraform file/s")

          # Create a pull request
          params = {
            repository: "github-collaborators",
            hash_body: remove_collaborator_hash(login, branch_name)
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
          logger.debug "PR already open for #{terraform_file_name} file"
          return true
        end
      end
      false
    end

    # Add collaborators to Terraform file/s
    def create_add_collaborator_pull_requests(collaborator, repositories)
      logger.debug "create_add_collaborator_pull_requests"

      title_message = "Add full org member / collaborator #{collaborator} to Terraform file/s"

      repositories.each do |repository|
        terraform_file_name = repository + ".tf"
        if does_pr_already_exist(terraform_file_name, title_message)
          repositories.delete_at(repository)
        end
      end

      # No pull request exists, modify the file
      branch_name = "add-collaborator-#{collaborator}-to-terraform"
      
      # Edit the files
      edited_files = []
      repositories.each do |repository_name|
        terraform_file_name = repository_name + ".tf"
        file_name = "terraform/#{terraform_file_name}"
        tc = GithubCollaborators::TerraformBlockCreator.new
        tc.add_data(collaborator)
        tc.update_file(repository_name)
        edited_files.push(file_name)
      end

      # Ready a new branch
      bc = GithubCollaborators::BranchCreator.new
      branch_name = bc.check_branch_name_is_valid(branch_name)
      bc.create_branch(branch_name)
      edited_files.each { |file_name| bc.add(file_name) }
      bc.commit_and_push(title_message)

      # Create a pull request
      params = {
        repository: "github-collaborators",
        hash_body: add_collaborator_hash(collaborator, branch_name)
      }

      GithubCollaborators::PullRequestCreator.new(params).create_pull_request
    end

    def remove_collaborator_hash(login, branch_name)
      logger.debug "remove_collaborator_hash"
      {
        title: "Remove expired collaborator #{login} from Terraform file/s",
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
        title: "Extend review dates for #{login} in Terraform file/s",
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

    def add_collaborator_hash(login, branch_name)
      logger.debug "add_collaborator_hash"
      {
        title: "Add full org member / collaborator #{login} to Terraform file/s",
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          #{login} was found to be missing from the file/s in this pull request.

          This is because the collaborator is a full organization member and is able to join repositories outside of Terraform.

          This pull request ensures we keep track of those collaborators and which repositories they are accessing.

          Edit the pull request file/s because Terraform requires the collaborators repository permission.

        EOF
      }
    end
  end
end
