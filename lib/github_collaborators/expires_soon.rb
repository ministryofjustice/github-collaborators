# The GithubCollaborators class namespace
class GithubCollaborators
  # The ExpiresSoon class
  class ExpiresSoon
    include Logging

    # Creates a line to be used within a Slack message using app data
    #
    # @param collaborator [GithubCollaborators::Collaborator] a collaborator object
    # @return [String] the formatted string
    def create_line(collaborator)
      logger.debug "create_line"

      review_date = collaborator.review_after_date
      if review_date.nil? || review_date == ""
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
      "- #{collaborator.login.downcase} in <#{collaborator.repo_url.downcase}|#{collaborator.repository.downcase}> see <#{collaborator.href}|terraform file> (#{expires_when})"
    end

    # Creates the first line to be used within a Slack message when a single
    # collaborator is reported by the Slack message
    #
    # @return [String] the formatted string
    def singular_message
      "I've found a collaborator whose review date will expire shortly, a pull request has been created to extend the date for this collaborator. Notify has emailed the user"
    end

    # Creates the first line to be used within a Slack message when a multiple
    # collaborators are reported by the Slack message
    #
    # @param collaborators [Numeric] the number of collaborators in the message
    # @return [String] the formatted string
    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators whose review date will expire shortly, pull requests have been created to extend the date for these collaborators. Notify has emailed these users"
    end
  end
end
