class GithubCollaborators
  class Collaborator
    include Logging
    attr_reader :data

    GITHUB_TO_TERRAFORM_PERMISSIONS = {
      "read" => "pull",
      "triage" => "triage",
      "write" => "push",
      "maintain" => "maintain",
      "admin" => "admin"
    }

    def initialize(data)
      @data = data
    end

    def login
      data.dig("node", "login")
    end

    def url
      data.dig("node", "url")
    end

    def permission
      logger.debug "permission"
      perm = data.fetch("permission").downcase!
      GITHUB_TO_TERRAFORM_PERMISSIONS.fetch(perm)
    end
  end

  class RepositoryCollaborators
    include Logging
    attr_reader :graphql, :repository, :login

    def initialize(params)
      logger.debug "initialize"
      @login = params.fetch(:login)
      @repository = params.fetch(:repository)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def list
      logger.debug "list"
      @list ||= get_all_outside_collaborators
    end

    def get_all_outside_collaborators
      logger.debug "get_all_outside_collaborators"
      arr = []
      graphql.get_paginated_results do |end_cursor|
        data = get_outside_collaborators(end_cursor)
        if data
          arr = data.fetch("edges").map { |d| Collaborator.new(d) }
          [arr, data]
        else
          logger.fatal "GH GraphQL query data missing"
          abort
        end
      end
      arr
    end

    def get_outside_collaborators(end_cursor = nil)
      logger.debug "get_outside_collaborators"
      json = graphql.run_query(outside_collaborators_query_pagination(end_cursor))
      sleep 2
      if json.include?("errors")
        if json.include?("RATE_LIMITED")
          sleep 300
          get_outside_collaborators(end_cursor)
        else
          logger.fatal "GH GraphQL query contains errors"
          abort(json)
        end
      else
        JSON.parse(json).dig("data", "organization", "repository", "collaborators")
      end
    end

    def outside_collaborators_query_pagination(end_cursor)
      logger.debug "outside_collaborators_query_pagination"
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
