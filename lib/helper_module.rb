module HelperModule
  include Logging
  include Constants

  def tf_safe(string)
    string.tr(".", "-")
  end

  def get_issues_from_github(repository)
    module_logger.debug "get_issues_from_github"
    url = "https://api.github.com/repos/ministryofjustice/#{repository.downcase}/issues"
    response = GithubCollaborators::HttpClient.new.fetch_json(url)
    JSON.parse(response, {symbolize_names: true})
  end

  def remove_access(repository, github_user)
    module_logger.debug "remove_access"

    repository = repository.downcase
    username = github_user.downcase

    if ENV.fetch("REALLY_POST_TO_GH", "0") == "1"
      url = "https://api.github.com/repos/ministryofjustice/#{repository}/collaborators/#{github_user}"
      GithubCollaborators::HttpClient.new.delete(url)
      sleep 2
    else
      module_logger.debug "Didn't remove #{username} from #{repository}, this is a dry run"
    end
  end

  # Called when an invite has expired
  def delete_expired_invite(repository_name, invite_login)
    module_logger.debug "delete_expired_invite"

    repository_name = repository_name.downcase
    invite_login = invite_login.downcase

    module_logger.warn "The invite for #{invite_login} on #{repository_name} has expired. Deleting the invite."
    url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/invitations/#{invite_login}"
    GithubCollaborators::HttpClient.new.delete(url)
    sleep 1
  end

  # Get the collaborator invites for the repository and store the data as
  # a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
  def get_repository_invites(repository_name)
    module_logger.debug "get_repository_invites"
    
    repository_invites = []
    
    url = "https://api.github.com/repos/ministryofjustice/#{repository_name.downcase}/invitations"
    
    json = GithubCollaborators::HttpClient.new.fetch_json(url)
    
    JSON.parse(json)
      .find_all { |invite| invite["invitee"]["login"].downcase }
      .map { |invite| repository_invites.push({login: invite["invitee"]["login"].downcase, expired: invite["expired"], invite_id: invite["id"]}) }
    repository_invites
  end

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

  def remove_issue(repository_name, issue_id)
    module_logger.debug "remove_issue"

    repository_name = repository_name.downcase

    url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/issues/#{issue_id}"

    params = {
      state: "closed"
    }

    GithubCollaborators::HttpClient.new.patch_json(url, params.to_json)

    module_logger.info "Closed issue #{issue_id} on repository #{repository_name}."

    sleep 2
  end

  def create_unknown_collaborator_issue(user_name, repository_name)
    module_logger.debug "create_unknown_collaborator_issue"
    
    repository_name = repository_name.downcase
    user_name = user_name.downcase
    
    if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/issues"
      GithubCollaborators::HttpClient.new.post_json(url, unknown_collaborator_hash(user_name).to_json)
      sleep 2
    else
      module_logger.debug "Didn't create unknown collaborator issue for #{user_name} on #{}, this is a dry run"
    end
  end

  def unknown_collaborator_hash(user_name)
    module_logger.debug "unknown_collaborator_hash"
    user_name = user_name.downcase

    {
      title: DEFINE_COLLABORATOR_IN_CODE,
      assignees: [user_name],
      body: <<~EOF
        Hi there
        
        We have a process to manage github collaborators in code: https://github.com/ministryofjustice/github-collaborators
        
        Please follow the procedure described there to grant @#{user_name} access to this repository.
        
        If you have any questions, please post in #ask-operations-engineering on Slack.
        
        If the outside collaborator is not needed, close this issue, they have already been removed from this repository.
      EOF
    }
  end

  def create_review_date_expires_soon_issue(user_name, repository_name)
    module_logger.debug "create_review_date_expires_soon_issue"
    repository_name = repository_name.downcase
    user_name = user_name.downcase

    if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/issues"
      GithubCollaborators::HttpClient.new.post_json(url, review_date_expires_soon_hash(user_name).to_json)
      sleep 2
    else
      module_logger.debug "Didn't create review date expires soon issue for #{user_name} on #{repository_name}, this is a dry run"
    end
  end

  def review_date_expires_soon_hash(user_name)
    module_logger.debug "review_date_expires_soon_hash"
    user_name = user_name.downcase

    {
      title: COLLABORATOR_EXPIRES_SOON + " " + user_name,
      assignees: [user_name],
      body: <<~EOF
        Hi there
        
        The user @#{user_name} has its access for this repository maintained in code here: https://github.com/ministryofjustice/github-collaborators

        The review_after date is due to expire within one month, please update this via a PR if they still require access.
        
        If you have any questions, please post in #ask-operations-engineering on Slack.

        Failure to update the review_date will result in the collaborator being removed from the repository via our automation.
      EOF
    }
  end

  # Checks if a specific issue within the repository issues
  # is already open for the collaborator
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

  def get_all_organisation_members
    module_logger.debug "get_all_organisation_members"
    org_members = []
    end_cursor = nil
    graphql = GithubCollaborators::GithubGraphQlClient.new
    loop do
      response = graphql.run_query(organisation_members_query(end_cursor))
      members = JSON.parse(response).dig("data", "organization", "membersWithRole", "edges")
      members.each do |member|
        org_members.push(GithubCollaborators::Member.new(member))
      end
      end_cursor = JSON.parse(response).dig("data", "organization", "membersWithRole", "pageInfo", "endCursor")
      break unless JSON.parse(response).dig("data", "organization", "membersWithRole", "pageInfo", "hasNextPage")
    end
    org_members.sort_by { |org_member| org_member.login }
  end

  def organisation_members_query(end_cursor)
    module_logger.debug "organisation_members_query"
    after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
    %[
      {
        organization(login: "ministryofjustice") {
          membersWithRole(first: 100 #{after}) {
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
  def get_all_org_members_team_repositories
    module_logger.debug "get_all_org_members_team_repositories"

    team_repositories = []

    #  Grabs 100 repositories from the team, if team has more than 100 repositories
    # this will need to be changed to paginate through the results.
    url = "https://api.github.com/orgs/ministryofjustice/teams/all-org-members/repos?per_page=100"
    json = GithubCollaborators::HttpClient.new.fetch_json(url)
    JSON.parse(json)
      .find_all { |repository| repository["name"].downcase }
      .map { |repository| team_repositories.push(repository["name"].downcase) }

    team_repositories
  end

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

  def get_name(login, collaborators)
    module_logger.debug "get_name"
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase && collaborator.name != ""
        return collaborator.name
      end
    end
    ""
  end

  def get_email(login, collaborators)
    module_logger.debug "get_email"
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase && collaborator.email != ""
        return collaborator.email
      end
    end
    ""
  end

  def get_org(login, collaborators)
    module_logger.debug "get_org"
    collaborators.each do |collaborator|
      if collaborator.login.downcase == login.downcase && collaborator.org != ""
        return collaborator.org
      end
    end
    ""
  end

  def get_org_outside_collaborators
    module_logger.debug "get_org_outside_collaborators"
    # Grab the Org outside collaborators
    # This has a hard limit return of 100 collaborators
    outside_collaborators = []
    url = "https://api.github.com/orgs/ministryofjustice/outside_collaborators?per_page=100"
    json = GithubCollaborators::HttpClient.new.fetch_json(url)
    JSON.parse(json)
      .find_all { |collaborator| collaborator["login"] }
      .map { |collaborator| outside_collaborators.push(collaborator["login"].downcase) }
    outside_collaborators
  end

  def remove_unknown_collaborators(collaborators)
    module_logger.debug "remove_unknown_collaborators"
    removed_outside_collaborators = []
    # Check all collaborators
    collaborators.each do |collaborator|
      # Unknown collaborator
      if collaborator.defined_in_terraform == false
        module_logger.info "Removing collaborator #{collaborator.login.downcase} from GitHub repository #{collaborator.repository.downcase}"
        # We must create the issue before removing access, because the issue is
        # assigned to the removed collaborator, so that they (hopefully) get a
        # notification about it.
        create_unknown_collaborator_issue(collaborator.login.downcase, collaborator.repository.downcase)
        remove_access(collaborator.repository.downcase, )
        removed_outside_collaborators.push(collaborator)
      end
    end

    if removed_outside_collaborators.length > 0
      # Raise Slack message
      GithubCollaborators::SlackNotifier.new(GithubCollaborators::Removed.new, removed_outside_collaborators).post_slack_message
    end
  end

  def get_pull_requests
    module_logger.debug "get_pull_requests"
    pull_requests = []
    graphql = GithubCollaborators::GithubGraphQlClient.new
    response = graphql.run_query(pull_request_query)
    data = JSON.parse(response).dig("data", "organization", "repository", "pullRequests")

    # Iterate over the pull requests
    data.fetch("nodes").each do |pull_request_data|
      title = pull_request_data.fetch("title")
      files = pull_request_data.dig("files", "edges").map { |d| d.dig("node", "path") }
      # Use a hash value like { :title => "", :files => list_of_file }
      pull_requests.push({title: title.to_s, files: files})
    end
    pull_requests
  end

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
    elsif type == "delete_archive_file"
      create_pull_request(delete_archive_file_hash(branch_name))
    end
  end

  # Create pull request
  def create_pull_request(hash_body)
    module_logger.debug "create_pull_request"
    if ENV.fetch("REALLY_POST_TO_GH", 0) == "1"
      url = "https://api.github.com/repos/ministryofjustice/github-collaborators/pulls"
      if ENV.fetch("OPS_BOT_TOKEN")
        GithubCollaborators::HttpClient.new.post_pull_request_json(url, hash_body.to_json)
      else
        GithubCollaborators::HttpClient.new.post_json(url, hash_body.to_json)
      end
      sleep 1
    else
      module_logger.debug "Didn't create pull request, this is a dry run"
    end
  end

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

  def get_active_repositories
    module_logger.debug "get_active_repositories"
    graphql = GithubCollaborators::GithubGraphQlClient.new
    active_repositories = []
    ["public", "private", "internal"].each do |type|
      end_cursor = nil
      loop do
        response = graphql.run_query(repositories_query(end_cursor, type))
        repositories = JSON.parse(response).dig("data", "search", "repos")
        repositories.reject { |r| r.dig("repo", "isDisabled") }
        repositories.reject { |r| r.dig("repo", "isLocked") }
        repositories.each do |repo|
          repository_name = repo.dig("repo", "name")
          outside_collaborators_count = repo.dig("collaborators", "totalCount")
          if outside_collaborators_count.nil?
            outside_collaborators_count = 0
          end
          active_repositories.push(GithubCollaborators::Repository.new(repository_name, outside_collaborators_count))
        end
        end_cursor = JSON.parse(response).dig("data", "search", "pageInfo", "endCursor")
        break unless JSON.parse(response).dig("data", "search", "pageInfo", "hasNextPage")
      end
    end
    active_repositories.sort_by { |repo| repo.name }
  end

  def get_archived_repositories
    module_logger.debug "get_archived_repositories"
    graphql = GithubCollaborators::GithubGraphQlClient.new
    archived_repositories = []
    ["public", "private", "internal"].each do |type|
      end_cursor = nil
      loop do
        response = graphql.run_query(get_archived_repositories_query(end_cursor, type))
        repositories = JSON.parse(response).dig("data", "search", "repos")
        repositories.each do |repo|
          # Get the archived repository name
          archived_repositories.push(repo.dig("repo", "name"))
        end
        end_cursor = JSON.parse(response).dig("data", "search", "pageInfo", "endCursor")
        break unless JSON.parse(response).dig("data", "search", "pageInfo", "hasNextPage")
      end
    end
    archived_repositories.sort!
  end

  def get_archived_repositories_query(end_cursor, type)
    module_logger.debug "get_archived_repositories_query"
    after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
    %[
      {
        search(
          type: REPOSITORY
          query: "org:ministryofjustice, archived:true, is:#{type}"
          first: 100 #{after}
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

  def repositories_query(end_cursor, type)
    module_logger.debug "repositories_query"
    after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
    %[
      {
        search(
          type: REPOSITORY
          query: "org:ministryofjustice, archived:false, is:#{type}"
          first: 100 #{after}
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

  def fetch_all_collaborators(repository)
    module_logger.debug "fetch_all_collaborators"
    end_cursor = nil
    graphql = GithubCollaborators::GithubGraphQlClient.new
    outside_collaborators = []
    loop do
      response = graphql.run_query(outside_collaborators_query(end_cursor, repository))
      json_data = JSON.parse(response)
      # Repos with no outside collaborators return an empty array
      break unless !json_data.dig("data", "organization", "repository", "collaborators", "edges").empty?
      collaborators = json_data.dig("data", "organization", "repository", "collaborators", "edges")
      collaborators.each do |outside_collaborator|
        outside_collaborators.push(GithubCollaborators::GitHubCollaborator.new(outside_collaborator))
      end
      end_cursor = JSON.parse(response).dig("data", "organization", "repository", "collaborators", "pageInfo", "endCursor")
      break unless JSON.parse(response).dig("data", "organization", "repository", "collaborators", "pageInfo", "hasNextPage")
    end
    outside_collaborators
  end

  def outside_collaborators_query(end_cursor, repository)
    module_logger.debug "outside_collaborators_query"
    after = end_cursor.nil? ? "" : %(, after: "#{end_cursor}")
    %[
      {
        organization(login: "ministryofjustice") {
          repository(name: "#{repository.downcase}") {
            collaborators(first:100 affiliation: OUTSIDE #{after}) {
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
end