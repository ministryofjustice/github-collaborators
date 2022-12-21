# The GithubCollaborators class namespace
class GithubCollaborators
  # The HttpClient class
  class HttpClient
    include Logging

    def initialize
      logger.debug "initialize"
      @github_token = ENV.fetch("ADMIN_GITHUB_TOKEN")
      @ops_bot_token = ENV.fetch("OPS_BOT_TOKEN")
    end

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

    def post_json(url, json)
      logger.debug "post_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    def post_pull_request_json(url, json)
      logger.debug "post_pull_request_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Post.new(uri.request_uri, pull_request_headers)
      request.body = json
      http.request(request)
    end

    def patch_json(url, json)
      logger.debug "patch_json"
      http, uri = create_http_client(url)
      request = Net::HTTP::Patch.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    def delete(url)
      logger.debug "delete"
      http, uri = create_http_client(url)
      request = Net::HTTP::Delete.new(uri.request_uri, headers)
      http.request(request)
    end

    private

    def http_get(url)
      logger.debug "http_get"
      http, uri = create_http_client(url)
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      http.request(request)
    end

    def create_http_client(url)
      logger.debug "create_http_client"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      [http, uri]
    end

    APPLICATION_JSON = "application/json"

    def headers
      {
        "Accept" => APPLICATION_JSON,
        "Content-Type" => APPLICATION_JSON,
        "Authorization" => "token #{@github_token}"
      }
    end

    def pull_request_headers
      {
        "Accept" => APPLICATION_JSON,
        "Content-Type" => APPLICATION_JSON,
        "Authorization" => "token #{@ops_bot_token}"
      }
    end
  end
end
