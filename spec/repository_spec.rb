class GithubCollaborators
  describe Repository do
    context "test repository" do
      subject(:repository) { described_class.new("somerepo", 4) }

      it "create object" do
        expect(repository.name).to eq("somerepo")
        expect(repository.outside_collaborators_names.length).to eq(0)
        expect(repository.outside_collaborators_count).to eq(4)
        expect(repository.issues.length).to eq(0)
      end

      it "add issues" do
        repository.add_issues(["issue1", "issue2"])
        expect(repository.name).to eq("somerepo")
        expect(repository.outside_collaborators_names.length).to eq(0)
        expect(repository.outside_collaborators_count).to eq(4)
        expect(repository.issues.length).to eq(2)
        expect(repository.issues).to eq(["issue1", "issue2"])
      end

      it "add collaborator names" do
        repository.store_collaborators_names(["someuser", "otheruser"])
        expect(repository.name).to eq("somerepo")
        expect(repository.outside_collaborators_names.length).to eq(2)
        expect(repository.outside_collaborators_names).to eq(["someuser", "otheruser"])
        expect(repository.outside_collaborators_count).to eq(4)
        expect(repository.issues.length).to eq(0)
      end
    end
  end
end
