class GithubCollaborators
  class OrganizationOutsideCollaborators
    attr_reader :login, :base_url

    def initialize(params)
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
    #     :repo_url=>"https://github.com/ministryofjustice/vcms-test-automation",
    #     :login_url=>"https://github.com/user-name",
    #     :permission=>"push"
    #   },
    # ]
    def list
      # For every repository in MoJ GitHub organisation
      repositories.each_with_object([]) { |repo, arr|
        # If an issue has been raised and a grace period has expired then close issue
        GithubCollaborators::IssueClose.new.close_expired_issues(repo.name)

        # For all outside collaborators attached to a repository
        get_repository_outside_collaborators(repo.name).each do |user|
          tc = TerraformCollaborator.new(
            repository: repo.name,
            login: user.login,
            base_url: base_url
          )
          if tc.status == TerraformCollaborator::FAIL
            arr.push(
              tc.to_hash.merge(
                repo_url: repo.url,
                login_url: user.url,
                permission: user.permission
              )
            )
          end
          arr # rubocop:disable Lint/Void
        end
      }
    end

    # Returns the outside collaborators for a certain repository, sample response:
    # {:login=>"benashton", :login_url=>"https://github.com/benashton", :permission=>"admin"}
    def for_repository(repo_name)
      get_repository_outside_collaborators(repo_name).map do |user|
        {
          login: user.login,
          login_url: user.url,
          permission: user.permission
        }
      end
    end

    def is_an_org_member(user_login)
      @organization.is_member?(user_login)
    end

    private

    # Returns a list of all active repositories as Repositories objects (does not include locked, archived etc)
    def repositories
      @repos ||= Repositories.new(login: login).current
    end

    # Returns a list of outside collaborators and additionally checks they are not MoJ organisation Members
    # Not this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    def get_repository_outside_collaborators(repo_name)
      outside_collaborators(repo_name).reject { |user| @organization.is_member?(user.login) }
    end

    # Returns a list of outside collaborators for a given repository
    # Note this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    def outside_collaborators(repo_name)
      RepositoryCollaborators.new(
        login: login,
        repository: repo_name
      ).list
    end
  end
end
