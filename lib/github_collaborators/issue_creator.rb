class GithubCollaborators
  class IssueCreator
    attr_reader :owner, :repository, :github_user

    def initialize(params)
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @github_user = params.fetch(:github_user)
    end

    def create
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
      HttpClient.new.post_json(url, issue_hash.to_json)
    end

    private

    def issue_hash
      {
        title: "Please define external collaborators in code",
        assignees: [ github_user ],
        body: <<EOF
Hi there

We now have a process to manage github collaborators in code:
https://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-external-collaborators

Please follow the procedure described there to grant @#{github_user} access to this repository.

If you have any questions, please post in #ask-operations-engineering on Slack.
EOF
      }
    end
  end
end
