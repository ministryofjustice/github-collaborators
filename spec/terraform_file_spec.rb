class GithubCollaborators
  include TestConstants
  include Constants

  describe TerraformFile do
    context "test TerraformFile" do
      context "" do
        before do
          @terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        end

        it "call get_collaborator_added_by when no collaborator exists" do
          test_equal(@terraform_file.get_collaborator_added_by(TEST_USER_1), "")
        end

        it "call add_collaborator_from_issue" do
          collaborator_data = create_collaborator_data("")
          terraform_blocks = @terraform_file.get_terraform_blocks
          test_equal(terraform_blocks.length, 0)
          @terraform_file.add_collaborator_from_issue(collaborator_data)
          terraform_blocks = @terraform_file.get_terraform_blocks
          test_equal(terraform_blocks.length, 1)
          @terraform_file.remove_collaborator(TEST_COLLABORATOR_LOGIN)
        end

        context "" do
          before do
            @review_date = Date.today.strftime(DATE_FORMAT)
            collaborator_data = create_collaborator_data(@review_date)
            collaborator_data[:login] = TEST_USER_1
            collaborator_data[:added_by] = TEST_COLLABORATOR_ADDED_BY
            @terraform_file.add_collaborator_from_issue(collaborator_data)
          end

          it "call extend_review_date and revert_terraform_blocks" do
            new_review_date = (Date.today + 180).strftime(DATE_FORMAT)
            terraform_blocks = @terraform_file.get_terraform_blocks
            terraform_blocks.each do |terraform_block|
              test_equal(terraform_block.review_after, @review_date)
            end
            @terraform_file.extend_review_date(TEST_USER_1)
            terraform_blocks = @terraform_file.get_terraform_blocks
            terraform_blocks.each do |terraform_block|
              test_equal(terraform_block.review_after, new_review_date)
            end
            @terraform_file.revert_terraform_blocks
            terraform_blocks = @terraform_file.get_terraform_blocks
            terraform_blocks.each do |terraform_block|
              test_equal(terraform_block.review_after, @review_date)
            end
          end

          it "call get_collaborator_added_by when collaborator exists" do
            test_equal(@terraform_file.get_collaborator_added_by(TEST_USER_1), TEST_COLLABORATOR_ADDED_BY)
          end

          it "call restore_terraform_blocks" do
            terraform_blocks_original = @terraform_file.get_terraform_blocks
            test_equal(terraform_blocks_original.length, 1)
            name = terraform_blocks_original[0].username
            @terraform_file.remove_collaborator(name)
            removed_terraform_blocks = @terraform_file.restore_terraform_blocks
            test_equal(removed_terraform_blocks.length, 0)
            terraform_blocks_restored = @terraform_file.get_terraform_blocks
            test_equal(terraform_blocks_original, terraform_blocks_restored)
          end

          it "call write_to_file" do
            expected_output = create_test_file_template
            expect(File).to receive(:write).with("#{TERRAFORM_DIR}/test-repo.tf", expected_output)
            @terraform_file.write_to_file
          end

          context "" do
            before do
              review_date = Date.today.strftime(DATE_FORMAT)
              collaborator_data = create_collaborator_data(review_date)
              collaborator_data[:login] = TEST_USER_2
              @terraform_file.add_collaborator_from_issue(collaborator_data)
            end

            it "call add_org_member_collaborator" do
              terraform_blocks = @terraform_file.get_terraform_blocks
              test_equal(terraform_blocks.length, 2)
            end

            it "call remove_collaborator" do
              terraform_blocks = @terraform_file.get_terraform_blocks
              test_equal(terraform_blocks.length, 2)
              @terraform_file.remove_collaborator(TEST_USER_1)
              terraform_blocks = @terraform_file.get_terraform_blocks
              test_equal(terraform_blocks.length, 1)
            end
          end
        end

        it "call create_terraform_collaborator_blocks" do
          original_file = File.read("spec/fixtures/test-repo.tf")
          File.write(TEST_FILE, original_file)
          @terraform_file.create_terraform_collaborator_blocks
          collaborators_in_file = []
          terraform_blocks = @terraform_file.get_terraform_blocks
          terraform_blocks.each do |terraform_block|
            collaborators_in_file.push(terraform_block.username)
          end
          expected_collaborators = [TEST_USER_1, TEST_USER_2]
          test_equal(collaborators_in_file, expected_collaborators)
          File.delete(TEST_FILE)
        end
      end

      it "call read_file when no file exists" do
        terraform_file = GithubCollaborators::TerraformFile.new("norepo", TERRAFORM_DIR)
        terraform_file.read_file
        terraform_blocks = terraform_file.get_terraform_blocks
        test_equal(terraform_blocks.length, 0)
      end

      def create_test_file_template
        review_date = Date.today.strftime(DATE_FORMAT)
        template = <<~EOF
          module "test-repo" {
            source     = "./modules/repository-collaborators"
            repository = "test-repo"
            collaborators = [
              {
                github_user  = "someuser1"
                permission   = "maintain"
                name         = "some user"
                email        = "someuser@some-email.com"
                org          = "some org"
                reason       = "some reason"
                added_by     = "other user"
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
