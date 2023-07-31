# The GithubCollaborators class namespace
class GithubCollaborators
  # The UndeliveredNotifyEmail class
  class UndeliveredNotifyEmail
    include Logging

    # Creates a line to be used within a Slack message using app data
    #
    # @param collaborator [GithubCollaborators::Collaborator] a collaborator object
    # @return [String] the formatted string
    def create_line(collaborator)
      logger.debug "create_line"
      "- #{collaborator.login.downcase} in <#{collaborator.repo_url.downcase}|#{collaborator.repository.downcase}> see <#{collaborator.href}|terraform file>"
    end

    # Creates the first line to be used within a Slack message when a single
    # collaborator is reported by the Slack message
    #
    # @return [String] the formatted string
    def singular_message
      "Notify failed to email a collaborator whose review date expires next week, see if the collaborator still require access"
    end

    # Creates the first line to be used within a Slack message when a multiple
    # collaborators are reported by the Slack message
    #
    # @param collaborators [Numeric] the number of collaborators in the message
    # @return [String] the formatted string
    def multiple_message(collaborators)
      "Notify failed to email #{collaborators} collaborator whose review date expire next week, see if these collaborator still require access"
    end
  end
end
