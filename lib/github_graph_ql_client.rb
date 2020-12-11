class GithubGraphQlClient
  attr_reader :github_token

  GITHUB_GRAPHQL_URL = "https://api.github.com/graphql"

  def initialize(params)
    @github_token = params.fetch(:github_token)
  end

  def get_paginated_results
    list = []
    end_cursor = nil

    loop do
      arr, data = yield(end_cursor)
      list += arr
      break unless data.dig("pageInfo", "hasNextPage")
      end_cursor = data.dig("pageInfo", "endCursor")
    end

    list
  end

  def run_query(body)
    json = {query: body}.to_json
    headers = {"Authorization" => "bearer #{github_token}"}

    uri = URI.parse(GITHUB_GRAPHQL_URL)
    resp = Net::HTTP.post(uri, json, headers)

    resp.body
  end
end
