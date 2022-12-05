URL = "https://api.github.com/repos/ministryofjustice/#{REPOSITORY_NAME}/issues"
LOGIN = "someuser"

describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }

  let(:http_client) { double(GithubCollaborators::HttpClient) }

  # Stub sleep
  before { allow_any_instance_of(helper_module).to receive(:sleep) }
  before { allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep) }

  context "test get_issues_from_github" do
    it "return an issue" do
      response = %([{"assignee": { "login":#{LOGIN}}, "title": #{COLLABORATOR_EXPIRES_SOON}, "assignees": [{"login":#{LOGIN} }]}])
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
      expect(helper_module.get_issues_from_github(REPOSITORY_NAME)).equal?(response)
    end

    it "return empty array if no issues" do
      response = []
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
      expect(helper_module.get_issues_from_github(REPOSITORY_NAME)).equal?([])
    end

    let(:json) { File.read("spec/fixtures/issues.json") }
    it "return issues" do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(URL).and_return(json)
      expect(helper_module.get_issues_from_github(REPOSITORY_NAME)).equal?(json)
    end
  end

  context "test delete_expired_invite" do
    it "call function" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/invitations/someuser"
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:delete).with(url)
      helper_module.delete_expired_invite("somerepo", "someuser")
    end
  end

  context "test get_repository_invites" do
    let(:json) { File.read("spec/fixtures/invites.json") }
    it "call function" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/invitations"
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(json)
      expected_result = [{login: "user1", expired: true, invite_id: 1}, {login: "user2", expired: false, invite_id: 2}]
      expect(helper_module.get_repository_invites("somerepo")).to eq(expected_result)
    end
  end

  context "test does_issue_already_exist" do
    let(:issues_json) { File.read("spec/fixtures/issues.json") }
    it "when no issues exists" do
      issues = JSON.parse(issues_json, {symbolize_names: true})
      expect(helper_module).to receive(:remove_issue).with("somerepo", 159)
      expect(helper_module.does_issue_already_exist(issues, COLLABORATOR_EXPIRES_SOON, "somerepo", "someuser1")).to eq(false)
      expect(issues.length).to eq(3)
    end

    it "when issue exists" do
      issues = JSON.parse(issues_json, {symbolize_names: true})
      expect(helper_module).to receive(:remove_issue).with("somerepo", 159)
      expect(helper_module.does_issue_already_exist(issues, COLLABORATOR_EXPIRES_SOON, "somerepo", "assigneduser1")).to eq(true)
      expect(issues.length).to eq(3)
    end
  end

  context "test get_all_org_members_team_repositories" do
    it "call function" do
      url = "https://api.github.com/orgs/ministryofjustice/teams/all-org-members/repos?per_page=100"
      response = %([{"name": "somerepo1"},{"name": "somerepo2"}])
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(response)
      repositories = ["somerepo1", "somerepo2"]
      expect(helper_module.get_all_org_members_team_repositories).to eq(repositories)
    end
  end

  context "test does_collaborator_already_exist" do
    terraform_block = create_collaborator_with_login("someuser1")
    collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
    terraform_block = create_collaborator_with_login("someuser2")
    collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
    collaborators = [collaborator1, collaborator2]

    it "when collaborator does exist" do
      expect(helper_module.does_collaborator_already_exist("someuser1", collaborators)).to eq(true)
    end

    it "when collaborator doesN'T exist" do
      expect(helper_module.does_collaborator_already_exist("someuser6", collaborators)).to eq(false)
    end
  end

end
