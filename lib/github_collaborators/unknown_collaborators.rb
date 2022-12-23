# The GithubCollaborators class namespace
class GithubCollaborators
  # The UnknownCollaborators class
  class UnknownCollaborators
    include Logging

    # Creates a line to be used within a Slack message using app data
    #
    # @param collaborator [Hash{login => String, repository => String}] the collaborator data needed for the message
    # @return [String] the formatted string
    def create_line(collaborator)
      logger.debug "create_line"
      "- #{collaborator[:login].downcase} in #{collaborator[:repository].downcase}"
    end

    # Creates the first line to be used within a Slack message when a single
    # collaborator is reported by the Slack message
    #
    # @return [String] the formatted string
    def singular_message
      "I've found an unknown collaborator who has an invite to a MoJ GitHub repository who is not defined within a Terraform file"
    end

    # Creates the first line to be used within a Slack message when a multiple
    # collaborators are reported by the Slack message
    #
    # @param collaborators [Numeric] the number of collaborators in the message
    # @return [String] the formatted string
    def multiple_message(collaborators)
      "I've found #{collaborators} unknown collaborators who have an invite to an MoJ GitHub repository who are not defined within a Terraform file"
    end
  end
end
