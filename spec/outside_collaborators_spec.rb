class GithubCollaborators
  describe OutsideCollaborators do
    let(:terraform_file) { double(GithubCollaborators::TerraformFile) }
    let(:terraform_files) { double(GithubCollaborators::TerraformFiles) }
    let(:organization) { double(GithubCollaborators::Organization) }

    context "test outside collaborators" do
      it "call start" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(terraform_files).not_to receive(:remove_file)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new

        expect(outside_collaborators).to receive(:remove_empty_files)
        expect(outside_collaborators).to receive(:archived_repository_check)
        expect(outside_collaborators).to receive(:compare_terraform_and_github)
        expect(outside_collaborators).to receive(:collaborator_checks)
        expect(outside_collaborators).to receive(:full_org_members_check)
        expect(outside_collaborators).to receive(:print_full_org_member_collaborators)
        outside_collaborators.start
      end

      it "call remove_empty_files when no empty file exists" do
        file = create_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(terraform_files).to receive(:get_empty_files).and_return([])
        expect(terraform_files).not_to receive(:remove_file)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.remove_empty_files
      end

      it "call remove_empty_files when empty file exists" do
        file = create_empty_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(terraform_files).to receive(:get_empty_files).and_return([EMPTY_REPOSITORY_NAME])
        expect(terraform_files).to receive(:remove_file).with(EMPTY_REPOSITORY_NAME)
        allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("delete-empty-files", ["terraform/empty-file.tf"], EMPTY_FILES_PR_TITLE, "", TYPE_DELETE)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.remove_empty_files
      end

      it "call remove_empty_files when empty file exists and pull request already exists" do
        file = create_empty_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(terraform_files).to receive(:get_empty_files).and_return([EMPTY_REPOSITORY_NAME])
        allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with("empty-file.tf", EMPTY_FILES_PR_TITLE).and_return(true)
        expect(terraform_files).not_to receive(:remove_file)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.remove_empty_files
      end

      it "call archived_repository_check when no terraform files exist" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([]).at_least(2).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(organization).to receive(:get_org_archived_repositories).and_return([])
        expect(terraform_files).not_to receive(:remove_file)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.archived_repository_check
      end

      it "call archived_repository_check when terraform files exist but isnt an archived file" do
        file = create_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(organization).to receive(:get_org_archived_repositories).and_return([])
        expect(terraform_files).not_to receive(:remove_file)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.archived_repository_check
      end

      it "call archived_repository_check when terraform files exist and is an archived file" do
        file = create_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(organization).to receive(:get_org_archived_repositories).and_return([TEST_REPO_NAME])
        expect(terraform_files).to receive(:remove_file).with(TEST_REPO_NAME)
        allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("delete-archived-repository-file", [TEST_FILE], ARCHIVED_REPOSITORY_PR_TITLE, "", TYPE_DELETE_ARCHIVE)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.archived_repository_check
      end

      it "call compare_terraform_and_github when no collaborators exist" do
        repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 0)
        repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 0)
        allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
        allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        my_organization = GithubCollaborators::Organization.new

        file = create_empty_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(1).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(my_organization).at_least(1).times
        expect(terraform_files).to receive(:get_collaborators_in_file).and_return([]).at_least(2).times
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.compare_terraform_and_github
      end

      it "call compare_terraform_and_github when collaborator is a full org member" do
        repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 0)
        repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 0)
        allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([TEST_USER_2])
        allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        my_organization = GithubCollaborators::Organization.new

        file = create_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(1).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(my_organization).at_least(1).times
        expect(terraform_files).to receive(:get_collaborators_in_file).and_return([TEST_USER_2]).at_least(2).times
        expect(my_organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new

        expect(my_organization).to receive(:is_collaborator_an_org_member).and_return(TEST_USER_2).at_least(1).times
        expect(outside_collaborators).not_to receive(:print_comparison)

        outside_collaborators.compare_terraform_and_github
      end

      it "call compare_terraform_and_github when collaborator lengths are different" do
        repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 2)
        repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 0)
        allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
        allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).with(TEST_REPO_NAME1).and_return([TEST_USER_3, TEST_USER_3])
        allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).with(TEST_REPO_NAME2).and_return([])
        allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        my_organization = GithubCollaborators::Organization.new

        file = create_terraform_file
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(1).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(my_organization).at_least(1).times
        expect(terraform_files).to receive(:get_collaborators_in_file).and_return([TEST_USER_1]).at_least(1).times
        expect(my_organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new

        expect(outside_collaborators).to receive(:print_comparison).with([TEST_USER_1], [TEST_USER_3, TEST_USER_3], TEST_REPO_NAME1)
        expect(outside_collaborators).to receive(:find_unknown_collaborators).with([TEST_USER_1], [TEST_USER_3, TEST_USER_3], TEST_REPO_NAME1).at_least(1).times.and_return([TEST_USER_1])
        expect(outside_collaborators).to receive(:create_unknown_collaborators).with([TEST_USER_1], TEST_REPO_NAME1)
        expect(outside_collaborators).to receive(:check_repository_invites).with(TEST_REPO_NAME1)
        expect(outside_collaborators).to receive(:print_comparison).with([TEST_USER_1], [], TEST_REPO_NAME2)
        expect(outside_collaborators).to receive(:find_unknown_collaborators).with([TEST_USER_1], [], TEST_REPO_NAME2).and_return([])
        expect(outside_collaborators).to receive(:check_repository_invites).with(TEST_REPO_NAME2)

        outside_collaborators.compare_terraform_and_github
      end

      # it "" do
      #   terraform_block = create_terraform_block_review_date_today
      #   expect(GithubCollaborators::TerraformBlock).to receive(:new).and_return(terraform_block)
      #   expect(terraform_block).to receive(:add_unknown_collaborator_data).with(TEST_USER_2)
    
      #   collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)        
      #   expect(GithubCollaborators::Collaborator).to receive(:new).and_return(collaborator)
      #   expect(collaborator).to receive(:add_issue).with("missing")        
      # end

      # it "call check_repository_invites" do
      #   allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
      #   expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
      #   expect(terraform_files).to receive(:get_terraform_files).and_return([])
      #   expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
      #   expect(organization).to receive(:create_full_org_members)
      #   expect(terraform_files).not_to receive(:remove_file)
      #   outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        
      #   outside_collaborators.check_repository_invites(TEST_REPO_NAME2)
      # end

    end
  end
end
