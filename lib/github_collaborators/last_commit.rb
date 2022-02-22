class GithubCollaborators
  class LastCommit
    attr_reader :graphql, :org, :repo, :login, :id

    def initialize(params)
      @org = params.fetch(:org)
      @repo = params.fetch(:repo)
      @login = params.fetch(:login)
      @id = params.fetch(:id)
      raise "Bad parameters: repo should be a string" unless repo.is_a?(String)
      @graphql = params.fetch(:graphql) { GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN")) }
    end

    def date
      @date ||= fetch_date
    end

    private

    def fetch_date
      json = graphql.run_query(last_commit_date_query)
      sleep(2)
      if json.include?('errors')
        STDERR.puts('Last_commit:fetch_date(): graphql query contains errors')
        if json.include?("RATE_LIMITED")
          sleep(300)
          fetch_date()
        else
          abort(json)
        end
      else
        if json
          JSON.parse(json)
            .dig("data", "repository", "defaultBranchRef", "target", "history", "edges")
            &.first
            &.dig("node", "committedDate")
        else
          STDERR.puts('last_commit:fetch_date(): graphql query data missing')
          abort()
         end 
      end
    end

    def last_commit_date_query
      %[
        {
          repository(owner: "#{org}", name: "#{repo}") {
            defaultBranchRef{
              target{
                ... on Commit{
                  history(first:1, author: { id: "#{id}" }){
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
  end
end
