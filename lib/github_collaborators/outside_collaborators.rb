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
        @outside_collaborators = @@test_outside_collaborator_list
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

    def is_review_date_within_a_week
      logger.debug "is_review_date_within_a_week"
      users_who_expire_soon = find_users_who_expire_soon
      
      # Raise Slack message
      GithubCollaborators::SlackNotifier.new(WillExpireBy.new, POST_TO_SLACK, users_who_expire_soon).run

      # Raise PRs
      create_extend_date_pull_requests(users_who_expire_soon)
    end

    private
    
    # Get list of users whose review date have one week remaining
    def find_users_who_expire_soon
      logger.debug "find_users_who_expire_soon"
      users_who_expire_soon = []
      @outside_collaborators.each do |x|
        x["issues"].each do |issue|
          if issue == "Review after date is within a week"
            users_who_expire_soon.push(x)
          end
        end
      end

      if users_who_expire_soon.length > 0
        # Sort list based on username
        users_who_expire_soon.sort_by! { |x| x["login"] }
      end

      users_who_expire_soon
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

    def user_in_data(file_data, user_name)
      logger.debug "user_in_data"
      data = file_data.split("\n")
      search_pattern = "github_user=\"#{user_name}\""
      line_number = 0
      data.each do |line|
        line = line.delete(' ')
        if line == search_pattern
          return line_number
        end
        line_number += 1
      end
      line_number
    end

    def extend_date(date_line_number, file_data)
      logger.debug "extend_date"
      begin
        date_line = file_data.split("\n").at(date_line_number)
        date = Date.parse date_line[22...32]
      rescue
        logger.error "Error parsing the date from file. Date characters are not in the expected alignment."
        return nil
      else
        return (date + 180).strftime("%Y-%m-%d")
      end
    end

    def write_new_date_to_file(date_line_number, file_data, new_date, file_name)
      logger.debug "write_new_date_to_file"
      the_data = file_data.split("\n")
      date_line = the_data.at(date_line_number)
      date_line[22...32] = new_date
      the_data[date_line_number] = date_line
      new_data = the_data.join("\n")

      File.open(file_name, "w") { |f|
        f.puts(new_data)
      }
    end

    def extend_date_in_file(file_name, user_name)
      logger.debug "extend_date_in_file"

      if File.exist?(file_name)
        file_data = File.read(file_name)
        line_number = user_in_data(file_data, user_name)
        if line_number > 0
          date_line_number = line_number + 7
          new_date = extend_date(date_line_number, file_data)
          if new_date != nil
            write_new_date_to_file(date_line_number, file_data, new_date, file_name)
            true
          end
        end
      end
      false
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
          
          if !does_pr_already_exist(terraform_file_name, user_name)
            # No pull request exists, modify the file
            file_name = "terraform/#{terraform_file_name}"
            branch_name = "update-review-date-#{user_name}"
            if extend_date_in_file(file_name, user_name)
              edited_files.push(file_name)
            end
            # TODO: Got to here, can create a file.
          end
        end

        # if edited_files.length > 0
        #   # At end of each user group commit modified file/s 
        #   bc.create_branch(branch_name)
        #   edited_files.each { |file_name| bc.add(file_name) }
        #   bc.commit_and_push("Update review date for #{user_name}")

        #   sleep 5

        #   # Create a pull request
        #   params = {
        #     owner: OWNER,
        #     repository: "github-collaborators",
        #     hash_body: extend_date_hash(user_name, branch_name)
        #   }
        
        #   GithubCollaborators::PullRequestCreator.new(params).create
        # end
      end
    end

    def does_pr_already_exist(terraform_file_name, user_name)
      logger.debug "does_pr_already_exist"
      @repo_pull_requests.each do |pull_request|
        if (pull_request.title.include? "#{user_name}") && (pull_request.files.include? "terraform/#{terraform_file_name}")
          logger.debug "For #{user_name} PR already open for #{terraform_file_name} file"
          return true
        end
      end
      false
    end

    @@test_outside_collaborator_list = []
  end
end