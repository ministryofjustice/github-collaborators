class GithubCollaborators
  include TestConstants
  include Constants

  describe TerraformBlock do
    context "test TerraformBlock" do
      before do
        @terraform_block = GithubCollaborators::TerraformBlock.new
        @review_date = Date.today.strftime(DATE_FORMAT)
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
        collaborator_data = create_collaborator_data(@review_date)
        @terraform_block.add_terraform_file_collaborator_data(collaborator_data)
        test_equal(@terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(@terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        test_equal(@terraform_block.name, TEST_COLLABORATOR_NAME)
        test_equal(@terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(@terraform_block.org, TEST_COLLABORATOR_ORG)
        test_equal(@terraform_block.reason, TEST_COLLABORATOR_REASON)
        test_equal(@terraform_block.added_by, TEST_COLLABORATOR_ADDED_BY)
        test_equal(@terraform_block.review_after, @review_date)
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

      it "call revert_block" do
        terraform_block = create_test_data(@review_date)
        test_equal(terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        test_equal(terraform_block.name, TEST_COLLABORATOR_NAME)
        test_equal(terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(terraform_block.org, TEST_COLLABORATOR_ORG)
        test_equal(terraform_block.reason, TEST_COLLABORATOR_REASON)
        test_equal(terraform_block.added_by, TEST_COLLABORATOR_ADDED_BY)
        test_equal(terraform_block.review_after, @review_date)
        terraform_block.revert_block(terraform_block)
        check_terraform_block_empty(terraform_block)
      end
    end
  end
end
