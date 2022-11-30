class GithubCollaborators
  TEST_URL = "https://api.github.com/repos/ministryofjustice/github-collaborators/issues"

  describe HttpClient do
    subject(:hc) { described_class.new }

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
        ENV["OPS_BOT_TOKEN"] = "foobar"
      end

      # Stub sleep
      before { allow_any_instance_of(HttpClient).to receive(:sleep) }

      it "call post pull request" do
        stub_request(:post, TEST_URL).to_return(body: "abc", status: 200)
        reply = hc.post_pull_request_json(TEST_URL, nil)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end
    end

    context "when correct token is provided" do
      before do
        ENV["ADMIN_GITHUB_TOKEN"] = "foobar"
      end

      it "catch error in response" do
        stub_request(:any, TEST_URL).to_return(body: "errors", status: 401)
        expect { hc.fetch_json(TEST_URL) }.to raise_error(SystemExit)
      end

      # Stub sleep
      before { allow_any_instance_of(HttpClient).to receive(:sleep) }

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
        stub_request(:get, TEST_URL).to_return(body: "abc", status: 200)
        reply = hc.fetch_json(TEST_URL)
        expect(reply).to eq("abc")
      end

      it "call post" do
        stub_request(:post, TEST_URL).to_return(body: "abc", status: 200)
        reply = hc.post_json(TEST_URL, nil)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end

      it "call patch" do
        stub_request(:patch, TEST_URL).to_return(body: "abc", status: 200)
        reply = hc.patch_json(TEST_URL, nil)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end

      it "call delete" do
        stub_request(:delete, TEST_URL).to_return(body: "abc", status: 200)
        reply = hc.delete(TEST_URL)
        expect(reply).to be_instance_of(Net::HTTPOK)
      end
    end
  end
end
