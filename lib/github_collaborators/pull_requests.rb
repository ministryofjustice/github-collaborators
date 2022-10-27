class GithubCollaborators
  class PullRequest
    attr_reader :data

    def initialize(data)
      @data = data
    end

    # ID of the PR
    def number
      data.fetch("number")
    end

    # Title of the PR
    def title
      data.fetch("title")
    end

    # Returns first file in the PR
    def file
      data.dig("files", "edges")
      &.first
      &.dig("node", "path")
    end

    # Returns all the files in the PR
    def files
      data.dig("files", "edges").map { |d| d.dig("node", "path") }
    end
  end

  class PullRequests
    attr_reader :graphql

    def initialize(params = nil)
      @graphql = if params.nil?
        GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
      else
        params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
      end
    end

    def list
      @list ||= get_all_pull_requests
    end

    private

    def get_all_pull_requests
      data = get_pull_requests
      data.fetch("nodes").map { |d| PullRequest.new(d) }
    end

    def get_pull_requests
      json = graphql.run_query(pull_request_query)
      sleep(2)
      if json.include?("errors")
        warn("pull_requests:get_pull_requests(): graphql query contains errors")
        if json.include?("RATE_LIMITED")
          sleep(300)
          get_pull_requests
        else
          abort(json)
        end
      else
        JSON.parse(json).dig("data", "organization", "repository", "pullRequests")
      end
    end

    def pull_request_query
      %[
      {
        organization(login: "ministryofjustice") {
          repository(name: "github-collaborators") {
              name
              pullRequests(states: OPEN, last: 25) {
                nodes {
                  number
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
        ]
    end
  end
end
