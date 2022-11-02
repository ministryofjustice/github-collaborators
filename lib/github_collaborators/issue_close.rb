class GithubCollaborators
  class IssueClose
    include Logging

    # Close issues that have been open longer than 45 days
    def close_expired_issues(repository)
      logger.debug "close_expired_issues"

      url = "https://api.github.com/repos/ministryofjustice/#{repository}/issues"
      got_data = false
      response = nil
      
      # Fetch all issues for a repository
      until got_data
        response = HttpClient.new.fetch_json(url).body
        if response.include?("errors")
          if response.include?("RATE_LIMITED")
            sleep(300)
          else
            logger.fatal "GH GraphQL query contains errors"
            abort(response)
          end
        else
          got_data = true
        end
      end

      issues = JSON.parse(response, {symbolize_names: true})
      allowed_days = 45

      if !issues.nil? && !issues.empty?
        issues.each do |issue|
          # Check for the issues created by this application and that the issue is open
          if (
            issue[:title].include?("Review after date expiry is upcoming") || 
            issue[:title].include?("Please define outside collaborators in code")
          ) && issue[:state] == "open"
            # Get issue created date and add 45 day grace period
            created_date = Date.parse(issue[:created_at])
            grace_period = created_date + allowed_days
            if grace_period < Date.today
              # Close issue as grace period has expired
              remove_issue(repository, issue[:number])
              sleep 3
            end
          end
        end
      end
    end

    private

    def remove_issue(repository, issue_id)
      logger.debug "remove_issue"

      url = "https://api.github.com/repos/ministryofjustice/#{repository}/issues/#{issue_id}"

      params = {
        state: "closed"
      }

      HttpClient.new.patch_json(url, params.to_json)

      logger.info "Closed issue #{issue_id} on repository #{repository}."
    end
  end
end
