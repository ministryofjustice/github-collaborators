class GithubCollaborators
  include TestConstants
  include Constants

  describe OddFullOrgMembers do
    context "test OddFullOrgMembers" do
      subject(:odd_collaborator) { described_class.new }

      it "call create_line" do
        line = odd_collaborator.create_line("bob")
        test_equal(line, "- bob")
      end

      it "singular_message" do
        line = odd_collaborator.singular_message
        test_equal(line, "I've found a collaborator who is a full Org member but isn't attached to any GitHub repositories except the all-org-members team respositories. Consider removing this collaborator")
      end

      it "multiple_message" do
        line = odd_collaborator.multiple_message(4)
        test_equal(line, "I've found 4 collaborators who are full Org members but are not attached to any GitHub repositories except the all-org-members team respositories. Consider removing these collaborators")
      end
    end
  end
end
