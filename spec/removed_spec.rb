class GithubCollaborators
  include TestConstants
  include Constants

  describe Removed do
    context "test Removed" do
      subject(:removed) { described_class.new }

      it "call create_line" do
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, "operations")
        line = removed.create_line(collaborator)
        test_equal(line, "- #{TEST_USER} from operations")
      end

      it "call singular_message" do
        line = removed.singular_message
        test_equal(line, "I've removed an unknown collaborator from Github")
      end

      it "call multiple_message" do
        line = removed.multiple_message(4)
        test_equal(line, "I've removed 4 unknown collaborators from Github")
      end
    end
  end
end
