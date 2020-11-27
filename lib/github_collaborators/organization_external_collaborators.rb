class GithubCollaborators
  class OrganizationExternalCollaborators < GithubGraphQlClient
    attr_reader :login

    def initialize(params)
      @login = params.fetch(:login)
      super(params)
    end

    def list
      @list ||= repositories.inject([]) do |arr, repo|
        external_collaborators(repo.name).each do |collab|
          arr.push(
            repository: repo.name,
            repo_url: repo.url,
            login: collab.login,
            login_url: collab.url,
            permission: collab.permission,
          )
        end
        arr
      end
    end

    def for_repository(repo_name)
      external_collaborators(repo_name).map do |collab|
        {
          login: collab.login,
          login_url: collab.url,
          permission: collab.permission,
        }
      end
    end

    private

    def repositories
      @repos ||= Repositories.new(
        github_token: github_token,
        login: "ministryofjustice"
      ).current
    end

    def external_collaborators(repo_name)
      collaborators(repo_name)
        .reject { |collab| organization.is_member?(collab.login) }
    end

    def collaborators(repo_name)
      RepositoryCollaborators.new(
        github_token: github_token,
        owner: login,
        repository: repo_name
      ).list
    end

    def organization
      @org ||= Organization.new(
        github_token: github_token,
        login: login
      )
    end
  end
end
