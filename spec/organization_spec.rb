class GithubCollaborators
  describe Organization do
    context "test organization" do
      before do
        allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
      end

      it "initialize object" do
        repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 5)
        repo3 = GithubCollaborators::Repository.new(TEST_REPO_NAME3, 0)
        allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
        allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).and_return([TEST_USER_1, TEST_USER_2, TEST_USER_3])
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo2, repo3])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([TEST_REPO_NAME1, TEST_REPO_NAME2])
        allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        organization = GithubCollaborators::Organization.new
        test_equal(organization.repositories.length, 2)
        test_equal(organization.full_org_members.length, 0)
        test_equal(organization.archived_repositories.length, 2)
        test_equal(organization.archived_repositories, [TEST_REPO_NAME1, TEST_REPO_NAME2])
      end

      context "" do
        before do
          allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        end

        context "" do
          before do
            allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([TEST_USER_1, TEST_USER_2])
            @organization = GithubCollaborators::Organization.new
          end

          it "call is_collaborator_an_org_member when collaborator is not an org member" do
            test_equal(@organization.is_collaborator_an_org_member(TEST_USER_6), false)
          end

          it "call is_collaborator_an_org_member when collaborator is an org member" do
            test_equal(@organization.is_collaborator_an_org_member(TEST_USER_2), true)
          end
        end

        context "" do
          before do
            allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
            @organization = GithubCollaborators::Organization.new
          end

          it "call is_collaborator_a_full_org_member when array is empty" do
            test_equal(@organization.is_collaborator_a_full_org_member(TEST_USER_2), false)
          end

          it "call is_collaborator_a_full_org_member when array has collaborators " do
            @organization.add_full_org_member(TEST_USER_1)
            @organization.add_full_org_member(TEST_USER_2)
            test_equal(@organization.is_collaborator_a_full_org_member(TEST_USER_2), true)
          end
        end

        terraform_block = create_collaborator_with_login(TEST_USER_1)
        collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
        terraform_block = create_collaborator_with_login(TEST_USER_2)
        collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
        terraform_block = create_collaborator_with_login(TEST_USER_3)
        collaborator3 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)

        context "" do
          before do
            allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:get_full_org_member_repositories)
          end

          context "" do
            before do
              allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:get_full_org_member_repositories)
              allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
              @organization = GithubCollaborators::Organization.new
            end

            it "call create_full_org_members when collaborators are not org members" do
              @organization.create_full_org_members([collaborator1, collaborator2, collaborator3])
              test_equal(@organization.full_org_members.length, 0)
            end

            it "call get_org_archived_repositories when empty" do
              test_equal(@organization.get_org_archived_repositories.length, 0)
            end
          end

          it "call create_full_org_members when collaborators are org members and names are the same" do
            allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([TEST_USER_1])
            organization = GithubCollaborators::Organization.new
            organization.create_full_org_members([collaborator1, collaborator1, collaborator1])
            test_equal(organization.full_org_members.length, 1)
          end

          it "call create_full_org_members when collaborators are org members and names are different" do
            allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([TEST_USER_1, TEST_USER_2, TEST_USER_3])
            organization = GithubCollaborators::Organization.new
            organization.create_full_org_members([collaborator1, collaborator2, collaborator3])
            test_equal(organization.full_org_members.length, 3)
          end
        end
      end

      it "call get_org_archived_repositories when there are archived_repositories" do
        allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([TEST_REPO_NAME1, TEST_REPO_NAME2])
        allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:get_full_org_member_repositories)
        organization = GithubCollaborators::Organization.new
        test_equal(organization.get_org_archived_repositories.length, 2)
      end
    end
  end
end
