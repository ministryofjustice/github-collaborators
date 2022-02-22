class GithubCollaborators
  describe RepositoryCollaborators do
    let(:params) {
      {
        login: "myorg",
        repository: "myrepo",
        graphql: graphql
      }
    }

    let(:json) { File.read("spec/fixtures/repo-collabs.json") }
    let(:collaborators) { # Defined in spec/fixtures/repo-collabs.json
      ["DangerDawson", "damacus", "digitalronin"]
    }

    let(:graphql) { double(GithubGraphQlClient, run_query: json) }

    let(:repo_collabs) { described_class.new(params) }

    it "lists collaborators" do
      expect(
        repo_collabs.list.map(&:login).sort
      ).to eq(collaborators)
    end
  end
end
