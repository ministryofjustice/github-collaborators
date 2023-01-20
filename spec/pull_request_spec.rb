class GithubCollaborators
  include TestConstants
  include Constants

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }
    let(:pull_requests_json) { File.read("spec/fixtures/pull-requests.json") }
    let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

    query = %(
      {
        organization(login: "#{ORG}") {
          repository(name: "#{REPO_NAME}") {
            pullRequests(states: OPEN, last: 100) {
              nodes {
                title
                files(first: 100) {
                  edges {
                    node {
                      path
                    }
                  }
                }
              }
            }
          }
        }
      }
      )

    no_pull_requests_json = %(
      {
        "data": {
          "organization": {
            "repository": {
              "pullRequests": {
                "nodes": []
              }
            }
          }
        }
      }
    )

    context "call get_pull_requests" do
      before do
        expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
      end

      it "when pull requests exist" do
        expect(graphql_client).to receive(:run_query).with(query).and_return(pull_requests_json)
        response = [{title: "Pull request 1", files: ["somefile1", "somefile2", "somefile3"]}, {title: "Pull request 2", files: ["somefile4", "somefile5", "somefile6"]}]
        test_equal(helper_module.get_pull_requests, response)
      end

      it "when no pull requests exist" do
        expect(graphql_client).to receive(:run_query).with(query).and_return(no_pull_requests_json)
        test_equal(helper_module.get_pull_requests, [])
      end
    end
  end
end
