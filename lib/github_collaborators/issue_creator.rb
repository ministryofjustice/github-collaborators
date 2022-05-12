class GithubCollaborators
  class IssueCreator
    attr_reader :owner, :repository, :github_user

    def initialize(params)
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @github_user = params.fetch(:github_user)
    end

    def create
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
      HttpClient.new.post_json(url, issue_hash.to_json)
    end

    def create_review_date
      if get_issues_for_user.empty?
        url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
        HttpClient.new.post_json(url, issue_hash_review_after.to_json)
      end
    end

    # Returns issues for a the user
    def get_issues_for_user
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
        bad_issues.each { |x| remove_issue(x[:number]) }
        issues.delete_if { |x| x[:assignees].length == 0 }

        # Check if there is an issue for that user
        if !issues.nil? && !issues&.empty?
          issues.select { |x| x[:assignee][:login] == github_user }
        else
          []
        end
      end
    end

    # Close issues that have been open longer than 45 days
    def close_expired_issues
      # Fetch all issues for repo
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
      response = HttpClient.new.fetch_json(url).body
      response_json = JSON.parse(response, {symbolize_names: true})
      allowed_days = 45

      if !response_json.nil? && !response_json.empty?
        response_json.each do |json|
          # Check for the issues created by this application
          if ( json[:title].include? "Review after date expiry is upcoming" or json[:title].include? "Please define outside collaborators in code" )
            # Check the issue is open
            if json[:state] == "open"
              # Get issue created date and add 45 day grace period
              created_date = Date.parse(json[:created_at])
              grace_period = created_date + allowed_days
              if grace_period < Date.today
                # Close issue as grace period has expired
                remove_issue(json[:number])
                sleep 5
              end
            end
          end
        end
      end
    end
    
    private

    def remove_issue(issue_id)
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues/#{issue_id}"

      params = {
        state: "closed"
      }

      HttpClient.new.patch_json(url, params.to_json)
    end

    def issue_hash
      {
        title: "Please define outside collaborators in code",
        assignees: [github_user],
        body: <<~EOF
          Hi there
          
          We now have a process to manage github collaborators in code:
          https://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-outside-collaborators
          
          Please follow the procedure described there to grant @#{github_user} access to this repository.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
          
          If the outside collaborator is not needed, close this issue, they have already been removed from this repository.
        EOF
      }
    end

    def issue_hash_review_after
      {
        title: "Review after date expiry is upcoming for user: #{github_user}",
        assignees: [github_user],
        body: <<~EOF
          Hi there
          
          The user @#{github_user} has its access for this repository maintained in code here:
          https://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-outside-collaborators

          The review_after date is due to expire within one month, please update this via a PR if they still require access.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
        EOF
      }
    end
  end
end
