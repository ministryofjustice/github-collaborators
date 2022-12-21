# The GithubCollaborators class namespace
class GithubCollaborators
  # The OddFullOrgMembers class
  class OddFullOrgMembers
    include Logging

    # Creates a line to be used within a Slack message using app data
    #
    # @param collaborator [String] the collaborator login name
    # @return [String] the formatted string
    def create_line(collaborator)
      logger.debug "create_line"
      "- #{collaborator.downcase}"
    end

    # Creates the first line to be used within a Slack message when a single
    # collaborator is reported by the Slack message
    #
    # @return [String] the formatted string
    def singular_message
      "I've found a collaborator who is a full Org member but isn't attached to any GitHub repositories except the all-org-members team respositories. Consider removing this collaborator"
    end

    # Creates the first line to be used within a Slack message when a multiple
    # collaborators are reported by the Slack message
    #
    # @param collaborators [Numeric] the number of collaborators in the message
    # @return [String] the formatted string
    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators who are full Org members but are not attached to any GitHub repositories except the all-org-members team respositories. Consider removing these collaborators"
    end
  end
end
