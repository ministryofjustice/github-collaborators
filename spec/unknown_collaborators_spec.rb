class GithubCollaborators
  describe UnknownCollaborators do
    context "call" do
      subject(:unknown_collaborator) { described_class.new }

      it "create line" do
        collaborator = {login: "bob", repository: "operations"}
        line = unknown_collaborator.create_line(collaborator)
        expect(line).to eq("- bob in operations")
      end

      it "singular message" do
        line = unknown_collaborator.singular_message
        expect(line).to eq("I've found an unknown collaborator who has an invite to a MoJ GitHub repository who is not defined within a Terraform file")
      end

      it "multiple message" do
        line = unknown_collaborator.multiple_message(4)
        expect(line).to eq("I've found 4 unknown collaborators who have an invite to an MoJ GitHub repository who are not defined within a Terraform file")
      end
    end
  end
end
