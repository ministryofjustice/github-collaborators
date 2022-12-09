class GithubCollaborators
  describe Repository do
    context "test repository" do
      subject(:repository) { described_class.new("somerepo", 4) }

      it "create object" do
        test_equal(repository.name, "somerepo")
        test_equal(repository.outside_collaborators_names.length, 0)
        test_equal(repository.outside_collaborators_count, 4)
        test_equal(repository.issues.length, 0)
      end

      it "add issues" do
        repository.add_issues(["issue1", "issue2"])
        test_equal(repository.name, "somerepo")
        test_equal(repository.outside_collaborators_names.length, 0)
        test_equal(repository.outside_collaborators_count, 4)
        test_equal(repository.issues.length, 2)
        test_equal(repository.issues, ["issue1", "issue2"])
      end

      it "add collaborator names" do
        repository.store_collaborators_names(["someuser", "otheruser"])
        test_equal(repository.name, "somerepo")
        test_equal(repository.outside_collaborators_names.length, 2)
        test_equal(repository.outside_collaborators_names, ["someuser", "otheruser"])
        test_equal(repository.outside_collaborators_count, 4)
        test_equal(repository.issues.length, 0)
      end
    end
  end
end
