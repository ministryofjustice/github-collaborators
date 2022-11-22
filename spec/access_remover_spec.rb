class GithubCollaborators
  describe AccessRemover do
    context "when env var not enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "1"
      end

      let(:params) {
        {
          repository: "somerepo",
          github_user: "somegithubuser"
        }
      }

      subject(:ar) { described_class.new(params) }

      let(:http_client) { double(HttpClient) }

      # Stub sleep
      before { allow_any_instance_of(AccessRemover).to receive(:sleep) }

      it "call github api" do
        url = "https://api.github.com/repos/ministryofjustice/somerepo/collaborators/somegithubuser"
        expect(HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:delete).with(url)
        ar.remove_access
      end

      after do
        ENV["REALLY_POST_TO_GH"] = "0"
      end
    end

    context "when env var not enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "0"
      end

      let(:params) {
        {
          repository: "somerepo",
          github_user: "somegithubuser"
        }
      }

      subject(:ar) { described_class.new(params) }

      let(:http_client) { double(HttpClient) }

      it "dont call github api" do
        expect(HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
        ar.remove_access
      end
    end
  end
end
