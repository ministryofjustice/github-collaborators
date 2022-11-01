class GithubCollaborators
  class Repository
    include Logging
    attr_reader :data

    def initialize(data)
      logger.debug "initialize"
      @data = data
    end

    def name
      data.fetch("name")
    end

    def url
      data.fetch("url")
    end

    def locked?
      data.fetch("isLocked")
    end

    def archived?
      data.fetch("isArchived")
    end

    def disabled?
      data.fetch("isDisabled")
    end
  end

  class Repositories
    include Logging
    attr_reader :graphql, :login

    def initialize(params)
      logger.debug "initialize"
      @login = params.fetch(:login)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def list
      logger.debug "list"
      @list ||= get_all_repos
    end

    def current
      logger.debug "current"
      list
        .reject(&:archived?)
        .reject(&:disabled?)
        .reject(&:locked?)
    end

    private

    def get_all_repos
      logger.debug "get_all_repos"
      graphql.get_paginated_results do |end_cursor|
        data = get_repos(end_cursor)
        if data
          arr = data.fetch("nodes").map { |d| Repository.new(d) }
          [arr, data]
        else
          logger.warn("GH GraphQL query data is missing")
          abort
        end
      end
    end

    def get_repos(end_cursor = nil)
      logger.debug "get_repos"
      json = graphql.run_query(repositories_query(end_cursor))
      if json.include?("errors")
        warn("repositories:get_repos(): graphql query contains errors")
        if json.include?("RATE_LIMITED")
          sleep(300)
          get_repos(end_cursor)
        else
          abort(json)
        end
      else
        JSON.parse(json).dig("data", "organization", "repositories")
      end
    end

    def repositories_query(end_cursor)
      logger.debug "repositories_query"
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
    {
      organization(login: "#{login}") {
        repositories(first: 100 #{after}) {
          nodes {
            name
            url
            isLocked
            isArchived
            isDisabled
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    }
      ]
    end
  end
end
