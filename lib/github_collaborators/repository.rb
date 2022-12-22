# The GithubCollaborators class namespace
class GithubCollaborators
  # The Repository class
  class Repository
    include Logging
    attr_reader :name, :outside_collaborators_names, :outside_collaborators_count, :issues

    def initialize(repository_name, outside_collaborators_count)
      logger.debug "initialize"
      @name = repository_name.downcase
      @outside_collaborators_count = outside_collaborators_count
      @outside_collaborators_names = []
      @issues = []
    end

    # Add new issues to the issue list
    #
    # @param issues [Array< Hash{title => String, state => String>, created_at => Date, number => Numeric} >] the issues
    def add_issues(issues)
      logger.debug "add_issues"
      @issues = issues
    end

    # Add collaborators login names to outside_collaborators_names list
    #
    # @param login_names [String] the collaborator login name
    def store_collaborators_names(login_names)
      logger.debug "store_collaborators_names"
      @outside_collaborators_names = login_names
    end
  end
end
