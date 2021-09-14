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

    def create_review_date
      if get_issues_for_user.empty?
        url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
        HttpClient.new.post_json(url, issue_hash_review_after.to_json)
      end
    end

    def get_issues_for_user
      url = "https://api.github.com/repos/#{owner}/#{repository}/issues"
      response = HttpClient.new.fetch_json(url).body
      JSON.parse(response).select { |x| x["assignee"]["login"] == github_user }
    end

    private

    def issue_hash
      {
        title: "Please define external collaborators in code",
        assignees: [github_user],
        body: <<~EOF
          Hi there
          
          We now have a process to manage github collaborators in code:
          https://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-external-collaborators
          
          Please follow the procedure described there to grant @#{github_user} access to this repository.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
        EOF
      }
    end

    def issue_hash_review_after
      {
        title: "Review after date expiry is upcoming for user: #{github_user}",
        assignees: [github_user],
        body: <<~EOF
          Hi there
          
          The user @#{github_user} has its access for this repository maintained in code here:
          https://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-external-collaborators

          The review_after date is due to expire within one month, please update this via a PR if they still require access.
          
          If you have any questions, please post in #ask-operations-engineering on Slack.
        EOF
      }
    end
  end
end
