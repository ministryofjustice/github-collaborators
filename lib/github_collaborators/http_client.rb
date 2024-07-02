# The GithubCollaborators class namespace
class GithubCollaborators
  # The HttpClient class
  class HttpClient
    include Logging
    include Constants

    # Send and get data from Github using the REST API

    def initialize
      logger.debug "initialize"
      @ops_bot_token = ENV.fetch("OPS_BOT_TOKEN")
    end

    # Get the HTTP code from a GitHub REST API request
    #
    # @param url [String] the REST API URL
    # @return [String] the HTTP response code
    def fetch_code(url)
      logger.debug "fetch_code"
      response = http_get(url)
      response.code
    end

    # Get data from GitHub REST API
    #
    # @param url [String] the REST API URL
    # @return [Bool] the returned data from GitHub
    def fetch_json(url)
      logger.debug "fetch_json"
      got_data = false
      response = nil
      count = 0

      until got_data
        count += 1
        response = http_get(url)
        if response.code != "200"
          if response.body.include?("errors")
            if response.body.include?(RATE_LIMITED)
              sleep 300
            else
              logger.fatal "HTTP Client REST API query contains errors"
              abort(response.body)
            end
          end
        else
          got_data = true
        end
        if count > 5
          logger.fatal "HTTP Client REST API query error"
          abort
        end
      end

      response.body
    end

    # Send data to GitHub REST API
    #
    # @param url [String] the REST API URL
    # @param json [String] the data to send to GitHub
    def put_json(url, json)
      logger.debug "put_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Put.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    # Send data to GitHub REST API
    #
    # @param url [String] the REST API URL
    # @param json [String] the data to send to GitHub
    def post_json(url, json)
      logger.debug "post_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    # Send a pull request to GitHub REST API using the Ops Eng Team Bot token
    #
    # @param url [String] the REST API URL
    # @param json [String] the data to send to GitHub
    def post_pull_request_json(url, json)
      logger.debug "post_pull_request_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Post.new(uri.request_uri, pull_request_headers)
      request.body = json
      http.request(request)
    end

    # Send data to GitHub REST API
    #
    # @param url [String] the REST API URL
    # @param json [String] the data to send to GitHub
    def patch_json(url, json)
      logger.debug "patch_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Patch.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    # Send a delete query to GitHub REST API
    #
    # @param url [String] the REST API URL
    def delete(url)
      logger.debug "delete"
      http, uri = create_http_client(url)
      request = Net::HTTP::Delete.new(uri.request_uri, headers)
      http.request(request)
    end

    private

    # Send a get query to GitHub REST API
    #
    # @param url [String] the REST API URL
    # @return [Net::HTTPResponse] the returned data from GitHub
    def http_get(url)
      logger.debug "http_get"
      http, uri = create_http_client(url)
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      http.request(request)
    end

    # Create a client to do the GitHub REST API query
    #
    # @param url [String] the REST API URL
    # @return [Array<Net::HTTP, URI>] the client object and URI
    def create_http_client(url)
      logger.debug "create_http_client"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      [http, uri]
    end

    APPLICATION_JSON = "application/vnd.github+json"

    # Create a header structured message
    #
    # @return [Hash{Accept => String, Content-Type => String, Authorization => String}] the header structured message
    def headers
      {
        "Accept" => APPLICATION_JSON,
        "Content-Type" => APPLICATION_JSON,
        "Authorization" => "token #{@ops_bot_token}"
      }
    end

    # Create a header structured message for pull requests
    #
    # @return [Hash{Accept => String, Content-Type => String, Authorization => String}] the header structured message
    def pull_request_headers
      {
        "Accept" => APPLICATION_JSON,
        "Content-Type" => APPLICATION_JSON,
        "Authorization" => "bearer #{@ops_bot_token}"
      }
    end
  end
end
