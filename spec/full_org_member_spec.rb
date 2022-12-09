class GithubCollaborators
  describe FullOrgMember do
    context "test FullOrgMember" do
      # Stub sleep
      before {
        allow_any_instance_of(GithubCollaborators::GithubGraphQlClient).to receive(:sleep)
        allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep)
      }

      before do
        ENV["ADMIN_GITHUB_TOKEN"] = ""
      end

      let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }
      let(:http_client) { double(GithubCollaborators::HttpClient) }
      let(:collaborator_repositories_json) { File.read("spec/fixtures/collaborator-repositories.json") }

      url = "https://api.github.com/repos/ministryofjustice/test-repo1/collaborators/someuser1/permission"

      query =
        %[
        {
          user(login: "#{TEST_USER_1}") {
            repositories(
              affiliations: ORGANIZATION_MEMBER
              ownerAffiliations: ORGANIZATION_MEMBER
              first: 100
              after: null
            ) {
              edges {
                node {
                  name
                  owner {
                    login
                  }
                }
              }
              pageInfo {
                endCursor
                hasNextPage
              }
            }
          }
        }
      ]

      it "call add_info_from_file" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_info_from_file(TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_ORG)
        test_equal(full_org_member.login, TEST_USER_1)
        test_equal(full_org_member.email, TEST_COLLABORATOR_EMAIL)
        test_equal(full_org_member.name, TEST_COLLABORATOR_NAME)
        test_equal(full_org_member.org, TEST_COLLABORATOR_ORG)
      end

      it "call add_archived_repositories" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_archived_repositories([TEST_REPO_NAME1, TEST_REPO_NAME2])
        test_equal(full_org_member.github_archived_repositories.length, 2)
      end

      it "call add_all_org_members_team_repositories" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1, TEST_REPO_NAME2])
        test_equal(full_org_member.org_members_team_repositories.length, 2)
      end

      it "call add_ignore_repository" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_ignore_repository(TEST_REPO_NAME1)
        full_org_member.add_ignore_repository(TEST_REPO_NAME2)
        test_equal(full_org_member.ignore_repositories.length, 2)
      end

      it "call add_terraform_repositories and adds to array" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.terraform_repositories.length, 1)
      end

      it "call add_terraform_repositories and don't add to array because repo is an archived all org team repo" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.org_members_team_repositories.length, 1)
        full_org_member.add_archived_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.github_archived_repositories.length, 1)
        full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.terraform_repositories.length, 0)
      end

      it "call add_terraform_repositories and don't add to array because repo is an all org team repo" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.org_members_team_repositories.length, 1)
        full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.terraform_repositories.length, 0)
      end

      it "call add_terraform_repositories and don't add to array because repo is an archived repo" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_archived_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.github_archived_repositories.length, 1)
        full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.terraform_repositories.length, 0)
      end

      it "call get_full_org_member_repositories when repos are not known already" do
        expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
        expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.get_full_org_member_repositories
        test_equal(full_org_member.github_repositories.length, 3)
      end

      it "call get_full_org_member_repositories when repo is already archived" do
        expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
        expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_archived_repositories([TEST_REPO_NAME2])
        full_org_member.get_full_org_member_repositories
        test_equal(full_org_member.github_repositories.length, 2)
      end

      it "call get_full_org_member_repositories when repo is already org repo" do
        expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
        expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME2])
        full_org_member.get_full_org_member_repositories
        test_equal(full_org_member.github_repositories.length, 2)
      end

      it "call odd_full_org_member_check expect true" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        test_equal(full_org_member.odd_full_org_member_check, true)
      end

      it "call odd_full_org_member_check expect false because org team array greater than 0" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME])
        test_equal(full_org_member.org_members_team_repositories.length, 1)
        test_equal(full_org_member.odd_full_org_member_check, false)
      end

      it "call odd_full_org_member_check expect true because github repositories is 0" do
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
        test_equal(full_org_member.terraform_repositories.length, 1)
        test_equal(full_org_member.odd_full_org_member_check, true)
      end

      it "call odd_full_org_member_check expect true because terraform repositories is 0" do
        expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
        expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        full_org_member.get_full_org_member_repositories
        test_equal(full_org_member.github_repositories.length, 3)
        test_equal(full_org_member.odd_full_org_member_check, true)
      end

      it "call get_full_org_member_repositories and add to archive array" do
        expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
        expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        test_equal(full_org_member.attached_archived_repositories.length, 0)
        full_org_member.add_archived_repositories([TEST_REPO_NAME2])
        full_org_member.get_full_org_member_repositories
        test_equal(full_org_member.attached_archived_repositories.length, 1)
      end

      def create_repo_permission_json_reply(admin, maintain, push, triage, pull)
        %(
          {
            "user": {
              "permissions": {
                "admin": #{admin},
                "maintain": #{maintain},
                "push": #{push},
                "triage": #{triage},
                "pull": #{pull}
              }
            }
          }
        )
      end

      it "call get_repository_permission expect admin" do
        json = create_repo_permission_json_reply(true, true, true, true, true)
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(url).and_return(json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        permission = full_org_member.get_repository_permission(TEST_REPO_NAME1)
        test_equal(permission, "admin")
      end

      it "call get_repository_permission expect maintain" do
        json = create_repo_permission_json_reply(false, true, true, true, true)
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(url).and_return(json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        permission = full_org_member.get_repository_permission(TEST_REPO_NAME1)
        test_equal(permission, "maintain")
      end

      it "call get_repository_permission expect push" do
        json = create_repo_permission_json_reply(false, false, true, true, true)
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(url).and_return(json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        permission = full_org_member.get_repository_permission(TEST_REPO_NAME1)
        test_equal(permission, "push")
      end

      it "call get_repository_permission expect triage" do
        json = create_repo_permission_json_reply(false, false, false, true, true)
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(url).and_return(json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        permission = full_org_member.get_repository_permission(TEST_REPO_NAME1)
        test_equal(permission, "triage")
      end

      it "call get_repository_permission expect pull" do
        json = create_repo_permission_json_reply(false, false, false, false, true)
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(url).and_return(json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        permission = full_org_member.get_repository_permission(TEST_REPO_NAME1)
        test_equal(permission, "pull")
      end

      it "call get_repository_permission expect pull when no permission" do
        json = create_repo_permission_json_reply(false, false, false, false, false)
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:fetch_json).with(url).and_return(json)
        full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
        permission = full_org_member.get_repository_permission(TEST_REPO_NAME1)
        test_equal(permission, "pull")
      end

      after do
        ENV.delete("ADMIN_GITHUB_TOKEN")
      end
    end
  end
end
