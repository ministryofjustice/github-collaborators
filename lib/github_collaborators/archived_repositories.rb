# The GithubCollaborators class namespace
class GithubCollaborators
  # The ArchivedRepositories class
  class ArchivedRepositories
    include Logging

    # Creates a line to be used within a Slack message using app data
    #
    # @param collaborator [Hash{login => String, repository => String}] the collaborator data
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
      "I've found a collaborator who is a full Org member attached to an archived repository. Un-archive the repository and remove this collaborator"
    end

    # Creates the first line to be used within a Slack message when a multiple
    # collaborators are reported by the Slack message
    #
    # @param collaborators [Numeric] the number of collaborators in the message
    # @return [String] the formatted string
    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators who are full Org members attached to archived repositories. Un-archive the repositories and remove these collaborators"
    end
  end
end
