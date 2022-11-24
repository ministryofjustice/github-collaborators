class GithubCollaborators
  class IssueClose
    include Logging
    
    # Close issues that have been open longer than 45 days
    def close_expired_issues(repository)
      logger.debug "close_expired_issues"
      allowed_days = 45

      params = {
        repository: nil,
        github_user: nil
      }

      issues = GithubCollaborators::IssueCreator.new(params).get_issues(repository)

      issues.each do |issue|
        # Check for the issues created by this application and that the issue is open
        if (
          issue[:title].include?(COLLABORATOR_EXPIRES_SOON) ||
          issue[:title].include?(COLLABORATOR_EXPIRY_UPCOMING) ||
          issue[:title].include?(DEFINE_COLLABORATOR_IN_CODE) ||
          issue[:title].include?(USE_TEAM_ACCESS)
        ) && issue[:state] == "open"
          # Get issue created date and add 45 day grace period
          created_date = Date.parse(issue[:created_at])
          grace_period = created_date + allowed_days
          if grace_period < Date.today
            # Close issue as grace period has expired
            remove_issue(repository, issue[:number])
          end
        end
      end
    end

    def remove_issue(repository, issue_id)
      logger.debug "remove_issue"

      url = "https://api.github.com/repos/ministryofjustice/#{repository}/issues/#{issue_id}"

      params = {
        state: "closed"
      }

      GithubCollaborators::HttpClient.new.patch_json(url, params.to_json)

      logger.info "Closed issue #{issue_id} on repository #{repository}."

      sleep 2
    end
  end
end
