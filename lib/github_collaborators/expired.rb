class GithubCollaborators
  class Expired
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      review_date = collaborator.review_after_date

      if review_date.nil? || review_date == ""
        review_date = Date.today
      end

      age = (Date.today - review_date).to_i

      expired_when = if review_date == Date.today
        "today"
      elsif age == 1
        "yesterday"
      else
        "#{age} days ago"
      end
      "- #{collaborator.login.downcase} in <#{collaborator.repo_url.downcase}|#{collaborator.repository.downcase}> see <#{collaborator.href}|terraform file> (#{expired_when})"
    end

    def singular_message
      "I've found a collaborator whose review date has expired, a pull request has been created to remove the collaborator"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators whose review dates have expired, pull requests have been created to remove these collaborators"
    end
  end
end
