class GithubCollaborators
  class Member
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def login
      data.dig("node", "login")
    end

    def name
      data.dig("node", "name")
    end

    def role
      data.fetch("role")
    end
  end

  class Organization
    attr_reader :graphql, :login

    def initialize(params)
      @login = params.fetch(:login)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def members
      @list ||= get_all_members
    end

    def is_member?(login)
      members.map(&:login).include?(login)
    end

    private

    def get_all_members
      graphql.get_paginated_results do |end_cursor|
        data = get_members(end_cursor)
        arr = data.fetch("edges").map { |d| Member.new(d) }
        [arr, data]
      end
    end

    def get_members(end_cursor = nil)
      json = graphql.run_query(members_query(end_cursor))
      JSON.parse(json).dig("data", "organization", "membersWithRole")
    end

    def members_query(end_cursor)
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
    {
      organization(login: "#{login}") {
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
  end
end
