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
      if get_issues_for_user.empty?
        url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
        HttpClient.new.post_json(url, review_date_expires_soon_hash.to_json)
        sleep 2
      end
    end

    # Returns issues for a the user
    def get_issues_for_user
      logger.debug "get_issues_for_user"
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
      # Fetch all issues for repo
      response = HttpClient.new.fetch_json(url).body
      response_json = JSON.parse(response, {symbolize_names: true})

      # Return empty array if no issues
      if response_json.nil? || response_json.empty?
        []
      else
        # Get only issues used by this application
        issues = response_json.select { |x| x[:title].include? "Review after date" }

        # This is a work around for when users unassign themself from the ticket without updating their review_after
        # There is a better way to reassign them but would involve some fairly big code edits, this closes the unassigned ticket and makes a new one
        bad_issues = issues.select { |x| x[:assignees].length == 0 }
        bad_issues.each { |x| GithubCollaborators::IssueClose::remove_issue(repository, x[:number]) }
        issues.delete_if { |x| x[:assignees].length == 0 }

        # Check if there is an issue for that user
        if !issues.nil? && !issues&.empty?
          issues.select { |x| x[:assignee][:login] == github_user }
        else
          []
        end
      end
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
