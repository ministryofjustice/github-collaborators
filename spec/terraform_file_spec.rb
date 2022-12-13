class GithubCollaborators
  describe TerraformFile do
    context "test TerraformFile" do
      original_file = File.read("spec/fixtures/test-repo.tf")
      collaborator1 = GithubCollaborators::FullOrgMember.new(TEST_COLLABORATOR_LOGIN)
      collaborator2 = GithubCollaborators::FullOrgMember.new(TEST_COLLABORATOR_LOGIN)
      collaborator1.add_info_from_file(TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_ORG)
      collaborator2.add_info_from_file(TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_ORG)
      review_date = (Date.today + 90).strftime(DATE_FORMAT)
      new_review_date = (Date.today + 180 + 90).strftime(DATE_FORMAT)

      it "call add_org_member_collaborator" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        terraform_file.add_org_member_collaborator(collaborator2, TEST_COLLABORATOR_PERMISSION)
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 2)
      end

      it "call extend_review_date and revert_terraform_blocks" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          test_equal(terraform_block.review_after, review_date)
        end
        terraform_file.extend_review_date(TEST_COLLABORATOR_LOGIN)
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          test_equal(terraform_block.review_after, new_review_date)
        end
        terraform_file.revert_terraform_blocks
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          test_equal(terraform_block.review_after, review_date)
        end
      end

      it "call remove_collaborator" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        terraform_file.add_org_member_collaborator(collaborator2, TEST_COLLABORATOR_PERMISSION)
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 2)
        terraform_file.remove_collaborator(TEST_COLLABORATOR_LOGIN)
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 1)
      end

      it "call get_collaborator_permission when collaborator exists" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        test_equal(terraform_file.get_collaborator_permission(TEST_COLLABORATOR_LOGIN), TEST_COLLABORATOR_PERMISSION)
      end

      it "call get_collaborator_permission when no collaborator exists" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        test_equal(terraform_file.get_collaborator_permission(TEST_COLLABORATOR_LOGIN), "")
      end

      it "call change_collaborator_permission and revert_terraform_blocks" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          test_equal(terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        end
        terraform_file.change_collaborator_permission(TEST_COLLABORATOR_LOGIN, "push")
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          test_equal(terraform_block.permission, "push")
        end
        terraform_file.revert_terraform_blocks
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          test_equal(terraform_block.permission, TEST_COLLABORATOR_PERMISSION)
        end
      end

      it "call get_repository_name" do
        File.write(TEST_FILE, original_file)
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        test_equal(terraform_file.get_repository_name, TEST_REPO_NAME)
        File.delete(TEST_FILE)
      end

      it "call get_repository_name when repo doesn't exist" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        test_equal(terraform_file.get_repository_name, "")
      end

      it "call create_terraform_collaborator_blocks" do
        File.write(TEST_FILE, original_file)
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.create_terraform_collaborator_blocks
        collaborators_in_file = []
        terraform_blocks = terraform_file.get_terraform_blocks
        terraform_blocks.each do |terraform_block|
          collaborators_in_file.push(terraform_block.username)
        end
        expected_collaborators = [TEST_USER_1, TEST_USER_2]
        test_equal(collaborators_in_file, expected_collaborators)
        File.delete(TEST_FILE)
      end

      it "call read_file when no file exists" do
        terraform_file = GithubCollaborators::TerraformFile.new("norepo", TERRAFORM_DIR)
        terraform_file.read_file
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 0)
      end

      it "call add_org_member_collaborator and restore_terraform_blocks" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 1)
        terraform_file.restore_terraform_blocks
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 0)
      end

      it "call remove_collaborator and restore_terraform_blocks" do
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        terraform_file.add_org_member_collaborator(collaborator2, TEST_COLLABORATOR_PERMISSION)
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 2)
        terraform_file.remove_collaborator(TEST_COLLABORATOR_LOGIN)
        terraform_file.restore_terraform_blocks
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 1)
      end

      it "call write_to_file" do
        expected_output = create_test_file_template
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.add_org_member_collaborator(collaborator1, TEST_COLLABORATOR_PERMISSION)
        expect(File).to receive(:write).with("terraform/test-repo.tf", expected_output)
        terraform_file.write_to_file
      end

      def create_test_file_template
        review_date = (Date.today + 90).strftime(DATE_FORMAT)
        template = <<~EOF
          module "test-repo" {
            source     = "./modules/repository-collaborators"
            repository = "test-repo"
            collaborators = [
              {
                github_user  = "someuser"
                permission   = "maintain"
                name         = "some user"
                email        = "someuser@some-email.com"
                org          = "some org"
                reason       = "Full Org member / collaborator missing from Terraform file"
                added_by     = "opseng-bot@digital.justice.gov.uk"
                review_after = "<%= review_date %>"
              },
            ]
          }
        EOF
        renderer = ERB.new(template, trim_mode: ">")
        renderer.result(binding)
      end
    end
  end
end
