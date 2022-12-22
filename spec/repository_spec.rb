class GithubCollaborators
  include TestConstants
  include Constants

  describe Repository do
    context "test repository" do
      subject(:repository) { described_class.new(REPOSITORY_NAME, 4) }

      before do
        test_equal(repository.outside_collaborators_count, 4)
        test_equal(repository.name, REPOSITORY_NAME)
      end

      it "create repository object" do
        test_equal(repository.outside_collaborators_names.length, 0)
        test_equal(repository.issues.length, 0)
      end

      it "call add_issues" do
        repository.add_issues(["issue1", "issue2"])
        test_equal(repository.outside_collaborators_names.length, 0)
        test_equal(repository.issues.length, 2)
        test_equal(repository.issues, ["issue1", "issue2"])
      end

      it "call store_collaborators_names" do
        repository.store_collaborators_names([TEST_USER, TEST_USER_1])
        test_equal(repository.outside_collaborators_names.length, 2)
        test_equal(repository.outside_collaborators_names, [TEST_USER, TEST_USER_1])
        test_equal(repository.issues.length, 0)
      end
    end
  end
end
