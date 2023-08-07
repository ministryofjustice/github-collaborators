class GithubCollaborators
  include TestConstants
  include Constants

  describe TerraformBlock do
    context "test TerraformBlock" do
      before do
        @terraform_block = GithubCollaborators::TerraformBlock.new
        @review_date = (Date.today + 90).strftime(DATE_FORMAT)
      end

      def check_terraform_block_empty(terraform_block)
        test_equal(@terraform_block.username, "")
        test_equal(@terraform_block.permission, "")
        test_equal(@terraform_block.name, "")
        test_equal(@terraform_block.email, "")
        test_equal(@terraform_block.org, "")
        test_equal(@terraform_block.reason, "")
        test_equal(@terraform_block.added_by, "")
        test_equal(@terraform_block.review_after, "")
      end

      it "call check_terraform_block_empty" do
        check_terraform_block_empty(@terraform_block)
      end

      it "call check_terraform_block_empty with empty data" do
        @terraform_block.add_terraform_file_collaborator_data({})
        check_terraform_block_empty(@terraform_block)
      end

      it "call add_terraform_file_collaborator_data" do
        review_date = Date.today.strftime(DATE_FORMAT)
        collaborator_data = create_collaborator_data(review_date)
        @terraform_block.add_terraform_file_collaborator_data(collaborator_data)
        test_equal(@terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        test_equal(@terraform_block.name, TEST_COLLABORATOR_NAME)
        test_equal(@terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(@terraform_block.org, TEST_COLLABORATOR_ORG)
        test_equal(@terraform_block.reason, TEST_COLLABORATOR_REASON)
        test_equal(@terraform_block.added_by, TEST_COLLABORATOR_ADDED_BY)
        test_equal(@terraform_block.review_after, review_date)
      end

      it "call add_collaborator_email_address" do
        @terraform_block.add_collaborator_email_address(TEST_COLLABORATOR_EMAIL)
        test_equal(@terraform_block.username, "")
        test_equal(@terraform_block.permission, "")
        test_equal(@terraform_block.name, "")
        test_equal(@terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(@terraform_block.org, "")
        test_equal(@terraform_block.reason, "")
        test_equal(@terraform_block.added_by, "")
        test_equal(@terraform_block.review_after, "")
      end

      it "call add_unknown_collaborator_data" do
        @terraform_block.add_unknown_collaborator_data(TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.permission, "")
        test_equal(@terraform_block.name, "")
        test_equal(@terraform_block.email, "")
        test_equal(@terraform_block.org, "")
        test_equal(@terraform_block.reason, "")
        test_equal(@terraform_block.added_by, "")
        test_equal(@terraform_block.review_after, "")
      end

      it "call add_org_member_collaborator_data" do
        collaborator = GithubCollaborators::FullOrgMember.new(TEST_COLLABORATOR_LOGIN)
        collaborator.add_info_from_file(TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_ORG)
        @terraform_block.add_org_member_collaborator_data(collaborator, TEST_COLLABORATOR_PERMISSION)
        test_equal(@terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        test_equal(@terraform_block.name, TEST_COLLABORATOR_NAME)
        test_equal(@terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(@terraform_block.org, TEST_COLLABORATOR_ORG)
        test_equal(@terraform_block.reason, REASON1)
        test_equal(@terraform_block.added_by, ADDED_BY_EMAIL)
        test_equal(@terraform_block.review_after, @review_date)
      end

      it "call add_missing_collaborator_data" do
        @terraform_block.add_missing_collaborator_data(TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.permission, "")
        test_equal(@terraform_block.name, "")
        test_equal(@terraform_block.email, "")
        test_equal(@terraform_block.org, "")
        test_equal(@terraform_block.reason, REASON2)
        test_equal(@terraform_block.added_by, ADDED_BY_EMAIL)
        test_equal(@terraform_block.review_after, @review_date)
      end

      it "call revert_block" do
        @terraform_block.add_terraform_file_collaborator_data({})
        check_terraform_block_empty(@terraform_block)
        terraform_block2 = GithubCollaborators::TerraformBlock.new
        terraform_block2.add_missing_collaborator_data(TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block2.username, TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block2.permission, "")
        test_equal(terraform_block2.name, "")
        test_equal(terraform_block2.email, "")
        test_equal(terraform_block2.org, "")
        test_equal(terraform_block2.reason, REASON2)
        test_equal(terraform_block2.added_by, ADDED_BY_EMAIL)
        test_equal(terraform_block2.review_after, @review_date)
        terraform_block2.revert_block(@terraform_block)
        check_terraform_block_empty(terraform_block2)
      end
    end
  end
end
