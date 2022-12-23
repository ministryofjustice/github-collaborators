class GithubCollaborators
  include TestConstants

  describe ArchivedRepositories do
    context "test ArchivedRepositories" do
      subject(:archived_repositories) { described_class.new }

      it "call create_line" do
        collaborator = {login: TEST_USER, repository: REPOSITORY_NAME}
        line = archived_repositories.create_line(collaborator)
        test_equal(line, "- #{TEST_USER} in #{REPOSITORY_NAME}")
      end

      it "call singular_message" do
        line = archived_repositories.singular_message
        test_equal(line, "I've found a collaborator who is a full Org member attached to an archived repository. Un-archive the repository and remove this collaborator")
      end

      it "call multiple_message" do
        line = archived_repositories.multiple_message(4)
        test_equal(line, "I've found 4 collaborators who are full Org members attached to archived repositories. Un-archive the repositories and remove these collaborators")
      end
    end
  end
end
