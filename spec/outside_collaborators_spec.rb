class GithubCollaborators
  describe OutsideCollaborators do
    let(:terraform_file) { double(GithubCollaborators::TerraformFile) }
    let(:terraform_files) { double(GithubCollaborators::TerraformFiles) }
    let(:organization) { double(GithubCollaborators::Organization) }
    let(:odd_full_org_slack_message) { double(GithubCollaborators::OddFullOrgMembers) }
    let(:full_org_archived_repository_slack_message) { double(GithubCollaborators::ArchivedRepositories) }
    let(:helper_module) { Class.new { extend HelperModule } }

    # The tests below are nested. This is to reduce code duplication.
    # This is because it take alot of object to create the object under test.
    # The before do blocks contain expectations that are common within
    # the nested context block. Therefore consider the top level and
    # nested context block when reading the test code.

    context "test outside_collaborators" do
      before do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(GithubCollaborators::Organization).to receive(:new).and_return(organization).at_least(1).times
        expect(organization).to receive(:create_full_org_members)
      end

      terraform_block = create_terraform_block_review_date_yesterday
      expired_collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
      expired_collaborator.check_for_issues

      terraform_block = create_terraform_block_review_date_less_than_week
      collaborator_expires_this_week = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
      collaborator_expires_this_week.check_for_issues

      terraform_block = create_terraform_block_review_date_less_than_month
      collaborator_expires_soon = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
      collaborator_expires_soon.check_for_issues

      terraform_block = create_terraform_block_review_date_more_than_month
      collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
      collaborator1.check_for_issues

      terraform_block = create_collaborator_with_login(TEST_USER_2)
      collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)

      context "" do
        before do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
          @outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        end

        it "call start" do
          expect(@outside_collaborators).to receive(:remove_empty_files)
          expect(@outside_collaborators).to receive(:archived_repository_check)
          expect(@outside_collaborators).to receive(:compare_terraform_and_github)
          expect(@outside_collaborators).to receive(:collaborator_checks)
          expect(@outside_collaborators).to receive(:full_org_members_check)
          expect(@outside_collaborators).to receive(:print_full_org_member_collaborators)
          @outside_collaborators.start
        end

        it "call has_review_date_expired" do
          expect(@outside_collaborators).to receive(:find_collaborators_who_have_expired).with([collaborator1]).and_return([collaborator1])
          expect(@outside_collaborators).to receive(:remove_expired_collaborators).with([collaborator1])
          expect(@outside_collaborators).to receive(:remove_expired_full_org_members).with([collaborator1])
          @outside_collaborators.has_review_date_expired([collaborator1])
        end

        it "call is_review_date_within_a_week" do
          expect(@outside_collaborators).to receive(:find_collaborators_who_expire_soon).with([collaborator1]).and_return([collaborator1])
          expect(@outside_collaborators).to receive(:extend_collaborators_review_date).with([collaborator1])
          expect(@outside_collaborators).to receive(:extend_full_org_member_review_date).with([collaborator1])
          @outside_collaborators.is_review_date_within_a_week([collaborator1])
        end

        it "call find_collaborators_who_expire_soon when collaborator doesn't have the issue" do
          expire_soon_collaborators = @outside_collaborators.find_collaborators_who_expire_soon([collaborator1])
          test_equal(expire_soon_collaborators.length, 0)
        end

        it "call find_collaborators_who_expire_soon when collaborator has the issue" do
          expire_soon_collaborators = @outside_collaborators.find_collaborators_who_expire_soon([collaborator_expires_this_week])
          test_equal(expire_soon_collaborators, [collaborator_expires_this_week])
        end

        it "call find_collaborators_who_have_expired when collaborator doesn't have the issue" do
          expire_soon_collaborators = @outside_collaborators.find_collaborators_who_have_expired([collaborator1])
          test_equal(expire_soon_collaborators.length, 0)
        end

        it "call find_collaborators_who_have_expired when collaborator has the issue" do
          expire_soon_collaborators = @outside_collaborators.find_collaborators_who_have_expired([expired_collaborator])
          test_equal(expire_soon_collaborators, [expired_collaborator])
        end

        it "call extend_date when no collaborators" do
          extended_collaborators = @outside_collaborators.extend_date([])
          test_equal(extended_collaborators.length, 0)
        end
        
        it "call extend_date when pull request exists" do
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}").and_return(true)
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_USER_2}").and_return(true)
          extended_collaborators = @outside_collaborators.extend_date([collaborator1, collaborator_expires_soon, collaborator2])
          test_equal(extended_collaborators.length, 0)
        end

        it "call extend_date when pull request doesn't exist" do
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}").and_return(false)
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_USER_2}").and_return(false)
          expect(terraform_files).to receive(:extend_date_in_file).with(REPOSITORY_NAME, TEST_COLLABORATOR_LOGIN).at_least(2).times
          expect(terraform_files).to receive(:extend_date_in_file).with(REPOSITORY_NAME, TEST_USER_2).at_least(1).times
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("#{UPDATE_REVIEW_DATE_BRANCH_NAME}#{TEST_COLLABORATOR_LOGIN}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH], "#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}", TEST_COLLABORATOR_LOGIN, TYPE_EXTEND)
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("#{UPDATE_REVIEW_DATE_BRANCH_NAME}#{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH], "#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_USER_2}", TEST_USER_2, TYPE_EXTEND)
          expect(@outside_collaborators).to receive(:add_new_pull_request).with("#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH])
          expect(@outside_collaborators).to receive(:add_new_pull_request).with("#{EXTEND_REVIEW_DATE_PR_TITLE} #{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH])
          extended_collaborators = @outside_collaborators.extend_date([collaborator1, collaborator_expires_soon, collaborator2])
          test_equal(extended_collaborators.length, 3)
        end

        it "call remove_collaborator when no collaborators" do
          removed_collaborators = @outside_collaborators.remove_collaborator([])
          test_equal(removed_collaborators.length, 0)
        end

        it "call remove_collaborator when pull request exists" do
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}").and_return(true)
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_USER_2}").and_return(true)
          removed_collaborators = @outside_collaborators.remove_collaborator([collaborator1, collaborator_expires_soon, collaborator2])
          test_equal(removed_collaborators.length, 0)
        end

        it "call remove_collaborator when pull request doesn't exist" do
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}").and_return(false)
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_USER_2}").and_return(false)
          expect(terraform_files).to receive(:remove_collaborator_from_file).with(REPOSITORY_NAME, TEST_COLLABORATOR_LOGIN).at_least(2).times
          expect(terraform_files).to receive(:remove_collaborator_from_file).with(REPOSITORY_NAME, TEST_USER_2).at_least(1).times
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("#{REMOVE_EXPIRED_COLLABORATORS_BRANCH_NAME}#{TEST_COLLABORATOR_LOGIN}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH], "#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}", TEST_COLLABORATOR_LOGIN, TYPE_REMOVE)
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("#{REMOVE_EXPIRED_COLLABORATORS_BRANCH_NAME}#{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH], "#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_USER_2}", TEST_USER_2, TYPE_REMOVE)
          expect(@outside_collaborators).to receive(:add_new_pull_request).with("#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_COLLABORATOR_LOGIN}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH])
          expect(@outside_collaborators).to receive(:add_new_pull_request).with("#{REMOVE_EXPIRED_COLLABORATOR_PR_TITLE} #{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH])
          removed_collaborators = @outside_collaborators.remove_collaborator([collaborator1, collaborator_expires_soon, collaborator2])
          test_equal(removed_collaborators.length, 3)
        end

        it "call change_collaborator_permission when no repositories passed in" do
          @outside_collaborators.change_collaborator_permission(TEST_USER_2, [])
          expect(terraform_files).not_to receive(:ensure_file_exists_in_memory)
        end
        
        it "call change_collaborator_permission when pull request doesn't exist" do
          repositories = [
            { permission: "push", repository_name: REPOSITORY_NAME },
            { permission: "admin", repository_name: REPOSITORY_NAME },
            { permission: "pull", repository_name: REPOSITORY_NAME },
          ]
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}").and_return(false)
          expect(terraform_files).to receive(:ensure_file_exists_in_memory).with(REPOSITORY_NAME).at_least(3).times
          expect(terraform_files).to receive(:change_collaborator_permission_in_file).with(TEST_USER_2, REPOSITORY_NAME, "push")
          expect(terraform_files).to receive(:change_collaborator_permission_in_file).with(TEST_USER_2, REPOSITORY_NAME, "admin")
          expect(terraform_files).to receive(:change_collaborator_permission_in_file).with(TEST_USER_2, REPOSITORY_NAME, "pull")
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("#{MODIFY_COLLABORATORS_BRANCH_NAME}#{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH], "#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}", TEST_USER_2, TYPE_PERMISSION)
          expect(@outside_collaborators).to receive(:add_new_pull_request).with("#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH])
          @outside_collaborators.change_collaborator_permission(TEST_USER_2, repositories)
        end
        
        it "call change_collaborator_permission when a pull request does exist" do
          repositories = [
            { permission: "push", repository_name: REPOSITORY_NAME },
            { permission: "admin", repository_name: TEST_REPO_NAME },
            { permission: "pull", repository_name: REPOSITORY_NAME },
          ]
          expect(@outside_collaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}").and_return(false)
          expect(@outside_collaborators).to receive(:does_pr_already_exist).with(TEST_REPO_NAME_TERRAFORM_FILE, "#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}").and_return(true)
          expect(@outside_collaborators).to receive(:does_pr_already_exist).with(TEST_TERRAFORM_FILE, "#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}").and_return(false)
          expect(terraform_files).to receive(:ensure_file_exists_in_memory).with(REPOSITORY_NAME).at_least(2).times
          expect(terraform_files).to receive(:change_collaborator_permission_in_file).with(TEST_USER_2, REPOSITORY_NAME, "push")
          expect(terraform_files).to receive(:change_collaborator_permission_in_file).with(TEST_USER_2, REPOSITORY_NAME, "pull")
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("#{MODIFY_COLLABORATORS_BRANCH_NAME}#{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH], "#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}", TEST_USER_2, TYPE_PERMISSION)
          expect(@outside_collaborators).to receive(:add_new_pull_request).with("#{CHANGE_PERMISSION_PR_TITLE} #{TEST_USER_2}", [TEST_TERRAFORM_FILE_FULL_PATH, TEST_TERRAFORM_FILE_FULL_PATH])
          @outside_collaborators.change_collaborator_permission(TEST_USER_2, repositories)
        end
      end

      it "call remove_empty_files when no empty file exists" do
        file = create_terraform_file
        expect(terraform_files).to receive(:get_terraform_files).and_return([file])
        expect(terraform_files).to receive(:get_empty_files).and_return([])
        expect(terraform_files).not_to receive(:remove_file)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.remove_empty_files
      end

      context "call remove_empty_files with empty file" do
        before do
          file = create_empty_terraform_file
          expect(terraform_files).to receive(:get_terraform_files).and_return([file])
          expect(terraform_files).to receive(:get_empty_files).and_return([EMPTY_REPOSITORY_NAME])
          @outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        end

        it "when empty file exists" do
          expect(terraform_files).to receive(:remove_file).with(EMPTY_REPOSITORY_NAME)
          allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with(DELETE_EMPTY_FILE_BRANCH_NAME, ["terraform/empty-file.tf"], EMPTY_FILES_PR_TITLE, "", TYPE_DELETE)
          @outside_collaborators.remove_empty_files
        end

        it "when empty file exists and pull request already exists" do
          allow_any_instance_of(OutsideCollaborators).to receive(:does_pr_already_exist).with("empty-file.tf", EMPTY_FILES_PR_TITLE).and_return(true)
          expect(terraform_files).not_to receive(:remove_file)
          @outside_collaborators.remove_empty_files
        end
      end

      context "call archived_repository_check" do
        before do
          expect(organization).to receive(:get_org_archived_repositories).and_return([])
          expect(terraform_files).not_to receive(:remove_file)
        end

        it "when no terraform files exist" do
          expect(terraform_files).to receive(:get_terraform_files).and_return([]).at_least(2).times
          expect(terraform_files).not_to receive(:remove_file)
          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          outside_collaborators.archived_repository_check
        end

        it "when terraform files exist but isnt an archived file" do
          file = create_terraform_file
          expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          outside_collaborators.archived_repository_check
        end
      end

      it "call archived_repository_check when terraform files exist and is an archived file" do
        file = create_terraform_file
        expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(2).times
        expect(organization).to receive(:get_org_archived_repositories).and_return([TEST_REPO_NAME])
        expect(terraform_files).to receive(:remove_file).with(TEST_REPO_NAME)
        allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with(DELETE_ARCHIVE_FILE_BRANCH_NAME, [TEST_FILE], ARCHIVED_REPOSITORY_PR_TITLE, "", TYPE_DELETE_ARCHIVE)
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        outside_collaborators.archived_repository_check
      end

      it "call create_unknown_collaborators" do
        expect(terraform_files).to receive(:get_terraform_files).and_return([])
        outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        terraform_block = GithubCollaborators::TerraformBlock.new
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME2)
        expect(GithubCollaborators::TerraformBlock).to receive(:new).and_return(terraform_block)
        expect(GithubCollaborators::Collaborator).to receive(:new).with(terraform_block, TEST_REPO_NAME2).and_return(collaborator)
        expect(terraform_block).to receive(:add_unknown_collaborator_data).with(TEST_USER_1)
        expect(collaborator).to receive(:add_issue).with(MISSING)
        outside_collaborators.create_unknown_collaborators([TEST_USER_1], TEST_REPO_NAME2)
      end

      context "call check_repository_invites" do
        before do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
          expect(terraform_files).not_to receive(:delete_expired_invite)
          @outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        end

        it " when no invites exist" do
          allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return([])
          @outside_collaborators.check_repository_invites([], TEST_REPO_NAME2)
        end

        invite1 = {login: TEST_USER_1, expired: false, invite_id: 2344}
        invite2 = {login: TEST_USER_2, expired: false, invite_id: 7924}

        it "when invites exist but passed in array is empty" do
          invites = [invite1, invite2]
          allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
          @outside_collaborators.check_repository_invites([], TEST_REPO_NAME2)
        end

        it "call check_repository_invites when invites exist and passed in array has values" do
          invite2 = {login: TEST_USER_2, expired: false, invite_id: 7924}
          invites = [invite1, invite2]
          allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
          expect(terraform_files).not_to receive(:delete_expired_invite)
          @outside_collaborators.check_repository_invites([TEST_USER_1], TEST_REPO_NAME2)
        end

        it "call check_repository_invites when invites exist but has expired" do
          invite1 = {login: TEST_USER_1, expired: true, invite_id: 2344}
          invites = [invite1, invite2]
          allow_any_instance_of(HelperModule).to receive(:get_repository_invites).with(TEST_REPO_NAME2).and_return(invites)
          allow_any_instance_of(HelperModule).to receive(:delete_expired_invite).with(TEST_REPO_NAME2, TEST_USER_1)
          @outside_collaborators.check_repository_invites([TEST_USER_1], TEST_REPO_NAME2)
        end
      end

      context "call collaborator_checks" do
        it "when collaborator array is empty" do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          expect(outside_collaborators).to receive(:get_repository_issues_from_github).with([])
          expect(outside_collaborators).to receive(:is_review_date_within_a_week).with([])
          expect(outside_collaborators).to receive(:is_renewal_within_one_month).with([])
          expect(outside_collaborators).to receive(:remove_unknown_collaborators).with([])
          expect(outside_collaborators).to receive(:has_review_date_expired).with([])
          outside_collaborators.collaborator_checks
        end

        it "when there is a collaborator with an issue" do
          file = create_terraform_file_with_collaborator_issue
          expect(terraform_files).to receive(:get_terraform_files).and_return([file])

          review_date = (Date.today - 90).strftime(DATE_FORMAT)
          collaborator_data = create_collaborator_data(review_date)
          block1 = GithubCollaborators::TerraformBlock.new
          block1.add_terraform_file_collaborator_data(collaborator_data)
          expect(file).to receive(:get_terraform_blocks).and_return([block1])

          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          expect(outside_collaborators).to receive(:get_repository_issues_from_github).with([TEST_REPO_NAME_EXPIRED_USER])
          expect(outside_collaborators).to receive(:is_review_date_within_a_week).with([instance_of(GithubCollaborators::Collaborator)])
          expect(outside_collaborators).to receive(:is_renewal_within_one_month).with([instance_of(GithubCollaborators::Collaborator)])
          expect(outside_collaborators).to receive(:remove_unknown_collaborators).with([instance_of(GithubCollaborators::Collaborator)])
          expect(outside_collaborators).to receive(:has_review_date_expired).with([instance_of(GithubCollaborators::Collaborator)])
          outside_collaborators.collaborator_checks
        end
      end

      context "call full_org_members_check" do
        before do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
        end

        it "when full org member not in terraform file" do
          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          expect(organization).to receive(:get_full_org_members_not_in_terraform_file).and_return([TEST_USER_1])
          expect(organization).to receive(:get_full_org_members_with_repository_permission_mismatches).and_return([])
          expect(organization).to receive(:get_odd_full_org_members).and_return([])
          expect(organization).to receive(:get_full_org_members_attached_to_archived_repositories).and_return([])

          expect(outside_collaborators).to receive(:add_collaborator).with(TEST_USER_1)
          expect(outside_collaborators).not_to receive(:change_collaborator_permission)
          expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
          outside_collaborators.full_org_members_check
        end

        context "" do
          before do
            expect(organization).to receive(:get_full_org_members_not_in_terraform_file).and_return([])
          end

          it "when org and arrays are empty" do
            outside_collaborators = GithubCollaborators::OutsideCollaborators.new
            expect(organization).to receive(:get_full_org_members_with_repository_permission_mismatches).and_return([])
            expect(organization).to receive(:get_odd_full_org_members).and_return([])
            expect(organization).to receive(:get_full_org_members_attached_to_archived_repositories).and_return([])

            expect(outside_collaborators).not_to receive(:add_collaborator)
            expect(outside_collaborators).not_to receive(:change_collaborator_permission)
            expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
            outside_collaborators.full_org_members_check
          end

          it "when full org member has repository mismatches" do
            outside_collaborators = GithubCollaborators::OutsideCollaborators.new
            mismatch1 = {permission: "admin", repository_name: TEST_REPO_NAME1}
            mismatch2 = {permission: "push", repository_name: TEST_REPO_NAME2}
            mismatches = [mismatch1, mismatch2]
            member = {login: TEST_USER_1, mismatches: mismatches}
            expect(organization).to receive(:get_full_org_members_with_repository_permission_mismatches).and_return([member])
            expect(organization).to receive(:get_odd_full_org_members).and_return([])
            expect(organization).to receive(:get_full_org_members_attached_to_archived_repositories).and_return([])

            expect(outside_collaborators).not_to receive(:add_collaborator)
            expect(outside_collaborators).to receive(:change_collaborator_permission).with(TEST_USER_1, mismatches)
            expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
            outside_collaborators.full_org_members_check
          end

          it "when find a odd full org member" do
            outside_collaborators = GithubCollaborators::OutsideCollaborators.new
            expect(organization).to receive(:get_full_org_members_with_repository_permission_mismatches).and_return([])
            expect(organization).to receive(:get_odd_full_org_members).and_return([TEST_USER_1])
            expect(organization).to receive(:get_full_org_members_attached_to_archived_repositories).and_return([])

            expect(outside_collaborators).not_to receive(:add_collaborator)
            expect(outside_collaborators).not_to receive(:change_collaborator_permission)
            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::OddFullOrgMembers), [TEST_USER_1]).and_return(odd_full_org_slack_message)
            expect(odd_full_org_slack_message).to receive(:post_slack_message)
            expect(GithubCollaborators::SlackNotifier).not_to receive(:new)
            outside_collaborators.full_org_members_check
          end

          it "when full org member attached to archived repository" do
            outside_collaborators = GithubCollaborators::OutsideCollaborators.new

            expect(organization).to receive(:get_full_org_members_with_repository_permission_mismatches).and_return([])
            expect(organization).to receive(:get_odd_full_org_members).and_return([])
            member = {login: TEST_USER_1, repository: TEST_REPO_NAME1}
            expect(organization).to receive(:get_full_org_members_attached_to_archived_repositories).and_return([member])

            expect(outside_collaborators).not_to receive(:add_collaborator)
            expect(outside_collaborators).not_to receive(:change_collaborator_permission)
            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::ArchivedRepositories), [member]).and_return(full_org_archived_repository_slack_message)
            expect(full_org_archived_repository_slack_message).to receive(:post_slack_message)
            outside_collaborators.full_org_members_check
          end
        end
      end

      context "functions that have a collaborators parameter" do
        before do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
          allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
          @my_organization = GithubCollaborators::Organization.new
          @outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        end

        slack_notififer = GithubCollaborators::SlackNotifier.new(nil, [])

        context "call extend_collaborators_review_date" do
          # it "call remove_unknown_collaborators" do
          #   outside_collaborators = GithubCollaborators::OutsideCollaborators.new

          #   @outside_collaborators.
          # end
        end

        context "call extend_collaborators_review_date" do
          it "when no collaborator is passed in" do
            expect(@outside_collaborators).not_to receive(:extend_date)
            @outside_collaborators.extend_collaborators_review_date([])
          end

          it "when collaborator is a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(true)
            expect(@outside_collaborators).not_to receive(:extend_date)
            @outside_collaborators.extend_collaborators_review_date([collaborator1])
          end

          it "when collaborator is not a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(false)
            expect(@outside_collaborators).to receive(:extend_date).with([collaborator1]).and_return([collaborator1])

            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::ExpiresSoon), [collaborator1]).and_return(slack_notififer)
            expect(slack_notififer).to receive(:post_slack_message)

            @outside_collaborators.extend_collaborators_review_date([collaborator1])
          end
        end

        context "call extend_full_org_member_review_date" do
          it "when no collaborator is passed in" do
            expect(@outside_collaborators).not_to receive(:extend_date)
            @outside_collaborators.extend_full_org_member_review_date([])
          end

          it "when collaborator is not a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(false)
            expect(@outside_collaborators).not_to receive(:extend_date)
            @outside_collaborators.extend_full_org_member_review_date([collaborator1])
          end

          it "when collaborator is a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(true)
            expect(@outside_collaborators).to receive(:extend_date).with([collaborator1]).and_return([collaborator1])
            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::FullOrgMemberExpiresSoon), [collaborator1]).and_return(slack_notififer)
            expect(slack_notififer).to receive(:post_slack_message)
            @outside_collaborators.extend_full_org_member_review_date([collaborator1])
          end
        end

        context "call remove_expired_full_org_members" do
          it "when no collaborator is passed in" do
            expect(@outside_collaborators).not_to receive(:remove_collaborator)
            @outside_collaborators.remove_expired_full_org_members([])
          end

          it "when collaborator is not a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(false)
            expect(@outside_collaborators).not_to receive(:remove_collaborator)
            @outside_collaborators.remove_expired_full_org_members([collaborator1])
          end

          it "when collaborator is a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(true)
            expect(@outside_collaborators).to receive(:remove_collaborator).with([collaborator1]).and_return([collaborator1])
            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::FullOrgMemberExpired), [collaborator1]).and_return(slack_notififer)
            expect(slack_notififer).to receive(:post_slack_message)

            @outside_collaborators.remove_expired_full_org_members([collaborator1])
          end
        end

        context "call remove_expired_collaborators" do
          it "when no collaborator passed to function exist" do
            expect(@outside_collaborators).not_to receive(:remove_collaborator)
            @outside_collaborators.remove_expired_collaborators([])
          end

          it "when collaborator is a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(true)
            expect(@outside_collaborators).not_to receive(:remove_collaborator)
            @outside_collaborators.remove_expired_collaborators([collaborator1])
          end

          it "when collaborator is not a full org collaborator" do
            expect(@my_organization).to receive(:is_collaborator_an_org_member).with(collaborator1.login).and_return(false)
            expect(@outside_collaborators).to receive(:remove_collaborator).with([collaborator1]).and_return([collaborator1])
            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::Expired), [collaborator1]).and_return(slack_notififer)
            expect(slack_notififer).to receive(:post_slack_message)
            @outside_collaborators.remove_expired_collaborators([collaborator1])
          end
        end
      end

      context "call is_renewal_within_one_month" do
        before do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
          @outside_collaborators = GithubCollaborators::OutsideCollaborators.new
        end

        it "when collaborator issue is not renewal within a month" do
          terraform_block = create_terraform_block_review_date_more_than_month
          collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
          collaborator1.check_for_issues

          expect(@outside_collaborators).to receive(:read_repository_issues).with(REPOSITORY_NAME).and_return([])
          expect(@outside_collaborators).not_to receive(:create_review_date_expires_soon_issue)
          @outside_collaborators.is_renewal_within_one_month([collaborator1])
        end

        it "when collaborator issue is renewal within a month and no issue already exists" do
          expect(@outside_collaborators).to receive(:read_repository_issues).with(REPOSITORY_NAME).and_return([])
          allow_any_instance_of(HelperModule).to receive(:does_issue_already_exist).and_return(false)
          expect(@outside_collaborators).to receive(:create_review_date_expires_soon_issue).with(TEST_USER, REPOSITORY_NAME)
          @outside_collaborators.is_renewal_within_one_month([collaborator_expires_soon])
        end

        it "when collaborator issue is renewal within a month but issue already exists" do
          expect(@outside_collaborators).to receive(:read_repository_issues).with(REPOSITORY_NAME).and_return([])
          allow_any_instance_of(HelperModule).to receive(:does_issue_already_exist).and_return(true)
          expect(@outside_collaborators).not_to receive(:create_review_date_expires_soon_issue)
          @outside_collaborators.is_renewal_within_one_month([collaborator1])
        end
      end
    end

    context "test outside_collaborators" do
      before do
        allow_any_instance_of(HelperModule).to receive(:get_pull_requests).and_return([])
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
      end

      context "call compare_terraform_and_github with repo with no collaborators" do
        before do
          allow_any_instance_of(HelperModule).to receive(:get_org_outside_collaborators).and_return([])
          allow_any_instance_of(HelperModule).to receive(:fetch_all_collaborators).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_archived_repositories).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_all_org_members_team_repositories).and_return([])
        end

        repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 0)
        repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 0)

        it "when no collaborators exist" do
          allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([])
          allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
          my_organization = GithubCollaborators::Organization.new
          expect(GithubCollaborators::Organization).to receive(:new).and_return(my_organization).at_least(1).times
          expect(my_organization).to receive(:create_full_org_members)

          file = create_empty_terraform_file
          expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(1).times
          expect(terraform_files).to receive(:get_collaborators_in_file).and_return([]).at_least(2).times
          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          outside_collaborators.compare_terraform_and_github
        end

        it "when collaborator is a full org member" do
          allow_any_instance_of(HelperModule).to receive(:get_all_organisation_members).and_return([TEST_USER_2])
          allow_any_instance_of(HelperModule).to receive(:get_active_repositories).and_return([repo1, repo2])
          my_organization = GithubCollaborators::Organization.new

          file = create_terraform_file
          expect(terraform_files).to receive(:get_terraform_files).and_return([file]).at_least(1).times
          expect(GithubCollaborators::Organization).to receive(:new).and_return(my_organization).at_least(1).times
          expect(terraform_files).to receive(:get_collaborators_in_file).and_return([TEST_USER_2]).at_least(2).times
          expect(my_organization).to receive(:create_full_org_members)

          outside_collaborators = GithubCollaborators::OutsideCollaborators.new
          expect(my_organization).to receive(:is_collaborator_an_org_member).and_return(TEST_USER_2).at_least(1).times
          expect(@outside_collaborators).not_to receive(:print_comparison)
          outside_collaborators.compare_terraform_and_github
        end
      end

      it "call compare_terraform_and_github when repository collaborator lengths are different" do
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
    end
  end
end
