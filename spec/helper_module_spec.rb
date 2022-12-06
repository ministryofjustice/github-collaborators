URL = "https://api.github.com/repos/ministryofjustice/#{REPOSITORY_NAME}/issues"
LOGIN = "someuser"
COLLABORATOR_EXISTS = "when collaborator does exist"
COLLABORATOR_DOESNT_EXIST = "when collaborator doesn't exist"
TEST_CREATE_PULL_REQUEST = "test create_pull_request"

describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }

  let(:http_client) { double(GithubCollaborators::HttpClient) }
  let(:branch_creator) { double(GithubCollaborators::BranchCreator) }
  let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

  # Stub sleep
  before {
    allow_any_instance_of(helper_module).to receive(:sleep)
    allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep)
    allow_any_instance_of(GithubCollaborators::BranchCreator).to receive(:sleep)
    allow_any_instance_of(GithubCollaborators::GithubGraphQlClient).to receive(:sleep)
  }

  terraform_block = create_collaborator_with_login("someuser1")
  collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
  terraform_block = create_collaborator_with_login("someuser2")
  collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
  collaborators = [collaborator1, collaborator2]

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
    it "when invites exist" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/invitations"
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(json)
      expected_result = [{login: "user1", expired: true, invite_id: 1}, {login: "user2", expired: false, invite_id: 2}]
      expect(helper_module.get_repository_invites("somerepo")).to eq(expected_result)
    end

    it "when invites don't exist" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/invitations"
      response = %([])
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(response)
      expect(helper_module.get_repository_invites("somerepo")).to eq([])
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
    url = "https://api.github.com/orgs/ministryofjustice/teams/all-org-members/repos?per_page=100"

    it "when team has repositories" do
      response = %([{"name": "somerepo1"},{"name": "somerepo2"}])
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(response)
      repositories = ["somerepo1", "somerepo2"]
      expect(helper_module.get_all_org_members_team_repositories).to eq(repositories)
    end

    it "when team has no repositories" do
      response = []
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(response.to_json)
      expect(helper_module.get_all_org_members_team_repositories).to eq([])
    end
  end

  context "test does_collaborator_already_exist" do
    it COLLABORATOR_EXISTS do
      expect(helper_module.does_collaborator_already_exist("someuser1", collaborators)).to eq(true)
    end

    it COLLABORATOR_DOESNT_EXIST do
      expect(helper_module.does_collaborator_already_exist("someuser6", collaborators)).to eq(false)
    end
  end

  context "test get_name" do
    it COLLABORATOR_EXISTS do
      expect(helper_module.get_name("someuser1", collaborators)).to eq(TEST_COLLABORATOR_NAME)
    end

    it COLLABORATOR_DOESNT_EXIST do
      expect(helper_module.get_name("someuser6", collaborators)).to eq("")
    end
  end

  context "test get_email" do
    it COLLABORATOR_EXISTS do
      expect(helper_module.get_email("someuser1", collaborators)).to eq(TEST_COLLABORATOR_EMAIL)
    end

    it COLLABORATOR_DOESNT_EXIST do
      expect(helper_module.get_email("someuser6", collaborators)).to eq("")
    end
  end

  context "test get_org" do
    it COLLABORATOR_EXISTS do
      expect(helper_module.get_org("someuser1", collaborators)).to eq(TEST_COLLABORATOR_ORG)
    end

    it COLLABORATOR_DOESNT_EXIST do
      expect(helper_module.get_org("someuser6", collaborators)).to eq("")
    end
  end

  context "test get_org_outside_collaborators" do
    url = "https://api.github.com/orgs/ministryofjustice/outside_collaborators?per_page=100"

    it "when collaborators exist" do
      json = %([{"login": "someuser1"},{"login": "someuser2"}])
      response = ["someuser1", "someuser2"]
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(json)
      expect(helper_module.get_org_outside_collaborators).to eq(response)
    end

    it "when no collaborators exist" do
      response = []
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:fetch_json).with(url).and_return(response.to_json)
      expect(helper_module.get_org_outside_collaborators).to eq([])
    end
  end

  context "test create_branch_and_pull_request" do
    pull_request_title = "sometitle"
    filenames = ["file1", "file2", "file3"]
    branch_name = "somebranch"
    collaborator_name = "someuser"
    types = ["delete", "extend", "remove", "permission", "add", "delete_archive_file"]

    it "when branch name valid and unknown type" do
      expect(GithubCollaborators::BranchCreator).to receive(:new).and_return(branch_creator)
      expect(branch_creator).to receive(:check_branch_name_is_valid).with(branch_name, collaborator_name).and_return(branch_name)
      expect(branch_creator).to receive(:create_branch).with(branch_name)
      filenames.each do |filename|
        expect(branch_creator).to receive(:add).with(filename)
      end
      expect(branch_creator).to receive(:commit_and_push).with(pull_request_title)
      helper_module.create_branch_and_pull_request(branch_name, filenames, pull_request_title, collaborator_name, "")
    end

    it "when branch name isnt valid and unknown type" do
      expect(GithubCollaborators::BranchCreator).to receive(:new).and_return(branch_creator)
      new_branch_name = "branchname2"
      expect(branch_creator).to receive(:check_branch_name_is_valid).with(branch_name, collaborator_name).and_return(new_branch_name)
      expect(branch_creator).to receive(:create_branch).with(new_branch_name)
      filenames.each do |filename|
        expect(branch_creator).to receive(:add).with(filename)
      end
      expect(branch_creator).to receive(:commit_and_push).with(pull_request_title)
      helper_module.create_branch_and_pull_request(branch_name, filenames, pull_request_title, collaborator_name, "")
    end

    it "when branch name is valid and use known types" do
      expect(GithubCollaborators::BranchCreator).to receive(:new).and_return(branch_creator).at_least(6).times
      expect(branch_creator).to receive(:check_branch_name_is_valid).with(branch_name, collaborator_name).and_return(branch_name).at_least(6).times
      expect(branch_creator).to receive(:create_branch).with(branch_name).at_least(6).times
      filenames.each do |filename|
        expect(branch_creator).to receive(:add).with(filename).at_least(6).times
      end
      expect(branch_creator).to receive(:commit_and_push).with(pull_request_title).at_least(6).times

      types.each do |type|
        if type == "delete"
          expect(helper_module).to receive(:create_pull_request)
          expect(helper_module).to receive(:delete_empty_files_hash).with(branch_name)
        elsif type == "extend"
          expect(helper_module).to receive(:create_pull_request)
          expect(helper_module).to receive(:extend_date_hash).with(collaborator_name, branch_name)
        elsif type == "remove"
          expect(helper_module).to receive(:create_pull_request)
          expect(helper_module).to receive(:remove_collaborator_hash).with(collaborator_name, branch_name)
        elsif type == "permission"
          expect(helper_module).to receive(:create_pull_request)
          expect(helper_module).to receive(:modify_collaborator_permission_hash).with(collaborator_name, branch_name)
        elsif type == "add"
          expect(helper_module).to receive(:create_pull_request)
          expect(helper_module).to receive(:add_collaborator_hash).with(collaborator_name, branch_name)
        elsif type == "delete_archive_file"
          expect(helper_module).to receive(:create_pull_request)
          expect(helper_module).to receive(:delete_archive_file_hash).with(branch_name)
        end
        helper_module.create_branch_and_pull_request(branch_name, filenames, pull_request_title, collaborator_name, type)
      end
    end
  end

  pull_request_url = "https://api.github.com/repos/ministryofjustice/github-collaborators/pulls"

  context TEST_CREATE_PULL_REQUEST do
    before do
      ENV.delete("REALLY_POST_TO_GH")
    end

    it "when token is do nothing" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      helper_module.create_pull_request("")
    end
  end

  context TEST_CREATE_PULL_REQUEST do
    before do
      ENV["REALLY_POST_TO_GH"] = "0"
    end

    it "when post to github env variable is not enabled" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      helper_module.create_pull_request("")
    end

    after do
      ENV.delete("REALLY_POST_TO_GH")
    end
  end

  context TEST_CREATE_PULL_REQUEST do
    before do
      ENV["REALLY_POST_TO_GH"] = "1"
      ENV["OPS_BOT_TOKEN"] = "1"
    end

    it "when post to github and ops eng bot env variables are set" do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_pull_request_json).with(pull_request_url, "".to_json)
      helper_module.create_pull_request("")
    end

    after do
      ENV.delete("REALLY_POST_TO_GH")
      ENV.delete("OPS_BOT_TOKEN")
    end
  end

  context TEST_CREATE_PULL_REQUEST do
    before do
      ENV["REALLY_POST_TO_GH"] = "1"
      ENV["OPS_BOT_TOKEN"] = "0"
    end

    it "when post to github env variable is set and ops eng bot env variables isn't set" do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(pull_request_url, "".to_json)
      helper_module.create_pull_request("")
    end

    after do
      ENV.delete("REALLY_POST_TO_GH")
      ENV.delete("OPS_BOT_TOKEN")
    end
  end

  context "test extend_date_hash" do
    login = "someuser"
    branch_name = "somebranch"
    hash_body = {
      title: EXTEND_REVIEW_DATE_PR_TITLE + " " + login,
      head: branch_name,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login} has review date/s that are close to expiring.
        
        The review date/s have automatically been extended.
        
        Either approve this pull request, modify it or delete it if it is no longer necessary.
      EOF
    }

    it "call extend_date_hash" do
      expect(helper_module.extend_date_hash(login, branch_name)).to eq(hash_body)
    end
  end

  context "test delete_archive_file_hash" do
    branch_name = "somebranch"
    hash_body = {
      title: ARCHIVED_REPOSITORY_PR_TITLE,
      head: branch_name,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The repositories in this pull request have been archived.
        
        This pull request is to remove those Terraform files.
        
      EOF
    }

    it "call delete_archive_file_hash" do
      expect(helper_module.delete_archive_file_hash(branch_name)).to eq(hash_body)
    end
  end

  context "test delete_empty_files_hash" do
    branch_name = "somebranch"
    hash_body = {
      title: EMPTY_FILES_PR_TITLE,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The Terraform files in this pull request are empty and serve no purpose, please remove them.
        
      EOF
    }

    it "call delete_empty_files_hash" do
      expect(helper_module.delete_empty_files_hash(branch_name)).to eq(hash_body)
    end
  end

  context "test add_collaborator_hash" do
    login = "someuser"
    branch_name = "somebranch"
    hash_body = {
      title: ADD_FULL_ORG_MEMBER_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} was found to be missing from the file/s in this pull request.
        
        This is because the collaborator is a full organization member and is able to join repositories outside of Terraform.
        
        This pull request ensures we keep track of those collaborators and which repositories they are accessing.
        
        Edit the pull request file/s because some of the data about the collaborator is missing.
        
      EOF
    }

    it "call add_collaborator_hash" do
      expect(helper_module.add_collaborator_hash(login, branch_name)).to eq(hash_body)
    end
  end

  context "test remove_collaborator_hash" do
    login = "someuser"
    branch_name = "somebranch"
    hash_body = {
      title: REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} review date has expired for the file/s contained in this pull request.
        
        Either approve this pull request, modify it or delete it if it is no longer necessary.
      EOF
    }

    it "call remove_collaborator_hash" do
      expect(helper_module.remove_collaborator_hash(login, branch_name)).to eq(hash_body)
    end
  end

  context "test modify_collaborator_permission_hash" do
    login = "someuser"
    branch_name = "somebranch"
    hash_body = {
      title: CHANGE_PERMISSION_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} permission on Github is different to the permission in the Terraform file for the repository.
        
        This is because the collaborator is a full organization member, is able to join repositories outside of Terraform and may have different access to the repository now they are in a Team.
        
        The permission on Github is given the priority.
        
        This pull request ensures we keep track of those collaborators, which repositories they are accessing and their permission.
        
        Permission can either be admin, push, maintain, pull or triage.
        
      EOF
    }

    it "call modify_collaborator_permission_hash" do
      expect(helper_module.modify_collaborator_permission_hash(login, branch_name)).to eq(hash_body)
    end
  end

  context "test get_active_repositories" do
    return_data = File.read("spec/fixtures/repositories.json")
    it "call get_active_repositories" do
      json_query_public = %[
      {
        search(
          type: REPOSITORY
          query: "org:ministryofjustice, archived:false, is:public"
          first: 100 
        ) {
          repos: edges {
            repo: node {
              ... on Repository {
                name
                isDisabled
                isLocked
                collaborators(affiliation: OUTSIDE) {
                  totalCount
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    ]

      json_query_private = %[
      {
        search(
          type: REPOSITORY
          query: "org:ministryofjustice, archived:false, is:private"
          first: 100 
        ) {
          repos: edges {
            repo: node {
              ... on Repository {
                name
                isDisabled
                isLocked
                collaborators(affiliation: OUTSIDE) {
                  totalCount
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    ]

      json_query_internal = %[
      {
        search(
          type: REPOSITORY
          query: "org:ministryofjustice, archived:false, is:internal"
          first: 100 
        ) {
          repos: edges {
            repo: node {
              ... on Repository {
                name
                isDisabled
                isLocked
                collaborators(affiliation: OUTSIDE) {
                  totalCount
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    ]
      # FUT has a loop with tree iterations. Each loop produces these objects.
      repo1 = GithubCollaborators::Repository.new("somerepo1", 1)
      repo2 = GithubCollaborators::Repository.new("somerepo3", 5)
      repo2 = GithubCollaborators::Repository.new("somerepo5", 0)
      expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client).at_least(1).times
      expect(graphql_client).to receive(:run_query).with(json_query_public).and_return(return_data)
      expect(graphql_client).to receive(:run_query).with(json_query_private).and_return(return_data)
      expect(graphql_client).to receive(:run_query).with(json_query_internal).and_return(return_data)
      # Thus expect these objects to created three times
      expect(GithubCollaborators::Repository).to receive(:new).with("somerepo1", 1).and_return(repo1).at_least(3).times
      expect(GithubCollaborators::Repository).to receive(:new).with("somerepo3", 5).and_return(repo2).at_least(3).times
      expect(GithubCollaborators::Repository).to receive(:new).with("somerepo5", 0).and_return(repo2).at_least(3).times
      # Thus expects the three iterations to create three objects each to make nine objects in total
      expect(helper_module.get_active_repositories.length).to eq(9)
    end
  end
end
