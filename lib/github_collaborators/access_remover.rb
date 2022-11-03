class GithubCollaborators
  class AccessRemover
    include Logging
    attr_reader :repository, :github_user
    POST_TO_GH = ENV.fetch("REALLY_POST_TO_GH", 0) == "1"

    def initialize(params)
      logger.debug "initialize"
      @repository = params.fetch(:repository)
      @github_user = params.fetch(:github_user)
    end

    def remove
      logger.debug "remove"
      if POST_TO_GH
        url = "https://api.github.com/repos/ministryofjustice/#{repository}/collaborators/#{github_user}"
        HttpClient.new.delete(url)
        sleep 2
      else
        logger.debug "Remove #{github_user} from #{repository}"
      end
    end
  end
end
