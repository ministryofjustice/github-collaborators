class GithubCollaborators
  class Organization
    include Logging
    attr_reader :base_url

    def initialize(params)
      logger.debug "initialize"
      # URL of the github UI page listing all the terraform files
      @base_url = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"
      @organization_members = params.fetch(:org) { OrganizationMembers.new.get_org_members }
      @outside_collaborators = []
      @repositories = params.fetch(:repositories) { Repositories.new.get_active_repositories }
    end

    def add_outside_collaborator_to_repositories
      logger.debug "add_outside_collaborator_to_repositories"
      # For every repository in MoJ GitHub organisation
      @repositories.each do |repository|
        # Get each outside collaborator
        outside_collaborators = get_repository_outside_collaborators(repository.name)
        outside_collaborators.each do |collaborator|
          params = {
            repository: repository.name,
            login: collaborator.login,
            base_url: @base_url,
            repo_url: repository.url
          }
          # Create the terraform file equivalent of the collaborator
          tc = TerraformCollaborator.new(params)
          # Add that collaborator to the repository
          repository.add_outside_collaborator(tc)
        end
      end
    end

    # Get collaborators from repos that has an issue
    def get_collaborators_with_issues
      logger.debug "get_collaborators_with_issues"
      collaborators = []
      # Check the repositories with outside collaborators
      @repositories.each do |repository|
        # Loop through each repository collaborators
        repository.get_all_outside_collaborators.each do |collaborator|
          # Is there an issue with the collaborator
          if collaborator.status == TerraformCollaborator::FAIL
            # This collaborator has an issue
            collaborators.push(collaborator)
          end
        end
      end
      collaborators
    end

    def fetch_repository_collaborators(repository_name)
      logger.debug "fetch_repository_collaborators"
      repository = @repositories.select { |repository| repository.name == repository_name }
      repository.get_all_outside_collaborators
    end

    def is_collaborator_an_org_member(user_login)
      logger.debug "is_collaborator_an_org_member"
      @organization_members.map(&:login).include?(user_login)
    end

    private

    # Returns a list of outside collaborators
    # This reads data from the GitHub API
    # This has nothing to do with the TerraformCollaborators class which reads data from the .tf files
    def get_repository_outside_collaborators(repo_name)
      logger.debug "get_repository_outside_collaborators"
      GithubCollaborators::RepositoryCollaborators.new(repository: repo_name).fetch_all_collaborators
    end
  end
end
