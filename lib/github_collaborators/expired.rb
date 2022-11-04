class GithubCollaborators
  class Expired
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      review_date = collaborator["review_date"]
      age = (Date.today - review_date).to_i
      expired_when = if review_date == Date.today
        "today"
      elsif age == 1
        "yesterday"
      else
        "#{age} days ago"
      end
      "- #{collaborator["login"]} in <#{collaborator[:repo_url]}|#{collaborator["repository"]}> see <#{collaborator["href"]}|terraform file> (#{expired_when})."
    end

    def singular_message
      "I've found a collaborator whose review date has expired"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators whose review dates have expired"
    end
  end
end
