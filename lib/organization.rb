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

class Organization < GithubGraphQlClient
  attr_reader :login

  PAGE_SIZE = 100

  def initialize(params)
    @login = params.fetch(:login)
    super(params)
  end

  def members
    @list ||= get_all_members
  end

  private

  def get_all_members
    members = []
    end_cursor = nil

    loop do
      data = get_members(end_cursor)
      members = members + data.fetch("edges").map { |d| Member.new(d) }
      break unless data.dig("pageInfo", "hasNextPage")
      end_cursor = data.dig("pageInfo", "endCursor")
    end

    members
  end

  def get_members(end_cursor = nil)
    json = run_query(members_query(end_cursor))
    JSON.parse(json).dig("data", "organization", "membersWithRole")
  end

  def members_query(end_cursor)
    after = end_cursor.nil? ? "" : %[, after: "#{end_cursor}"]
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
