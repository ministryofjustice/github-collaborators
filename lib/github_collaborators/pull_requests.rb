# Please note that the PullRequest/s classes are written to work with a particular solution and may have weird behaviours if used for other uses
# An example of this is the files method only returning the first file of the PR
# There is no current need for large more expansive PullRequest functionality
# Please contact Operations Engineering if you wish to consume this code in an more extensive fashion

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
    # This works because the PRs we create only contain one file
    def file
      data.dig("files", "edges")
      &.first
      &.dig("node", "path")
    end
  end

  class PullRequests
    attr_reader :graphql, :login

    def initialize(params)
      @login = params.fetch(:login)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
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
      JSON.parse(json).dig("data", "organization", "repository", "pullRequests")
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
                  files(first: 1) {
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
