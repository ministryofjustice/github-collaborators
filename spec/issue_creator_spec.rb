class GithubCollaborators
  URL = "https://api.github.com/repos/ministryofjustice/somerepo/issues"

  describe IssueCreator do
    context "when env var enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "1"
      end

      let(:params) {
        {
          repository: "somerepo",
          github_user: "somegithubuser"
        }
      }

      subject(:issue_creator) { described_class.new(params) }

      let(:http_client) { double(HttpClient) }

      # Stub sleep
      before { allow_any_instance_of(IssueCreator).to receive(:sleep) }

      let(:json1) {
        %({"title":"Please define outside collaborators in code","assignees":["somegithubuser"],"body":"Hi there\\n\\nWe have a process to manage github collaborators in code: https://github.com/ministryofjustice/github-collaborators\\n\\nPlease follow the procedure described there to grant @somegithubuser access to this repository.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nIf the outside collaborator is not needed, close this issue, they have already been removed from this repository.\\n"})
      }

      it "call github api in create unknown collaborator issue" do
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:post_json).with(URL, json1)
        issue_creator.create_unknown_collaborator_issue
      end

      it "do not call github api in create review date expires soon issue type one when issue already exists" do
        response = [{assignee: {login: "somegithubuser"}, title: "Collaborator review date expires soon for user somegithubuser", assignees: [{login: "somegithubuser"}]}]
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
        expect(http_client).not_to receive(:post_json)
        issue_creator.create_review_date_expires_soon_issue
      end

      it "do not call github api in create review date expires soon issue type two when issue already exists" do
        response = [{assignee: {login: "somegithubuser"}, title: "Review after date expiry is upcoming for user somegithubuser", assignees: [{login: "somegithubuser"}]}]
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
        expect(http_client).not_to receive(:post_json)
        issue_creator.create_review_date_expires_soon_issue
      end

      let(:json2) {
        %({"title":"Collaborator review date expires soon for user somegithubuser","assignees":["somegithubuser"],"body":"Hi there\\n\\nThe user @somegithubuser has its access for this repository maintained in code here: https://github.com/ministryofjustice/github-collaborators\\n\\nThe review_after date is due to expire within one month, please update this via a PR if they still require access.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nFailure to update the review_date will result in the collaborator being removed from the repository via our automation.\\n"})
      }

      it "delete an issue when issue missing an assignee then create an issue" do
        response = [{number: 3, assignee: {login: "somegithubuser"}, title: "Collaborator review date expires soon for user somegithubuser", assignees: []}]
        expect(HttpClient).to receive(:new).and_return(http_client).at_least(3).times

        close_issue_url = URL + "/3"
        state = {state: "closed"}
        expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
        expect(http_client).to receive(:patch_json).with(close_issue_url, state.to_json)
        expect(http_client).to receive(:post_json).with(URL, json2)
        issue_creator.create_review_date_expires_soon_issue
      end

      after do
        ENV["REALLY_POST_TO_GH"] = "0"
      end
    end

    context "when env var not enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "0"
      end

      let(:params) {
        {
          repository: "somerepo",
          github_user: "somegithubuser"
        }
      }

      subject(:issue_creator) { described_class.new(params) }

      let(:http_client) { double(HttpClient) }

      it "dont call github api in create unknown collaborator issue" do
        expect(HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
        issue_creator.create_unknown_collaborator_issue
      end

      it "dont call github api in create review date expires soon issue" do
        expect(HttpClient).to receive(:new).and_return(http_client)
        response = []
        expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
        expect(http_client).not_to receive(:delete)
        issue_creator.create_review_date_expires_soon_issue
      end
    end

    context "call get issues" do
      let(:params) {
        {
          repository: "somerepo",
          github_user: "somegithubuser"
        }
      }

      subject(:issue_creator) { described_class.new(params) }

      let(:http_client) { double(HttpClient) }

      it "returns an issue" do
        response = '[{"assignee": { "login": "somegithubuser" }, "title": "Collaborator review date expires soon for user", "assignees": [{"login":"somegithubuser"}]}]'
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
        expect(issue_creator.get_issues("somerepo")).equal?(response)
      end

      it "returns [] if no issues" do
        response = []
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
        expect(issue_creator.get_issues("somerepo")).equal?([])
      end
    end
  end
end
