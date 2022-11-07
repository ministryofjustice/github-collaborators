class GithubCollaborators
  class ExpiresSoon < GithubCollaborators::ExpiresSoonMessage
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      super create_line(collaborator)
    end

    def singular_message
      "I've found a collaborator whose review date will expire shortly"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators whose review date will expire shortly"
    end
  end
end
