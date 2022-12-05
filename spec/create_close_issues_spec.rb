URL = "https://api.github.com/repos/ministryofjustice/#{REPOSITORY_NAME}/issues"
LOGIN = "someuser"
TITLE_1 = COLLABORATOR_EXPIRES_SOON + " " + LOGIN

describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }

  let(:http_client) { double(GithubCollaborators::HttpClient) }

  # Stub sleep
  before { allow_any_instance_of(helper_module).to receive(:sleep) }
  before { allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep) }

  let(:json1) {
    %({"title":"#{DEFINE_COLLABORATOR_IN_CODE}","assignees":["#{LOGIN}"],"body":"Hi there\\n\\nWe have a process to manage github collaborators in code: https://github.com/ministryofjustice/github-collaborators\\n\\nPlease follow the procedure described there to grant @#{LOGIN} access to this repository.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nIf the outside collaborator is not needed, close this issue, they have already been removed from this repository.\\n"})
  }

  let(:json2) {
    %({"title":"#{TITLE_1}","assignees":["#{LOGIN}"],"body":"Hi there\\n\\nThe user @#{LOGIN} has its access for this repository maintained in code here: https://github.com/ministryofjustice/github-collaborators\\n\\nThe review_after date is due to expire within one month, please update this via a PR if they still require access.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nFailure to update the review_date will result in the collaborator being removed from the repository via our automation.\\n"})
  }

  context "when env var enabled" do
    before do
      ENV["REALLY_POST_TO_GH"] = "1"
    end

    it "call github api in create unknown collaborator issue" do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(URL, json1)
      helper_module.create_unknown_collaborator_issue(LOGIN, REPOSITORY_NAME)
    end

    it "call github api in create review date expires soon issue" do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(URL, json2)
      helper_module.create_review_date_expires_soon_issue(LOGIN, REPOSITORY_NAME)
    end

    after do
      ENV.delete("REALLY_POST_TO_GH")
    end
  end

  context "when env var not enabled" do
    before do
      ENV["REALLY_POST_TO_GH"] = "0"
    end

    it "dont call github api in create unknown collaborator issue" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      expect(http_client).not_to receive(:delete)
      helper_module.create_unknown_collaborator_issue(LOGIN, REPOSITORY_NAME)
    end

    it "dont call github api in create review date expires soon issue" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      expect(http_client).not_to receive(:delete)
      helper_module.create_review_date_expires_soon_issue(LOGIN, REPOSITORY_NAME)
    end

    after do
      ENV.delete("REALLY_POST_TO_GH")
    end
  end

  context "when env var is missing" do
    before do
      ENV.delete("REALLY_POST_TO_GH")
    end

    it "dont call github api in create unknown collaborator issue" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      expect(http_client).not_to receive(:delete)
      helper_module.create_unknown_collaborator_issue(LOGIN, REPOSITORY_NAME)
    end

    it "dont call github api in create review date expires soon issue" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      expect(http_client).not_to receive(:delete)
      helper_module.create_review_date_expires_soon_issue(LOGIN, REPOSITORY_NAME)
    end
  end
end
