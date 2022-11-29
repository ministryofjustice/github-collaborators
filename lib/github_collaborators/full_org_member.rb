class GithubCollaborators
  class FullOrgMember
    include Logging
    attr_reader :login, :email, :org, :name, :missing_from_repositories, :repository_permission_mismatches, :attached_archived_repositories

    def initialize(login)
      logger.debug "initialize"
      # Store the repositories the collaborator is associated with in this array
      # This is updated by a query directly on the collaborator
      @github_repositories = []
      # Store the repositories the collaborator is associated with in this array for Terraform files
      # This is updated by reading each Terraform file
      @terraform_repositories = []
      @missing_from_repositories = []
      @org_members_team_repositories = []
      @repository_permission_mismatches = []
      @ignore_repositories = []
      @github_archived_repositories = []
      @attached_archived_repositories = []
      @login = login.downcase
      @email = ""
      @name = ""
      @org = ""
    end

    def add_info_from_file(email, name, org)
      logger.debug "add_info_from_file"
      @email = email.downcase
      @name = name.downcase
      @org = org.downcase
    end

    def add_ignore_repository(repository_name)
      logger.debug "add_ignore_repository"
      @ignore_repositories.push(repository_name.downcase)
    end

    # Check whether a collaborator is attached to no repositories
    def odd_full_org_member_check
      logger.debug "odd_full_org_members"
      if (@github_repositories.length == 0 || @terraform_repositories.length == 0) && @org_members_team_repositories.length == 0
        return true
      end
      false
    end

    def add_all_org_members_team_repositories(repositories)
      logger.debug "add_all_org_members_team_repositories"
      @org_members_team_repositories = repositories
    end

    def add_archived_repositories(repositories)
      logger.debug "add_archived_repositories"
      @github_archived_repositories = repositories
    end

    def get_full_org_member_repositories
      logger.debug "get_full_org_member_repositories"
      end_cursor = nil
      graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))

      repositories = []

      loop do
        # Read which Github repositories the collaborator has access to
        response = graphql.run_query(full_org_member_query(end_cursor))
        repos = JSON.parse(response).dig("data", "user", "repositories", "edges")
        repositories += repos
        break unless JSON.parse(response).dig("data", "user", "repositories", "pageInfo", "hasNextPage")
        end_cursor = JSON.parse(response).dig("data", "user", "repositories", "pageInfo", "endCursor")
      end

      repositories.each do |repo|
        # Accept only ministryofjustice repositories
        if repo.dig("node", "owner", "login").downcase == "ministryofjustice"
          repository_name = repo.dig("node", "name").downcase
          # Ignore excluded repositories ie the all-org-members team repositories and archived repositories
          # This is to focus on active repositories that should be tracked
          if !@org_members_team_repositories.include?(repository_name) && !@github_archived_repositories.include?(repository_name)
            # Store repository
            @github_repositories.push(repository_name)
          end

          # Store which archived repositories the collaborator is attached to
          # as will raise Slack alerts for this later on
          if @github_archived_repositories.include?(repository_name)
            @attached_archived_repositories.push(repository_name)
          end
        end
      end
    end

    def add_terraform_repositories(terraform_repositories)
      logger.debug "add_terraform_repositories"
      terraform_repositories.each do |terraform_repository_name|
        # Ignore excluded repositories ie the all-org-members team repositories and archived repositories
        # This is to focus on active repositories that should be tracked
        if !@org_members_team_repositories.include?(terraform_repository_name.downcase) && !@github_archived_repositories.include?(terraform_repository_name.downcase)
          # Store repository
          @terraform_repositories.push(terraform_repository_name.downcase)
        end
      end
    end

    def do_repositories_match
      logger.debug "do_repositories_match"

      missing_repositories = []

      # Join the two arrays
      repositories = @github_repositories + @terraform_repositories

      repositories.uniq!
      repositories.sort!

      # Search all repositories
      repositories.each do |repository_name|
        repository_name = repository_name.downcase
        # expect to find repository in both arrays
        if @github_repositories.count(repository_name) == 0 ||
            @terraform_repositories.count(repository_name) == 0
          # Found a missing repository
          missing_repositories.push(repository_name)
        end
      end

      if missing_repositories.length > 0
        missing_repositories.each do |repository_name|
          repository_name = repository_name.downcase
          # Ignore the all_org_members team repositories
          if !@org_members_team_repositories.include?(repository_name)
            @missing_from_repositories.push(repository_name)
          end
        end

        @missing_from_repositories.sort!
        @missing_from_repositories.uniq!
      end

      # Result is based on any missing repositories
      if @missing_from_repositories.length == 0
        return true
      end
      false
    end

    def check_repository_permissions_match(terraform_files)
      logger.debug "check_repository_permissions_match"

      permission_mismatch = false
      # Search through the collaborators repositories
      @github_repositories.each do |github_repository_name|
        github_repository_name = github_repository_name.downcase
        # Find the matching Terraform file
        terraform_files.terraform_files.each do |terraform_file|
          # Skip this iteration if file name is in the array, the array
          # contains repositories / Terraform files that are not on the GitHub yet
          if !@ignore_repositories.include?(terraform_file.filename.downcase) && terraform_file.filename.downcase == GithubCollaborators.tf_safe(github_repository_name)

            # Get the github permission for that repository
            github_permission = get_repository_permission(github_repository_name)

            # Get the permission for the Terraform file
            terraform_permission = terraform_file.get_collaborator_permission(@login)

            if github_permission != terraform_permission
              permission_mismatch = true
              # Store values as a hash like this { :permission => "granted_permission", :repository_name => "repo_name" }
              @repository_permission_mismatches.push({permission: github_permission.to_s, repository_name: github_repository_name.to_s})
            end
          end
        end
      end
      permission_mismatch
    end

    def get_repository_permission(repository_name)
      logger.debug "get_repository_permission"
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name.downcase}/collaborators/#{@login}/permission"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      if JSON.parse(json).dig("user", "permissions", "admin")
        "admin"
      elsif JSON.parse(json).dig("user", "permissions", "maintain")
        "maintain"
      elsif JSON.parse(json).dig("user", "permissions", "push")
        "push"
      elsif JSON.parse(json).dig("user", "permissions", "triage")
        "triage"
      else
        "pull"
      end
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
