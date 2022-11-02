class GithubCollaborators
  class IssueClose
    include Logging

    # Close issues that have been open longer than 45 days
    def close_expired_issues(repository)
      logger.debug "close_expired_issues"

      # Fetch all issues for repo
      url = "https://api.github.com/repos/ministryofjustice/#{repository}/issues"
      response = HttpClient.new.fetch_json(url).body
      response_json = JSON.parse(response, {symbolize_names: true})
      allowed_days = 45

      if !response_json.nil? && !response_json.empty?
        response_json.each do |json|
          # Check for the issues created by this application and that the issue is open
          if (
            json[:title].include?("Review after date expiry is upcoming") || 
            json[:title].include?("Please define outside collaborators in code")
          ) && json[:state] == "open"
            # Get issue created date and add 45 day grace period
            created_date = Date.parse(json[:created_at])
            grace_period = created_date + allowed_days
            if grace_period < Date.today
              # Close issue as grace period has expired
              remove_issue(repository, json[:number])
              sleep 5
            end
          end
        end
      end
    end

    private

    def remove_issue(repository, issue_id)
      logger.debug("remove_issue")

      url = "https://api.github.com/repos/ministryofjustice/#{repository}/issues/#{issue_id}"

      params = {
        state: "closed"
      }

      HttpClient.new.patch_json(url, params.to_json)

      logger.info "Closed issue #{issue_id} on repository #{repository}."
    end
  end
end
