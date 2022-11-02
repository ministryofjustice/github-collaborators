class GithubCollaborators
  class PullRequestCreator
    include Logging
    attr_reader :owner, :repository, :hash_body

    def initialize(params)
      logger.debug "initialize"
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @hash_body = params.fetch(:hash_body)
    end

    # Create pull request
    def create
      logger.debug "create"
      url = "https://api.github.com/repos/#{@owner}/#{@repository}/pulls"
      HttpClient.new.post_json(url, @hash_body.to_json)
      sleep 1
    end
  end
end
