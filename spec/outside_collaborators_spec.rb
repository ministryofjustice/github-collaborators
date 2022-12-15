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

        invite1 = {login: TEST_USER_2, expired: false, invite_id: 2344}
        invites = [invite1]
        allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME1).and_return(invites)
        allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
        expect(terraform_files).not_to receive(:delete_expired_invite)

        expect(outside_collaborators).to receive(:print_comparison).with([TEST_USER_1], [], TEST_REPO_NAME2)
        expect(outside_collaborators).to receive(:find_unknown_collaborators).with([TEST_USER_1], [], TEST_REPO_NAME2).and_return([])

        slack_notififer = GithubCollaborators::SlackNotifier.new(nil, [])
        expect(GithubCollaborators::SlackNotifier).to receive(:new).and_return(slack_notififer)
        expect(slack_notififer).to receive(:post_slack_message)

        outside_collaborators.compare_terraform_and_github
      end

      it "call create_unknown_collaborators" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        terraform_block = GithubCollaborators::TerraformBlock.new
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME2)

        expect(GithubCollaborators::TerraformBlock).to receive(:new).and_return(terraform_block)
        expect(GithubCollaborators::Collaborator).to receive(:new).with(terraform_block, TEST_REPO_NAME2).and_return(collaborator)
        expect(terraform_block).to receive(:add_unknown_collaborator_data).with(TEST_USER_1)
        expect(collaborator).to receive(:add_issue).with("missing")
        outside_collaborators.create_unknown_collaborators([TEST_USER_1], TEST_REPO_NAME2)
      end

      it "call check_repository_invites when no invites exist" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return([])
        expect(terraform_files).not_to receive(:delete_expired_invite)
        outside_collaborators.check_repository_invites([], TEST_REPO_NAME2)
      end

      it "call check_repository_invites when invites exist but passed in array is empty" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        invite1 = {login: TEST_USER_1, expired: false, invite_id: 2344}
        invite2 = {login: TEST_USER_2, expired: false, invite_id: 7924}
        invites = [invite1, invite2]
        allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
        expect(terraform_files).not_to receive(:delete_expired_invite)
        outside_collaborators.check_repository_invites([], TEST_REPO_NAME2)
      end

      it "call check_repository_invites when invites exist and passed in array has values" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        invite1 = {login: TEST_USER_1, expired: false, invite_id: 2344}
        invite2 = {login: TEST_USER_2, expired: false, invite_id: 7924}
        invites = [invite1, invite2]
        allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
        expect(terraform_files).not_to receive(:delete_expired_invite)
        outside_collaborators.check_repository_invites([TEST_USER_1], TEST_REPO_NAME2)
      end

      it "call check_repository_invites when invites exist but has expired" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        invite1 = {login: TEST_USER_1, expired: true, invite_id: 2344}
        invite2 = {login: TEST_USER_2, expired: false, invite_id: 7924}
        invites = [invite1, invite2]
        allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
        allow_any_instance_of(HelperModule).to receive(:delete_expired_invite).with(TEST_REPO_NAME2, TEST_USER_1)
        outside_collaborators.check_repository_invites([TEST_USER_1], TEST_REPO_NAME2)
      end

      it "call collaborator_checks when collaborator array is empty" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        expect(outside_collaborators).to receive(:get_repository_issues_from_github).with([])
        expect(outside_collaborators).to receive(:is_review_date_within_a_week).with([])
        expect(outside_collaborators).to receive(:is_renewal_within_one_month).with([])
        expect(outside_collaborators).to receive(:remove_unknown_collaborators).with([])
        expect(outside_collaborators).to receive(:has_review_date_expired).with([])
        outside_collaborators.collaborator_checks
      end

      it "call collaborator_checks when there is a collaborator with an issue" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times

        file = create_terraform_file_with_collaborator_issue
        expect(terraform_files).to receive(:get_terraform_files).and_return([file])

        review_date = (Date.today - 90).strftime(DATE_FORMAT)
        collaborator_data = create_collaborator_data(review_date)
        block1 = GithubCollaborators::TerraformBlock.new
        block1.add_terraform_file_collaborator_data(collaborator_data)
        expect(file).to receive(:get_terraform_blocks).and_return([block1])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)

        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        expect(outside_collaborators).to receive(:get_repository_issues_from_github).with([TEST_REPO_NAME_EXPIRED_USER])
        expect(outside_collaborators).to receive(:is_review_date_within_a_week).with([instance_of(GithubCollaborators::Collaborator)])
        expect(outside_collaborators).to receive(:is_renewal_within_one_month).with([instance_of(GithubCollaborators::Collaborator)])
        expect(outside_collaborators).to receive(:remove_unknown_collaborators).with([instance_of(GithubCollaborators::Collaborator)])
        expect(outside_collaborators).to receive(:has_review_date_expired).with([instance_of(GithubCollaborators::Collaborator)])
        outside_collaborators.collaborator_checks
      end

      it "call full_org_members_check when org and arrays are empty" do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
        expect(terraform_files).not_to receive(:remove_file)
 
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new

        expect(organization).to receive(:get_full_org_members_not_in_terraform_file).and_return([])
        expect(organization).to receive(:get_full_org_members_with_repository_permission_mismatches).and_return([])
        expect(organization).to receive(:get_odd_full_org_members).and_return([])
        expect(organization).to receive(:get_full_org_members_attached_to_archived_repositories).and_return([])
        
        expect(outside_collaborators).not_to receive(:add_collaborator)
        expect(outside_collaborators).not_to receive(:change_collaborator_permission)
        expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
        expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
        outside_collaborators.full_org_members_check
      end

    #   it "call full_org_members_check when full org member exists" do
    #     repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 0)
    #     repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 0)
    #     allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
    #     allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
    #     allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).and_return([])
    #     allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
    #     allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
    #     allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
    #     my_organization = GithubCollaborators::Organization.new
    #     my_organization.add_full_org_member(TEST_USER_1)

    #     allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
    #     expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
    #     expect(terraform_files).to receive(:get_terraform_files).and_return([])
    #     expect(GithubCollaborators::Organization).to receive(:new).and_return(my_organization).at_least(1).times
    #     expect(my_organization).to receive(:create_full_org_members)


    #     outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        
    #     expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
    #     outside_collaborators.full_org_members_check
    #   end
    end
  end
end
