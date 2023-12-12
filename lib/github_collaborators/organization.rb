# The GithubCollaborators class namespace
class GithubCollaborators
  # The Organization class
  class Organization
    include Logging
    include HelperModule
    attr_reader :repositories, :archived_repositories

    def initialize
      logger.debug "initialize"

      # This is a list of collaborator login names
      # Array<String>
      @outside_collaborators = get_org_outside_collaborators

      # This is a list of Organization archived repository names
      # Array<String>
      @archived_repositories = get_archived_repositories

      # This is a list of Organization repository objects (that are not disabled or archived)
      # Array<GithubCollaborators::Repository>
      @repositories = get_active_repositories

      # This is the number of Organization outside collaborators
      @github_collaborators = @outside_collaborators.length
    end

    # Get the Organization archived repository name
    #
    # @return [Array<String>] true if no issue were found in the reply
    def get_org_archived_repositories
      logger.debug "get_org_archived_repositories"
      @archived_repositories
    end

    # Call the function to get the issues for a repository from
    # GitHub and add them to the repository object
    # @param repositories [Array<String>] the repository names
    def get_repository_issues_from_github(repositories)
      logger.debug "get_repository_issues_from_github"
      repositories.each do |repository_name|
        @repositories.each do |org_repository|
          if org_repository.name == repository_name
            issues = get_issues_from_github(repository_name)
            org_repository.add_issues(issues)
          end
        end
      end
    end

    # Returns the issues from a specific repository object
    # @param repository_name [String] the repository name
    # @return [Array< Hash{title => String, state => String>, created_at => Date, number => Numeric} >] the issues
    def read_repository_issues(repository_name)
      logger.debug "read_repository_issues"
      @repositories.each do |repository|
        if repository.name == repository_name
          return repository.issues
        end
      end
      []
    end
  end
end
