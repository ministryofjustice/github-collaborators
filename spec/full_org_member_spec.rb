class GithubCollaborators
  include TestConstants
  include Constants

  describe FullOrgMember do
    context "test FullOrgMember" do
      before {
        allow_any_instance_of(GithubCollaborators::GithubGraphQlClient).to receive(:sleep)
        allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep)
        @full_org_member = GithubCollaborators::FullOrgMember.new(TEST_USER_1)
      }

      before do
        ENV["OPS_BOT_TOKEN"] = ""
      end

      let(:terraform_files) { double(GithubCollaborators::TerraformFiles) }
      let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }
      let(:http_client) { double(GithubCollaborators::HttpClient) }
      let(:collaborator_repositories_json) { File.read("spec/fixtures/collaborator-repositories.json") }

      url = "#{GH_API_URL}/test-repo1/collaborators/someuser1/permission"

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

      it "call add_github_repository" do
        @full_org_member.add_github_repository(TEST_USER_1)
        test_equal(@full_org_member.github_repositories.length, 1)
      end

      it "call add_info_from_file" do
        @full_org_member.add_info_from_file(TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_ORG)
        test_equal(@full_org_member.login, TEST_USER_1)
        test_equal(@full_org_member.email, TEST_COLLABORATOR_EMAIL)
        test_equal(@full_org_member.name, TEST_COLLABORATOR_NAME)
        test_equal(@full_org_member.org, TEST_COLLABORATOR_ORG)
      end

      it "call add_archived_repositories" do
        @full_org_member.add_archived_repositories([TEST_REPO_NAME1, TEST_REPO_NAME2])
        test_equal(@full_org_member.github_archived_repositories.length, 2)
      end

      it "call add_all_org_members_team_repositories" do
        @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1, TEST_REPO_NAME2])
        test_equal(@full_org_member.all_org_members_team_repositories.length, 2)
      end

      it "call add_attached_archived_repository" do
        @full_org_member.add_attached_archived_repository(TEST_REPO_NAME1)
        @full_org_member.add_attached_archived_repository(TEST_REPO_NAME2)
        test_equal(@full_org_member.attached_archived_repositories.length, 2)
      end

      it "call add_ignore_repository" do
        @full_org_member.add_ignore_repository(TEST_REPO_NAME1)
        @full_org_member.add_ignore_repository(TEST_REPO_NAME2)
        test_equal(@full_org_member.ignore_repositories.length, 2)
      end

      context "call add_terraform_repositories" do
        it "when add to array" do
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 1)
        end

        it "when don't add to array because repo is an archived all org team repo" do
          @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.all_org_members_team_repositories.length, 1)
          @full_org_member.add_archived_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.github_archived_repositories.length, 1)
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 0)
        end

        it "when don't add to array because repo is an all org team repo" do
          @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.all_org_members_team_repositories.length, 1)
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 0)
        end

        it "when don't add to array because repo is an archived repo" do
          @full_org_member.add_archived_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.github_archived_repositories.length, 1)
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 0)
        end
      end

      context "call get_full_org_member_repositories" do
        before do
          expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
          expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        end

        it "when terraform repositories is 0" do
          @full_org_member.get_full_org_member_repositories
          test_equal(@full_org_member.github_repositories.length, 3)
          test_equal(@full_org_member.odd_full_org_member_check, true)
        end

        it "when repos are not known already" do
          @full_org_member.get_full_org_member_repositories
          test_equal(@full_org_member.github_repositories.length, 3)
        end

        it "when repo is already archived" do
          @full_org_member.add_archived_repositories([TEST_REPO_NAME2])
          @full_org_member.get_full_org_member_repositories
          test_equal(@full_org_member.github_repositories.length, 2)
        end

        it "when repo is already org repo" do
          @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME2])
          @full_org_member.get_full_org_member_repositories
          test_equal(@full_org_member.github_repositories.length, 2)
        end

        it "call get_full_org_member_repositories and add to archive array" do
          test_equal(@full_org_member.attached_archived_repositories.length, 0)
          @full_org_member.add_archived_repositories([TEST_REPO_NAME2])
          @full_org_member.get_full_org_member_repositories
          test_equal(@full_org_member.attached_archived_repositories.length, 1)
        end
      end

      context "call odd_full_org_member_check" do
        it "when member is odd" do
          test_equal(@full_org_member.odd_full_org_member_check, true)
        end

        it "when org team array greater than 0" do
          @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME])
          test_equal(@full_org_member.all_org_members_team_repositories.length, 1)
          test_equal(@full_org_member.odd_full_org_member_check, false)
        end

        it "when github repositories is 0" do
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 1)
          test_equal(@full_org_member.odd_full_org_member_check, true)
        end
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

      context "call get_repository_permission" do
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        end

        it "when use admin" do
          json = create_repo_permission_json_reply(true, true, true, true, true)
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          permission = @full_org_member.get_repository_permission(TEST_REPO_NAME1)
          test_equal(permission, "admin")
        end

        it "when use maintain" do
          json = create_repo_permission_json_reply(false, true, true, true, true)
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          permission = @full_org_member.get_repository_permission(TEST_REPO_NAME1)
          test_equal(permission, "maintain")
        end

        it "when use push" do
          json = create_repo_permission_json_reply(false, false, true, true, true)
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          permission = @full_org_member.get_repository_permission(TEST_REPO_NAME1)
          test_equal(permission, "push")
        end

        it "when use triage" do
          json = create_repo_permission_json_reply(false, false, false, true, true)
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          permission = @full_org_member.get_repository_permission(TEST_REPO_NAME1)
          test_equal(permission, "triage")
        end

        it "when use pull" do
          json = create_repo_permission_json_reply(false, false, false, false, true)
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          permission = @full_org_member.get_repository_permission(TEST_REPO_NAME1)
          test_equal(permission, "pull")
        end

        it "when use no permission" do
          json = create_repo_permission_json_reply(false, false, false, false, false)
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          permission = @full_org_member.get_repository_permission(TEST_REPO_NAME1)
          test_equal(permission, "pull")
        end
      end

      context "call removed_from_github_repository" do
        it "when added no repositories" do
          test_equal(@full_org_member.removed_from_github_repository, false)
        end

        it "when user is in a Terraform file and GitHub repo" do
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          @full_org_member.add_github_repository(TEST_REPO_NAME1)
          test_equal(@full_org_member.terraform_repositories.length, 1)
          test_equal(@full_org_member.github_repositories.length, 1)
          test_equal(@full_org_member.removed_from_github_repository, false)
        end

        it "when user is in a Terraform file but not on the GitHub repo" do
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 1)
          test_equal(@full_org_member.github_repositories.length, 0)
          test_equal(@full_org_member.removed_from_github_repository, true)
        end

        it "when user is in a Terraform file but not on the GitHub repo which is a all-org-members team" do
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 1)
          test_equal(@full_org_member.github_repositories.length, 0)
          test_equal(@full_org_member.removed_from_github_repository, false)
        end
      end

      context "call missing_from_terraform_files" do
        it "when added no repositories" do
          test_equal(@full_org_member.missing_from_terraform_files, false)
        end

        it "when user is in a Terraform file" do
          @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
          test_equal(@full_org_member.terraform_repositories.length, 1)
          test_equal(@full_org_member.missing_from_terraform_files, false)
        end
      end

      context "" do
        before do
          expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
          expect(graphql_client).to receive(:run_query).with(query).and_return(collaborator_repositories_json)
        end

        context "call missing_from_terraform_files" do
          it "when add only github repositories" do
            @full_org_member.get_full_org_member_repositories
            test_equal(@full_org_member.github_repositories.length, 3)
            test_equal(@full_org_member.missing_from_terraform_files, true)
          end

          it "when github and terraform repositories do not match but a repo is an all org team repo" do
            @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
            @full_org_member.get_full_org_member_repositories
            @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
            test_equal(@full_org_member.github_repositories.length, 2)
            test_equal(@full_org_member.terraform_repositories.length, 0)
            test_equal(@full_org_member.missing_from_terraform_files, true)
          end

          it "when github and terraform repositories do not match" do
            @full_org_member.get_full_org_member_repositories
            @full_org_member.add_terraform_repositories([TEST_REPO_NAME1])
            test_equal(@full_org_member.github_repositories.length, 3)
            test_equal(@full_org_member.terraform_repositories.length, 1)
            test_equal(@full_org_member.missing_from_terraform_files, true)
          end

          it "when github and terraform repositories do match" do
            @full_org_member.get_full_org_member_repositories
            @full_org_member.add_terraform_repositories([TEST_REPO_NAME2, TEST_REPO_NAME1, TEST_REPO_NAME3])
            test_equal(@full_org_member.github_repositories.length, 3)
            test_equal(@full_org_member.terraform_repositories.length, 3)
            test_equal(@full_org_member.missing_from_terraform_files, false)
          end

          it "when github and terraform repositories do match but a repo is an all org team repo" do
            @full_org_member.add_all_org_members_team_repositories([TEST_REPO_NAME1])
            @full_org_member.get_full_org_member_repositories
            @full_org_member.add_terraform_repositories([TEST_REPO_NAME2, TEST_REPO_NAME1, TEST_REPO_NAME3])
            test_equal(@full_org_member.github_repositories.length, 2)
            test_equal(@full_org_member.terraform_repositories.length, 2)
            test_equal(@full_org_member.missing_from_terraform_files, false)
          end
        end

        context "call mismatched_repository_permissions_check" do
          it "when github_repositories has repositories" do
            @full_org_member.get_full_org_member_repositories
            test_equal(@full_org_member.github_repositories.length, 3)
            expect(terraform_files).to receive(:get_terraform_files).and_return([]).at_least(3).times
            test_equal(@full_org_member.mismatched_repository_permissions_check(terraform_files), false)
          end

          it "when github_repositories and terraform_files have repositories" do
            @full_org_member.get_full_org_member_repositories
            test_equal(@full_org_member.github_repositories.length, 3)
            file = create_empty_terraform_file
            expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(3).times
            test_equal(@full_org_member.mismatched_repository_permissions_check(terraform_files), false)
          end

          it "when github_repositories and terraform_files have repositories and permissions do not match" do
            @full_org_member.get_full_org_member_repositories
            test_equal(@full_org_member.github_repositories.length, 3)
            file = create_terraform_file_with_name(TEST_REPO_NAME1)
            expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
            expect(@full_org_member).to receive(:get_repository_permission).with(TEST_REPO_NAME1).and_return("push")
            expect(file).to receive(:get_collaborator_permission).with(TEST_USER_1).and_return("admin")
            test_equal(@full_org_member.mismatched_repository_permissions_check(terraform_files), true)
          end

          it "when github_repositories and terraform_files have repositories and permissions do match" do
            @full_org_member.get_full_org_member_repositories
            test_equal(@full_org_member.github_repositories.length, 3)
            file = create_terraform_file_with_name(TEST_REPO_NAME1)
            expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
            expect(@full_org_member).to receive(:get_repository_permission).with(TEST_REPO_NAME1).and_return("push")
            expect(file).to receive(:get_collaborator_permission).with(TEST_USER_1).and_return("push")
            test_equal(@full_org_member.mismatched_repository_permissions_check(terraform_files), false)
          end

          it "when github_repositories and terraform_files have repositories but repository is in the ignore list" do
            @full_org_member.add_ignore_repository(TEST_REPO_NAME1)
            @full_org_member.get_full_org_member_repositories
            test_equal(@full_org_member.github_repositories.length, 3)
            file = create_terraform_file_with_name(TEST_REPO_NAME1)
            expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
            test_equal(@full_org_member.mismatched_repository_permissions_check(terraform_files), false)
          end
        end
      end

      after do
        ENV.delete("OPS_BOT_TOKEN")
      end
    end
  end
end
