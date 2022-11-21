class GithubCollaborators
  class PullRequests
    include Logging
    GITHUB_COLLABORATORS = "github-collaborators"
    
    # Create pull request
    def create_pull_request(hash_body)
      logger.debug "create_pull_request"
      if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
        url = "https://api.github.com/repos/ministryofjustice/github-collaborators/pulls"
        GithubCollaborators::HttpClient.new.post_json(url, hash_body.to_json)
        sleep 1
      else
        logger.debug "Didn't create pull request on #{repository}, this is a dry run"
      end
    end

    def get_pull_requests
      logger.debug "get_pull_requests"
      pull_requests = []
      graphql = GithubCollaborators::GithubGraphQlClient.new(github_token: ENV.fetch("ADMIN_GITHUB_TOKEN"))
      response = graphql.run_query(pull_request_query)
      data = JSON.parse(response).dig("data", "organization", "repository", "pullRequests")

      # Iterate over the pull requests
      data.fetch("nodes").each do |pull_request_data|
        title = pull_request_data.fetch("title")
        files = pull_request_data.dig("files", "edges").map { |d| d.dig("node", "path") }
        # Use a hash value like { :title => "", :files => list_of_file }
        pull_requests.push( { :title => "#{title}", :files => files })
      end
      pull_requests
    end

    def create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
      logger.debug "create_branch_and_pull_request"

      # Ready a new branch
      branch_creator = GithubCollaborators::BranchCreator.new  
      branch_name = branch_creator.check_branch_name_is_valid(branch_name, collaborator_name)
      branch_creator.create_branch(branch_name)

      # Add, commit and push the changes
      edited_files.each { |file_name| branch_creator.add(file_name) }
      branch_creator.commit_and_push(pull_request_title)
  
      if type == "delete"
        create_pull_request(delete_empty_files_hash(branch_name))
      elsif type == "extend"
        create_pull_request(extend_date_hash(collaborator_name, branch_name))
      elsif type == "remove" 
        create_pull_request(remove_collaborator_hash(collaborator_name, branch_name))
      elsif type == "permission" 
        create_pull_request(modify_collaborator_permission_hash(collaborator_name, branch_name))
      elsif type == "add" 
        create_pull_request(add_collaborator_hash(collaborator_name, branch_name))
      end
    end

    private

    def pull_request_query
      %[
        {
          organization(login: "ministryofjustice") {
            repository(name: "github-collaborators") {
              pullRequests(states: OPEN, last: 100) {
                nodes {
                  title
                  files(first: 100) {
                    edges {
                      node {
                        path
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

    def extend_date_hash(login, branch_name)
      logger.debug "extend_date_hash"
      {
        title: EXTEND_REVIEW_DATE_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          The collaborator #{login} has review date/s that are close to expiring. 
          
          The review date/s have automatically been extended.

          Either approve this pull request, modify it or delete it if it is no longer necessary.
        EOF
      }
    end

    def delete_empty_files_hash(branch_name)
      logger.debug "delete_empty_files_hash"
      {
        title: EMPTY_FILES_PR_TITLE,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot.

          The Terraform files in this pull request are empty and serve no purpose, please remove them.

        EOF
      }
    end

    def add_collaborator_hash(login, branch_name)
      logger.debug "add_collaborator_hash"
      {
        title: ADD_FULL_ORG_MEMBER_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          The collaborator #{login} was found to be missing from the file/s in this pull request.

          This is because the collaborator is a full organization member and is able to join repositories outside of Terraform.

          This pull request ensures we keep track of those collaborators and which repositories they are accessing.

          Edit the pull request file/s because some of the data about the collaborator is missing.

        EOF
      }
    end

    def remove_collaborator_hash(login, branch_name)
      logger.debug "remove_collaborator_hash"
      {
        title: REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there

          This is the GitHub-Collaborator repository bot. 

          The collaborator #{login} review date has expired for the file/s contained in this pull request.
          
          Either approve this pull request, modify it or delete it if it is no longer necessary.
        EOF
      }
    end

    def modify_collaborator_permission_hash(login, branch_name)
      logger.debug "modify_collaborator_permission_hash"
      {
        title: CHANGE_PERMISSION_PR_TITLE + " " + login,
        head: branch_name,
        base: "main",
        body: <<~EOF
          Hi there
          
          This is the GitHub-Collaborator repository bot. 

          The collaborator #{login} permission on Github is different to the permission in the Terraform file for the repository.

          This is because the collaborator is a full organization member, is able to join repositories outside of Terraform and may have different access to the repository now they are in a Team.

          The permission on Github is given the priority.
          
          This pull request ensures we keep track of those collaborators, which repositories they are accessing and their permission.

          Permission can either be admin, push, maintain, pull or triage.

        EOF
      }
    end
  end
end
