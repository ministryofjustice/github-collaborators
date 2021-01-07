class GithubCollaborators
  describe LastCommit do
    let(:org) { "myorg" }
    let(:repo) { "myrepo" }
    let(:login) { "whoever" }

    let(:params) {
      {
        org: org,
        repo: repo,
        login: login,
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

    specify { expect(lc.date).to eq("2020-12-24T04:23:22Z") }

    context "bad parameters" do
      it "barfs if repo is not a string" do
        expect {
          described_class.new(params.merge(repo: double(Repository)))
        }.to raise_error("Bad parameters: repo should be a string")
      end
    end
  end
end
