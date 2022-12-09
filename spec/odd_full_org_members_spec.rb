class GithubCollaborators
  describe OddFullOrgMembers do
    context "call" do
      subject(:odd_collaborator) { described_class.new }

      it "create line" do
        line = odd_collaborator.create_line("bob")
        test_equal(line, "- bob")
      end

      it "singular message" do
        line = odd_collaborator.singular_message
        test_equal(line, "I've found a collaborator who is a full Org member but isn't attached to any GitHub repositories except the all-org-members team respositories. Consider removing this collaborator")
      end

      it "multiple message" do
        line = odd_collaborator.multiple_message(4)
        test_equal(line, "I've found 4 collaborators who are full Org members but are not attached to any GitHub repositories except the all-org-members team respositories. Consider removing these collaborators")
      end
    end
  end
end
