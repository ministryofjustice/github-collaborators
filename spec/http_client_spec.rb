class GithubCollaborators
  TEST_URL = "https://api.github.com/repos/ministryofjustice/github-collaborators/issues"
  BODY = "abc"

  describe HttpClient do
    subject(:hc) { described_class.new }

    # Stub sleep
    before {
      allow_any_instance_of(GithubCollaborators).to receive(:sleep)
      allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep)
      allow_any_instance_of(GithubCollaborators::BranchCreator).to receive(:sleep)
      allow_any_instance_of(GithubCollaborators::GithubGraphQlClient).to receive(:sleep)
    }

    context "when token is missing" do
      it "catch error on fetch" do
        expect { hc.fetch_json(TEST_URL) }.to raise_error(KeyError)
      end

      it "catch error on post" do
        expect { hc.post_json(TEST_URL, nil) }.to raise_error(KeyError)
      end

      it "catch error on patch" do
        expect { hc.patch_json(TEST_URL, nil) }.to raise_error(KeyError)
      end

      it "catch error on delete" do
        expect { hc.delete(TEST_URL) }.to raise_error(KeyError)
      end

      it "catch error on post pull request" do
        expect { hc.post_pull_request_json(TEST_URL, nil) }.to raise_error(KeyError)
      end
    end

    context "when correct pull request token is provided" do
      before do
        ENV["OPS_BOT_TOKEN"] = ""
        ENV["ADMIN_GITHUB_TOKEN"] = ""
      end

      it "call post pull request" do
        stub_request(:post, TEST_URL).to_return(body: BODY, status: 200)
        reply = hc.post_pull_request_json(TEST_URL, nil)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end

      after do
        ENV.delete("OPS_BOT_TOKEN")
        ENV.delete("ADMIN_GITHUB_TOKEN")
      end
    end

    context "when correct token is provided" do
      before do
        ENV["OPS_BOT_TOKEN"] = ""
        ENV["ADMIN_GITHUB_TOKEN"] = ""
      end

      it "catch error in response" do
        stub_request(:any, TEST_URL).to_return(body: "errors", status: 401)
        expect { hc.fetch_json(TEST_URL) }.to raise_error(SystemExit)
      end

      it "catch rate limited error in response" do
        stub_request(:any, TEST_URL).to_return(body: "errors RATE_LIMITED", status: 401)
        expect { hc.fetch_json(TEST_URL) }.to raise_error(SystemExit)
      end

      it "call fetch and return a good response with empty body" do
        stub_request(:get, TEST_URL).to_return(body: "", status: 200)
        reply = hc.fetch_json(TEST_URL)
        expect(reply).to eq("")
      end

      it "call fetch and return a good response with body" do
        stub_request(:get, TEST_URL).to_return(body: BODY, status: 200)
        reply = hc.fetch_json(TEST_URL)
        expect(reply).to eq(BODY)
      end

      it "call post" do
        stub_request(:post, TEST_URL).to_return(body: BODY, status: 200)
        reply = hc.post_json(TEST_URL, nil)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end

      it "call patch" do
        stub_request(:patch, TEST_URL).to_return(body: BODY, status: 200)
        reply = hc.patch_json(TEST_URL, nil)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end

      it "call delete" do
        stub_request(:delete, TEST_URL).to_return(body: BODY, status: 200)
        reply = hc.delete(TEST_URL)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end

      after do
        ENV.delete("OPS_BOT_TOKEN")
        ENV.delete("ADMIN_GITHUB_TOKEN")
      end
    end
  end
end
