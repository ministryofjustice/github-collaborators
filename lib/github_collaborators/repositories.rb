class GithubCollaborators
  class Repository
    include Logging
    attr_reader :name, :outside_collaborators, :outside_collaborators_count

    def initialize(data)
      logger.debug "initialize"
      @name = data.fetch("name")
      @outside_collaborators_count = data.dig("collaborators", "totalCount")
      @outside_collaborators = []
    end

    # Add collaborator based on login name
    def add_outside_collaborator(collaborator)
      logger.debug "add_outside_collaborator"
      @outside_collaborators.push(collaborator.login)
    end

    # Add collaborators based on login name
    def add_outside_collaborators(collaborators)
      logger.debug "add_outside_collaborators"
      collaborators.each { |collaborator| @outside_collaborators.push(collaborator.login) }
    end
  end

  class Repositories
    include Logging

    def initialize
      logger.debug "initialize"
      @graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
    end

    def get_active_repositories
      logger.debug "get_active_repositories"
      active_repositories = []
      ["public", "private", "internal"].each do |type|
        end_cursor = nil
        loop do
          response = @graphql.run_query(repositories_query(end_cursor, type))
          repositories = JSON.parse(response).dig("data", "search", "repos")
          repositories.reject { |r| r.dig("repo", "isDisabled") }
          repositories.reject { |r| r.dig("repo", "isLocked") }
          repositories.each do |repo|
            active_repositories.push(GithubCollaborators::Repository.new(repo.dig("repo")))
          end
          break unless JSON.parse(response).dig("data", "search", "pageInfo", "hasNextPage")
          end_cursor = JSON.parse(response).dig("data", "search", "pageInfo", "endCursor")
        end
      end
      active_repositories.sort_by { |repo| repo.name }
    end

    private

    def repositories_query(end_cursor, type)
      logger.debug "repositories_query"
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
        {
          search(
            type: REPOSITORY
            query: "org:ministryofjustice, archived:false, is:#{type}"
            first: 100 #{after}
          ) {
            repos: edges {
              repo: node {
                ... on Repository {
                  name
                  isDisabled
                  isLocked
                  collaborators(affiliation: OUTSIDE) {
                    totalCount
                  }
                }
              }
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      ]
    end
  end
end
