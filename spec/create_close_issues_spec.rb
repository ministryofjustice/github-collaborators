class GithubCollaborators
  include TestConstants
  include Constants
  TITLE_1 = COLLABORATOR_EXPIRES_SOON + " " + TEST_USER

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }
    let(:http_client) { double(GithubCollaborators::HttpClient) }

    let(:json1) {
      %({"title":"#{DEFINE_COLLABORATOR_IN_CODE}","assignees":["#{TEST_USER}"],"body":"Hi there\\n\\nWe have a process to manage github collaborators in code: #{GH_ORG_URL}/#{REPO_NAME}\\n\\nPlease follow the procedure described there to grant @#{TEST_USER} access to this repository.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nIf the outside collaborator is not needed, close this issue, they have already been removed from this repository.\\n"})
    }

    let(:json2) {
      %({"title":"#{TITLE_1}","assignees":["#{TEST_USER}"],"body":"Hi there\\n\\nThe user @#{TEST_USER} has its access for this repository maintained in code here: #{GH_ORG_URL}/#{REPO_NAME}\\n\\nThe review_after date is due to expire within one month, please update this via a PR if they still require access.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\\nFailure to update the review_date will result in the collaborator being removed from the repository via our automation.\\n"})
    }

    context "when env var enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "1"
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      end

      it "call create_unknown_collaborator_issue" do
        expect(http_client).to receive(:post_json).with(URL, json1)
        helper_module.create_unknown_collaborator_issue(TEST_USER, REPOSITORY_NAME)
      end

      it "call create_review_date_expires_soon_issue" do
        expect(http_client).to receive(:post_json).with(URL, json2)
        helper_module.create_review_date_expires_soon_issue(TEST_USER, REPOSITORY_NAME)
      end

      after do
        ENV.delete("REALLY_POST_TO_GH")
      end
    end

    context "when env var not enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "0"
        expect(GithubCollaborators::HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
      end

      it "call create unknown collaborator issue and don't call github api" do
        helper_module.create_unknown_collaborator_issue(TEST_USER, REPOSITORY_NAME)
      end

      it "call create_review_date_expires_soon_issue and don't call github api" do
        helper_module.create_review_date_expires_soon_issue(TEST_USER, REPOSITORY_NAME)
      end

      after do
        ENV.delete("REALLY_POST_TO_GH")
      end
    end

    context "when env var is missing" do
      before do
        ENV.delete("REALLY_POST_TO_GH")
        expect(GithubCollaborators::HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
      end

      it "call create_unknown_collaborator_issue and don't call github api" do
        helper_module.create_unknown_collaborator_issue(TEST_USER, REPOSITORY_NAME)
      end

      it "call create_review_date_expires_soon_issue and don't call github api" do
        helper_module.create_review_date_expires_soon_issue(TEST_USER, REPOSITORY_NAME)
      end
    end
  end
end
