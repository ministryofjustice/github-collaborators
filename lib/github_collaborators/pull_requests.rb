class GithubCollaborators
  class PullRequest
    include Logging
    attr_reader :number, :title, :files, :file

    def initialize(data)
      logger.debug "initialize"
      @number = data.fetch("number")
      @title = data.fetch("title")
      @files = data.dig("files", "edges").map { |d| d.dig("node", "path") }
      @file = data.dig("files", "edges")&.first&.dig("node", "path")
    end
  end

  class PullRequests
    include Logging

    def initialize
      logger.debug "initialize"
      @graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
    end

    def get_pull_requests
      logger.debug "get_pull_requests"
      response = @graphql.run_query(pull_request_query)
      data = JSON.parse(response).dig("data", "organization", "repository", "pullRequests")
      pull_requests = (data.fetch("nodes").map { |d| PullRequest.new(d) })
    end

    private

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
