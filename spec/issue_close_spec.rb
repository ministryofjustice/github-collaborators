class GithubCollaborators
  describe IssueClose do
    CREATED_DATE = "2019-10-01"

    subject(:issue_close) { described_class.new }
    
    # Stub sleep
    before { allow_any_instance_of(GithubCollaborators::IssueClose).to receive(:sleep) }

    let(:http_client) { double(GithubCollaborators::HttpClient) }

    GRACE_PERIOD_OKAY = (Date.today - 45).strftime(DATE_FORMAT)
    GRACE_PERIOD_EXPIRED = (Date.today - 46).strftime(DATE_FORMAT)
    OPEN = "open"
    CLOSED = "closed"
    REPOSITORY_NAME = "somerepo"

    context "call" do
      it "remove issue" do
        url = "https://api.github.com/repos/ministryofjustice/somerepo/issues/1"
        state = "{\"state\":\"closed\"}"
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:patch_json).with(url, state)
        issue_close.remove_issue(REPOSITORY_NAME, 1)
      end
    end

    context "call close expired issues" do

      let(:issue_creator) { double(GithubCollaborators::IssueCreator) }

      it "no issue exists" do
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return([])
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expires soon, issue has expired and is open" do
        issues = create_issues(COLLABORATOR_EXPIRES_SOON, CREATED_DATE, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expires soon, grace period okay and is open" do
        issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_OKAY, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expires soon, grace period okay and is closed" do
        issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_OKAY, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expires soon, grace period expired and is open" do
        issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_EXPIRED, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expires soon, grace period expired and is closed" do
        issues = create_issues(COLLABORATOR_EXPIRES_SOON, GRACE_PERIOD_EXPIRED, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expiry upcoming, issue has expired and is open" do
        issues = create_issues(COLLABORATOR_EXPIRY_UPCOMING, CREATED_DATE, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expiry upcoming, grace period okay and is open" do
        issues = create_issues(COLLABORATOR_EXPIRY_UPCOMING, GRACE_PERIOD_OKAY, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expiry upcoming, grace period okay and is closed" do
        issues = create_issues(COLLABORATOR_EXPIRY_UPCOMING, GRACE_PERIOD_OKAY, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expiry upcoming, grace period expired and is open" do
        issues = create_issues(COLLABORATOR_EXPIRY_UPCOMING, GRACE_PERIOD_EXPIRED, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "collaborator expiry upcoming, grace period expired and is closed" do
        issues = create_issues(COLLABORATOR_EXPIRY_UPCOMING, GRACE_PERIOD_EXPIRED, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "define collaborator in code, issue has expired and is open" do
        issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, CREATED_DATE, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "define collaborator in code, grace period okay and is open" do
        issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_OKAY, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "define collaborator in code, grace period okay and is closed" do
        issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_OKAY, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "define collaborator in code, grace period expired and is open" do
        issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_EXPIRED, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "define collaborator in code, grace period expired and is closed" do
        issues = create_issues(DEFINE_COLLABORATOR_IN_CODE, GRACE_PERIOD_EXPIRED, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "use team access, issue has expired and is open" do
        issues = create_issues(USE_TEAM_ACCESS, CREATED_DATE, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "use team access, grace period okay and is open" do
        issues = create_issues(USE_TEAM_ACCESS, GRACE_PERIOD_OKAY, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "use team access, grace period okay and is closed" do
        issues = create_issues(USE_TEAM_ACCESS, GRACE_PERIOD_OKAY, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "use team access, grace period expired and is open" do
        issues = create_issues(USE_TEAM_ACCESS, GRACE_PERIOD_EXPIRED, OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "use team access, grace period expired and is closed" do
        issues = create_issues(USE_TEAM_ACCESS, GRACE_PERIOD_EXPIRED, CLOSED, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "other open issue, ignore" do
        issues = create_issues("some issue", "2020-02-11", OPEN, 1)
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with(REPOSITORY_NAME, 1)
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "use team access, multiple issues, expired and open" do
        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: CREATED_DATE,
            state: OPEN,
            number: 1
          },
          {
            title: USE_TEAM_ACCESS,
            created_at: CREATED_DATE,
            state: OPEN,
            number: 2
          },
          {
            title: USE_TEAM_ACCESS,
            created_at: CREATED_DATE,
            state: OPEN,
            number: 3
          }
        ]
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).at_least(3).times
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end

      it "multiple issues, some expired and open" do
        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: GRACE_PERIOD_OKAY,
            state: OPEN,
            number: 1
          },
          {
            title: USE_TEAM_ACCESS,
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
        expect(GithubCollaborators::IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with(REPOSITORY_NAME).and_return(issues)
        expect(issue_close).to receive(:remove_issue).with(REPOSITORY_NAME, 2).at_least(1).times
        issue_close.close_expired_issues(REPOSITORY_NAME)
      end
    end
  end
end
