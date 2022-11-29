class GithubCollaborators
  class ArchivedRepositories
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      # Use a hash like this { :login => "name", :repository => "repo_name" }
      "- #{collaborator[:login].downcase} in #{collaborator[:repository].downcase}"
    end

    def singular_message
      "I've found a collaborator who is a full Org member attached to an archived repository. Un-archive the repository and remove this collaborator"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators who are full Org members attached to archived repositories. Un-archive the repositories and remove these collaborators"
    end
  end
end
