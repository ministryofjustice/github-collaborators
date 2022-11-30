class GithubCollaborators
  describe Removed do
    context "call" do
      subject(:removed) { described_class.new }

      it "create line" do
        terraform_block = TerraformBlock.new

        today = Date.today.strftime(DATE_FORMAT).to_s

        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: today
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = removed.create_line(collaborator)
        expect(line).to eq("- bob123 from operations")
      end

      it "singular message" do
        line = removed.singular_message
        expect(line).to eq("I've removed an unknown collaborator from Github")
      end

      it "multiple message" do
        line = removed.multiple_message(4)
        expect(line).to eq("I've removed 4 unknown collaborators from Github")
      end
    end
  end
end
