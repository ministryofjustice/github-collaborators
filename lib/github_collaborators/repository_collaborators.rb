class GithubCollaborators
  class Collaborator
    include Logging
    attr_reader :login

    def initialize(data)
      logger.debug "initialize"
      @login = data.dig("node", "login")
    end
  end

  class RepositoryCollaborators
    include Logging
    attr_reader :graphql, :repository

    def initialize(params)
      logger.debug "initialize"
      @repository = params.fetch(:repository)
      @graphql = params.fetch(:graphql) { GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def fetch_all_collaborators
      logger.debug "fetch_all_collaborators"
      end_cursor = nil
      collaborators = []
      loop do
        response = graphql.run_query(outside_collaborators_query(end_cursor))
        json_data = JSON.parse(response)
        # Repos with no outside collaborators return an empty array
        break unless !json_data.dig("data", "organization", "repository", "collaborators", "edges").empty?
        outside_collaborators = json_data.dig("data", "organization", "repository", "collaborators", "edges")
        outside_collaborators.each do |outside_collaborator|
          collaborators.push(GithubCollaborators::Collaborator.new(outside_collaborator))
        end
        break unless JSON.parse(response).dig("data", "organization", "repository", "collaborators", "pageInfo", "hasNextPage")
        end_cursor = JSON.parse(response).dig("data", "organization", "repository", "collaborators", "pageInfo", "endCursor")
      end
      collaborators.sort_by { |collaborator| collaborator.login }
    end

    def outside_collaborators_query(end_cursor)
      logger.debug "outside_collaborators_query"
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
      {
        organization(login: "ministryofjustice") {
          repository(name: "#{repository}") {
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
