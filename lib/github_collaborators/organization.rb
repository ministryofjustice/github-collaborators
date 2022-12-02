class GithubCollaborators
  class Organization
    include Logging
    include HelperModule
    attr_reader :repositories, :full_org_members, :archived_repositories

    def initialize
      logger.debug "initialize"

      @outside_collaborators = get_org_outside_collaborators

      # Grab the Org members
      @organization_members = get_all_organisation_members

      # Grab the Org repositories
      @repositories = get_active_repositories

      # Grab the Org archived repositories
      @archived_repositories = get_archived_repositories

      # Get all the outside collaborators from GitHub per repo that has an outside collaborator
      @repositories.each do |repository|
        if repository.outside_collaborators_count > 0
          # Get all of the repository outside collaborators login names
          repository_collaborators = fetch_all_collaborators(repository.name)
          # Add collaborators login names to the repository object
          repository.add_outside_collaborators(repository_collaborators)
        end
      end

      # Record the number of collaborators found on GitHub
      @github_collaborators = @outside_collaborators.length

      # There are some collaborators who have full Org membership
      @full_org_members = []

      # Get the all-org members-members team repositories
      @all_org_members_team_repositories = get_all_org_members_team_repositories
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
        if org_member.login.downcase == login.downcase
          add_new_collaborator_and_org_member(login.downcase)
          return true
        end
      end
      false
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

    private

    # Checks and stores which collaborator have org membership
    def add_new_collaborator_and_org_member(new_collaborator_login)
      logger.debug "add_new_collaborator_and_org_member"

      # See if collaborator already exists
      # If it doesn't create a new collaborator
      if is_collaborator_a_full_org_member(new_collaborator_login.downcase) == false
        full_org_member = GithubCollaborators::FullOrgMember.new(new_collaborator_login.downcase)
        @full_org_members.push(full_org_member)
      end
    end
  end
end
