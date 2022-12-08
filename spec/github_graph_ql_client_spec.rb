class GithubCollaborators
  GRAPHQL_URI = "https://api.github.com/graphql"
  describe GithubGraphQlClient do

    # Stub sleep
    before {
      allow_any_instance_of(GithubCollaborators::GithubGraphQlClient).to receive(:sleep)
    }

    context "call" do
      subject(:graphql_client) { described_class.new }

      context "when env var is missing" do
        before {
          ENV.delete("ADMIN_GITHUB_TOKEN")
        }

        it "catch error" do
          expect { GithubCollaborators::GithubGraphQlClient.new }.to raise_error(KeyError)
        end
      end

      context "when env var is provided" do
        before do
          ENV["ADMIN_GITHUB_TOKEN"] = ""
        end

        query = ""
        it "when result is nil catch error and abort" do
          expect(graphql_client).to receive(:query_github_api).with(query).and_return(nil).at_least(6).times
          expect { graphql_client.run_query(query) }.to raise_error(SystemExit)
        end

        it "when result is empty catch error and abort" do
          expect(graphql_client).to receive(:query_github_api).with(query).and_return("").at_least(6).times
          expect { graphql_client.run_query(query) }.to raise_error(SystemExit)
        end

        it "when result is not 200 catch error and abort" do
          net_http_resp = Net::HTTPResponse.new(1.0, 20, "OK")
          expect(graphql_client).to receive(:query_github_api).with(query).and_return(net_http_resp).at_least(6).times
          expect { graphql_client.run_query(query) }.to raise_error(SystemExit)
        end

        it "when result is 200 but containers errors so abort" do
          stub_request(:any, GRAPHQL_URI).to_return(body: "errors", status: 200)
          expect { graphql_client.run_query(query) }.to raise_error(SystemExit)
        end

        it "when result is 200 but RATE_LIMITED then abort" do
          stub_request(:any, GRAPHQL_URI).to_return(body: RATE_LIMITED, status: 200)
          expect { graphql_client.run_query(query) }.to raise_error(SystemExit)
        end

        it "when result is 200 but body is empty so abort" do
          stub_request(:any, GRAPHQL_URI).to_return(body: nil, status: 200)
          expect { graphql_client.run_query(query) }.to raise_error(SystemExit)
        end

        it "when result is 200 and body is ok" do
          stub_request(:any, GRAPHQL_URI).to_return(body: "good", status: 200)
          expect(graphql_client.run_query(query)).to eq("good")
        end
      end
    end
  end
end
