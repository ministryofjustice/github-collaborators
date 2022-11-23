class GithubCollaborators
  describe IssueCreator do
    # TODO: Remove after re-write test
    before { skip }

    let(:params) {
      {
        repository: "somerepo",
        github_user: "somegithubuser"
      }
    }

    subject(:ic) { described_class.new(params) }

    let(:http_client) { double(HttpClient) }

    let(:json) {
      %({"title":"Please define outside collaborators in code","assignees":["somegithubuser"],"body":"Hi there\\n\\nWe now have a process to manage github collaborators in code:\\nhttps://github.com/ministryofjustice/github-collaborators/blob/main/README.md#github-outside-collaborators\\n\\nPlease follow the procedure described there to grant @somegithubuser access to this repository.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nIf the outside collaborator is not needed, close this issue, they have already been removed from this repository.\\n"})
    }

    url = "https://api.github.com/repos/ministryofjustice/somerepo/issues"

    it "calls github api" do
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(url, json)

      ic.create
    end

    it "returns present issues" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{"assignee": { "login": "somegithubuser" }, "title": "Review after date", "assignees": [{"login":"somegithubuser"}]}]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)

      expect(ic.get_issues_for_user).not_to be_empty
    end

    it "returns [] if no issues" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { "[]" }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)

      expect(ic.get_issues_for_user).equal?([])
    end

    it "close issue three" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{ "number": 3, "created_at": "2022-03-12T04:23:22Z", "state": "open", "assignee": { "login": "somegithubuser" }, "title": "Please define outside collaborators in code", "assignees": [{"login":"somegithubuser"}]} ]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)
      allow(ic).to receive(:remove_issue).with(3).and_return("")
      allow_any_instance_of(IssueCreator).to receive_message_chain(:sleep)
      ic.close_expired_issues
    end

    it "close issue not yet" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{ "number": 3, "created_at": "2011-01-01T04:23:22Z", "state": "open", "assignee": { "login": "somegithubuser" }, "title": "Collaborator review date expires soon", "assignees": [{"login":"somegithubuser"}]} ]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)
      stub_date = Date.parse("2011-02-15")
      allow(Date).to receive(:today).and_return(stub_date)
      allow_any_instance_of(IssueCreator).to receive_message_chain(:sleep)
      ic.close_expired_issues
    end

    it "close issue now" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{ "number": 3, "created_at": "2011-01-01T04:23:22Z", "state": "open", "assignee": { "login": "somegithubuser" }, "title": "Collaborator review date expires soon", "assignees": [{"login":"somegithubuser"}]} ]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)
      stub_date = Date.parse("2011-02-16")
      allow(Date).to receive(:today).and_return(stub_date)
      allow(ic).to receive(:remove_issue).with(3).and_return("")
      allow_any_instance_of(IssueCreator).to receive_message_chain(:sleep)
      ic.close_expired_issues
    end
  end
end
