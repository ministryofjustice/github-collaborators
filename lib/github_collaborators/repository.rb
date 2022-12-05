class GithubCollaborators
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

    def add_issues(issues)
      logger.debug "add_issues"
      @issues = issues
    end

    # Add collaborators login names
    def store_collaborators_names(names)
      logger.debug "store_collaborators_names"
      @outside_collaborators_names = names
    end
  end
end
