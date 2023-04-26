# The GithubCollaborators class namespace
class GithubCollaborators
  # The FullOrgMember class
  class FullOrgMember
    include Logging
    include HelperModule
    attr_reader :login, :email, :org, :name, :missing_from_repositories, :removed_from_repositories, :repository_permission_mismatches, :attached_archived_repositories, :github_repositories, :terraform_repositories, :github_archived_repositories, :ignore_repositories, :all_org_members_team_repositories

    # This class covers collaborators that are full Organization members
    # Full Organization members have access to repositories via Organization teams.
    # We need to track these collaborators.
    # Tracking these collaborators increases the App complexity.
    # Because collaborator can be in a team, their permission to the repository can be different to the Terraform file.

    def initialize(login)
      logger.debug "initialize"

      # Store the repositories the collaborator is associated within this array
      # This is updated by a query directly on the collaborator
      # Array<String>
      @github_repositories = []

      # Store the Terraform files related repositories the collaborator is associated within this array
      # This is updated by reading each Terraform file
      # Array<String>
      @terraform_repositories = []

      # This array will store the repositories where the collaborator is not defined in Terraform files
      # Array<String>
      @missing_from_repositories = []

      # This array will store the Github repositories where the collaborator has been removed
      # Array<String>
      @removed_from_repositories = []

      # This array stores the all-org-members team repositories
      # Array<String>
      @all_org_members_team_repositories = []

      # This array stores which repositories have a permission mismatch, meaning the team has different permissions
      # Array[Hash{ permission => String, repository_name => String }]
      @repository_permission_mismatches = []

      # This array stores which repositories the full org member has been newly added to a Terraform file,
      # because they were missing from that Terraform file. The reason for this array is because the Terraform
      # file may not exist until a pull request has been created and merged in.
      # Array<String>
      @ignore_repositories = []

      # This array stores the Organization repositories that have been archived. This array of repositories is
      # used to check if the collaborator has access to archived repositories.
      # Array<String>
      @github_archived_repositories = []

      # This array stores which Organization repositories the collaborator has access to.
      # Array<String>
      @attached_archived_repositories = []

      @login = login.downcase
      @email = ""
      @name = ""
      @org = ""
    end

    # Add new values to the collaborator
    #
    # @param email [String] the new email address
    # @param name [String] the new collaborator name
    # @param org [String] the new organization name
    def add_info_from_file(email, name, org)
      logger.debug "add_info_from_file"
      @email = email.downcase
      @name = name.downcase
      @org = org.downcase
    end

    # Add a repository name to the ignore repositories array
    #
    # @param repository_name [String] the repository name
    def add_ignore_repository(repository_name)
      logger.debug "add_ignore_repository"
      @ignore_repositories.push(repository_name.downcase)
      ignore_repositories.sort!
      ignore_repositories.uniq!
    end

    # Add repository names to the all-org-member team repositories array
    #
    # @param repositories [Array<String>] the repository names
    def add_all_org_members_team_repositories(repositories)
      logger.debug "add_all_org_members_team_repositories"
      @all_org_members_team_repositories = repositories
      @all_org_members_team_repositories.sort!
      @all_org_members_team_repositories.uniq!
    end

    # Add repository name to the github repositories array
    #
    # @param repositories [String] the repository name
    def add_github_repository(repository_name)
      logger.debug "add_github_repository"
      @github_repositories.append(repository_name)
      @github_repositories.sort!
      @github_repositories.uniq!
    end

    # Add repository names to the archived repositories array
    #
    # @param repositories [Array<String>] the repository names
    def add_archived_repositories(repositories)
      logger.debug "add_archived_repositories"
      @github_archived_repositories = repositories
      @github_archived_repositories.sort!
      @github_archived_repositories.uniq!
    end

    # Add names of Terraform file to the terraform repositories array
    #
    # @param terraform_repositories [Array<String>] the repository names
    def add_terraform_repositories(terraform_repositories)
      logger.debug "add_terraform_repositories"
      terraform_repositories.each do |terraform_repository_name|
        # Ignore excluded repositories ie the all-org-members team repositories and archived repositories
        # This is to focus on active repositories that should be tracked
        if !@all_org_members_team_repositories.include?(terraform_repository_name.downcase) && !@github_archived_repositories.include?(terraform_repository_name.downcase)
          @terraform_repositories.push(terraform_repository_name.downcase)
        end
      end
      @terraform_repositories.sort!
      @terraform_repositories.uniq!
    end

    # A check too see if the collaborator is attached to no repositories
    #
    # @return [Bool] true if collaborator is not attached to any repositories or defined in a Terraform file
    def odd_full_org_member_check
      logger.debug "odd_full_org_members"
      if (@github_repositories.length == 0 || @terraform_repositories.length == 0) && @all_org_members_team_repositories.length == 0
        return true
      end
      false
    end

    # Collect which GitHub repository names the collaborator is attached to
    #
    def get_full_org_member_repositories
      logger.debug "get_full_org_member_repositories"
      end_cursor = nil
      graphql = GithubCollaborators::GithubGraphQlClient.new
      repositories = []

      loop do
        response = graphql.run_query(full_org_member_query(end_cursor))
        json_data = JSON.parse(response)
        repos = json_data.dig("data", "user", "repositories", "edges")
        repositories += repos
        end_cursor = json_data.dig("data", "user", "repositories", "pageInfo", "endCursor")
        break unless json_data.dig("data", "user", "repositories", "pageInfo", "hasNextPage")
      end

      repositories.each do |repo|
        # Accept only ministryofjustice repositories
        if repo.dig("node", "owner", "login").downcase == ORG
          repository_name = repo.dig("node", "name").downcase

          # Filter out repositories from the all-org-members team and archived repositories
          if !is_repo_already_known(repository_name)
            # Store new repository
            add_github_repository(repository_name)
          end

          # Store which archived repositories the collaborator is attached to
          # App will raise Slack alerts for this later on
          if @github_archived_repositories.include?(repository_name)
            add_attached_archived_repository(repository_name)
          end
        end
      end
    end

    # Add the repository name to the attached archived array
    #
    # @param repository_name [String] the repository name
    def add_attached_archived_repository(repository_name)
      logger.debug "add_attached_archived_repository"
      @attached_archived_repositories.push(repository_name)
      @attached_archived_repositories.sort!
      @attached_archived_repositories.uniq!
    end

    # Check if the collaborator is defined in the same repositories on GitHub and within the Terraform files
    #
    # @return [Bool] true if collaborator repositories on GitHub and in Terraform files match each other
    def missing_from_terraform_files
      logger.debug "missing_from_terraform_files"

      missing_repositories = []

      # Join the two arrays
      repositories = @github_repositories + @terraform_repositories
      repositories.uniq!
      repositories.sort!

      repositories.each do |repository_name|
        repository_name = repository_name.downcase
        # expect to find the repository name on GitHub but not in a Terraform file
        if @github_repositories.count(repository_name) > 0 &&
            @terraform_repositories.count(repository_name) == 0
          missing_repositories.push(repository_name)
        end
      end

      if missing_repositories.length > 0
        # Store the missing repositories to the object variable
        missing_repositories.each do |repository_name|
          repository_name = repository_name.downcase
          # but filter out the all-org-members team repositories
          if !@all_org_members_team_repositories.include?(repository_name)
            @missing_from_repositories.push(repository_name)
          end
        end

        @missing_from_repositories.sort!
        @missing_from_repositories.uniq!
      end

      # Result is based on any missing repositories
      if @missing_from_repositories.length == 0
        return false
      end
      true
    end

    # Check if the full org member has been removed from any GitHub repositories
    #
    # @return [Bool] true if full org member exists in a terraform file but not in a Github repository
    def removed_from_github_repository
      logger.debug "removed_from_github_repository"
      removed_repositories = []

      # Join the two arrays
      repositories = @github_repositories + @terraform_repositories
      repositories.uniq!
      repositories.sort!

      repositories.each do |repository_name|
        repository_name = repository_name.downcase
        # expect to find the repository name on GitHub but not in a Terraform file
        if @terraform_repositories.count(repository_name) > 0 &&
            @github_repositories.count(repository_name) == 0
          removed_repositories.push(repository_name)
        end
      end

      if removed_repositories.length > 0
        removed_repositories.each do |repository_name|
          repository_name = repository_name.downcase
          # filter out the all-org-members team repositories
          if !@all_org_members_team_repositories.include?(repository_name)
            @removed_from_repositories.push(repository_name)
          end
        end

        @removed_from_repositories.sort!
        @removed_from_repositories.uniq!
      end

      # Result is based on being removed from any repositories
      if @removed_from_repositories.length == 0
        return false
      end
      true
    end

    # Check collaborator for permissions mismatches between GitHub and the Terraform files
    #
    # @param terraform_files_obj [Array<GithubCollaborators::TerraformFiles>] the terraform file objects
    # @return [Bool] true if a permission mismatch exists
    def mismatched_repository_permissions_check(terraform_files_obj)
      logger.debug "mismatched_repository_permissions_check"

      permission_mismatch = false
      # Search through the collaborators repositories
      @github_repositories.each do |github_repository_name|
        github_repository_name = github_repository_name.downcase
        # Find the matching Terraform file
        terraform_files = terraform_files_obj.get_terraform_files
        terraform_files.each do |terraform_file|
          # Skip this iteration if file name is in the ignore array, the ignore array
          # contains repositories / Terraform files that are not on the GitHub yet
          if !@ignore_repositories.include?(terraform_file.filename.downcase) && terraform_file.filename.downcase == tf_safe(github_repository_name)

            # Get the github permission for that repository
            github_permission = get_repository_permission(github_repository_name)

            # Get the permission for the Terraform file
            terraform_permission = terraform_file.get_collaborator_permission(@login)

            if github_permission != terraform_permission
              permission_mismatch = true
              # Store values as a hash like this { permission: "granted_permission", repository_name: "repo_name" }
              @repository_permission_mismatches.push({permission: github_permission.to_s, repository_name: github_repository_name.to_s})
            end
          end
        end
      end
      permission_mismatch
    end

    # Get the collaborator permission for a specific repository name
    #
    # @param repository_name [String] the repository name
    # @return [String] the collaborator repository permission value
    def get_repository_permission(repository_name)
      logger.debug "get_repository_permission"
      url = "#{GH_API_URL}/#{repository_name.downcase}/collaborators/#{@login}/permission"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      json_data = JSON.parse(json)
      if json_data.dig("user", "permissions", "admin")
        "admin"
      elsif json_data.dig("user", "permissions", "maintain")
        "maintain"
      elsif json_data.dig("user", "permissions", "push")
        "push"
      elsif json_data.dig("user", "permissions", "triage")
        "triage"
      else
        "pull"
      end
    end

    private

    # Check if repository name is in arrays that store repository names for various reasons
    # This includes the all-org-members team and archived array of repository names
    # The reason for this is to focus on active repositories that should be tracked and filter
    # out those that do not need to be
    #
    # @param repository_name [String] the repository name
    # @return [Bool] true if the repository name is in the archived array or all-org-member team array of repositories
    def is_repo_already_known(repository_name)
      if @all_org_members_team_repositories.include?(repository_name) || @github_archived_repositories.include?(repository_name)
        return true
      end
      false
    end

    # Create a GraphQL query that returns the repository names the collaborators has access to
    #
    # @param end_cursor [String] id of next page in search results
    # @return [String] the GraphQL query
    def full_org_member_query(end_cursor)
      logger.debug "full_org_member_query"
      after = end_cursor.nil? ? "null" : "\"#{end_cursor}\""
      %[
        {
          user(login: "#{@login}") {
            repositories(
              affiliations: ORGANIZATION_MEMBER
              ownerAffiliations: ORGANIZATION_MEMBER
              first: 100
              after: #{after}
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
