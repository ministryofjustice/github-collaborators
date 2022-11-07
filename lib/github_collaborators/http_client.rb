class GithubCollaborators
  class HttpClient
    include Logging
    attr_reader :token

    def initialize
      logger.debug "initialize"
      @token = ENV.fetch("ADMIN_GITHUB_TOKEN")
    end

    def fetch_json(url)
      logger.debug "fetch_json"
      got_data = false
      response = nil

      until got_data
        response = http_get(url)
        if response.code != "200"
          if response.body.include?("errors")
            if response.body.include?("RATE_LIMITED")
              sleep 300
            else
              @logger.fatal "GH GraphQL query contains errors"
              abort(response.body)
            end
          end
        else
          got_data = true
        end
      end

      if response.body.nil?
        @logger.fatal "GH GraphQL query data is missing"
        abort
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

    def headers
      {
        "Accept" => "application/json",
        "Content-Type" => "application/json",
        "Authorization" => "token #{token}"
      }
    end
  end
end
