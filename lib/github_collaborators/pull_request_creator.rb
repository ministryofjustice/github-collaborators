# Please note that this class was written to work with a particular solution and may have weird behaviours if used for other uses
# An example of this that the pull request content requires a file name
# There is no current need for large more expansive PullRequest functionality
# Please contact Operations Engineering if you wish to consume this code in an more extensive fashion

class GithubCollaborators
  class PullRequestCreator
    attr_reader :owner, :repository, :pull_file, :branch

    def initialize(params)
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @pull_file = params.fetch(:pull_file)
      @branch = params.fetch(:branch)
    end

    # Create pull request
    def create(pull_hash = self.pull_hash)
      url = "https://api.github.com/repos/#{owner}/#{repository}/pulls"
      HttpClient.new.post_json(url, pull_hash.to_json)
    end

    # Body of the PR
    def pull_hash
      {
        title: "Remove #{pull_file} as repository being deleted ",
        head: branch,
        base: "main",
        body: <<~EOF
          Hi there
          
          The repository that is maintained by the file #{pull_file} has been deleted/archived
          
          Please merge this pull request to delete the file.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
        EOF
      }
    end
  end
end
