class GithubCollaborators
  class LastCommit
    attr_reader :graphql, :org, :repo, :login

    def initialize(params)
      @org = params.fetch(:org)
      @repo = params.fetch(:repo)
      @login = params.fetch(:login)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def date
      @date ||= fetch_date
    end

    private

    def fetch_date
      json = graphql.run_query(last_commit_date_query)
      JSON.parse(json)
        .dig("data", "repository", "defaultBranchRef", "target", "history", "edges")
        &.first
        &.dig("node", "committedDate")
    end

    def last_commit_date_query
      %[
        {
          repository(owner: "#{org}", name: "#{repo}") {
            defaultBranchRef{
              target{
                ... on Commit{
                  history(first:1, author: { id: "#{userid}" }){
                    edges{
                      node{
                        ... on Commit{
                          committedDate
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      ]
    end

    def userid
      @userid ||= fetch_id
    end

    def fetch_id
      json = graphql.run_query(id_query)
      JSON.parse(json).dig("data", "user", "id")
    end

    def id_query
      %[
        {
          user(login: "#{login}") {
            id
          }
        }
      ]
    end
  end
end
