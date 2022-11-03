class GithubCollaborators
  class Collaborator
    include Logging
    attr_reader :login, :url, :permission

    GITHUB_TO_TERRAFORM_PERMISSIONS = {
      "read" => "pull",
      "triage" => "triage",
      "write" => "push",
      "maintain" => "maintain",
      "admin" => "admin"
    }

    def initialize(data)
      logger.debug "initialize"
      @login = data.dig("node", "login")
      @url = data.dig("node", "url")
      @permission = data.fetch("permission").downcase!
      GITHUB_TO_TERRAFORM_PERMISSIONS.fetch(@permission)
    end
  end

  class RepositoryCollaborators
    include Logging
    attr_reader :graphql, :repository, :login

    def initialize(params)
      logger.debug "initialize"
      @login = params.fetch(:login)
      @repository = params.fetch(:repository)
      @graphql = params.fetch(:graphql) { GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def fetch_all_collaborators
      logger.debug "fetch_all_collaborators"
      end_cursor = nil
      loop do
        response = graphql.run_query(outside_collaborators_query(end_cursor))
        outside_collaborators = JSON.parse(response).dig("data", "organization", "repository", "collaborators")
        outside_collaborators.each do |outside_collaborator|
          @collaborators.push(GithubCollaborators::Collaborator.new(outside_collaborator.fetch("edges")))
        end
        break unless JSON.parse(response).dig("data", "search", "pageInfo", "hasNextPage")
        end_cursor = JSON.parse(response).dig("data", "search","pageInfo", "endCursor")
      end
      @collaborators.sort_by { |collaborator| collaborator.name }
    end

    def outside_collaborators_query(end_cursor)
      logger.debug "outside_collaborators_query"
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
      {
        organization(login: "#{login}") {
          repository(name: "#{repository}") {
            collaborators(first:100 affiliation: OUTSIDE #{after}) {
              pageInfo {
                hasNextPage
                endCursor
              }
              edges {
                permission
                node {
                  login
                  url
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
