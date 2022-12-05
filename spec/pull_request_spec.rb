describe HelperModule do
  # extended class
  let(:helper_module) { Class.new { extend HelperModule } }
  let(:pull_requests_json) { File.read("spec/fixtures/pull-requests.json") }
  let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

  # Stub sleep
  before { allow_any_instance_of(helper_module).to receive(:sleep) }
  before { allow_any_instance_of(GithubCollaborators::GithubGraphQlClient).to receive(:sleep) }

  query = %(
      {
        organization(login: "ministryofjustice") {
          repository(name: "github-collaborators") {
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

  context "test get_pull_requests" do
    
    it "call get_pull_requests when pull requests exist" do
      expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
      expect(graphql_client).to receive(:run_query).with(query).and_return(pull_requests_json)
      response = [{ title: "Pull request 1", files: ["somefile1", "somefile2", "somefile3"] }, { title: "Pull request 2", files: ["somefile4", "somefile5", "somefile6"] }]
      expect(helper_module.get_pull_requests).to eq(response)
    end

    it "call get_pull_requests when no pull requests exist" do
      expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
      expect(graphql_client).to receive(:run_query).with(query).and_return(no_pull_requests_json)
      expect(helper_module.get_pull_requests).to eq([])
    end
  end
end
