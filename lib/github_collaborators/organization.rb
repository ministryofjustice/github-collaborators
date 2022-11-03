class GithubCollaborators
  class Member
    include Logging
    attr_reader :login, :name

    def initialize(data)
      logger.debug "initialize"
      @login = data.dig("node", "login")
      # Some users do not return an name
      if data.dig("node", "name").nil?
        # So use the user name instead
        @name = @login
      else
        @name = data.dig("node", "name")
      end   
    end
  end

  class Organization
    include Logging
    attr_reader :graphql

    def initialize
      logger.debug "initialize"
      @graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
      @org_members = get_all_organisation_members
    end

    def is_member?(login)
      logger.debug "is_member"
      @org_members.map(&:login).include?(login)
    end

    private

    def get_all_organisation_members
      logger.debug "get_all_organisation_members"
      org_members = []
      end_cursor = nil
      loop do 
        response = graphql.run_query(organisation_members_query(end_cursor))
        members = JSON.parse(response).dig("data", "organization", "membersWithRole", "edges")
        members.each do |member|
          org_members.push(GithubCollaborators::Member.new(member))
        end
        break unless JSON.parse(response).dig("data", "organization", "membersWithRole", "pageInfo", "hasNextPage")
        end_cursor = JSON.parse(response).dig("data", "organization", "membersWithRole", "pageInfo", "endCursor")
      end
      org_members.sort_by { |org_member| org_member.name }
    end

    def organisation_members_query(end_cursor)
      logger.debug "organisation_members_query"
      after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
      %[
        {
          organization(login: "ministryofjustice") {
            membersWithRole(first: 100 #{after}) {
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
