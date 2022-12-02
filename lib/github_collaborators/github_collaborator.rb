class GithubCollaborators
  class GitHubCollaborator
    include Logging
    attr_reader :login

    def initialize(data)
      logger.debug "initialize"
      @login = data.dig("node", "login").downcase
    end
  end
end
