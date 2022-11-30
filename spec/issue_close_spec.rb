class GithubCollaborators
  describe IssueClose do
    context "call" do
      subject(:issue_close) { described_class.new }

      # Stub sleep
      before { allow_any_instance_of(IssueClose).to receive(:sleep) }

      let(:http_client) { double(HttpClient) }

      it "remove issue" do
        url = "https://api.github.com/repos/ministryofjustice/somerepo/issues/1"
        state = "{\"state\":\"closed\"}"
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:patch_json).with(url, state)
        issue_close.remove_issue("somerepo", 1)
      end
    end

    context "call close expired issues" do
      subject(:issue_close) { described_class.new }

      let(:issue_creator) { double(IssueCreator) }

      it "no issue exists" do
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return([])
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expires soon, issue has expired and is open" do
        issues = [
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: "2019-10-01",
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expires soon, grace period okay and is open" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: grace_period_ok,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expires soon, grace period okay and is closed" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: grace_period_ok,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expires soon, grace period expired and is open" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: grace_period_expired,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expires soon, grace period expired and is closed" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: grace_period_expired,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expiry upcoming, issue has expired and is open" do
        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: "2019-10-01",
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expiry upcoming, grace period okay and is open" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: grace_period_ok,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expiry upcoming, grace period okay and is closed" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: grace_period_ok,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expiry upcoming, grace period expired and is open" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: grace_period_expired,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "collaborator expiry upcoming, grace period expired and is closed" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: grace_period_expired,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "define collaborator in code, issue has expired and is open" do
        issues = [
          {
            title: DEFINE_COLLABORATOR_IN_CODE,
            created_at: "2019-10-01",
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "define collaborator in code, grace period okay and is open" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: DEFINE_COLLABORATOR_IN_CODE,
            created_at: grace_period_ok,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "define collaborator in code, grace period okay and is closed" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: DEFINE_COLLABORATOR_IN_CODE,
            created_at: grace_period_ok,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "define collaborator in code, grace period expired and is open" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: DEFINE_COLLABORATOR_IN_CODE,
            created_at: grace_period_expired,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "define collaborator in code, grace period expired and is closed" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: DEFINE_COLLABORATOR_IN_CODE,
            created_at: grace_period_expired,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "use team access, issue has expired and is open" do
        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: "2019-10-01",
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "use team access, grace period okay and is open" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: grace_period_ok,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "use team access, grace period okay and is closed" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: grace_period_ok,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "use team access, grace period expired and is open" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: grace_period_expired,
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "use team access, grace period expired and is closed" do
        grace_period_expired = (Date.today - 46).strftime(DATE_FORMAT)

        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: grace_period_expired,
            state: "closed",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue)
        issue_close.close_expired_issues("somerepo")
      end

      it "other open issue, ignore" do
        issues = [
          {
            title: "some issue",
            created_at: "2020-02-11",
            state: "open",
            number: 1
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).not_to receive(:remove_issue).with("somerepo", 1)
        issue_close.close_expired_issues("somerepo")
      end

      it "use team access, multiple issues, expired and open" do
        issues = [
          {
            title: USE_TEAM_ACCESS,
            created_at: "2019-10-01",
            state: "open",
            number: 1
          },
          {
            title: USE_TEAM_ACCESS,
            created_at: "2019-10-01",
            state: "open",
            number: 2
          },
          {
            title: USE_TEAM_ACCESS,
            created_at: "2019-10-01",
            state: "open",
            number: 3
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).at_least(3).times
        issue_close.close_expired_issues("somerepo")
      end

      it "multiple issues, some expired and open" do
        grace_period_ok = (Date.today - 45).strftime(DATE_FORMAT)

        issues = [
          {
            title: COLLABORATOR_EXPIRY_UPCOMING,
            created_at: grace_period_ok,
            state: "open",
            number: 1
          },
          {
            title: USE_TEAM_ACCESS,
            created_at: "2019-10-01",
            state: "open",
            number: 2
          },
          {
            title: COLLABORATOR_EXPIRES_SOON,
            created_at: "2050-10-01",
            state: "open",
            number: 3
          }
        ]
        expect(IssueCreator).to receive(:new).and_return(issue_creator)
        expect(issue_creator).to receive(:get_issues).with("somerepo").and_return(issues)
        expect(issue_close).to receive(:remove_issue).with("somerepo", 2).at_least(1).times
        issue_close.close_expired_issues("somerepo")
      end
    end
  end
end
