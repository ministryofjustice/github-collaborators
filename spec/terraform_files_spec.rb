class GithubCollaborators
  include TestConstants
  include Constants

  describe TerraformFiles do
    context "test TerraformFiles" do
      original_file = File.read("spec/fixtures/test-repo.tf")

      context "test files exist when posting to GitHub" do
        context "when env variable exists" do
          before do
            ENV["REALLY_POST_TO_GH"] = "1"
          end

          it "but no files exist" do
            stub_const(STUB_TERRAFORM_FILES, TEMP_TERRAFORM_FILES)
            expect { GithubCollaborators::TerraformFiles.new }.to raise_error(SystemExit)
          end

          it "and files exist" do
            terraform_files = GithubCollaborators::TerraformFiles.new
            expect { terraform_files }.not_to raise_error(SystemExit)
          end

          after do
            ENV.delete("REALLY_POST_TO_GH")
          end
        end

        context "when env variable doesn't exist" do
          before do
            ENV["REALLY_POST_TO_GH"] = "0"
          end

          it "but no files exist" do
            stub_const(STUB_TERRAFORM_FILES, TEMP_TERRAFORM_FILES)
            expect { terraform_files }.not_to raise_error(SystemExit)
          end

          it "and files exist" do
            terraform_files = GithubCollaborators::TerraformFiles.new
            expect { terraform_files }.not_to raise_error(SystemExit)
          end

          after do
            ENV.delete("REALLY_POST_TO_GH")
          end
        end
      end

      context "" do
        before do
          @terraform_files = GithubCollaborators::TerraformFiles.new
        end

        it "call get_terraform_files, create object and read terraform folder files" do
          files = Dir[TERRAFORM_FILES].length - EXCLUDE_FILES.length
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, files)
        end

        it "call create_new_file_in_memory" do
          files = Dir[TERRAFORM_FILES].length - EXCLUDE_FILES.length
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, files)
          @terraform_files.create_new_file_in_memory(TEST_REPO_NAME)
          new_file_length = files + 1
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, new_file_length)
        end

        it "call remove_file, don't remove file when file doesn't exist" do
          files = Dir[TERRAFORM_FILES].length - EXCLUDE_FILES.length
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, files)
          @terraform_files.remove_file(TEST_REPO_NAME)
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, files)
        end

        it "call does_file_exist when no empty files exist" do
          test_equal(@terraform_files.does_file_exist(TEST_REPO_NAME), false)
        end

        it "call ensure_file_exists_in_memory" do
          files = Dir[TERRAFORM_FILES].length - EXCLUDE_FILES.length
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, files)
          @terraform_files.ensure_file_exists_in_memory(TEST_REPO_NAME)
          new_file_length = files + 1
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, new_file_length)
        end
      end

      context "call get_empty_files" do
        it "when no empty files exist" do
          stub_const(STUB_TERRAFORM_FILES, TEMP_TERRAFORM_FILES)
          terraform_files = GithubCollaborators::TerraformFiles.new
          result = terraform_files.get_empty_files
          test_equal(result.length, 0)
        end

        it "when file exists" do
          stub_const(STUB_TERRAFORM_FILES, TEMP_TERRAFORM_FILES)
          empty_file = File.read("spec/fixtures/empty-file.tf")
          File.write("spec/tmp/empty-file.tf", empty_file)
          files = Dir["spec/tmp"].length
          terraform_files = GithubCollaborators::TerraformFiles.new
          the_terraform_files = terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, files)
          result = terraform_files.get_empty_files
          test_equal(result.length, 1)
          File.delete("spec/tmp/empty-file.tf")
        end
      end

      context "" do
        before do
          File.write(TEST_FILE, original_file)
          @files = Dir[TERRAFORM_FILES].length - EXCLUDE_FILES.length
          @terraform_files = GithubCollaborators::TerraformFiles.new
          @the_terraform_files = @terraform_files.get_terraform_files
          test_equal(@the_terraform_files.length, @files)
        end

        context "call does_file_exist" do
          it "when files exist" do
            test_equal(@terraform_files.does_file_exist(TEST_REPO_NAME), true)
          end

          it "when no match exists" do
            test_equal(@terraform_files.does_file_exist(TEST_REPO_NAME4), false)
          end
        end

        it "call remove_file when file exists" do
          @terraform_files.remove_file(TEST_REPO_NAME)
          new_file_length = @files - 1
          the_terraform_files = @terraform_files.get_terraform_files
          test_equal(the_terraform_files.length, new_file_length)
        end

        context "" do
          it "call extend_date_in_file" do
            @terraform_files.extend_date_in_file(TEST_REPO_NAME, TEST_USER_1)
            modified_file = File.read(TEST_FILE)
            test_not_equal(modified_file, original_file)
          end

          it "call remove_collaborator_from_file" do
            @terraform_files.remove_collaborator_from_file(TEST_REPO_NAME, TEST_USER_1)
            modified_file = File.read(TEST_FILE)
            test_not_equal(modified_file, original_file)
          end

          it "call ensure_file_exists_in_memory when file already exists" do
            @terraform_files.ensure_file_exists_in_memory(TEST_REPO_NAME)
            the_terraform_files = @terraform_files.get_terraform_files
            test_equal(the_terraform_files.length, @files)
          end

          it "call get_collaborators_in_file when file already exists" do
            test_equal(@the_terraform_files.length, @files)
            test_equal(@terraform_files.get_collaborators_in_file(TEST_REPO_NAME), [TEST_USER_1, TEST_USER_2])
          end

          it "call is_user_in_file when file already exists" do
            test_equal(@the_terraform_files.length, @files)
            test_equal(@terraform_files.is_user_in_file(TEST_REPO_NAME, TEST_USER_1), true)
          end

          after do
            File.delete(TEST_FILE)
          end
        end
      end

      it "call get_collaborators_in_file when file doesn't exist" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        test_equal(terraform_files.get_collaborators_in_file(TEST_REPO_NAME4), [])
      end

      it "call is_user_in_file when file doesn't exist" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        test_equal(terraform_files.is_user_in_file(TEST_REPO_NAME5, TEST_USER_1), false)
      end
    end
  end
end
