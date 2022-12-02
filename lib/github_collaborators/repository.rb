class GithubCollaborators
  class Repository
    include Logging
    attr_reader :name, :outside_collaborators, :outside_collaborators_count, :issues

    def initialize(data)
      logger.debug "initialize"
      @name = data.fetch("name").downcase
      @outside_collaborators_count = data.dig("collaborators", "totalCount")
      @outside_collaborators = []
      @issues = []
    end

    def add_issues(issues)
      logger.debug "add_issues"
      @issues = issues
    end

    # Add collaborator based on login name
    def add_outside_collaborator(collaborator)
      logger.debug "add_outside_collaborator"
      @outside_collaborators.push(collaborator.login.downcase)
    end

    # Add collaborators based on login name
    def add_outside_collaborators(collaborators)
      logger.debug "add_outside_collaborators"
      collaborators.each { |collaborator| @outside_collaborators.push(collaborator.login.downcase) }
    end
  end
end
