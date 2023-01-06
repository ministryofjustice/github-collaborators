# The GithubCollaborators class namespace
class GithubCollaborators
  # The Organization class
  class Organization
    include Logging
    include HelperModule
    attr_reader :repositories, :full_org_members, :archived_repositories

    def initialize
      logger.debug "initialize"

      # This is a list of collaborator login names
      # Array<String>
      @outside_collaborators = get_org_outside_collaborators

      # This is a list of Organization member login names
      # Array<String>
      @organization_members = get_all_organisation_members

      # This is a list of Organization archived repository names
      # Array<String>
      @archived_repositories = get_archived_repositories

      # This is a list of Organization repository objects (that are not disabled or archived)
      # Array<GithubCollaborators::Repository>
      @repositories = get_active_repositories

      # This is the number of Organization outside collaborators
      @github_collaborators = @outside_collaborators.length

      # This is an list of the FullOrgMember objects who are collaborators
      # that have full Org membership
      # Array<GithubCollaborators::FullOrgMember>
      @full_org_members = []

      # This is a list of the all-org-members team repositories
      # Array<String>
      @all_org_members_team_repositories = get_all_org_members_team_repositories
    end

    # Get the Organization archived repository name
    #
    # @return [Array<String>] true if no issue were found in the reply
    def get_org_archived_repositories
      logger.debug "get_org_archived_repositories"
      @archived_repositories
    end

    # See if a specific collaborator is an outside collaborator that
    # also has full Organization membership
    #
    # @param collaborator_name [String] the name of the collaborator
    # @return [Bool] true if find collaborator who is a full Organization member
    def is_collaborator_a_full_org_member(collaborator_name)
      logger.debug "is_collaborator_a_full_org_member"
      user_exists = false
      @full_org_members.each do |full_org_member|
        if full_org_member.login.downcase == collaborator_name.downcase
          user_exists = true
        end
      end
      user_exists
    end

    # See if a specific login name is a Organization member
    #
    # @param login [String] the login name to check
    # @return [Bool] true if find Organization member with same login name
    def is_collaborator_an_org_member(login)
      logger.debug "is_collaborator_an_org_member"
      # Loop through all the org members
      login = login.downcase
      @organization_members.each do |org_member|
        # See if collaborator name is in the org members list
        if org_member.downcase == login
          add_new_full_org_member(login)
          return true
        end
      end
      false
    end

    # Create a FullOrgMember object and add it to the full_org_members array
    #
    # @param login [String] the login name of FullOrgMember
    def add_full_org_member(login)
      logger.debug "add_full_org_member"
      full_org_member = GithubCollaborators::FullOrgMember.new(login.downcase)
      @full_org_members.push(full_org_member)
    end

    # Create all the Organization FullOrgMember objects and populate those objects.
    # The Terraform file collaborators are used as the base to find out which
    # collaborators are FullOrgMembers and thus be turned into FullOrgMember objects.
    #
    # @param terraform_collaborators [Array<GithubCollaborators::Collaborator>] the Terraform file collaborators
    def create_full_org_members(terraform_collaborators)
      logger.debug "create_full_org_members"

      # FullOrgMember objects are created within is_collaborator_an_org_member() when a full org member is detected
      terraform_collaborators.each { |collaborator| is_collaborator_an_org_member(collaborator.login.downcase) }

      # Iterate over the list of FullOrgMember objects
      @full_org_members.each do |full_org_member|
        # Add the all-org-members team repositories
        full_org_member.add_all_org_members_team_repositories(@all_org_members_team_repositories)

        # Add the archived repositories
        full_org_member.add_archived_repositories(@archived_repositories)

        # Collect the GitHub and Terraform repositories for each full org member

        # Get the GitHub repositories
        full_org_member.get_full_org_member_repositories

        # Get the repository names where collaborator is defined in Terraform files
        tc_repositories = []
        collaborator_repositories = terraform_collaborators.select { |terraform_collaborator| terraform_collaborator.login.downcase == full_org_member.login.downcase }
        collaborator_repositories.each do |collaborator|
          tc_repositories.push(collaborator.repository.downcase)
        end

        # Add the repositories names to the object
        full_org_member.add_terraform_repositories(tc_repositories)

        # When collaborators already defined in Terraform files, parse them
        # to get additional information about the full org member
        if does_collaborator_already_exist(full_org_member.login.downcase, terraform_collaborators)
          name = get_name(full_org_member.login, terraform_collaborators)
          email = get_email(full_org_member.login, terraform_collaborators)
          org = get_org(full_org_member.login, terraform_collaborators)
          full_org_member.add_info_from_file(email, name, org)
        end
      end
    end

    # Find which FullOrgMembers are not defined in a Terraform file
    #
    # @return [Array<GithubCollaborators::FullOrgMember>] a list of FullOrgMember objects
    def get_full_org_members_not_in_terraform_file
      logger.debug "get_full_org_members_not_in_terraform_file"
      return_list = []
      @full_org_members.each do |full_org_member|
        # Compare the GitHub and Terraform repositories
        if full_org_member.missing_from_terraform_files
          return_list.push(full_org_member)
        end
      end
      return_list
    end

    # Find which FullOrgMembers have a difference in repository access permissions
    #
    # @return [Array<Hash{login => String, mismatches => Array[Hash{ permission => String, repository_name => String }]}>] a list of hash items that have data from the the FullOrgMember objects
    def get_full_org_members_with_repository_permission_mismatches(terraform_files_obj)
      logger.debug "get_full_org_members_with_repository_permission_mismatches"
      return_list = []
      @full_org_members.each do |full_org_member|
        # Compare the GitHub and Terraform repositories to find a permission mismatch
        if full_org_member.mismatched_repository_permissions_check(terraform_files_obj)
          return_list.push({login: full_org_member.login.downcase, mismatches: full_org_member.repository_permission_mismatches})
        end
      end
      return_list
    end

    # Find which FullOrgMembers are attached to no GitHub repositories
    #
    # @return [Array<String>] the list FullOrgMember login names
    def get_odd_full_org_members
      logger.debug "get_odd_full_org_members"
      return_list = []
      @full_org_members.each do |full_org_member|
        if full_org_member.odd_full_org_member_check
          return_list.push(full_org_member.login.downcase)
        end
      end
      return_list
    end

    # Find which FullOrgMembers are attached to archived repositories
    #
    # @return [Array<Hash{login => String, repository_name => String}>] a list of hash items that contain the FullOrgMember login name and archived repository
    def get_full_org_members_attached_to_archived_repositories(terraform_files_obj)
      logger.debug "get_full_org_members_attached_to_archived_repositories"
      return_list = []
      @full_org_members.each do |full_org_member|
        full_org_member.attached_archived_repositories.each do |archived_repository|
          if terraform_files_obj.does_file_exist(archived_repository.downcase)
            return_list.push({login: full_org_member.login.downcase, repository: archived_repository.downcase})
          end
        end
      end
      return_list
    end

    # Call the function to get the issues for a repository from
    # GitHub and add them to the repository object
    # @param repositories [Array<String>] the repository names
    def get_repository_issues_from_github(repositories)
      logger.debug "get_repository_issues_from_github"
      repositories.each do |repository_name|
        @repositories.each do |org_repository|
          if org_repository.name == repository_name
            issues = get_issues_from_github(repository_name)
            org_repository.add_issues(issues)
          end
        end
      end
    end

    # Returns the issues from a specific repository object
    # @param repository_name [String] the repository name
    # @return [Array< Hash{title => String, state => String>, created_at => Date, number => Numeric} >] the issues
    def read_repository_issues(repository_name)
      logger.debug "read_repository_issues"
      @repositories.each do |repository|
        if repository.name == repository_name
          return repository.issues
        end
      end
      []
    end

    # Check if a full Organization member is attached to a repository
    # @param repository_name [String] the repository name
    # @return [Bool] true if attached to the repository
    def is_full_org_member_attached_to_repository(repository_name)
      logger.debug "is_full_org_member_attached_to_repository"
      @full_org_members.each do |full_org_member|
        if full_org_member.github_repositories.include?(repository_name)
          return true
        end
      end
      false
    end

    private

    # Adds a new full Organization member if it doesn't already exist
    #
    # @param collaborator_login [String] the login name of the collaborator
    def add_new_full_org_member(collaborator_login)
      logger.debug "add_new_full_org_member"

      collaborator_login = collaborator_login.downcase

      if is_collaborator_a_full_org_member(collaborator_login) == false
        add_full_org_member(collaborator_login)
      end
    end
  end
end
