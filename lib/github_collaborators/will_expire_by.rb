class WillExpireBy
  def create_line(collaborator)
    review_date = DateTime.strptime(collaborator["review_date"], "%Y-%m-%d")
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

  def singular_message
    "I've found a collaborator whose review date will expire shortly"
  end

  def multiple_message(users)
    "I've found #{users} collaborators whose review date will expire shortly"
  end
end
