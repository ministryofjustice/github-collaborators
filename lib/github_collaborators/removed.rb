class GithubCollaborators
  class Removed
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      "- #{collaborator.login} from #{collaborator.repository}."
    end

    def singular_message
      "I've removed an unknown collaborator from Github"
    end

    def multiple_message(collaborators)
      "I've removed #{collaborators} unknown collaborators from Github"
    end
  end
end
