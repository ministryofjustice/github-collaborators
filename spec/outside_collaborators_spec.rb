class GithubCollaborators
  describe OutsideCollaborators do
    let(:terraform_file) { double(GithubCollaborators::TerraformFile) }
    let(:terraform_files) { double(GithubCollaborators::TerraformFiles) }
    let(:organization) { double(GithubCollaborators::Organization) }

    context "test outside collaborators" do
      def create_terraform_file
        stub_const("Constants::TERRAFORM_DIR", "spec/fixtures")
        terraform_file1 = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
        terraform_file1.read_file
        terraform_file1.get_repository_name
        terraform_file1.create_terraform_collaborator_blocks
        terraform_file1
      end

      def create_empty_terraform_file
        stub_const("Constants::TERRAFORM_DIR", "spec/fixtures")
        terraform_file2 = GithubCollaborators::TerraformFile.new("empty-file", TERRAFORM_DIR)
        terraform_file2.read_file
        terraform_file2.get_repository_name
        terraform_file2
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
        expect(terraform_files).to receive(:get_empty_files).and_return(["empty-file"])
        expect(terraform_files).to receive(:remove_file).with("empty-file")
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
        expect(terraform_files).to receive(:get_empty_files).and_return(["empty-file"])
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
    end
  end
end
