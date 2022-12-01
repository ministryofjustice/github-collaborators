class GithubCollaborators
  describe PullRequests do
    # TODO: Remove after re-write test
    before { skip }

    let(:json) { File.read("spec/fixtures/pull-request.json") }

    subject(:pullrequest) { described_class.new(JSON.parse(json)) }

    specify { expect(pullrequest.number).to eq(290) }
    specify { expect(pullrequest.title).to eq("This is a test PR") }
    specify { expect(pullrequest.file).to eq("terraform/myfile.tf") }
  end

  describe PullRequests do
    # TODO: Remove after re-write test
    before { skip }

    let(:params) {
      {
        repository: "somerepo",
        hash_body: {title: "Remove myfile as repository being deleted", head: "mybranch", base: "main", body: "Hi there\n\nThe repository that is maintained by the file myfile has been deleted/archived\n\nPlease merge this pull request to delete the file.\n\nIf you have any questions, please post in #ask-operations-engineering on Slack.\n"}
      }
    }

    subject(:ic) { described_class.new(params) }

    let(:http_client) { double(HttpClient) }

    let(:json) {
      %({"title":"Remove myfile as repository being deleted","head":"mybranch","base":"main","body":"Hi there\\n\\nThe repository that is maintained by the file myfile has been deleted/archived\\n\\nPlease merge this pull request to delete the file.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n"})
    }

    it "calls github api" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/pulls"
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(url, json)
      ic.create_pull_request
    end
  end

  describe PullRequests do
    # TODO: Remove after re-write test
    before { skip }

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
