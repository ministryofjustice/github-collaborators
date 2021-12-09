##!/usr/bin/env ruby

# It is VERY important that the repo setting Actions > General > Fork pull request workflows from outside collaborators is set
# to "Require approval for first-time contributors"

require "net/http"
require "uri"
require "json"

# Grab GitHub token
token = ENV.fetch("ADMIN_GITHUB_TOKEN")

def headers(token)
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Authorization" => "token #{token}"
    }
end

def client(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    [http, uri]
end

def comment_body
{
    body: <<~EOF
            Hi there

            Thank you for creating a GitHub Collaborators pull request.

            Unfortunately the current process does not allow for pull requests from a forked repository due to security concerns.

            Please recreate this pull request from a branch, reach out to us on Slack at #ask-operations-engineering or create an issue on this repo with your requirements.

            This pull request will now be closed.
            
            Sorry for the inconvenience,

            Operations Engineering
        EOF
    }
end

# Grab needed data from GitHub Actions payload
pr_json       = JSON.parse(ENV.fetch("PULL_REQUEST"))
pr_is_fork    = pr_json.dig("head", "repo", "fork")
pr_issue_url  = pr_json.fetch("issue_url", "href")
pr_pull_url   = pr_json.dig("_links", "self", "href")

# If it is a fork, action it
if pr_is_fork
    
    # Leave comment
    http, uri = client("#{pr_issue_url}/comments")
    request = Net::HTTP::Post.new(uri.request_uri, headers(token))
    request.body = comment_body.to_json
    http.request(request)

    # Give GitHub API a little time
    sleep(5)

    # Close PR
    http, uri = client(pr_pull_url)
    request = Net::HTTP::Patch.new(uri.request_uri, headers(token))
    request.body = { "state": "closed" }.to_json
    http.request(request)

end
