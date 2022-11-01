class GithubCollaborators
  class Member
    include Logging
    attr_reader :data

    def initialize(data)
      logger.debug "initialize"
      @data = data
    end

    def login
      data.dig("node", "login")
    end

    def name
      data.dig("node", "name")
    end
  end

  class Organization
    include Logging
    attr_reader :graphql, :login

    def initialize(login)
      logger.debug "initialize"
      @login = login
      @graphql = GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
    end

    def members
      logger.debug "members"
      @list ||= get_all_organisation_members
    end

    def is_member?(login)
      logger.debug "is_member"
      members.map(&:login).include?(login)
    end

    private

    def get_all_organisation_members
      logger.debug "get_all_organisation_members"
      graphql.get_paginated_results do |end_cursor|
        data = get_organisation_members(end_cursor)
        if data
          arr = data.fetch("edges").map { |d| Member.new(d) }
          [arr, data]
        else
          logger.fatal("GH GraphQL query data is missing")
          abort
        end
      end
    end

    def get_organisation_members(end_cursor = nil)
      logger.debug "get_organisation_members"
      json = graphql.run_query(organisation_members_query(end_cursor))
      sleep(2)
      if json.include?("errors")
        if json.include?("RATE_LIMITED")
          sleep(300)
          get_organisation_members(end_cursor)
        else
          logger.fatal("GH GraphQL query contains errors")
          abort(json)
        end
      else
        JSON.parse(json).dig("data", "organization", "membersWithRole")
      end
    end

    def organisation_members_query(end_cursor)
      logger.debug "organisation_members_query"
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
