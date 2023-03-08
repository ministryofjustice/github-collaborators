class GithubCollaborators
  include TestConstants
  include Constants

  describe CreatePrFromIssue do
    let(:http_client) { double(GithubCollaborators::HttpClient) }
    repo_url = "#{GH_API_URL}/#{TEST_REPO_NAME}"

    before do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
    end

    context "test good path" do
      good_json_no_lists = {"body": "### usernames\n\n#{TEST_COLLABORATOR_LOGIN}\n\n### names\n\n#{TEST_COLLABORATOR_NAME}\n\n### emails\n\n#{TEST_COLLABORATOR_EMAIL}\n\n### org\n\n#{TEST_COLLABORATOR_ORG}\n\n### reason\n\n#{REASON1}\n\n### added_by\n\n#{ADDED_BY_EMAIL}\n\n### review_after\n\n#{CORRECT_REVIEW_DATE}\n\n### permission\n\n#{CORRECT_PERMISSION}\n\n### repositories\n\n#{TEST_REPO_NAME}"}.to_json
      subject(:create_pr_from_issue) { described_class.new(good_json_no_lists) }
      
      it "call get_permission" do
        test_equal(create_pr_from_issue.get_permission, CORRECT_PERMISSION)
      end

      context "" do
        it "call get_repositories" do
          expect(http_client).to receive(:fetch_code).with(repo_url).and_return("200")
          test_equal(create_pr_from_issue.get_repositories, [TEST_REPO_NAME])
        end

      end
    end

    context "test good path" do
      good_json_with_lists = {"body": "### usernames\n\n#{TEST_COLLABORATOR_LOGIN}***23\r\n#{TEST_COLLABORATOR_LOGIN}***23\n\n### names\n\n#{TEST_COLLABORATOR_NAME}\r\n#{TEST_COLLABORATOR_NAME}\n\n### emails\n\n#{TEST_COLLABORATOR_EMAIL}\r\n#{TEST_COLLABORATOR_EMAIL}\n\n### org\n\n#{TEST_COLLABORATOR_ORG}\n\n### reason\n\n#{REASON1}\n\n### added_by\n\n#{ADDED_BY_EMAIL}\n\n### review_after\n\n#{CORRECT_REVIEW_DATE}\n\n### permission\n\n#{CORRECT_PERMISSION}\n\n### repositories\n\n#{TEST_REPO_NAME}***\r\n#{TEST_REPO_NAME}"}.to_json
      subject(:create_pr_from_issue) { described_class.new(good_json_with_lists) }

      it "call get_permission" do
        test_equal(create_pr_from_issue.get_permission, CORRECT_PERMISSION)
      end

      context "" do
        it "call get_repositories" do
          expect(http_client).to receive(:fetch_code).with(repo_url).and_return("200").at_least(2).times
          test_equal(create_pr_from_issue.get_repositories, [TEST_REPO_NAME, TEST_REPO_NAME])
        end
      end
    end

    context "test bad parameters" do
      subject(:create_pr_from_issue) { described_class.new(good_json_no_lists) }
    end
  end
end
