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

    let(:graphql) { GithubGraphQlClient.new(github_token: "fake") }

    before do
      allow(graphql).to receive(:run_query).and_return(json)
    end

    let(:repo_collabs) { described_class.new(params) }

    it "lists collaborators" do
      expect(
        repo_collabs.fetch_all_collaborators.map(&:login).sort
      ).to eq(collaborators)
    end
  end
end
