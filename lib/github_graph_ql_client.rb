class GithubGraphQlClient
  attr_reader :github_token

  GITHUB_GRAPHQL_URL = "https://api.github.com/graphql"

  def initialize(params)
    @github_token = params.fetch(:github_token)
  end

  # private

  def run_query(body)
    json = {query: body}.to_json
    headers = {"Authorization" => "bearer #{github_token}"}

    uri = URI.parse(GITHUB_GRAPHQL_URL)
    resp = Net::HTTP.post(uri, json, headers)

    resp.body
  end
end
