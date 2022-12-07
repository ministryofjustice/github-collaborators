describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }

  let(:http_client) { double(GithubCollaborators::HttpClient) }

  context "when env var enabled" do
    before do
      ENV["REALLY_POST_TO_GH"] = "1"
    end

    it "call github api" do
      url = "https://api.github.com/repos/ministryofjustice/somerepo/collaborators/somegithubuser"
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
      expect(http_client).to receive(:delete).with(url)
      helper_module.remove_access("somerepo", "somegithubuser")
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
      helper_module.remove_access("somerepo", "somegithubuser")
    end

    after do
      ENV.delete("REALLY_POST_TO_GH")
    end
  end

  context "when env var is missing" do
    it "dont call github api" do
      expect(GithubCollaborators::HttpClient).not_to receive(:new)
      expect(http_client).not_to receive(:delete)
      helper_module.remove_access("somerepo", "somegithubuser")
    end
  end
end
