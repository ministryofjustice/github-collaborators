class GithubCollaborators
  class GithubGraphQlClient
    include Logging

    def initialize
      logger.debug "initialize"
      @github_token = ENV.fetch("ADMIN_GITHUB_TOKEN")
    end

    def run_query(query)
      logger.debug "run_query"
      got_data = false
      response = nil
      count = 0

      until got_data
        count += 1
        response = query_github_api(query)
        if response.code == "200"
          if response.body.include?("errors")
            if response.body.include?("RATE_LIMITED")
              sleep 300
            else
              logger.fatal "GH GraphQL query contains errors"
              abort(response.body)
            end
          end
          got_data = true
        end
        if count > 5
          logger.fatal "GH GraphQL query error"
          abort
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
      headers = {"Authorization" => "bearer #{@github_token}"}
      uri = URI.parse("https://api.github.com/graphql")
      Net::HTTP.post(uri, json, headers)
    end
  end
end
