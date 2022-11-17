class GithubCollaborators
  class FullOrgMember
    include Logging
    attr_reader :login, :missing_repositories, :repository_permission_mismatches

    def initialize(login)
      logger.debug "initialize"
      @graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
      @login = login
      # Store the repositories the collaborator is associated with in this array
      # This is updated by a query directly on the collaborator
      @github_repositories = []
      # Store the repositories the collaborator is associated with in this array for Terraform files
      # This is updated by reading each Terraform file
      @terraform_repositories = []
      @missing_repositories = []
      @excluded_repositories = []
      @repository_permission_mismatches = []
    end

    # Check whether a collaborator is attached to no repositories
    # This is called after the API calls below have been called and
    # the all-org-members team repositories have been removed.
    def odd_full_org_member_check
      logger.debug "odd_full_org_members"
      if @github_repositories.length == 0
        return true
      end
      false
    end

    def add_excluded_repositories(repositories)
      logger.debug "add_excluded_repositories"
      @excluded_repositories = repositories
    end

    def get_full_org_member_repositories
      logger.debug "get_full_org_member_repositories"
      end_cursor = nil
      loop do
        # Read which Github repositories the collaborator has access to
        response = @graphql.run_query(full_org_member_query(end_cursor))
        repositories = JSON.parse(response).dig("data", "user", "repositories", "edges")
        repositories.each do |repo|
          # Accept only ministryofjustice repositories
          if repo.dig("node", "owner", "login") == "ministryofjustice"
            repository_name = repo.dig("node", "name")
            # Ignore excluded repositories ie the all-org-members team repositories
            if !@excluded_repositories.include?(repository_name)
              # Store repository
              @github_repositories.push(repository_name)
            end
          end
        end
        break unless JSON.parse(response).dig("data", "user", "repositories", "pageInfo", "hasNextPage")
        end_cursor = JSON.parse(response).dig("data", "user", "repositories", "pageInfo", "endCursor")
      end
    end

    def add_terraform_repositories(repositories)
      logger.debug "add_terraform_repositories"
      @terraform_repositories = repositories
    end

    def do_repositories_match
      logger.debug "do_repositories_match"

      if @github_repositories.length > 0 && @terraform_repositories.length == 0
        # GitHub repository exists and no Terraform files exists
        @github_repositories.each do |github_repository_name|
          @missing_repositories.push(github_repository_name)
        end
      elsif @github_repositories.length == 0 && @terraform_repositories.length > 0
        # Terraform files exists but no GitHub repository exists
        @terraform_repositories.each do |terraform_repository_name|
          @missing_repositories.push(terraform_repository_name)
        end
      else
        # Join the two arrays
        repositories = @github_repositories + @terraform_repositories
        # Search all repositories
        repositories.each do |repository_name|
          # expect to find repository in both arrays
          if @github_repositories.count(repository_name) == 0 ||
              @terraform_repositories.count(repository_name) == 0
            # Found a missing repository
            @missing_repositories.push(repository_name)
          end
        end

        # Sort and filter any duplicates results
        if @missing_repositories.length > 0
          @missing_repositories.sort!
          @missing_repositories.uniq!
        end
      end

      # Result is based on any missing repositories
      if @missing_repositories.length == 0
        return true
      end
      false
    end

    def check_repository_permissions_match(terraform_files)
      logger.debug "check_repository_permissions_match"

      permission_mismatch = false
      # Search through the collaborators repositories
      @github_repositories.each do |github_repository_name|

        # Find the matching Terraform file
        terraform_files.terraform_files.each do |terraform_file|

          if terraform_file.filename == GithubCollaborators.tf_safe(github_repository_name)

            # Get the github permission for that repository
            github_permission = get_repository_permission(github_repository_name)

            # Get the permission for the Terraform file
            terraform_permission = terraform_file.get_collaborator_permission(login)

            if github_permission != terraform_permission
              permission_mismatch = true
              # Store values as a hash like this { :permission => "value", :repository_name => "repo_name" }
              @repository_permission_mismatches.push({ :permission => "#{github_permission}", :repository_name => "#{github_repository_name}" })
            end
          end
        end
      end
      permission_mismatch
    end

    def get_repository_permission(repository_name)
      logger.debug "get_repository_permission"
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/collaborators/#{@login}/permission"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(json).dig("permission")
    end

    private

    def full_org_member_query(end_cursor)
      logger.debug "full_org_member_query"
      after = end_cursor.nil? ? "" : %(after: "#{end_cursor}")
      %[
        {
          user(login: "#{@login}") {
            repositories(
              first: 100
              affiliations: ORGANIZATION_MEMBER
              ownerAffiliations: ORGANIZATION_MEMBER
              #{after}
            ) {
              edges {
                node {
                  name
                  owner {
                    login
                  }
                }
              }
              pageInfo {
                endCursor
                hasNextPage
              }
            }
          }
        }
      ]
    end
  end
end
