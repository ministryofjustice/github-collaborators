class GithubCollaborators
  describe LastCommit do
    let(:params) {
      {
        org: "myorg",
        repo: "myrepo",
        login: "whoever",
        graphql: graphql
      }
    }

    let(:userjson) { File.read("spec/fixtures/user-id.json") }
    let(:json) { File.read("spec/fixtures/last-commit.json") }

    let(:graphql) { double(GithubGraphQlClient) }

    subject(:lc) { described_class.new(params) }

    before do
      allow(graphql).to receive(:run_query).and_return(userjson, json)
    end

    specify { expect(lc.date).to eq("2020-12-24 04:23:22") }
  end
end
