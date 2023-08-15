class GithubCollaborators
  include TestConstants
  include Constants

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }
    let(:pull_requests_json) { File.read("spec/fixtures/pull-requests.json") }
    let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

    before do
      expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client)
    end

    context "call get_pull_request_files" do
      pull_request_query = %(
      {
        organization(login: "#{ORG}") {
          repository(name: "#{REPO_NAME}") {
            pullRequest(number: 1) {
              files(
                first: 100
                after: null
              ) {
                nodes {
                  path
                }
                pageInfo {
                  hasNextPage
                  endCursor
                }
              }
            }
          }
        }
      }
      )

      no_pull_request_json = %(
        {
          "data": {
            "organization": {
              "repository": {
                "pullRequest": {
                }
              }
            }
          }
        }
      )

      real_path = {
        path: TEST_RANDOM_FILE
      }

      hundred_real_paths = Array.new(100, real_path)

      hundred_files_pull_request_json = %(
        {
          "data": {
            "organization": {
              "repository": {
                "pullRequest": {
                  "files": {
                    "nodes": #{hundred_real_paths.to_json},
                    "pageInfo": {
                      "hasNextPage": false,
                      "endCursor": null
                    }
                  }
                }
              }
            }
          }
        }
      )

      hundred_files_and_more_pull_request_json = %(
        {
          "data": {
            "organization": {
              "repository": {
                "pullRequest": {
                  "files": {
                    "nodes": #{hundred_real_paths.to_json},
                    "pageInfo": {
                      "hasNextPage": true,
                      "endCursor": "abc"
                    }
                  }
                }
              }
            }
          }
        }
      )

      it "when no pull request exist" do
        expect(graphql_client).to receive(:run_query).with(pull_request_query).and_return(no_pull_request_json)
        test_equal(helper_module.get_pull_request_files(1), [])
      end

      it "when pull request has less than 100 files" do
        expect(graphql_client).to receive(:run_query).with(pull_request_query).and_return(hundred_files_pull_request_json)
        response = Array.new(100, TEST_RANDOM_FILE)
        pull_request_files = helper_module.get_pull_request_files(1)
        test_equal(pull_request_files, response)
        test_equal(pull_request_files.length, 100)
      end

      it "when pull request has more than 100 files" do
        expect(graphql_client).to receive(:run_query).with(pull_request_query).and_return(hundred_files_and_more_pull_request_json).at_least(1).times
        expect(graphql_client).to receive(:run_query).and_return(hundred_files_pull_request_json).at_least(1).times
        response = Array.new(200, TEST_RANDOM_FILE)
        pull_request_files = helper_module.get_pull_request_files(1)
        test_equal(pull_request_files, response)
        test_equal(pull_request_files.length, 200)
      end
    end

    context "call get_pull_requests" do
      pull_requests_query = %(
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
            "path": #{TEST_RANDOM_FILE}
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
        node: {
          path: TEST_RANDOM_FILE
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

      it "when pull requests exist" do
        expect(graphql_client).to receive(:run_query).with(pull_requests_query).and_return(pull_requests_json)
        response = [{title: PULL_REQUEST_TITLE, files: ["somefile1", "somefile2", "somefile3"]}, {title: "Pull request 2", files: ["somefile4", "somefile5", "somefile6"]}]
        test_equal(helper_module.get_pull_requests, response)
      end

      it "when no pull requests exist" do
        expect(graphql_client).to receive(:run_query).with(pull_requests_query).and_return(no_pull_requests_json)
        test_equal(helper_module.get_pull_requests, [])
      end

      it "when pull request exists with more than 100 files" do
        expect(graphql_client).to receive(:run_query).with(pull_requests_query).and_return(pull_request_with_many_files_json)
        the_files = Array.new(101, TEST_RANDOM_FILE)
        expect(helper_module).to receive(:get_pull_request_files).and_return(the_files)
        pull_requests = helper_module.get_pull_requests
        test_equal(pull_requests, [{title: PULL_REQUEST_TITLE, files: the_files}])
        test_equal(pull_requests[0][:files].length, 101)
      end

      it "when pull request exists with less than 101 files" do
        expect(graphql_client).to receive(:run_query).with(pull_requests_query).and_return(pull_request_with_alot_files_json)
        expect(helper_module).not_to receive(:get_pull_request_files)
        the_files = Array.new(100, TEST_RANDOM_FILE)
        pull_requests = helper_module.get_pull_requests
        test_equal(pull_requests, [{title: PULL_REQUEST_TITLE, files: the_files}])
        test_equal(pull_requests[0][:files].length, 100)
      end
    end
  end
end
