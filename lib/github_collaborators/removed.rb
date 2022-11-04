class GithubCollaborators
  class Removed
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      "- #{collaborator["login"]} from #{collaborator["repository"]}."
    end

    def singular_message
      "I've removed an unknown collaborator"
    end

    def multiple_message(users)
      "I've removed #{users} unknown collaborators"
    end
  end
end
