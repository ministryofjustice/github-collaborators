class GithubCollaborators
  describe LastCommit do
    let(:org) { "myorg" }
    let(:repo) { "myrepo" }
    let(:login) { "whoever" }
    let(:id) { "MDQ6VXNlcjkwMDU2OTM=" }

    let(:params) {
      {
        org: org,
        repo: repo,
        login: login,
        id: id,
        graphql: graphql
      }
    }

    let(:json) { File.read("spec/fixtures/last-commit.json") }

    let(:graphql) { double(GithubGraphQlClient) }

    subject(:lc) { described_class.new(params) }

    before do
      allow(graphql).to receive(:run_query).and_return(json)
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
