class GithubCollaborators
  class AccessRemover
    include Logging

    def initialize(params)
      logger.debug "initialize"
      @repository = params.fetch(:repository)
      @github_user = params.fetch(:github_user)
    end

    def remove_access
      logger.debug "remove_access"
      if ENV.fetch("REALLY_POST_TO_GH", "0") == "1"
        url = "https://api.github.com/repos/ministryofjustice/#{@repository}/collaborators/#{@github_user}"
        GithubCollaborators::HttpClient.new.delete(url)
        sleep 2
      else
        logger.debug "Didn't remove #{@github_user} from #{@repository}, this is a dry run"
      end
    end
  end
end
