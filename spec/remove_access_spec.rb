class GithubCollaborators
  include TestConstants
  include Constants

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }
    let(:http_client) { double(GithubCollaborators::HttpClient) }

    context "when env var enabled" do
      before do
        ENV["REALLY_POST_TO_GH"] = "1"
      end

      it "call remove_access and call github api" do
        url = "#{GH_API_URL}/#{REPOSITORY_NAME}/collaborators/#{TEST_USER}"
        expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        expect(http_client).to receive(:delete).with(url)
        helper_module.remove_access(REPOSITORY_NAME, TEST_USER)
      end

      after do
        ENV.delete("REALLY_POST_TO_GH")
      end
    end

    context "call remove_access" do
      before do
        expect(GithubCollaborators::HttpClient).not_to receive(:new)
        expect(http_client).not_to receive(:delete)
      end

      context "when env var not enabled" do
        before do
          ENV["REALLY_POST_TO_GH"] = "0"
        end

        it "and don't call github api" do
          helper_module.remove_access(REPOSITORY_NAME, TEST_USER)
        end

        after do
          ENV.delete("REALLY_POST_TO_GH")
        end
      end

      context "when env var is missing" do
        it "and don't call github api" do
          helper_module.remove_access(REPOSITORY_NAME, TEST_USER)
        end
      end
    end
  end
end
