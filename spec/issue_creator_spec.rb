class GithubCollaborators
  describe IssueCreator do
    let(:params) {
      {
        owner: "ministryofjustice",
        repository: "somerepo",
        github_user: "somegithubuser"
      }
    }

    subject(:ic) { described_class.new(params) }

    let(:http_client) { double(HttpClient) }

    let(:json) {
      %({"title":"Please define external collaborators in code","assignees":["somegithubuser"],"body":"Hi there\\n\\nWe now have a process to manage github collaborators in code:\\nhttps://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-external-collaborators\\n\\nPlease follow the procedure described there to grant @somegithubuser access to this repository.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n"})
    }

    it "calls github api" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/issues"
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(url, json)

      ic.create
    end
  end
end
