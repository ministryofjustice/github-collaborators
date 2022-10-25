class GithubCollaborators
  class PullRequestCreator
    attr_reader :owner, :repository, :hash_body

    def initialize(params)
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @hash_body = params.fetch(:hash_body)
    end

    # Create pull request
    def create
      url = "https://api.github.com/repos/#{@owner}/#{@repository}/pulls"
      HttpClient.new.post_json(url, @hash_body.to_json)
    end
  end
end
