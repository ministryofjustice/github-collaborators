class GithubCollaborators
  describe IssueClose do
    let(:http_client) { double(HttpClient) }

    subject(:ic) { described_class.new }

    it "close issue three" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{ "number": 3, "created_at": "2022-03-12T04:23:22Z", "state": "open", "assignee": { "login": "somegithubuser" }, "title": "Please define outside collaborators in code", "assignees": [{"login":"somegithubuser"}]} ]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)
      allow(ic).to receive(:remove_issue).with("somerepo", 3).and_return("")
      allow_any_instance_of(IssueClose).to receive_message_chain(:sleep)
      ic.close_expired_issues("somerepo")
    end

    it "close issue not yet" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{ "number": 3, "created_at": "2011-01-01T04:23:22Z", "state": "open", "assignee": { "login": "somegithubuser" }, "title": "Review after date expiry is upcoming", "assignees": [{"login":"somegithubuser"}]} ]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)
      stub_date = Date.parse("2011-02-15")
      allow(Date).to receive(:today).and_return(stub_date)
      allow_any_instance_of(IssueClose).to receive_message_chain(:sleep)
      ic.close_expired_issues("somerepo")
    end

    it "close issue now" do
      response = Net::HTTPSuccess.new(1.0, "200", "OK")
      expect(response).to receive(:body) { '[{ "number": 3, "created_at": "2011-01-01T04:23:22Z", "state": "open", "assignee": { "login": "somegithubuser" }, "title": "Review after date expiry is upcoming", "assignees": [{"login":"somegithubuser"}]} ]' }
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).and_return(response)
      stub_date = Date.parse("2011-02-16")
      allow(Date).to receive(:today).and_return(stub_date)
      allow(ic).to receive(:remove_issue).with("somerepo", 3).and_return("")
      allow_any_instance_of(IssueClose).to receive_message_chain(:sleep)
      ic.close_expired_issues("somerepo")
    end
  end
end
