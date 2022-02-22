class GithubCollaborators
  class Repository
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def id
      data.fetch("id")
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
    attr_reader :graphql, :login

    def initialize(params)
      @login = params.fetch(:login)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def list
      @list ||= get_all_repos
    end

    def current
      list
        .reject(&:archived?)
        .reject(&:disabled?)
        .reject(&:locked?)
    end

    private

    def get_all_repos
      graphql.get_paginated_results do |end_cursor|
        data = get_repos(end_cursor)
        if data
          arr = data.fetch("nodes").map { |d| Repository.new(d) }
          [arr, data]
        else
          STDERR.puts('repositories:get_all_repos(): graphql query data missing')
          abort()
         end
      end
    end

    def get_repos(end_cursor = nil)
      json = graphql.run_query(repositories_query(end_cursor))
      sleep(2)
      if json.include?('errors')
        STDERR.puts('repositories:get_repos(): graphql query contains errors')
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
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
    {
      organization(login: "#{login}") {
        repositories(first: #{PAGE_SIZE} #{after}) {
          nodes {
            id
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
