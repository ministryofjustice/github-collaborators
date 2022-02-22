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

    def initialize(login)
      @login = login
      @graphql = GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
    end

    def members
      @list ||= get_all_organisation_members
    end

    def is_member?(login)
      members.map(&:login).include?(login)
    end

    private

    def get_all_organisation_members
      graphql.get_paginated_results do |end_cursor|
        data = get_organisation_members(end_cursor)
        if data
          arr = data.fetch("edges").map { |d| Member.new(d) }
          [arr, data]
        else
          STDERR.puts('organization:get_all_organisation_members(): graphql query data missing')
          abort()
         end
      end
    end

    def get_organisation_members(end_cursor = nil)
      json = graphql.run_query(organisation_members_query(end_cursor))
      sleep(2)
      if json.include?('errors')
        STDERR.puts('organization:get_organisation_members(): graphql query contains errors')
        if json.include?("RATE_LIMITED")
          sleep(300)
          get_organisation_members(end_cursor)
        else
          abort(json)
        end
      else
        JSON.parse(json).dig("data", "organization", "membersWithRole")
      end
    end

    def organisation_members_query(end_cursor)
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
