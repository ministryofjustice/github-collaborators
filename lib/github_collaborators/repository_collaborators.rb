class GithubCollaborators
  class GitHubCollaborator
    include Logging
    attr_reader :login

    def initialize(data)
      logger.debug "initialize"
      @login = data.dig("node", "login").downcase
    end
  end

  class RepositoryCollaborators
    include Logging

    def initialize
      logger.debug "initialize"
    end

    def fetch_all_collaborators(repository)
      logger.debug "fetch_all_collaborators"
      end_cursor = nil
      graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
      outside_collaborators = []
      loop do
        response = graphql.run_query(outside_collaborators_query(end_cursor, repository))
        json_data = JSON.parse(response)
        # Repos with no outside collaborators return an empty array
        break unless !json_data.dig("data", "organization", "repository", "collaborators", "edges").empty?
        collaborators = json_data.dig("data", "organization", "repository", "collaborators", "edges")
        collaborators.each do |outside_collaborator|
          outside_collaborators.push(GithubCollaborators::GitHubCollaborator.new(outside_collaborator))
        end
        break unless JSON.parse(response).dig("data", "organization", "repository", "collaborators", "pageInfo", "hasNextPage")
        end_cursor = JSON.parse(response).dig("data", "organization", "repository", "collaborators", "pageInfo", "endCursor")
      end
      outside_collaborators
    end

    private

    def outside_collaborators_query(end_cursor, repository)
      logger.debug "outside_collaborators_query"
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
        {
          organization(login: "ministryofjustice") {
            repository(name: "#{repository.downcase}") {
              collaborators(first:100 affiliation: OUTSIDE #{after}) {
                pageInfo {
                  hasNextPage
                  endCursor
                }
                edges {
                  node {
                    login
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