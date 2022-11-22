class GithubCollaborators
  class FullOrgMemberExpiresSoon
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"

      review_date = collaborator.review_after_date

      if review_date == nil || review_date == ""
        review_date = Date.today
      end

      age = (review_date - Date.today).to_i

      expires_when = if review_date == Date.today
        "today"
      elsif age == 1
        "tomorrow"
      else
        "in #{age} days"
      end

      "- #{collaborator.login} in <#{collaborator.repo_url}|#{collaborator.repository}> see <#{collaborator.href}|terraform file> (#{expires_when})"
    end

    def singular_message
      "I've found a collaborator who is a full Org member whose review date will expire shortly, a pull request has been created to extend the date for this collaborator"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators who are full Org members whose review date will expire shortly, pull requests have been created to extend the date for these collaborators"
    end
  end
end
