class GithubCollaborators
  class OrganizationExternalCollaborators
    attr_reader :login, :base_url

    def initialize(params)
      @login = params.fetch(:login)
      @base_url = params.fetch(:base_url) # URL of the github UI page listing all the terraform files
    end

    def list
      repositories.each_with_object([]) { |repo, arr|
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
                last_commit: last_commit(repo, collab.login),
              )
            )
          end
          arr
        end
      }
    end

    def for_repository(repo_name)
      external_collaborators(repo_name).map do |collab|
        {
          login: collab.login,
          login_url: collab.url,
          permission: collab.permission,
          last_commit: last_commit(repo_name, collab.login),
        }
      end
    end

    private

    def last_commit(repo, username)
      LastCommit.new(
        org: login,
        login: username,
        repo: repo,
      ).date
    end

    def repositories
      @repos ||= Repositories.new(login: login).current
    end

    def external_collaborators(repo_name)
      collaborators(repo_name)
        .reject { |collab| organization.is_member?(collab.login) }
    end

    def collaborators(repo_name)
      RepositoryCollaborators.new(
        owner: login,
        repository: repo_name
      ).list
    end

    def organization
      @org ||= Organization.new(login: login)
    end
  end
end
