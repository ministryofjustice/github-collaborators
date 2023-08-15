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
            pullRequests(states: OPEN, first: 100) {
              nodes {
                title
                number
                files(first: 100) {
                  totalCount
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

    edge = %(
      {
        "node": {
          "path": "somefile"
        }
      }
    )

    hundred_one_edges = Array.new(101, edge)
    pull_request_with_many_files_json = %(
      {
        "data": {
          "organization": {
            "repository": {
              "pullRequests": {
                "nodes": [
                  {
                    "title": "Pull request 1",
                    "number": 1,
                    "files": {
                      "totalCount": 101,
                      "edges": #{hundred_one_edges}
                    }
                  }
                ]
              }
            }
          }
        }
      }
    )

    real_edge = {
      "node": {
        "path": "somefile"
      }
    }

    hundred_real_edges = Array.new(100, real_edge)
    pull_request_with_alot_files_json = %(
      {
        "data": {
          "organization": {
            "repository": {
              "pullRequests": {
                "nodes": [
                  {
                    "title": "Pull request 1",
                    "number": 1,
                    "files": {
                      "totalCount": 100,
                      "edges": #{hundred_real_edges.to_json}
                    }
                  }
                ]
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

      it "when pull request exists with more than 100 files" do
        expect(graphql_client).to receive(:run_query).with(query).and_return(pull_request_with_many_files_json)
        the_files = Array.new(101, "somefile") 
        allow_any_instance_of(HelperModule).to receive(:get_pull_request_files).and_return(the_files)
        pull_requests = helper_module.get_pull_requests
        test_equal(pull_requests, [{title: "Pull request 1", files: the_files}])
        test_equal(pull_requests[0][:files].length, 101)
      end

      it "when pull request exists with less than 101 files" do
        expect(graphql_client).to receive(:run_query).with(query).and_return(pull_request_with_alot_files_json)
        the_files = Array.new(100, "somefile")
        test_equal(helper_module.get_pull_requests, [{title: "Pull request 1", files: the_files}])
      end
    end
  end
end
