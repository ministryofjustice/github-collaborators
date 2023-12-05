class GithubCollaborators
  include TestConstants
  include Constants

  describe Organization do
    context "test organization" do
      before do
        allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
      end

      it "initialize object" do
        repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 5)
        repo3 = GithubCollaborators::Repository.new(TEST_REPO_NAME3, 0)
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo2, repo3])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([TEST_REPO_NAME1, TEST_REPO_NAME2])
        organization = GithubCollaborators::Organization.new
        test_equal(organization.repositories.length, 2)
        test_equal(organization.archived_repositories.length, 2)
        test_equal(organization.archived_repositories, [TEST_REPO_NAME1, TEST_REPO_NAME2])
      end

      repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 0)
      repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 0)

      context "" do
        before do
          allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
        end

        context "call get_repository_issues_from_github" do
          context "" do
            before do
              allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
              @organization = GithubCollaborators::Organization.new
            end

            it "when no repositories are passed in" do
              @organization.get_repository_issues_from_github([])
            end

            it "when repositories are passed in but no org repositories exist" do
              @organization.get_repository_issues_from_github([TEST_REPO_NAME1, TEST_REPO_NAME2])
            end
          end

          context "" do
            before do
              allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
              @organization = GithubCollaborators::Organization.new
            end

            it "when org repositories and repositories passed in exist but do not match" do
              @organization.get_repository_issues_from_github([TEST_REPO_NAME3, TEST_REPO_NAME4])
            end

            it "when org repositories and repositories passed in exist and match" do
              allow_any_instance_of(HelperModule).to receive(:get_issues_from_github).with(TEST_REPO_NAME1).and_return([])
              @organization.get_repository_issues_from_github([TEST_REPO_NAME3, TEST_REPO_NAME1])
            end
          end
        end

        context "call read_repository_issues" do
          it "when no repositories exist" do
            allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
            organization = GithubCollaborators::Organization.new
            issues = organization.read_repository_issues([TEST_REPO_NAME1])
            test_equal(issues, [])
          end

          context "" do
            before do
              allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
              @organization = GithubCollaborators::Organization.new
            end

            it "when org repositories exist but does not match function parameter" do
              issues = @organization.read_repository_issues(TEST_REPO_NAME3)
              test_equal(issues, [])
            end

            it "when org repositories exist and match function parameter but no issues exist" do
              allow_any_instance_of(HelperModule).to receive(:get_issues_from_github).with(TEST_REPO_NAME1).and_return([])
              @organization.get_repository_issues_from_github([])
              issues = @organization.read_repository_issues(TEST_REPO_NAME1)
              test_equal(issues, [])
            end

            it "when org repositories exist and match function parameter but no issues exist" do
              issue = %([{"assignee": { "login":#{TEST_USER}}, "title": #{COLLABORATOR_EXPIRES_SOON}, "assignees": [{"login":#{TEST_USER} }]}])
              allow_any_instance_of(HelperModule).to receive(:get_issues_from_github).with(TEST_REPO_NAME1).and_return([issue])
              @organization.get_repository_issues_from_github([TEST_REPO_NAME3, TEST_REPO_NAME1])
              issues = @organization.read_repository_issues(TEST_REPO_NAME1)
              test_equal(issues, [issue])
            end
          end
        end
      end

      context "" do
        before do
          allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
        end

        context "" do
          before do
            terraform_block = create_collaborator_with_login(TEST_USER_1)
            @collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
            terraform_block = create_collaborator_with_login(TEST_USER_2)
            @collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
            terraform_block = create_collaborator_with_login(TEST_USER_3)
            @collaborator3 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
          end

          context "" do
            before do
              @organization = GithubCollaborators::Organization.new
            end
          end
        end
      end

      it "call get_org_archived_repositories when there are archived_repositories" do
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([TEST_REPO_NAME1, TEST_REPO_NAME2])
        organization = GithubCollaborators::Organization.new
        test_equal(organization.get_org_archived_repositories.length, 2)
      end
    end
  end
end
