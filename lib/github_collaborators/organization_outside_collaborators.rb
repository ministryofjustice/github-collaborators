class GithubCollaborators
  class OrganizationOutsideCollaborators
    attr_reader :login, :base_url

    def initialize(params)
      @login = params.fetch(:login)
      @base_url = params.fetch(:base_url) # URL of the github UI page listing all the terraform files
      @organization ||= Organization.new(params.fetch(:login))
    end

    def list
      # For every repository in MoJ GitHub organisation
      repositories.each_with_object([]) { |repo, arr|
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
                permission: user.permission,
                last_commit: last_commit(repo.name, user.login, user.id)
              )
            )
          end
          arr
        end
      }
    end

    # Returns the outside collaborators for a certain repository, sample response:
    # {:login=>"benashton", :login_url=>"https://github.com/benashton", :permission=>"admin", :last_commit=>nil}
    # repo_name: string
    def for_repository(repo_name)
      get_repository_outside_collaborators(repo_name).map do |user|
        {
          login: user.login,
          login_url: user.url,
          permission: user.permission,
          last_commit: last_commit(repo_name, user.login, user.id)
        }
      end
    end

    private

    # Returns time of last commit
    # username: string
    # repo: string
    def last_commit(repo, username, id)
      LastCommit.new(
        org: login,
        login: username,
        repo: repo,
        id: id
      ).date
    end

    # Returns a list of all active repositories as Repositories objects (does not include locked, archived etc)
    def repositories
      @repos ||= Repositories.new(login: login).current
    end
    
    # Returns a list of outside collaborators and additionally checks they are not MoJ organisation Members
    # Not this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    # repo_name: string
    def get_repository_outside_collaborators(repo_name)
      outside_collaborators(repo_name).reject { |user| @organization.is_member?(user.login) }
    end

    # Returns a list of outside collaborators for a given repository
    # Not this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    # repo_name: string
    def outside_collaborators(repo_name)
      RepositoryCollaborators.new(
        login: login,
        repository: repo_name
      ).list
    end
  end
end
