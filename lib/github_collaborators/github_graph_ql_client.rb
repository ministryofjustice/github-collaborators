class GithubCollaborators
  class GithubGraphQlClient
    include Logging
    include Constants

    def initialize
      logger.debug "initialize"
      @github_token = ENV.fetch("ADMIN_GITHUB_TOKEN")
    end

    def is_response_okay(response)
      logger.debug "is_response_okay"

      if response.nil? || response == "" || response.code != "200"
        return false
      end

      if response.body.nil? || response.body == ""
        logger.fatal "GH GraphQL query data is missing"
        abort
      elsif response.body.include?(RATE_LIMITED)
        sleep 300
        return false
      elsif response.body.include?("errors")
        logger.fatal "GH GraphQL query contains errors"
        abort(response.body)
      end

      true
    end

    def run_query(query)
      logger.debug "run_query"
      got_data = false
      count = 0

      until got_data
        count += 1
        response = query_github_api(query)
        got_data = is_response_okay(response)
        if count > 5
          logger.fatal "GH GraphQL query error"
          abort
        end
      end
      response.body
    end

    private

    def query_github_api(body)
      logger.debug "query_github_api"
      json = {query: body}.to_json
      headers = {"Authorization" => "bearer #{@github_token}"}
      uri = URI.parse(GRAPHQL_URI)
      Net::HTTP.post(uri, json, headers)
    end
  end
end
