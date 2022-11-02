class GithubCollaborators
  class IssueCreator
    include Logging
    attr_reader :owner, :repository, :github_user

    def initialize(params)
      logger.debug "initialize"
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @github_user = params.fetch(:github_user)
    end

    def create_unknown_user_issue
      logger.debug "create_unknown_user_issue"
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
      HttpClient.new.post_json(url, unknown_user_hash.to_json)
      sleep 2
    end

    def create_review_date_expires_soon_issue
      logger.debug "create_review_date_expires_soon_issue"
      if !does_issue_already_exists?
        url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
        HttpClient.new.post_json(url, review_date_expires_soon_hash.to_json)
        sleep 2
      end
    end

    # Checks if issue already open for a user
    def does_issue_already_exists?
      logger.debug "does_issue_already_exists"
      found_issues = false
      data = get_issues(repository)
      if data.nil?
        logger.error "Issues are missing"
      else
        # Get only issues used by this application
        issues = data.select { |issue| issue[:title].include? "Review after date" }

        # This is a work around for when users unassign themself from the ticket without updating their review_after
        # There is a better way to reassign them but would involve some fairly big code edits, this closes the unassigned ticket and makes a new one
        bad_issues = issues.select { |issue| issue[:assignees].length == 0 }
        bad_issues.each { |issue| GithubCollaborators::IssueClose::remove_issue(repository, issue[:number]) }
        issues.delete_if { |issue| issue[:assignees].length == 0 }

        # Check which issues are assigned to the user
        issues.select { |issue| issue[:assignee][:login] == github_user }
        if issues.length > 0
          # Found matching issue
          found_issues = true
        end
      end
      found_issues
    end

    def get_issues(repository)
      logger.debug "get_issues"
      url = "https://api.github.com/repos/ministryofjustice/#{repository}/issues"
      got_data = false
      response = nil
      
      # Fetch all issues for repo
      until got_data
        response = HttpClient.new.fetch_json(url).body
        if response.include?("errors")
          if response.include?("RATE_LIMITED")
            sleep 300
          else
            logger.fatal "GH GraphQL query contains errors"
            abort(response)
          end
        else
          got_data = true
        end
      end
      response.nil? ? nil : JSON.parse(response, {symbolize_names: true})
    end

    private

    def unknown_user_hash
      logger.debug "unknown_user_hash"
      {
        title: "Please define outside collaborators in code",
        assignees: [github_user],
        body: <<~EOF
          Hi there
          
          We have a process to manage github collaborators in code: https://github.com/ministryofjustice/github-collaborators
          
          Please follow the procedure described there to grant @#{github_user} access to this repository.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
          
          If the outside collaborator is not needed, close this issue, they have already been removed from this repository.
        EOF
      }
    end

    def review_date_expires_soon_hash
      logger.debug "review_date_expires_soon_hash"
      {
        title: "Collaborator review date expires soon for user: #{github_user}",
        assignees: [github_user],
        body: <<~EOF
          Hi there
          
          The user @#{github_user} has its access for this repository maintained in code here: https://github.com/ministryofjustice/github-collaborators

          The review_after date is due to expire within one month, please update this via a PR if they still require access.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.

          Failure to update the review_date will result in the user being removed from the repository via our automation.
        EOF
      }
    end
  end
end
