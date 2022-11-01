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

    # Sample response
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
    def list
      logger.debug "list"
      # For every repository in MoJ GitHub organisation
      repositories.each_with_object([]) { |repo, arr|
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
          tc = TerraformCollaborator.new(params)
          if tc.status == TerraformCollaborator::FAIL
            arr.push(tc.to_hash)
          end
          arr # rubocop:disable Lint/Void
        end
      }
    end

    # Returns the outside collaborators for a certain repository, sample response:
    # {:login=>"benashton", :login_url=>"https://github.com/benashton", :permission=>"admin"}
    def for_repository(repo_name)
      logger.debug "for_repository"
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

    # Returns a list of all active repositories as Repositories objects (does not include locked, archived etc)
    def repositories
      logger.debug "repositories"
      @repos ||= Repositories.new(login: login).current
    end

    private

    # Returns a list of outside collaborators and additionally checks they are not MoJ organisation Members
    # Note this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    def get_repository_outside_collaborators(repo_name)
      logger.debug "get_repository_outside_collaborators"
      outside_collaborators(repo_name).reject { |user| @organization.is_member?(user.login) }
    end

    # Returns a list of outside collaborators for a given repository
    # Note this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    def outside_collaborators(repo_name)
      logger.debug "outside_collaborators"
      RepositoryCollaborators.new(
        login: login,
        repository: repo_name
      ).list
    end
  end
end
