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
      @outside_collaborators = get_org_outside_collaborators

      # This is a list of Organization member login names
      @organization_members = get_all_organisation_members

      # This is a list of Organization archived repository names
      @archived_repositories = get_archived_repositories

      # This is a list of Organization repository objects (that are not disabled or archived)
      @repositories = get_active_repositories

      # This is the number of Organization outside collaborators
      @github_collaborators = @outside_collaborators.length

      # This is an list of the collaborator names who have full Org membership
      @full_org_members = []

      # This is a list of the all-org members-members team repositories
      @all_org_members_team_repositories = get_all_org_members_team_repositories
    end

    def get_org_archived_repositories
      logger.debug "get_org_archived_repositories"
      @archived_repositories
    end

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

    def is_collaborator_an_org_member(login)
      logger.debug "is_collaborator_an_org_member"
      # Loop through all the org members
      @organization_members.each do |org_member|
        # See if collaborator name is in the org members list
        if org_member.downcase == login.downcase
          add_new_collaborator_and_org_member(login.downcase)
          return true
        end
      end
      false
    end

    def add_full_org_member(login)
      logger.debug "add_full_org_member"
      full_org_member = GithubCollaborators::FullOrgMember.new(login.downcase)
      @full_org_members.push(full_org_member)
    end

    def create_full_org_members(terraform_collaborators)
      logger.debug "create_full_org_members"

      # A list of FullOrgMember objects is created in this function when a full org members is detected
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

    # Where collaborator is not defined in Terraform, add collaborator to those files
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

    # Find which collaborators has a difference in repository permissions
    def get_full_org_members_with_repository_permission_mismatches(terraform_files_obj)
      logger.debug "get_full_org_members_with_repository_permission_mismatches"
      return_list = []
      @full_org_members.each do |full_org_member|
        if full_org_member.mismatched_repository_permissions_check(terraform_files_obj)
          return_list.push({login: full_org_member.login.downcase, mismatches: full_org_member.repository_permission_mismatches})
        end
      end
      return_list
    end

    # Find the collaborators that are attached to no GitHub repositories
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

    # Find which collaborators are attached to archived repositories in the files that we track
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

    private

    # Check and store collaborator that have full §org membership
    def add_new_collaborator_and_org_member(new_collaborator_login)
      logger.debug "add_new_collaborator_and_org_member"

      new_collaborator_login = new_collaborator_login.downcase

      if is_collaborator_a_full_org_member(new_collaborator_login) == false
        add_full_org_member(new_collaborator_login)
      end
    end
  end
end
