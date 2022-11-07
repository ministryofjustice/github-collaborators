class GithubCollaborators
  class ExpiresSoonMessage
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      review_date = collaborator["review_date"]
      age = (review_date - Date.today).to_i
      expires_when = if review_date == Date.today
        "today"
      elsif age == 1
        "tomorrow"
      else
        "in #{age} days"
      end
      "- #{collaborator["login"]} in <#{collaborator[:repo_url]}|#{collaborator["repository"]}> see <#{collaborator["href"]}|terraform file> (#{expires_when})."
    end
  end
end
