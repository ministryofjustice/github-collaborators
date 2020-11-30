class GithubCollaborators
  class OrganizationExternalCollaborators
    attr_reader :login

    def initialize(params)
      @login = params.fetch(:login)
    end

    def list
      @list ||= repositories.each_with_object([]) { |repo, arr|
        external_collaborators(repo.name).each do |collab|
          tc = TerraformCollaborator.new(
            repository: repo.name,
            login: collab.login,
          )
          if tc.status == TerraformCollaborator::FAIL
            arr.push(
              tc.to_hash.merge(
                repo_url: repo.url,
                login_url: collab.url,
                permission: collab.permission
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
          permission: collab.permission
        }
      end
    end

    private

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
