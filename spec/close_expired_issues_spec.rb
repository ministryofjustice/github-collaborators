class GithubCollaborators
  include TestConstants
  include Constants

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }
    let(:http_client) { double(GithubCollaborators::HttpClient) }
    let(:issue_creator) { double(GithubCollaborators::IssueCreator) }

    it "call remove_issue" do
      url = "#{URL}/1"
      state = "{\"state\":\"closed\"}"
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:patch_json).with(url, state)
      helper_module.remove_issue(REPOSITORY_NAME, 1)
    end

    it "call close_expired_issues when no issue exists" do
      expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return([])
      helper_module.close_expired_issues(REPOSITORY_NAME)
    end

    context "call close_expired_issues" do
      context "and remove issue" do
        before do
          expect(helper_module).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        end

        it "when collaborator expires soon, issue has expired and is open" do
          issues = create_issues(COLLABORATOR_EXPIRES_SOON, CREATED_DATE, OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when collaborator expires soon, grace period expired and is open" do
          issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_EXPIRED, OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when define collaborator in code, issue has expired and is open" do
          issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, CREATED_DATE, OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when define collaborator in code, grace period expired and is open" do
          issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_EXPIRED, OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

      context "do not remove issue" do
        before do
          expect(helper_module).not_to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        end

        it "when collaborator expires soon, grace period expired and is closed" do
          issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_EXPIRED, CLOSED, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when define collaborator in code, grace period expired and is closed" do
          issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_EXPIRED, CLOSED, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when other open issue, ignore" do
          issues = create_issues("some issue", "2020-02-11", OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end
      end

      context "do not remove issue" do
        before do
          expect(helper_module).not_to receive(:remove_issue)
        end

        it "when collaborator expires soon, grace period okay and is open" do
          issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_OKAY, OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when collaborator expires soon, grace period okay and is closed" do
          issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_OKAY, CLOSED, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when define collaborator in code, grace period okay and is open" do
          issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_OKAY, OPEN, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end

        it "when define collaborator in code, grace period okay and is closed" do
          issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_OKAY, CLOSED, 1)
          expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
          helper_module.close_expired_issues(REPOSITORY_NAME)
        end
      end

      it "call close_expired_issues when multiple issues, some expired and open" do
        issues = [
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: GRACE_PERIOD_OKAY,
            state: OPEN,
            number: 1
          },
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: CREATED_DATE,
            state: OPEN,
            number: 2
          },
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: "2050-10-01",
            state: OPEN,
            number: 3
          }
        ]
        expect(helper_module).to receive(:get_issues_from_github).with(REPOSITORY_NAME).and_return(issues)
        expect(helper_module).to receive(:remove_issue).with(REPOSITORY_NAME, 2).at_least(1).times
        helper_module.close_expired_issues(REPOSITORY_NAME)
      end
    end
  end
end
