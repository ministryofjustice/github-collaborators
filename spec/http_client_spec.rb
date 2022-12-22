class GithubCollaborators
  include TestConstants
  include Constants

  describe HttpClient do
    context "test HttpClient" do
      subject(:hc) { described_class.new }

      # Stub sleep
      before {
        allow_any_instance_of(GithubCollaborators::HttpClient).to receive(:sleep)
      }

      context "when one env var is missing" do
        before {
          ENV.delete("OPS_BOT_TOKEN")
          ENV["ADMIN_GITHUB_TOKEN"] = ""
        }

        it CATCH_ERROR do
          expect { GithubCollaborators::HttpClient.new }.to raise_error(KeyError)
        end

        it "catch error on fetch_json" do
          expect { hc.fetch_json(TEST_URL) }.to raise_error(KeyError)
        end

        it "catch error on post_json" do
          expect { hc.post_json(TEST_URL, nil) }.to raise_error(KeyError)
        end

        it "catch error on patch_json" do
          expect { hc.patch_json(TEST_URL, nil) }.to raise_error(KeyError)
        end

        it "catch error on delete" do
          expect { hc.delete(TEST_URL) }.to raise_error(KeyError)
        end

        it "catch error on post_pull_request_json" do
          expect { hc.post_pull_request_json(TEST_URL, nil) }.to raise_error(KeyError)
        end
      end

      context "when other env var is missing" do
        before {
          ENV["OPS_BOT_TOKEN"] = ""
          ENV.delete("ADMIN_GITHUB_TOKEN")
        }

        it CATCH_ERROR do
          expect { GithubCollaborators::HttpClient.new }.to raise_error(KeyError)
        end
      end

      context "when both env vars are missing" do
        before {
          ENV.delete("OPS_BOT_TOKEN")
          ENV.delete("ADMIN_GITHUB_TOKEN")
        }

        it CATCH_ERROR do
          expect { GithubCollaborators::HttpClient.new }.to raise_error(KeyError)
        end
      end

      context "when correct env vars are provided" do
        before do
          ENV["OPS_BOT_TOKEN"] = ""
          ENV["ADMIN_GITHUB_TOKEN"] = ""
        end

        it "call post_pull_request_json" do
          stub_request(:post, TEST_URL).to_return(body: BODY, status: 200)
          reply = hc.post_pull_request_json(TEST_URL, nil)
          expect(reply).to be_instance_of(Net::HTTPOK)
        end

        context "call fetch_json" do
          it "and catch error and abort" do
            stub_request(:any, TEST_URL).to_return(body: "errors", status: 401)
            expect { hc.fetch_json(TEST_URL) }.to raise_error(SystemExit)
          end

          it "and catch rate limited error in response" do
            stub_request(:any, TEST_URL).to_return(body: "errors RATE_LIMITED", status: 401)
            expect { hc.fetch_json(TEST_URL) }.to raise_error(SystemExit)
          end

          it "and return a good response with empty body" do
            stub_request(:get, TEST_URL).to_return(body: "", status: 200)
            reply = hc.fetch_json(TEST_URL)
            test_equal(reply, "")
          end

          it "and return a good response with body" do
            stub_request(:get, TEST_URL).to_return(body: BODY, status: 200)
            reply = hc.fetch_json(TEST_URL)
            test_equal(reply, BODY)
          end
        end

        it "call post_json" do
          stub_request(:post, TEST_URL).to_return(body: BODY, status: 200)
          reply = hc.post_json(TEST_URL, nil)
          expect(reply).to be_instance_of(Net::HTTPOK)
        end

        it "call patch_json" do
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
end
