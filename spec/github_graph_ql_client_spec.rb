class GithubCollaborators
  describe GithubGraphQlClient do
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

        # query = ""
        # it "catch error and abort" do
        #   expect(graphql_client).to receive(:query_github_api).with(query).and_return()
        #   expect(graphql_client.fetch_json(TEST_URL)).to raise_error(SystemExit)
        # end
      end
    end
  end
end
