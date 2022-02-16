class GithubCollaborators
  class OrganizationOutsideCollaborators
    attr_reader :login, :base_url

    def initialize(params)
      @login = params.fetch(:login)
      @base_url = params.fetch(:base_url) # URL of the github UI page listing all the terraform files
    end

    # Reports any collaborators with problems e.g. review_after etc
    def list
      # For every repository in MoJ GitHub organisation
      repositories.each_with_object([]) { |repo, arr|
        # TODO: Delete printout
        puts repo.name
        # For every unknown collaborator
        get_non_organisation_users(repo.name).each do |collab|
          tc = TerraformCollaborator.new(
            repository: repo.name,
            login: collab.login,
            base_url: base_url
          )
          # TODO: Delete printout
          puts collab.login
          if tc.status == TerraformCollaborator::FAIL
            # TODO: Delete printout
            puts " ^^^ Failed"
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

    # Returns unknown collaborators for a certain repository, sample response:
    # {:login=>"benashton", :login_url=>"https://github.com/benashton", :permission=>"admin", :last_commit=>nil}
    # repo_name: string
    def for_repository(repo_name)
      get_non_organisation_users(repo_name).map do |collab|
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
    # username: string
    # repo: string
    def last_commit(repo, username)
      LastCommit.new(
        org: login,
        login: username,
        repo: repo
      ).date
    end

    # Returns a list of all active repositories as Repositories objects (does not include locked, archived etc)
    def repositories
      @repos ||= Repositories.new(login: login).current
    end

    # Returns a list users who are not members of the organization for a given repository
    # Not this has nothing to do with the TerraformCollaborators which is based of the tf files, this is from the GitHub API directly
    # repo_name: string
    def get_non_organisation_users(repo_name)
      collaborators(repo_name).reject { |collab| organization.is_member?(collab.login) }
    end

    # Returns a list of the users who are collaborators for a given repository
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
