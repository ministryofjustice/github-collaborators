# Functions used by the app
module HelperModule
  include Logging
  include Constants

  # Changes a . to a - within the string
  #
  # @param string [String] a string object
  # @return [String] the object converted into the expected format
  def tf_safe(string)
    string.tr(".", "-")
  end

  # Collect the issues from a repository on GitHub
  #
  # @param repository [String] name of the repository
  # @return [JSON] the issues in json format
  def get_issues_from_github(repository)
    module_logger.debug "get_issues_from_github"
    url = "#{GH_API_URL}/#{repository.downcase}/issues"
    response = GithubCollaborators::HttpClient.new.fetch_json(url)
    JSON.parse(response, {symbolize_names: true})
  end

  # Remove specific collaborator from GitHub repository
  #
  # @param repository [String] name of the repository
  # @param github_user [String] login name of the collaborator
  def remove_access(repository, github_user)
    module_logger.debug "remove_access"

    repository = repository.downcase
    username = github_user.downcase

    if ENV.fetch("REALLY_POST_TO_GH", "0") == "1"
      url = "#{GH_API_URL}/#{repository}/collaborators/#{username}"
      GithubCollaborators::HttpClient.new.delete(url)
      sleep 2
    else
      module_logger.debug "Didn't remove #{username} from #{repository}, this is a dry run"
    end
  end

  # Delete a collaborator invite on a GitHub repository
  #
  # @param repository_name [String] name of the repository
  # @param invite_login [String] login name of the collaborator
  def delete_expired_invite(repository_name, invite_login)
    module_logger.debug "delete_expired_invite"

    repository_name = repository_name.downcase
    invite_login = invite_login.downcase

    module_logger.warn "The invite for #{invite_login} on #{repository_name} has expired. Deleting the invite."
    url = "#{GH_API_URL}/#{repository_name}/invitations/#{invite_login}"
    GithubCollaborators::HttpClient.new.delete(url)
    sleep 1
  end

  # Get the collaborator invites to a specific GitHub repository
  #
  # @param repository_name [String] name of the repository
  # @return [Hash{login => String, expired => Bool, invite_id => Numeric}] the required fields from the issue
  def get_repository_invites(repository_name)
    module_logger.debug "get_repository_invites"

    repository_invites = []

    url = "#{GH_API_URL}/#{repository_name.downcase}/invitations"

    json = GithubCollaborators::HttpClient.new.fetch_json(url)

    JSON.parse(json)
      .find_all { |invite| invite["invitee"]["login"].downcase }
      .map { |invite| repository_invites.push({login: invite["invitee"]["login"].downcase, expired: invite["expired"], invite_id: invite["id"]}) }
    repository_invites
  end

  # Close invites that have expired on a GitHub repository
  #
  # @param repository_name [String] name of the repository
  def close_expired_issues(repository_name)
    module_logger.debug "close_expired_issues"
    allowed_days = 45

    issues = get_issues_from_github(repository_name.downcase)
    issues.each do |issue|
      # Check for the issues created by this application and that the issue is open
      if (
        issue[:title].include?(COLLABORATOR_EXPIRES_SOON) ||
        issue[:title].include?(COLLABORATOR_EXPIRY_UPCOMING) ||
        issue[:title].include?(DEFINE_COLLABORATOR_IN_CODE) ||
        issue[:title].include?(USE_TEAM_ACCESS)
      ) && issue[:state] == "open"
        # Get issue created date and add 45 day grace period
        created_date = Date.parse(issue[:created_at])
        grace_period = created_date + allowed_days
        if grace_period < Date.today
          # Close issue as grace period has expired
          remove_issue(repository_name.downcase, issue[:number])
        end
      end
    end
  end

  # Remove specific issue from a GitHub repository
  #
  # @param repository_name [String] name of the repository
  # @param repository_name [Numeric] issue id number
  def remove_issue(repository_name, issue_id)
    module_logger.debug "remove_issue"

    repository_name = repository_name.downcase

    url = "#{GH_API_URL}/#{repository_name}/issues/#{issue_id}"

    params = {
      state: "closed"
    }

    GithubCollaborators::HttpClient.new.patch_json(url, params.to_json)

    module_logger.info "Closed issue #{issue_id} on repository #{repository_name}."

    sleep 2
  end

  # Create a new issue on a GitHub repository for a specific collaborator
  #
  # @param user_name [String] login name of the collaborator
  # @param repository_name [String] name of the repository
  def create_unknown_collaborator_issue(user_name, repository_name)
    module_logger.debug "create_unknown_collaborator_issue"

    repository_name = repository_name.downcase
    user_name = user_name.downcase

    if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
      url = "#{GH_API_URL}/#{repository_name}/issues"
      GithubCollaborators::HttpClient.new.post_json(url, unknown_collaborator_hash(user_name).to_json)
      sleep 2
    else
      module_logger.debug "Didn't create unknown collaborator issue for #{user_name} on , this is a dry run"
    end
  end

  # Composes a GitHub issue structured message
  #
  # @param user_name [String] login name of the collaborator
  # @return [Hash{title => String, assignees => [Array<String>], body => String}] the message to send to GitHub
  def unknown_collaborator_hash(user_name)
    module_logger.debug "unknown_collaborator_hash"
    user_name = user_name.downcase

    {
      title: DEFINE_COLLABORATOR_IN_CODE,
      assignees: [user_name],
      body: <<~EOF
        Hi there
        
        We have a process to manage github collaborators in code: #{GH_ORG_URL}/github-collaborators
        
        Please follow the procedure described there to grant @#{user_name} access to this repository.
        
        If you have any questions, please post in #ask-operations-engineering on Slack.
        
        If the outside collaborator is not needed, close this issue, they have already been removed from this repository.
      EOF
    }
  end

  # Create a new issue on a GitHub repository
  #
  # @param user_name [String] login name of the collaborator
  # @param repository_name [String] name of the repository
  def create_review_date_expires_soon_issue(user_name, repository_name)
    module_logger.debug "create_review_date_expires_soon_issue"
    repository_name = repository_name.downcase
    user_name = user_name.downcase

    if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
      url = "#{GH_API_URL}/#{repository_name}/issues"
      GithubCollaborators::HttpClient.new.post_json(url, review_date_expires_soon_hash(user_name).to_json)
      sleep 2
    else
      module_logger.debug "Didn't create review date expires soon issue for #{user_name} on #{repository_name}, this is a dry run"
    end
  end

  # Composes a GitHub issue structured message
  #
  # @param user_name [String] login name of the collaborator
  # @return [Hash{title => String, assignees => [Array<String>], body => String}] the message to send to GitHub
  def review_date_expires_soon_hash(user_name)
    module_logger.debug "review_date_expires_soon_hash"
    user_name = user_name.downcase

    {
      title: COLLABORATOR_EXPIRES_SOON + " " + user_name,
      assignees: [user_name],
      body: <<~EOF
        Hi there
        
        The user @#{user_name} has its access for this repository maintained in code here: #{GH_ORG_URL}/github-collaborators

        The review_after date is due to expire within one month, please update this via a PR if they still require access.
        
        If you have any questions, please post in #ask-operations-engineering on Slack.

        Failure to update the review_date will result in the collaborator being removed from the repository via our automation.
      EOF
    }
  end

  # Checks if a specific issue on a GitHub repository is already open for the collaborator
  #
  # @param issues [Hash{login => String, title => String, assignees => [Array<String>], number => Numeric}] issue data from GitHub repository
  # @param issue_title [String] the name of the issue
  # @param repository_name [String] the name of the repository
  # @param user_name [String] the login name of the collaborator
  # @return [Bool] true when the specific issue exists on repository
  def does_issue_already_exist(issues, issue_title, repository_name, user_name)
    module_logger.debug "does_issue_already_exist"
    repository_name = repository_name.downcase
    user_name = user_name.downcase
    found_issues = false

    # Find the specific issue assigned to the collaborator
    issues.each do |issue|
      # Match the issue title
      if issue[:title].include?(issue_title)
        # Look to see if the collaborator has unassigned themself
        # from the issue, if so close the unassigned issue
        if issue[:assignees].length == 0
          remove_issue(repository_name, issue[:number])
          index = issues.index(issue)
          issues.delete_at(index)
        else
          # Match issue assignee to collaborator
          issue[:assignees].each do |assignee|
            if assignee[:login].downcase == user_name
              # Found matching issue
              found_issues = true
            end
          end
        end
      end
    end

    found_issues
  end

  # Get full list of Organization user login names
  #
  # @return [Array<String>] the user login names
  def get_all_organisation_members
    module_logger.debug "get_all_organisation_members"
    org_members = []
    end_cursor = nil
    graphql = GithubCollaborators::GithubGraphQlClient.new
    loop do
      response = graphql.run_query(organisation_members_query(end_cursor))
      json_data = JSON.parse(response)
      if !json_data.dig("data", "organization", "membersWithRole", "edges").nil?
        members = json_data.dig("data", "organization", "membersWithRole", "edges")
        members.each do |member|
          login = member.dig("node", "login")
          org_members.push(login.downcase)
        end
      end
      end_cursor = json_data.dig("data", "organization", "membersWithRole", "pageInfo", "endCursor")
      break unless json_data.dig("data", "organization", "membersWithRole", "pageInfo", "hasNextPage")
    end
    org_members.sort!
  end

  # Create a GraphQL query that returns the organization user login names
  #
  # @param end_cursor [String] id of next page in search results
  # @return [String] the GraphQL query
  def organisation_members_query(end_cursor)
    module_logger.debug "organisation_members_query"
    after = end_cursor.nil? ? "null" : "\"#{end_cursor}\""
    %[
      {
        organization(login: "#{ORG}") {
          membersWithRole(
            first: 100
            after: #{after}
          ) {
            edges {
              node {
                login
              }
            }
            pageInfo {
              hasNextPage
              endCursor
            }
          }
        }
      }
    ]
  end

  # Query the all_org_members team and return its repositories
  #
  # @return [Array<String>] list of the repository names
  def get_all_org_members_team_repositories
    module_logger.debug "get_all_org_members_team_repositories"

    #  Grabs 100 repositories from the team, if team has more than 100 repositories
    # this will need to be changed to paginate through the results.
    url = "https://api.github.com/orgs/#{ORG}/teams/all-org-members/repos?per_page=100"
    team_repositories = []
    json = GithubCollaborators::HttpClient.new.fetch_json(url)
    JSON.parse(json)
      .find_all { |repository| repository["name"].downcase }
      .map { |repository| team_repositories.push(repository["name"].downcase) }

    team_repositories
  end

  # Check a list of collaborator objects for a specific login name
  #
  # @param login [String] login name of the collaborator to find
  # @param collaborators [Array<GithubCollaborators::Collaborator>] list of collaborator objects
  # @return [Bool] true if the collaborator login name is found
  def does_collaborator_already_exist(login, collaborators)
    module_logger.debug "does_collaborator_already_exist"
    exists = false
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase
        exists = true
        break
      end
    end
    exists
  end

  # Return the name of a specific collaborator from a list of collaborator objects
  #
  # @param login [String] login name of the collaborator to find
  # @param collaborators [Array<GithubCollaborators::Collaborator>] list of collaborator objects
  # @return [String] name of collaborator if collaborator exists in list, else return an empty string
  def get_name(login, collaborators)
    module_logger.debug "get_name"
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase && collaborator.name != ""
        return collaborator.name
      end
    end
    ""
  end

  # Return the email address of a specific collaborator from a list of collaborator objects
  #
  # @param login [String] login name of the collaborator to find
  # @param collaborators [Array<GithubCollaborators::Collaborator>] list of collaborator objects
  # @return [String] the email address of the collaborator if collaborator exists in list, else return an empty string
  def get_email(login, collaborators)
    module_logger.debug "get_email"
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase && collaborator.email != ""
        return collaborator.email
      end
    end
    ""
  end

  # Return the organisation of a specific collaborator from a list of collaborator objects
  #
  # @param login [String] login name of the collaborator to find
  # @param collaborators [Array<GithubCollaborators::Collaborator>] list of collaborator objects
  # @return [String] the organisation of the collaborator if collaborator exists in list, else return an empty string
  def get_org(login, collaborators)
    module_logger.debug "get_org"
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase && collaborator.org != ""
        return collaborator.org
      end
    end
    ""
  end

  # Return the organisation outside collaborator login names
  #
  # @return [String] a list of collaborator login names
  def get_org_outside_collaborators
    module_logger.debug "get_org_outside_collaborators"
    outside_collaborators = []
    # This has a hard limit of 100 collaborators, if this value is exceeded, pagination will be needed here
    url = "https://api.github.com/orgs/#{ORG}/outside_collaborators?per_page=100"
    json = GithubCollaborators::HttpClient.new.fetch_json(url)
    JSON.parse(json)
      .find_all { |collaborator| collaborator["login"] }
      .map { |collaborator| outside_collaborators.push(collaborator["login"].downcase) }
    outside_collaborators
  end

  # Get the github-collaborators repository pull requests
  #
  # @return [Array<[Hash{title => String, files => [Array<String>]}]>] a list of hash values containing the pull request title and related files
  def get_pull_requests
    module_logger.debug "get_pull_requests"
    pull_requests = []
    graphql = GithubCollaborators::GithubGraphQlClient.new
    response = graphql.run_query(pull_request_query)
    json_data = JSON.parse(response)
    if !json_data.dig("data", "organization", "repository", "pullRequests").nil?
      data = json_data.dig("data", "organization", "repository", "pullRequests")

      # Iterate over the pull requests
      data.fetch("nodes").each do |pull_request_data|
        title = pull_request_data.fetch("title")
        files = pull_request_data.dig("files", "edges").map { |d| d.dig("node", "path") }
        pull_requests.push({title: title.to_s, files: files})
      end
    end
    pull_requests
  end

  # Create a Git branch, create a valid branch name and raise a specific pull request
  #
  # @param branch_name [String] the original branch name to be used
  # @param edited_files [Array<String>] a list of file paths
  # @param pull_request_title [String] the pull request title
  # @param collaborator_name [Array<string>] the collaborator login name
  # @param type [Array<string>] the type of pull request to create
  def create_branch_and_pull_request(branch_name, edited_files, pull_request_title, collaborator_name, type)
    module_logger.debug "create_branch_and_pull_request"

    collaborator_name = collaborator_name.downcase

    # Ready a new branch
    branch_creator = GithubCollaborators::BranchCreator.new
    branch_name = branch_creator.check_branch_name_is_valid(branch_name.downcase, collaborator_name)
    branch_name = branch_name.downcase

    branch_creator.create_branch(branch_name)

    # Add, commit and push the changes
    edited_files.each { |file_name| branch_creator.add(file_name) }
    branch_creator.commit_and_push(pull_request_title)

    if type == TYPE_DELETE
      create_pull_request(delete_empty_files_hash(branch_name))
    elsif type == TYPE_EXTEND
      create_pull_request(extend_date_hash(collaborator_name, branch_name))
    elsif type == TYPE_REMOVE
      create_pull_request(remove_collaborator_hash(collaborator_name, branch_name))
    elsif type == TYPE_PERMISSION
      create_pull_request(modify_collaborator_permission_hash(collaborator_name, branch_name))
    elsif type == TYPE_ADD
      create_pull_request(add_collaborator_hash(collaborator_name, branch_name))
    elsif type == TYPE_DELETE_ARCHIVE
      create_pull_request(delete_archive_file_hash(branch_name))
    end
  end

  # Create a pull request on the github-collaborators repository
  #
  # @param hash_body [String] a GitHub branch structured message
  def create_pull_request(hash_body)
    module_logger.debug "create_pull_request"
    if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
      url = "#{GH_API_URL}/github-collaborators/pulls"
      if ENV.fetch("OPS_BOT_TOKEN", 0) == "1"
        # Use a different pull request GitHub token so A.B. can authorise automated pull requests
        GithubCollaborators::HttpClient.new.post_pull_request_json(url, hash_body.to_json)
      else
        GithubCollaborators::HttpClient.new.post_json(url, hash_body.to_json)
      end
      sleep 1
    else
      module_logger.debug "Didn't create pull request, this is a dry run"
    end
  end

  # Create a GraphQL query that returns the github-collaborators repository pull requests
  #
  # @return [String] the GraphQL query
  def pull_request_query
    %[
      {
        organization(login: "#{ORG}") {
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

  # Composes a GitHub branch structured message
  #
  # @param login [String] the login name of the collaborator
  # @param branch_name [String] the name of the branch
  # @return [Hash{title => String, head => String, base => String, body => String}] the message to send to GitHub
  def extend_date_hash(login, branch_name)
    module_logger.debug "extend_date_hash"
    {
      title: EXTEND_REVIEW_DATE_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} has review date/s that are close to expiring.
        
        The review date/s have automatically been extended.
        
        Either approve this pull request, modify it or delete it if it is no longer necessary.
      EOF
    }
  end

  # Composes a GitHub branch structured message
  #
  # @param branch_name [String] the name of the branch to delete
  # @return [Hash{title => String, head => String, base => String, body => String}] the message to send to GitHub
  def delete_archive_file_hash(branch_name)
    module_logger.debug "delete_archive_file_hash"
    {
      title: ARCHIVED_REPOSITORY_PR_TITLE,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The repositories in this pull request have been archived.
        
        This pull request is to remove those Terraform files.

      EOF
    }
  end

  # Composes a GitHub branch structured message
  #
  # @param branch_name [String] the name of the branch
  # @return [Hash{title => String, head => String, base => String, body => String}] the message to send to GitHub
  def delete_empty_files_hash(branch_name)
    module_logger.debug "delete_empty_files_hash"
    {
      title: EMPTY_FILES_PR_TITLE,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The Terraform files in this pull request are empty and serve no purpose, please remove them.
        
      EOF
    }
  end

  # Composes a GitHub branch structured message
  #
  # @param login [String] the login name of the collaborator
  # @param branch_name [String] the name of the branch
  # @return [Hash{title => String, head => String, base => String, body => String}] the message to send to GitHub
  def add_collaborator_hash(login, branch_name)
    module_logger.debug "add_collaborator_hash"
    {
      title: ADD_FULL_ORG_MEMBER_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} was found to be missing from the file/s in this pull request.
        
        This is because the collaborator is a full organization member and is able to join repositories outside of Terraform.
        
        This pull request ensures we keep track of those collaborators and which repositories they are accessing.
        
        Edit the pull request file/s because some of the data about the collaborator is missing.
        
      EOF
    }
  end

  # Composes a GitHub branch structured message
  #
  # @param login [String] name of collaborator
  # @param branch_name [String] name of new branch
  # @return [Hash{title => String, head => String, base => String, body => String}] the message to send to GitHub
  def remove_collaborator_hash(login, branch_name)
    module_logger.debug "remove_collaborator_hash"
    {
      title: REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} review date has expired for the file/s contained in this pull request.
        
        Either approve this pull request, modify it or delete it if it is no longer necessary.
      EOF
    }
  end

  # Composes a GitHub branch structured message
  #
  # @param login [String] name of collaborator
  # @param branch_name [String] name of new branch
  # @return [Hash{title => String, head => String, base => String, body => String}] the message to send to GitHub
  def modify_collaborator_permission_hash(login, branch_name)
    module_logger.debug "modify_collaborator_permission_hash"
    {
      title: CHANGE_PERMISSION_PR_TITLE + " " + login.downcase,
      head: branch_name.downcase,
      base: "main",
      body: <<~EOF
        Hi there
        
        This is the GitHub-Collaborator repository bot.
        
        The collaborator #{login.downcase} permission on Github is different to the permission in the Terraform file for the repository.
        
        This is because the collaborator is a full organization member, is able to join repositories outside of Terraform and may have different access to the repository now they are in a Team.
        
        The permission on Github is given the priority.
        
        This pull request ensures we keep track of those collaborators, which repositories they are accessing and their permission.
        
        Permission can either be admin, push, maintain, pull or triage.
        
      EOF
    }
  end

  # Get the Organization repositories and the number of outside collaborators
  # per repository to create a list of Repository objects for the ones that are
  # not disabled or archived
  #
  # @return [Array<GithubCollaborators::Repository>] list of Repository objects
  def get_active_repositories
    module_logger.debug "get_active_repositories"
    graphql = GithubCollaborators::GithubGraphQlClient.new
    active_repositories = []
    ["public", "private", "internal"].each do |type|
      end_cursor = nil
      loop do
        response = graphql.run_query(repositories_query(end_cursor, type))
        json_data = JSON.parse(response)
        if !json_data.dig("data", "search", "repos").nil?
          repositories = json_data.dig("data", "search", "repos")
          repositories = repositories.reject { |r| r.dig("repo", "isDisabled") }
          repositories = repositories.reject { |r| r.dig("repo", "isLocked") }
          repositories.each do |repo|
            repository_name = repo.dig("repo", "name")
            outside_collaborators_count = repo.dig("repo", "collaborators", "totalCount")
            if outside_collaborators_count.nil?
              outside_collaborators_count = 0
            end
            active_repositories.push(GithubCollaborators::Repository.new(repository_name, outside_collaborators_count))
          end
        end
        end_cursor = json_data.dig("data", "search", "pageInfo", "endCursor")
        break unless json_data.dig("data", "search", "pageInfo", "hasNextPage")
      end
    end
    active_repositories.sort_by { |repo| repo.name }
  end

  # Get the names of the Organization repositories that are archived
  #
  # @return [Array<String>] list of repository names
  def get_archived_repositories
    module_logger.debug "get_archived_repositories"
    graphql = GithubCollaborators::GithubGraphQlClient.new
    archived_repositories = []
    ["public", "private", "internal"].each do |type|
      end_cursor = nil
      loop do
        response = graphql.run_query(get_archived_repositories_query(end_cursor, type))
        json_data = JSON.parse(response)
        if !json_data.dig("data", "search", "repos").nil?
          repositories = json_data.dig("data", "search", "repos")
          repositories.each do |repo|
            archived_repositories.push(repo.dig("repo", "name"))
          end
        end
        end_cursor = json_data.dig("data", "search", "pageInfo", "endCursor")
        break unless json_data.dig("data", "search", "pageInfo", "hasNextPage")
      end
    end
    archived_repositories.sort!
  end

  # Create a GraphQL query that returns the Organisation repositories that are archived
  #
  # @param end_cursor [String] id of next page in search results
  # @param type [String] repository type (public, private, internal)
  # @return [String] the GraphQL query
  def get_archived_repositories_query(end_cursor, type)
    module_logger.debug "get_archived_repositories_query"
    after = end_cursor.nil? ? "null" : "\"#{end_cursor}\""
    %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:true, is:#{type}"
          first: 100
          after: #{after}
        ) {
          repos: edges {
            repo: node {
              ... on Repository {
                name
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    ]
  end

  # Create a GraphQL query that returns the Organisation repositories
  #
  # @param end_cursor [String] id of next page in search results
  # @param type [String] repository type (public, private, internal)
  # @return [String] the GraphQL query
  def repositories_query(end_cursor, type)
    module_logger.debug "repositories_query"
    after = end_cursor.nil? ? "null" : "\"#{end_cursor}\""
    %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:false, is:#{type}"
          first: 100
          after: #{after}
        ) {
          repos: edges {
            repo: node {
              ... on Repository {
                name
                isDisabled
                isLocked
                collaborators(affiliation: OUTSIDE) {
                  totalCount
                }
              }
            }
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    ]
  end

  # Get the outside collaborators login names for a specific repository
  #
  # @param repository [String] the name of the repository
  # @return [Array<String>] list of collaborator login names
  def fetch_all_collaborators(repository)
    module_logger.debug "fetch_all_collaborators"
    end_cursor = nil
    graphql = GithubCollaborators::GithubGraphQlClient.new
    outside_collaborators = []
    loop do
      response = graphql.run_query(outside_collaborators_query(end_cursor, repository))
      json_data = JSON.parse(response)
      # Repos with no outside collaborators return an empty array
      if !json_data.dig("data", "organization", "repository", "collaborators", "edges").nil?
        collaborators = json_data.dig("data", "organization", "repository", "collaborators", "edges")
        collaborators.each do |collaborator|
          login = collaborator.dig("node", "login").downcase
          outside_collaborators.push(login)
        end
      end
      end_cursor = json_data.dig("data", "organization", "repository", "collaborators", "pageInfo", "endCursor")
      break unless json_data.dig("data", "organization", "repository", "collaborators", "pageInfo", "hasNextPage")
    end
    outside_collaborators.sort!
  end

  # Create a GraphQL query that returns the outside collaborators login names for a specific repository
  #
  # @param end_cursor [String] id of next page in search results
  # @param repository [String] the name of the repository
  # @return [String] the GraphQL query
  def outside_collaborators_query(end_cursor, repository)
    module_logger.debug "outside_collaborators_query"
    after = end_cursor.nil? ? "null" : "\"#{end_cursor}\""
    %[
      {
        organization(login: "#{ORG}") {
          repository(name: "#{repository.downcase}") {
            collaborators(
              affiliation: OUTSIDE
              first: 100
              after: #{after}
            ) {
              pageInfo {
                hasNextPage
                endCursor
              }
              edges {
                node {
                  login
                }
              }
            }
          }
        }
      }
    ]
  end

  # Print the comparison of GitHub and Terraform collaborators for a specific repository
  #
  # @param collaborators_in_file [Array<String>] a list of collaborator login names
  # @param collaborators_on_github [Array<String>] a list of collaborator login names
  # @param repository_name [String] the name of the repository
  def print_comparison(collaborators_in_file, collaborators_on_github, repository_name)
    logger.debug "print_comparison"
    logger.warn "=" * 37
    logger.warn "There is a difference in Outside Collaborators for the #{repository_name} repository"
    logger.warn "GitHub Outside Collaborators: #{collaborators_on_github.length}"
    logger.warn "Terraform Outside Collaborators: #{collaborators_in_file.length}"
    logger.warn "Collaborators on GitHub:"
    collaborators_on_github.each { |gc_name| logger.warn "    #{gc_name.downcase}" }
    logger.warn "Collaborators in Terraform:"
    collaborators_in_file.each { |tc_name| logger.warn "    #{tc_name.downcase}" }
    logger.warn "=" * 37
  end

  # Compare each collaborator login name against the collaborator login names within a
  # Terraform file to find any unknown collaborators attached to a specific repository
  #
  # @param collaborators_in_file [Array<String>] a list of collaborator login names
  # @param collaborators_on_github [Array<String>] a list of collaborator login names
  # @param repository_name [String] the name of the repository
  # @return [Array<String>] a list of unknown collaborator login names
  def find_unknown_collaborators(collaborators_in_file, collaborators_on_github, repository_name)
    logger.debug "find_unknown_collaborators"

    unknown_collaborators = []

    # Loop through GitHub Collaborators
    collaborators_on_github.each do |gc_name|
      gc_name = gc_name.downcase
      found_name = false

      # Loop through Terraform file collaborators
      collaborators_in_file.each do |tc_name|
        if tc_name.downcase == gc_name
          # Found a GitHub Collaborator name in Terraform collaborator name
          found_name = true
        end
      end

      if found_name == false
        # Didn't find a match ie unknown collaborator
        unknown_collaborators.push(gc_name)
      end
    end
    unknown_collaborators
  end
end
