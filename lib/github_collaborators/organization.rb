class GithubCollaborators
  class Organization
    include Logging
    attr_reader :repositories, :collaborators_and_org_members

    def initialize
      logger.debug "initialize"

      @outside_collaborators = []

      # Grab the Org outside collaborators
      # This has a hard limit return of 100 collaborators
      url = "https://api.github.com/orgs/ministryofjustice/outside_collaborators?per_page=100"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(json)
        .find_all { |collaborator| collaborator["login"] }
        .map { |collaborator| @outside_collaborators.push(collaborator["login"]) }

      # Grab the Org members
      @organization_members = OrganizationMembers.new.org_members

      # Grab the Org repositories
      @repositories = Repositories.new.get_active_repositories

      # Get all the outside collaborators from GitHub per repo that has an outside collaborator
      repo_collaborators = GithubCollaborators::RepositoryCollaborators.new
      @repositories.each do |repository|
        if repository.outside_collaborators_count > 0
          # Get all of the repository outside collaborators login names
          repository_collaborators = repo_collaborators.fetch_all_collaborators(repository.name)
          # Add collaborators login names to the repository object
          repository.add_outside_collaborators(repository_collaborators)
        end
      end

      # Record the number of collaborators found on GitHub
      @github_collaborators = @outside_collaborators.length

      # There are some collaborators who have full Org membership
      @collaborators_and_org_members = []
    end

    def is_collaborator_an_org_member(login)
      logger.debug "is_collaborator_an_org_member"
      # Loop through all the org members
      @organization_members.each do |org_member|
        # See if collaborator name is in the org members list
        if org_member.login == login
          add_collaborator_and_org_member(login)
          return true
        end
      end
      false
    end

    private

    # Checks and stores which collaborator have org membership
    def add_collaborator_and_org_member(login)
      logger.debug "add_collaborator_and_org_member"
      if !@collaborators_and_org_members.include?(login)
        @collaborators_and_org_members.push(login)
      end
    end
  end
end
