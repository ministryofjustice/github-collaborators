class GithubCollaborators
  describe AccessRemover do
    let(:params) {
      {
        owner: "ministryofjustice",
        repository: "somerepo",
        github_user: "somegithubuser"
      }
    }

    subject(:ar) { described_class.new(params) }

    let(:http_client) { double(HttpClient) }

    it "calls github api" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/collaborators/somegithubuser"
      expect(HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:delete).with(url)

      ar.remove
    end
  end
end
