class GithubCollaborators
  class OrganizationOutsideCollaborators
    include Logging
    attr_reader :login, :base_url

    def initialize(params)
      logger.debug "initialize"
      @login = params.fetch(:login)
      @base_url = params.fetch(:base_url) # URL of the github UI page listing all the terraform files
      @organization ||= Organization.new(params.fetch(:login))
    end

    # Sample response: A [] of {} objects as shown below
    # [
    #   {
    #     "repository"=>"vcms-test-automation",
    #     "login"=>"user-name",
    #     "status"=>"fail",
    #     "issues"=>[
    #       "Review after date is more than a year in the future"
    #     ],
    #     "href"=>"https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/vcms-test-automation.tf",
    #     "defined_in_terraform"=>true,
    #     "review_date"=>"2022-10-10",
    #     "repo_url"=>"https://github.com/ministryofjustice/vcms-test-automation",
    #     "login_url"=>"https://github.com/user-name",
    #     "permission"=>"push"
    #   },
    # ]
    def fetch_users_with_issues
      logger.debug "fetch_users_with_issues"
      # For every repository in MoJ GitHub organisation
      fetch_org_repositories.each_with_object([]) { |repo, users|
        # For all outside collaborators attached to a repository
        get_repository_outside_collaborators(repo.name).each do |user|
          params = {
            repository: repo.name,
            login: user.login,
            base_url: @base_url,
            repo_url: repo.url,
            login_url: user.url,
            permission: user.permission
          }
          # Create the terraform file equivalent of the collaborator
          tc = TerraformCollaborator.new(params)
          # Is there an issue with the collaborator
          if tc.status == TerraformCollaborator::FAIL
            # This collaborator has an issue
            users.push(tc.to_hash)
          end
          users # rubocop:disable Lint/Void
        end
      }
    end

    # Returns the outside collaborators for a certain repository
    # Sample response: immutable hash values
    # {
    #   :login=>"benashton",
    #   :login_url=>"https://github.com/benashton",
    #   :permission=>"admin"
    # }
    def fetch_repository_collaborators(repo_name)
      logger.debug "fetch_repository_collaborators"
      get_repository_outside_collaborators(repo_name).map do |user|
        {
          login: user.login,
          login_url: user.url,
          permission: user.permission
        }
      end
    end

    def is_an_org_member(user_login)
      logger.debug "is_an_org_member"
      @organization.is_member?(user_login)
    end

    # Returns a list of all active repositories (as Repositories objects) excluding locked, archived etc
    def fetch_org_repositories
      logger.debug "repositories"
      @repos ||= Repositories.new(login: login).active_repositories
    end

    private

    # Returns a list of outside collaborators and additionally checks they are not MoJ organisation Members
    # This reads data from the GitHub API
    # This has nothing to do with the TerraformCollaborators class which reads data from the .tf files
    def get_repository_outside_collaborators(repo_name)
      logger.debug "get_repository_outside_collaborators"
      outside_collaborators(repo_name).reject { |user| @organization.is_member?(user.login) }
    end

    # Returns a list of outside collaborators for a given repository
    # This reads data from the GitHub API
    # This has nothing to do with the TerraformCollaborators class which reads data from the .tf files
    def outside_collaborators(repo_name)
      logger.debug "outside_collaborators"
      RepositoryCollaborators.new(
        login: login,
        repository: repo_name
      ).fetch_all_collaborators
    end
  end
end
