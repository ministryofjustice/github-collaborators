class GithubCollaborators
  describe TerraformBlock do
    context "test TerraformBlock" do

      def check_terraform_block_empty(terraform_block)
        test_equal(terraform_block.username, "")
        test_equal(terraform_block.permission, "")
        test_equal(terraform_block.name, "")
        test_equal(terraform_block.email, "")
        test_equal(terraform_block.org, "")
        test_equal(terraform_block.reason, "")
        test_equal(terraform_block.added_by, "")
        test_equal(terraform_block.review_after, "")
      end

      it "create terraform block" do
        terraform_block = GithubCollaborators::TerraformBlock.new
        check_terraform_block_empty(terraform_block)
      end

      it "create terraform block with empty data" do
        terraform_block = GithubCollaborators::TerraformBlock.new
        terraform_block.add_terraform_file_collaborator_data({})
        check_terraform_block_empty(terraform_block)
      end

      it "create terraform block with test data" do
        review_date = Date.today.strftime(DATE_FORMAT)
        collaborator_data = create_collaborator_data(review_date)
        terraform_block = GithubCollaborators::TerraformBlock.new
        terraform_block.add_terraform_file_collaborator_data(collaborator_data)
        test_equal(terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        test_equal(terraform_block.name, TEST_COLLABORATOR_NAME)
        test_equal(terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(terraform_block.org, TEST_COLLABORATOR_ORG)
        test_equal(terraform_block.reason, TEST_COLLABORATOR_REASON)
        test_equal(terraform_block.added_by, TEST_COLLABORATOR_ADDED_BY)
        test_equal(terraform_block.review_after, review_date)
      end

      it "call add_unknown_collaborator_data" do
        terraform_block = GithubCollaborators::TerraformBlock.new
        terraform_block.add_unknown_collaborator_data(TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block.permission, "")
        test_equal(terraform_block.name, "")
        test_equal(terraform_block.email, "")
        test_equal(terraform_block.org, "")
        test_equal(terraform_block.reason, "")
        test_equal(terraform_block.added_by, "")
        test_equal(terraform_block.review_after, "")
      end

      it "call add_org_member_collaborator_data" do
        review_date = (Date.today + 90).strftime(DATE_FORMAT)
        collaborator = GithubCollaborators::FullOrgMember.new(TEST_COLLABORATOR_LOGIN)
        collaborator.add_info_from_file(TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_ORG)
        terraform_block = GithubCollaborators::TerraformBlock.new
        terraform_block.add_org_member_collaborator_data(collaborator, TEST_COLLABORATOR_PERMISSION)
        test_equal(terraform_block.username, TEST_COLLABORATOR_LOGIN)
        test_equal(terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        test_equal(terraform_block.name, TEST_COLLABORATOR_NAME)
        test_equal(terraform_block.email, TEST_COLLABORATOR_EMAIL)
        test_equal(terraform_block.org, TEST_COLLABORATOR_ORG)
        test_equal(terraform_block.reason, REASON1)
        test_equal(terraform_block.added_by, ADDED_BY_EMAIL)
        test_equal(terraform_block.review_after, review_date)
      end

    end
  end
end
