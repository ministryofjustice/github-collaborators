class GithubCollaborators
  class GithubGraphQlClient
    include Logging
    attr_reader :github_token

    GITHUB_GRAPHQL_URL = "https://api.github.com/graphql"

    def initialize(params)
      logger.debug "initialize"
      @github_token = params.fetch(:github_token)
    end
  
    def run_query(query)
      logger.debug "run_query"
      got_data = false
      response = nil

      until got_data
        response = query_github_api(query)
        if response.code != "200"
          if response.body.include?("errors")
            if response.body.include?("RATE_LIMITED")
              sleep 300
            else
              logger.fatal "GH GraphQL query contains errors"
              abort(response.body)
            end
          end
        else
          got_data = true
        end
      end

      if response.body.nil?
        logger.fatal "GH GraphQL query data is missing"
        abort
      end

      response.body
    end

    private

    def query_github_api(body)
      logger.debug "query_github_api"
      json = {query: body}.to_json
      headers = {"Authorization" => "bearer #{github_token}"}

      uri = URI.parse(GITHUB_GRAPHQL_URL)
      resp = Net::HTTP.post(uri, json, headers)

      resp
    end
  end
end