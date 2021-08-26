class GithubCollaborators
  class OrganizationExternalCollaborators
    attr_reader :login, :base_url

    def initialize(params)
      @login = params.fetch(:login)
      @base_url = params.fetch(:base_url) # URL of the github UI page listing all the terraform files
    end

    # Reports any collaborators with problems e.g. review_after etc
    def list
      # For every repository in target GitHub org
      repositories.each_with_object([]) { |repo, arr|
        # For every external collaborator
        external_collaborators(repo.name).each do |collab|
          tc = TerraformCollaborator.new(
            repository: repo.name,
            login: collab.login,
            base_url: base_url
          )
          if tc.status == TerraformCollaborator::FAIL
            arr.push(
              tc.to_hash.merge(
                repo_url: repo.url,
                login_url: collab.url,
                permission: collab.permission,
                last_commit: last_commit(repo.name, collab.login)
              )
            )
          end
          arr
        end
      }
    end

    # Returns external collaborators for a certain repo, sample response:
    # {:login=>"benashton", :login_url=>"https://github.com/benashton", :permission=>"admin", :last_commit=>nil}
    # repo_name: string
    def for_repository(repo_name)
      external_collaborators(repo_name).map do |collab|
        {
          login: collab.login,
          login_url: collab.url,
          permission: collab.permission,
          last_commit: last_commit(repo_name, collab.login)
        }

      end
    end

    private

    # Returns time of last commit
    # login: string
    # repo: string
    def last_commit(repo, username)
      LastCommit.new(
        org: login,
        login: username,
        repo: repo
      ).date
    end

    # Returns a list of all active repos as Repositories objects (does not include locked, archived etc)
    def repositories
      @repos ||= Repositories.new(login: login).current
    end

    # Returns list of external collaborators (GithubCollaborators) for a given repo
    # Not this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    # repo_name: string
    def external_collaborators(repo_name)
      collaborators(repo_name).reject { |collab| organization.is_member?(collab.login) }
    end

    # Returns list of collaborators (GithubCollaborators) for a given repo
    # Not this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    # repo_name: string
    def collaborators(repo_name)
      RepositoryCollaborators.new(
        owner: login,
        repository: repo_name
      ).list
    end

    # Returns an Organization object for MoJ GitHub
    def organization
      @org ||= Organization.new(login: login)
    end
  end
end
