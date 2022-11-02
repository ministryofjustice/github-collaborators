class GithubCollaborators
  class HttpClient
    include Logging
    attr_reader :token

    def initialize(params = {})
      logger.debug "initialize"
      @token = params.fetch(:token) { ENV.fetch("ADMIN_GITHUB_TOKEN") }
    end

    def fetch_json(url)
      logger.debug "fetch_json"
      http, uri = client(url)
      request = Net::HTTP::Get.new(uri.request_uri, headers)
      http.request(request)
    end

    def post_json(url, json)
      logger.debug "post_json"
      http, uri = client(url)
      request = Net::HTTP::Post.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    def patch_json(url, json)
      logger.debug "patch_json"
      http, uri = client(url)
      request = Net::HTTP::Patch.new(uri.request_uri, headers)
      request.body = json
      http.request(request)
    end

    def delete(url)
      logger.debug "delete"
      http, uri = client(url)
      request = Net::HTTP::Delete.new(uri.request_uri, headers)
      http.request(request)
    end

    private

    def client(url)
      logger.debug "client"
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
