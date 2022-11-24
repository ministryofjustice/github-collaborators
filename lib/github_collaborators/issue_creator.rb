class GithubCollaborators
  class IssueCreator
    include Logging

    def initialize(params)
      logger.debug "initialize"
      @repository = params.fetch(:repository).downcase
      @github_user = params.fetch(:github_user).downcase
    end

    def create_unknown_collaborator_issue
      logger.debug "create_unknown_collaborator_issue"
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        url = "https://api.github.com/repos/ministryofjustice/#{@repository}/issues"
        GithubCollaborators::HttpClient.new.post_json(url, unknown_collaborator_hash.to_json)
        sleep 2
      else
        logger.debug "Didn't create unknown collaborator issue for #{@github_user} on #{@repository}, this is a dry run"
      end
    end

    def create_review_date_expires_soon_issue
      logger.debug "create_review_date_expires_soon_issue"
      if !does_issue_already_exists?
        if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
          url = "https://api.github.com/repos/ministryofjustice/#{@repository}/issues"
          GithubCollaborators::HttpClient.new.post_json(url, review_date_expires_soon_hash.to_json)
          sleep 2
        else
          logger.debug "Didn't create review date expires soon issue for #{@github_user} on #{@repository}, this is a dry run"
        end
      end
    end

    def get_issues(repository)
      logger.debug "get_issues"
      url = "https://api.github.com/repos/ministryofjustice/#{repository.downcase}/issues"
      response = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(response, {symbolize_names: true})
    end

    private

    # Checks if issue already open for a collaborator
    def does_issue_already_exists?
      logger.debug "does_issue_already_exists"
      found_issues = false
      repository_issues = get_issues(@repository)

      # Get the issues created previously by this application
      issues = []
      repository_issues.each do |issue|
        if issue[:title].include?(COLLABORATOR_EXPIRES_SOON) ||
            issue[:title].include?(COLLABORATOR_EXPIRY_UPCOMING)
          issues.push(issue)
        end
      end

      # This is a work around for when collaborators unassign themself from the ticket without updating their review_after
      # There is a better way to reassign them but would involve some fairly big code edits, this closes the unassigned ticket and makes a new one
      bad_issues = issues.select { |issue| issue[:assignees].length == 0 }
      bad_issues.each { |issue| GithubCollaborators::IssueClose.new.remove_issue(@repository, issue[:number]) }
      issues.delete_if { |issue| issue[:assignees].length == 0 }

      # Check which issues are assigned to the collaborator
      issues.select { |issue| issue[:assignee][:login].downcase == @github_user }
      if issues.length > 0
        # Found matching issue
        found_issues = true
      end
      found_issues  
    end

    def unknown_collaborator_hash
      logger.debug "unknown_collaborator_hash"
      {
        title: DEFINE_COLLABORATOR_IN_CODE,
        assignees: [@github_user],
        body: <<~EOF
          Hi there
          
          We have a process to manage github collaborators in code: https://github.com/ministryofjustice/github-collaborators
          
          Please follow the procedure described there to grant @#{@github_user} access to this repository.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
          
          If the outside collaborator is not needed, close this issue, they have already been removed from this repository.
        EOF
      }
    end

    def review_date_expires_soon_hash
      logger.debug "review_date_expires_soon_hash"
      {
        title: COLLABORATOR_EXPIRES_SOON + " " + @github_user,
        assignees: [@github_user],
        body: <<~EOF
          Hi there
          
          The user @#{@github_user} has its access for this repository maintained in code here: https://github.com/ministryofjustice/github-collaborators

          The review_after date is due to expire within one month, please update this via a PR if they still require access.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.

          Failure to update the review_date will result in the collaborator being removed from the repository via our automation.
        EOF
      }
    end
  end
end
