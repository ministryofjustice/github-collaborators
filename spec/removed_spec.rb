class GithubCollaborators
  describe Removed do
    context "call" do
      subject(:removed) { described_class.new }

      it "create line" do
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, "operations")
        line = removed.create_line(collaborator)
        expect(line).to eq("- someuser from operations")
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
