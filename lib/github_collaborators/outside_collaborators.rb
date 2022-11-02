class GithubCollaborators
  class OutsideCollaborators
    include Logging

    OWNER = "ministryofjustice"
    BASE_URL = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"    
    TESTING = true
    POST_TO_SLACK = ENV.fetch("REALLY_POST_TO_SLACK", 0) == "1"

    def initialize
      logger.debug "initialize"
      # TODO: remove this code
      if TESTING
        # @outside_collaborators = @@test_outside_collaborator_list
        @outside_collaborators = test_data
      else
        # Create a list of users that are outside collaborators ie not MoJ Organisation Members
        @outside_collaborators = GithubCollaborators::OrganizationOutsideCollaborators.new(login: OWNER, base_url: BASE_URL).list
      end
      # Grab the GitHub-Collaborator repository open pull requests
      @repo_pull_requests = GithubCollaborators::PullRequests.new.list
    end

    def is_renewal_within_one_month
      logger.debug "is_renewal_within_one_month"
      @outside_collaborators.each do |x|
        params = {
          owner: OWNER,
          repository: x["repository"],
          github_user: x["login"]
        }

        # Create an issue on the repo when "Review after date is within a month" is true
        if x["issues"].include? "Review after date is within a month"
          GithubCollaborators::IssueCreator.new(params).create_review_date
        end
      end
    end

    def remove_unknown_collaborators
      logger.debug "remove_unknown_collaborators"
      @outside_collaborators.each do |x|
        params = {
          owner: OWNER,
          repository: x["repository"],
          github_user: x["login"]
        }
        
        if x["defined_in_terraform"] == false
          logger.info "Removing collaborator #{x["login"]} from repository #{x["repository"]}"
          # We must create the issue before removing access, because the issue is
          # assigned to the removed collaborator, so that they (hopefully) get a
          # notification about it.
          GithubCollaborators::IssueCreator.new(params).create
          sleep 3
          GithubCollaborators::AccessRemover.new(params).remove
          sleep 1
        end
      end
    end

    def has_review_date_expired
      logger.debug "has_review_date_expired"
      expired_users = find_users_who_have_expired
      
      # Raise Slack message
      GithubCollaborators::SlackNotifier.new(GithubCollaborators::Expired.new, POST_TO_SLACK, expired_users).run

      # Raise PRs
      create_remove_user_pull_requests(expired_users)
    end

    def is_review_date_within_a_week
      logger.debug "is_review_date_within_a_week"
      users_who_expire_soon = find_users_who_expire_soon
      
      # Raise Slack message
      GithubCollaborators::SlackNotifier.new(GithubCollaborators::ExpiresSoon.new, POST_TO_SLACK, users_who_expire_soon).run

      # Raise PRs
      create_extend_date_pull_requests(users_who_expire_soon)
    end

    private
    
    # Get list of users whose review date have one week remaining
    def find_users_who_expire_soon
      logger.debug "find_users_who_expire_soon"
      users_who_expire_soon = []
      @outside_collaborators.each do |user|
        user["issues"].each do |issue|
          if issue == "Review after date is within a week"
            users_who_expire_soon.push(user)
            logger.info "Review after date is within a week for #{user["login"]} on #{user["review_date"]}"
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
      @outside_collaborators.each do |user|
        user["issues"].each do |issue|
          if issue == "Review after date has passed"
            users_who_have_expired.push(user)
            logger.info "Review after date has passed for #{user["login"]} on #{user["review_date"]}"
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
        repo_url: nil,
        login_url: nil,
        permission: nil
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
        repo_url: nil,
        login_url: nil,
        permission: nil
      }
      tc = TerraformCollaborator.new(params)
      tc.remove_user
    end
  
    def create_extend_date_pull_requests(users_who_expire_soon)
      logger.debug "create_extend_date_pull_requests"
      # Put users into groups to commit multiple files per branch
      user_groups = users_who_expire_soon.group_by { |x| x["login"] }
      user_groups.each do |group|

        # Ready a new branch
        bc = GithubCollaborators::BranchCreator::new
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
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Update review date for #{user_name}")

          sleep 5

          # Create a pull request
          params = {
            owner: OWNER,
            repository: "github-collaborators",
            hash_body: extend_date_hash(user_name, branch_name)
          }
        
          GithubCollaborators::PullRequestCreator.new(params).create
        end
      end
    end

    def create_remove_user_pull_requests(expired_users)
      logger.debug "create_remove_user_pull_requests"
      # Put users into groups to commit multiple files per branch
      user_groups = expired_users.group_by { |x| x["login"] }
      user_groups.each do |group|

        # Ready a new branch
        bc = GithubCollaborators::BranchCreator::new
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
          bc.create_branch(branch_name)
          edited_files.each { |file_name| bc.add(file_name) }
          bc.commit_and_push("Remove expired user #{user_name}")

          sleep 5

          # Create a pull request
          params = {
            owner: OWNER,
            repository: "github-collaborators",
            hash_body: remove_user_hash(user_name, branch_name)
          }
        
          GithubCollaborators::PullRequestCreator.new(params).create
        end
      end
    end

    def does_pr_already_exist(terraform_file_name, title_message)
      logger.debug "does_pr_already_exist"
      @repo_pull_requests.each do |pull_request|
        if (
          (pull_request.title.include? "#{title_message}") &&
          (pull_request.files.include? "terraform/#{terraform_file_name}")
        )
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

    def test_data

      params = {
        terraform_dir: "terraform",
        folder_path: "/Users/nick.walters/MoJ/github-collaborators"
      }
      
      terraform_collabs = GithubCollaborators::TerraformCollaborators.new(params)
      the_files = terraform_collabs.fetch_terraform_files
      
      exclude_files = ["acronyms.tf", "main.tf", "variables.tf", "versions.tf", "backend.tf"]
      
      collabs = []
      the_files.each do |file|
        if !exclude_files.include?(File.basename(file))
      
          params2 = {
            folder_path: "/Users/nick.walters/MoJ/github-collaborators"
          }
          collaborators_in_file = GithubCollaborators::TerraformCollaborators.new(params2).return_collaborators_from_file(file)
      
          collaborators_in_file.each do |collaborator|
            params1 = {
              repository: File.basename(file, ".tf"),
              base_url: "/Users/nick.walters/MoJ/github-collaborators",
              login: collaborator.login,
            }
        
            tc = GithubCollaborators::TerraformCollaborator.new(params1)
            the_hash = tc.to_hash
            collabs.push(the_hash)
            # if tc.status == GithubCollaborators::TerraformCollaborator::FAIL
            #   print file
            #   print "\n"
      
            #   print collaborator.login
            #   print "\n"
      
            #   tc.get_issues.each do |issue|
            #     print issue
            #     print "\n"
            #   end
      
            #   print tc.get_review_after_date
            #   print "\n"
            #   print "\n"
            # end
          end
        end
      end
      collabs
    end

    @@test_outside_collaborator_list = []
  end
end