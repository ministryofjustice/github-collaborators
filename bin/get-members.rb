#!/usr/bin/env ruby

require "pry-byebug"
require_relative "../lib/github_collaborators"

PAGE_SIZE = 100

def get_all_members(client)
  members = []
  end_cursor = nil

  data = get_members(client, end_cursor)

  members = members + data.fetch("edges")
  next_page = data.dig("pageInfo", "hasNextPage")
  end_cursor = data.dig("pageInfo", "endCursor")

  while next_page do
    data = get_members(client, end_cursor)
    members = members + data.fetch("edges")
    next_page = data.dig("pageInfo", "hasNextPage")
    end_cursor = data.dig("pageInfo", "endCursor")
  end

  members
end

def get_members(client, end_cursor = nil)
  json = client.run_query(members_query(end_cursor))
  JSON.parse(json).dig("data", "organization", "membersWithRole")
end

def members_query(end_cursor)
  after = end_cursor.nil? ? "" : %[, after: "#{end_cursor}"]
  %[
    {
      organization(login: "ministryofjustice") {
        membersWithRole(first: #{PAGE_SIZE} #{after}) {
          edges {
            node {
              login
              name
            }
            role
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    }
  ]
end

client = GithubGraphQlClient.new(github_token: ENV.fetch("GITHUB_TOKEN"))

puts get_all_members(client).size
