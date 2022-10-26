class GithubCollaborators
  class AccessRemover
    attr_reader :owner, :repository, :github_user

    def initialize(params)
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @github_user = params.fetch(:github_user)
    end

    def remove
      url = "https://api.github.com/repos/#{owner}/#{repository}/collaborators/#{github_user}"
      HttpClient.new.delete(url)
      sleep 1
    end
  end
end
