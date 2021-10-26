class GithubCollaborators
  describe PullRequests do
    let(:params) {
      {
        login: "mylogin",
        graphql: graphql
      }
    }

    let(:json) { File.read("spec/fixtures/pull-requests.json") }

    let(:graphql) { GithubGraphQlClient.new(github_token: "fake") }

    subject(:pullrequests) { described_class.new(params) }

    before do
      allow(graphql).to receive(:run_query).and_return(json)
    end

    specify { expect(pullrequests.list.size).to eq(10) }
  end
end
