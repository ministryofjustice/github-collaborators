class GithubCollaborators
  class PullRequest
    include Logging
    attr_reader :number, :title, :files, :file

    def initialize
      logger.debug "initialize"
      @files = []
      @file = ""
    end

    def add_github_data(data)
      logger.debug "add_github_data"
      @title = data.fetch("title")
      @files = data.dig("files", "edges").map { |d| d.dig("node", "path") }
    end

    def add_local_data(title, files)
      logger.debug "add_local_data"
      @title = title
      @files = files
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
      pull_requests = []
      response = @graphql.run_query(pull_request_query)
      data = JSON.parse(response).dig("data", "organization", "repository", "pullRequests")

      data.fetch("nodes").each do |pull_request_data|
        pull_request = GithubCollaborators::PullRequest.new
        pull_request.add_github_data(pull_request_data)
        pull_requests.push(pull_request)
      end
      pull_requests
    end

    private

    def pull_request_query
      %[
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
        ]
    end
  end
end
