class GithubCollaborators
  describe PullRequests do
    let(:params) {
      {
        graphql: graphql
      }
    }

    let(:json) { File.read("spec/fixtures/pull-requests.json") }

    let(:graphql) { GithubCollaborators::GithubGraphQlClient.new(github_token: "fake") }

    subject(:pullrequests) { described_class.new(params) }

    before do
      allow(graphql).to receive(:run_query).and_return(json)
    end

    specify { expect(pullrequests.get_pull_requests.size).to eq(10) }
  end
end
