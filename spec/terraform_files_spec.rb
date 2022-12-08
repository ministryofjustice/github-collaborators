class GithubCollaborators
  describe TerraformFiles do
    context "test TerraformFiles" do

      original_file = File.read("spec/fixtures/test-repo.tf")

      it "create object and read terraform folder files" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        expect(terraform_files.terraform_files.length).to eq(files)
      end

      it "call create_new_file_in_memory" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.create_new_file_in_memory(TEST_REPO_NAME)
        new_file_length = files + 1
        expect(terraform_files.terraform_files.length).to eq(new_file_length)
      end

      it "dont remove file when file doesn't exist" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.remove_file(TEST_REPO_NAME)
        expect(terraform_files.terraform_files.length).to eq(files)
      end

      it "remove file when file exists" do
        File.write(TEST_FILE, original_file)
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.remove_file(TEST_REPO_NAME)
        new_file_length = files - 1
        expect(terraform_files.terraform_files.length).to eq(new_file_length)
      end

      it "call extend_date_in_file" do
        File.write(TEST_FILE, original_file)
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.extend_date_in_file(TEST_REPO_NAME, TEST_USER_1)
        modified_file = File.read(TEST_FILE)
        expect(modified_file).not_to eq(original_file)
        File.delete(TEST_FILE)
      end

      it "call remove_collaborator_from_file" do
        File.write(TEST_FILE, original_file)
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.remove_collaborator_from_file(TEST_REPO_NAME, TEST_USER_1)
        modified_file = File.read(TEST_FILE)
        expect(modified_file).not_to eq(original_file)
        File.delete(TEST_FILE)
      end

      it "call change_collaborator_permission_in_file" do
        File.write(TEST_FILE, original_file)
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.change_collaborator_permission_in_file(TEST_USER_1, TEST_REPO_NAME, "pull")
        modified_file = File.read(TEST_FILE)
        expect(modified_file).not_to eq(original_file)
        File.delete(TEST_FILE)
      end

      it "call add_collaborator_to_file" do
        File.write(TEST_FILE, original_file)
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
        terraform_files.add_collaborator_to_file(collaborator, TEST_REPO_NAME, "pull")
        terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file.create_terraform_collaborator_blocks
        collaborators_in_file = []
        terraform_file.terraform_blocks.each do |terraform_block|
          collaborators_in_file.push(terraform_block.username)
        end
        expected_collaborators = [TEST_USER_1, TEST_USER_2, "someuser"]
        expect(collaborators_in_file).to eq(expected_collaborators)
        modified_file = File.read(TEST_FILE)
        expect(modified_file).not_to eq(original_file)
        File.delete(TEST_FILE)
      end      

      it "call get_empty_files when no empty files exist" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        result = terraform_files.get_empty_files
        expect(result.length).to eq(0)
      end

      it "call get_empty_files when file exists" do
        empty_file = File.read("spec/fixtures/empty-file.tf")
        File.write("terraform/empty-file.tf", empty_file)
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.terraform_files.length).to eq(files)
        result = terraform_files.get_empty_files
        expect(result.length).to eq(1)
        File.delete("terraform/empty-file.tf")
      end

      it "call ensure_file_exists_in_memory" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.ensure_file_exists_in_memory(TEST_REPO_NAME)
        new_file_length = files + 1
        expect(terraform_files.terraform_files.length).to eq(new_file_length)
      end

      it "call ensure_file_exists_in_memory when file already exists" do
        File.write(TEST_FILE, original_file)
        terraform_files = GithubCollaborators::TerraformFiles.new
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        expect(terraform_files.terraform_files.length).to eq(files)
        terraform_files.ensure_file_exists_in_memory(TEST_REPO_NAME)
        expect(terraform_files.terraform_files.length).to eq(files)
        File.delete(TEST_FILE)
      end

      it "call get_collaborators_in_file when file already exists" do
        File.write(TEST_FILE, original_file)
        terraform_files = GithubCollaborators::TerraformFiles.new
        files = (Dir[TERRAFORM_FILES].length) - EXCLUDE_FILES.length
        expect(terraform_files.terraform_files.length).to eq(files)
        expect(terraform_files.get_collaborators_in_file(TEST_REPO_NAME)).to eq([TEST_USER_1,TEST_USER_2])
        File.delete(TEST_FILE)
      end

      it "call get_collaborators_in_file when file doesn't exist" do
        terraform_files = GithubCollaborators::TerraformFiles.new
        expect(terraform_files.get_collaborators_in_file(TEST_REPO_NAME)).to eq([])
      end 
    end
  end
end
