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

            it "call get_full_org_members_not_in_terraform_file when no full org members" do
              test_equal(@organization.get_full_org_members_not_in_terraform_file, [])
            end

            it "call get_full_org_members_with_repository_permission_mismatches when no full org members" do
              test_equal(@organization.get_full_org_members_with_repository_permission_mismatches(nil), [])
            end

            it "call get_odd_full_org_members when no full org members" do
              test_equal(@organization.get_odd_full_org_members, [])
            end
            
            it "call get_full_org_members_attached_to_archived_repositories when no full org members" do
              test_equal(@organization.get_full_org_members_attached_to_archived_repositories(nil), [])
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

          context "" do
            before do
              allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([TEST_USER_1, TEST_USER_2, TEST_USER_3])
              @organization = GithubCollaborators::Organization.new
              @organization.create_full_org_members([collaborator1, collaborator2, collaborator3])
              test_equal(@organization.full_org_members.length, 3)
            end

            context "call get_full_org_members_with_repository_permission_mismatches" do
              it "when collaborator permissions do not match" do
                allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:check_repository_permissions_match).and_return(false)
                test_equal(@organization.get_full_org_members_with_repository_permission_mismatches(nil), [])
              end

              it "when collaborator permissions do match" do
                allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:check_repository_permissions_match).and_return(true)
                result = @organization.get_full_org_members_with_repository_permission_mismatches(nil)
                test_equal(result.length, 3)
                expected_collaborators = [{login:TEST_USER_1, mismatches:[]}, {login:TEST_USER_2, mismatches:[]}, {login:TEST_USER_3, mismatches:[]}]
                test_equal(result, expected_collaborators)
              end
            end

            context "call get_full_org_members_not_in_terraform_file" do
              it "when collaborators are defined in terraform file" do
                allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:do_repositories_match).and_return(true)
                test_equal(@organization.get_full_org_members_not_in_terraform_file, [])
              end

              it "when collaborators are not defined in terraform file" do
                allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:do_repositories_match).and_return(false)
                test_equal(@organization.get_full_org_members_not_in_terraform_file.length, 3)
              end
            end

            context "call get_odd_full_org_members" do
              it "when collaborators are odd" do
                allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:odd_full_org_member_check).and_return(false)
                test_equal(@organization.get_odd_full_org_members, [])
              end

              it "when collaborators are not odd" do
                allow_any_instance_of(GithubCollaborators::FullOrgMember).to receive(:odd_full_org_member_check).and_return(true)
                result = @organization.get_odd_full_org_members
                test_equal(result, [TEST_USER_1, TEST_USER_2, TEST_USER_3])
              end
            end

            context "call get_full_org_members_attached_to_archived_repositories" do
              let(:terraform_files) { double(GithubCollaborators::TerraformFiles) }

              it "when full org member has no archived repositories" do
                test_equal(@organization.get_full_org_members_attached_to_archived_repositories(nil), [])
              end

              it "when full org member has archived repositories but the file doesn't exist" do
                @organization.full_org_members.each do |full_org_member|
                  full_org_member.add_attached_archived_repository(TEST_REPO_NAME1)
                  full_org_member.add_attached_archived_repository(TEST_REPO_NAME2)
                end
                expect(terraform_files).to receive(:does_file_exist).and_return(false).at_least(6).times
                result = @organization.get_full_org_members_attached_to_archived_repositories(terraform_files)
                test_equal(result, [])
              end

              it "when full org member has archived repositories and the file does exist" do
                @organization.full_org_members.each do |full_org_member|
                  full_org_member.add_attached_archived_repository(TEST_REPO_NAME1)
                  full_org_member.add_attached_archived_repository(TEST_REPO_NAME2)
                end
                expect(terraform_files).to receive(:does_file_exist).and_return(true).at_least(6).times
                result = @organization.get_full_org_members_attached_to_archived_repositories(terraform_files)
                expected_result = [
                  {:login=>TEST_USER_1, :repository=>TEST_REPO_NAME1},
                  {:login=>TEST_USER_1, :repository=>TEST_REPO_NAME2},
                  {:login=>TEST_USER_2, :repository=>TEST_REPO_NAME1},
                  {:login=>TEST_USER_2, :repository=>TEST_REPO_NAME2},
                  {:login=>TEST_USER_3, :repository=>TEST_REPO_NAME1},
                  {:login=>TEST_USER_3, :repository=>TEST_REPO_NAME2}]
                test_equal(result, expected_result)
              end
            end
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
