class GithubCollaborators
  describe PullRequestCreator do
    let(:params) {
      {
        repository: "somerepo",
        hash_body: {title: "Remove myfile as repository being deleted", head: "mybranch", base: "main", body: "Hi there\n\nThe repository that is maintained by the file myfile has been deleted/archived\n\nPlease merge this pull request to delete the file.\n\nIf you have any questions, please post in #ask-operations-engineering on Slack.\n"}
      }
    }

    subject(:ic) { described_class.new(params) }

    let(:http_client) { double(HttpClient) }

    let(:json) {
      %({\"title\":\"Remove myfile as repository being deleted\",\"head\":\"mybranch\",\"base\":\"main\",\"body\":\"Hi there\\n\\nThe repository that is maintained by the file myfile has been deleted/archived\\n\\nPlease merge this pull request to delete the file.\\n\\nIf you have any questions, please post in #ask-operations-engineering on Slack.\\n\"})
    }

    it "calls github api" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/pulls"
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:post_json).with(url, json)
      ic.create_pull_request
    end
  end
end
