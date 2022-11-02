class GithubCollaborators
  describe Repositories do
    let(:params) {
      {
        login: "whoever",
        graphql: graphql
      }
    }

    let(:json) { File.read("spec/fixtures/repositories.json") }

    let(:graphql) { GithubGraphQlClient.new(github_token: "dummy") }

    subject(:repos) { described_class.new(params) }

    before do
      allow(graphql).to receive(:run_query).and_return(json)
    end

    specify { expect(repos.active_repositories.size).to eq(4) }

    it "excludes archived, locked & disabled repos" do
      expect(repos.active_repositories.size).to eq(1)
    end

    it "returns repo objects" do
      repos.active_repositories.each do |repo|
        expect(repo).to be_a(Repository)
      end
    end
  end
end
