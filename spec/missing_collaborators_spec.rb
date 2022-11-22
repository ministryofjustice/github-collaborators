class GithubCollaborators
  describe MissingCollaborators do
    context "call" do

      subject(:missing_collaborator) { described_class.new }

      it "create line" do
        collaborator = { :login => "bob", :repository => "operations" }
        line = missing_collaborator.create_line(collaborator)
        expect(line).to eq("- bob in operations")
      end

      it "singular message" do
        line = missing_collaborator.singular_message
        expect(line).to eq("I've found a collaborator who is defined in Terraform but is not attached to a GitHub repository. Find out if the collaborator still requires access")
      end

      it "multiple message" do
        line = missing_collaborator.multiple_message(4)
        expect(line).to eq("I've found 4 collaborators who are defined in Terraform but they are not attached to a GitHub repository. Find out if these collaborators still require access")
      end
    end
  end
end
