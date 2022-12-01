class GithubCollaborators
  describe AccessRemover do
    let(:params) {
      {
        repository: "somerepo",
        github_user: "somegithubuser"
      }
    }
  
    let(:http_client) { double(GithubCollaborators::HttpClient) }

    # Stub sleep
    before { allow_any_instance_of(GithubCollaborators::AccessRemover).to receive(:sleep) }
    
    subject(:ar) { described_class.new(params) }

    context "when env var enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "1"
      end

      it "call github api" do
        url = "https://api.github.com/repos/ministryofjustice/somerepo/collaborators/somegithubuser"
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:delete).with(url)
        ar.remove_access
      end

      after do
        ENV.delete("REALLY_POST_TO_GH")
      end
    end

    context "when env var not enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "0"
      end

      it "dont call github api" do
        expect(GithubCollaborators::HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
        ar.remove_access
      end

      after do
        ENV.delete("REALLY_POST_TO_GH")
      end
    end

    context "when env var is missing" do
      it "dont call github api" do
        expect(GithubCollaborators::HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
        ar.remove_access
      end
    end
  end
end
