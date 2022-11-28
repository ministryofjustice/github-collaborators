class GithubCollaborators
  class UnknownCollaborators
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      # Use a hash like this { :login => "name", :repository => "repo_name" }
      "- #{collaborator[:login]} in #{collaborator[:repository]}"
    end

    def singular_message
      "I've found an unknown collaborator who has an invite to a MoJ GitHub repository who is not defined within a Terraform file"
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} unknown collaborators who have an invite to an MoJ GitHub repository who are not defined within a Terraform file"
    end
  end
end
