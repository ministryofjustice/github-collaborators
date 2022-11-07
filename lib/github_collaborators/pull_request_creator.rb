class GithubCollaborators
  class PullRequestCreator
    include Logging
    attr_reader :repository, :hash_body
    POST_TO_GH = ENV.fetch("REALLY_POST_TO_GH", 0) == "1"

    def initialize(params)
      logger.debug "initialize"
      @repository = params.fetch(:repository)
      @hash_body = params.fetch(:hash_body)
    end

    # Create pull request
    def create_pull_request
      logger.debug "create_pull_request"
      if POST_TO_GH
        url = "https://api.github.com/repos/ministryofjustice/#{@repository}/pulls"
        HttpClient.new.post_json(url, @hash_body.to_json)
        sleep 1
      else
        logger.debug "Didn't create pull request on #{repository}, this is a dry run"
      end
    end
  end
end
