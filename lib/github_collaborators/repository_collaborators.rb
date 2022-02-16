class GithubCollaborators
  class Collaborator
    attr_reader :data

    # data is a hash, from the github graphql API, like this:
    #
    # {"node"=>{"login"=>"SteveMarshall"},
    #  "permissionSources"=>
    #   [{"permission"=>"ADMIN",
    #     "source"=>
    #      {"websiteUrl"=>"https://www.justice.gov.uk/",
    #       "id"=>"MDEyOk9yZ2FuaXphdGlvbjIyMDM1NzQ=",
    #       "name"=>"Ministry of Justice"}},
    #    {"permission"=>"ADMIN",
    #     "source"=>
    #      {"homepageUrl"=>nil,
    #       "id"=>"MDEwOlJlcG9zaXRvcnkzMTA2MTkyNzY=",
    #       "name"=>"testing-outside-collaborators",
    #       "nameWithOwner"=>"ministryofjustice/testing-outside-collaborators"}},
    #    {"permission"=>"ADMIN",
    #     "source"=>
    #      {"editTeamUrl"=>
    #        "https://github.com/orgs/ministryofjustice/teams/operations-engineering/edit",
    #       "id"=>"MDQ6VGVhbTQxOTIxMTU=",
    #       "name"=>"Operations Engineering",
    #       "combinedSlug"=>"ministryofjustice/operations-engineering"}}]}
    #
    # This user has access to the repo because:
    #   * They are an Organization admin
    #   * They are in the "Operations Engineering" team
    # They also show up as having direct permission on the repository. This is
    # misleading - they only have access to the repository because of their
    # Organization permission and team membership.

    GITHUB_TO_TERRAFORM_PERMISSIONS = {
      "read" => "pull",
      "triage" => "triage",
      "write" => "push",
      "maintain" => "maintain",
      "admin" => "admin"
    }

    def initialize(data)
      @data = data
    end

    def login
      data.dig("node", "login")
    end

    def url
      data.dig("node", "url")
    end

    # This will only be correct if this is an outside collaborator.
    # Organisation members with access to the repository are likely to have
    # multiple permissions, and there is no guarantee that the first permission
    # (which this method returns) is the highest privilege permission.
    def permission
      perm = data.fetch("permissionSources")
        .map { |i| i["permission"] }
        .first
        .downcase
      GITHUB_TO_TERRAFORM_PERMISSIONS.fetch(perm)
    end

    # If the only permissionSources this collaborator has is permission on the
    # repository (i.e. no "Organization" or "Team" permissions), then they have
    # been granted acess specifically to this repository (so they're probably an
    # outside collaborator, but we would need to check a) if they are a member
    # of the organization and b) if they have an organization email address, if
    # we want to confirm that.
    def is_direct_collaborator?
      permission_sources = data.fetch("permissionSources")
      permission_sources.size == 1 && permission_sources.first.fetch("source").has_key?("nameWithOwner") # nameWithOwner means this is a Repository permission
    end
  end

  class RepositoryCollaborators
    attr_reader :graphql, :repository, :owner

    def initialize(params)
      @owner = params.fetch(:owner)
      @repository = params.fetch(:repository)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    # TODO - this only returns the first 100
    # Lists collaborators attached to a repo - GitHub API
    def list
      JSON.parse(graphql.run_query(collaborators_query))
        .dig("data", "organization", "repository", "collaborators", "edges")
        .to_a
        .map { |hash| Collaborator.new(hash) }

      # TODO: Above code hides errors with this function - uncomment below to see silent errors
      # puts JSON.parse(graphql.run_query(collaborators_query))
      # JSON.parse(graphql.run_query(collaborators_query))
    end

    private

    def collaborators_query
      %[
      {
        organization(login: "#{owner}") {
          repository(name: "#{repository}") {
            collaborators(first: 100) {
              edges {
                node {
                  login
                  url
                }
                permissionSources {
                  permission
                  source {
                    ... on Organization { websiteUrl id name }
                    ... on Repository { homepageUrl id name nameWithOwner }
                    ... on Team { editTeamUrl id name combinedSlug }
                  }
                }
              }
            }
          }
        }
      }
      ]
    end
  end
end
