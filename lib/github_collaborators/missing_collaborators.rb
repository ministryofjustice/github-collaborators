class GithubCollaborators
  class MissingCollaborators
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      # Use a hash like this { :login => "name", :repository => "repo_name" }
      "- #{collaborator[:login]} in #{collaborator[:repository]}."
    end

    def singular_message
      "I've found a collaborator who is defined in Terraform but is not attached to a repository. Find out if the Collaborator still requires access"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators who are defined in Terraform but they are not attached to a repository. Find out if these Collaborators still require access"
    end
  end
end
