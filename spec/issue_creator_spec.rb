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

    it "returns present issues" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/issues"
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{"assignee": { "login": "somegithubuser" }, "title": "Review after date", "assignees": [{"login":"somegithubuser"}]}]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)

      expect(ic.get_issues_for_user).not_to be_empty
    end

    it "returns [] if no issues" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/issues"
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { "[]" }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)

      expect(ic.get_issues_for_user).equal?([])
    end
  end
end
