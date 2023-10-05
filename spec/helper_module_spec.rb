class GithubCollaborators
  include TestConstants
  include Constants

  describe HelperModule do
    let(:helper_module) { Class.new { extend HelperModule } }

    let(:http_client) { double(GithubCollaborators::HttpClient) }
    let(:branch_creator) { double(GithubCollaborators::BranchCreator) }
    let(:graphql_client) { double(GithubCollaborators::GithubGraphQlClient) }

    context "" do
      before do
        terraform_block = create_collaborator_with_login(TEST_USER_1)
        @collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        terraform_block = create_collaborator_with_login(TEST_USER_2)
        @collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        @collaborators = [@collaborator1, @collaborator2]
      end

      context "call get_issues_from_github" do
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        end

        it "and return an issue" do
          response = %([{"assignee": { "login":#{TEST_USER}}, "title": #{COLLABORATOR_EXPIRES_SOON}, "assignees": [{"login":#{TEST_USER} }]}])
          expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
          test_equal(helper_module.get_issues_from_github(REPOSITORY_NAME), response)
        end

        it "and return empty array if no issues" do
          response = []
          expect(http_client).to receive(:fetch_json).with(URL).and_return(response.to_json)
          test_equal(helper_module.get_issues_from_github(REPOSITORY_NAME), [])
        end

        let(:json) { File.read("spec/fixtures/issues.json") }
        it "return issues" do
          expect(http_client).to receive(:fetch_json).with(URL).and_return(json)
          expect(helper_module.get_issues_from_github(REPOSITORY_NAME)).equal?(json)
        end
      end

      context "call delete_expired_invite" do
        it "call function" do
          url = "#{GH_API_URL}/#{REPOSITORY_NAME}/invitations/1"
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
          expect(http_client).to receive(:delete).with(url)
          helper_module.delete_expired_invite(REPOSITORY_NAME, TEST_USER, 1)
        end
      end

      context "call get_repository_invites" do
        let(:json) { File.read("spec/fixtures/invites.json") }
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        end

        url = "#{GH_API_URL}/#{REPOSITORY_NAME}/invitations"

        it "when invites exist" do
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          expected_result = [{login: TEST_USER_1, expired: true, invite_id: 1}, {login: TEST_USER_2, expired: false, invite_id: 2}]
          test_equal(helper_module.get_repository_invites(REPOSITORY_NAME), expected_result)
        end

        it "when invites don't exist" do
          response = %([])
          expect(http_client).to receive(:fetch_json).with(url).and_return(response)
          test_equal(helper_module.get_repository_invites(REPOSITORY_NAME), [])
        end
      end

      context "call does_issue_already_exist" do
        issues_json = File.read("spec/fixtures/issues.json")
        before do
          expect(helper_module).to receive(:remove_issue).with(REPOSITORY_NAME, 159)
        end

        it "when no issues exists" do
          issues = JSON.parse(issues_json, {symbolize_names: true})
          test_equal(helper_module.does_issue_already_exist(issues, COLLABORATOR_EXPIRES_SOON, REPOSITORY_NAME, TEST_USER_1), false)
          test_equal(issues.length, 3)
        end

        it "when issue exists" do
          issues = JSON.parse(issues_json, {symbolize_names: true})
          test_equal(helper_module.does_issue_already_exist(issues, COLLABORATOR_EXPIRES_SOON, REPOSITORY_NAME, "assigneduser1"), true)
          test_equal(issues.length, 3)
        end
      end

      context "call get_repository_teams_and_access_permissions" do
        url = "#{GH_API_URL}/#{REPOSITORY_NAME}/teams"
        repository_teams_json = File.read("spec/fixtures/repository-teams.json")
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        end

        it "when team has admin permission to repository" do
          expected_teams = [
            {
              description: "",
              permission: "admin",
              team_name: "operations-engineering"
            },
            {
              description: AUTOMATED_GENERATED_TEAM.to_s,
              permission: "read",
              team_name: "operations-engineering-read-team"
            }
          ]
          expect(http_client).to receive(:fetch_json).with(url).and_return(repository_teams_json)
          the_teams = helper_module.get_repository_teams_and_access_permissions(REPOSITORY_NAME)
          test_equal(the_teams, expected_teams)
        end
      end

      context "call get_all_org_members_team_repositories" do
        url = "#{GH_ORG_API_URL}/teams/all-org-members/repos?per_page=100"
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        end

        it "when team has repositories" do
          response = %([{"name": "#{TEST_REPO_NAME1}"},{"name": "#{TEST_REPO_NAME2}"}])
          expect(http_client).to receive(:fetch_json).with(url).and_return(response)
          repositories = [TEST_REPO_NAME1, TEST_REPO_NAME2]
          test_equal(helper_module.get_all_org_members_team_repositories, repositories)
        end

        it "when team has no repositories" do
          response = []
          expect(http_client).to receive(:fetch_json).with(url).and_return(response.to_json)
          test_equal(helper_module.get_all_org_members_team_repositories, [])
        end
      end

      context "call does_collaborator_already_exist" do
        it COLLABORATOR_EXISTS do
          test_equal(helper_module.does_collaborator_already_exist(TEST_USER_1, @collaborators), true)
        end

        it COLLABORATOR_DOESNT_EXIST do
          test_equal(helper_module.does_collaborator_already_exist(TEST_USER_6, @collaborators), false)
        end
      end

      context "call get_name" do
        it COLLABORATOR_EXISTS do
          test_equal(helper_module.get_name(TEST_USER_1, @collaborators), TEST_COLLABORATOR_NAME)
        end

        it COLLABORATOR_DOESNT_EXIST do
          test_equal(helper_module.get_name(TEST_USER_6, @collaborators), "")
        end
      end

      context "call get_email" do
        it COLLABORATOR_EXISTS do
          test_equal(helper_module.get_email(TEST_USER_1, @collaborators), TEST_COLLABORATOR_EMAIL)
        end

        it COLLABORATOR_DOESNT_EXIST do
          test_equal(helper_module.get_email(TEST_USER_6, @collaborators), "")
        end
      end

      context "call get_org" do
        it COLLABORATOR_EXISTS do
          test_equal(helper_module.get_org(TEST_USER_1, @collaborators), TEST_COLLABORATOR_ORG)
        end

        it COLLABORATOR_DOESNT_EXIST do
          test_equal(helper_module.get_org(TEST_USER_6, @collaborators), "")
        end
      end

      context "call add_collaborator_to_automation_generated_team" do
        context "" do
          before do
            incorrect_team_data = [{
              team_name: TEST_TEAM,
              permission: "admin",
              description: "some description"
            }]
            expect(helper_module).to receive(:get_repository_teams_and_access_permissions).and_return(incorrect_team_data)
            expect(helper_module).not_to receive(:add_collaborator_to_team)
          end

          it "when a repository team exists but the permission doesn't match" do
            result = helper_module.add_collaborator_to_automation_generated_team(REPOSITORY_NAME, TEST_USER_1, "pull")
            test_equal(result, false)
          end

          it "when a repository team exists with the required permission but isn't an automation created team" do
            result = helper_module.add_collaborator_to_automation_generated_team(REPOSITORY_NAME, TEST_USER_1, "admin")
            test_equal(result, false)
          end
        end

        it "when a repository team exists with the required permission and is an automation created team" do
          correct_team_data = [{team_name: TEST_TEAM, permission: "admin", description: AUTOMATED_GENERATED_TEAM}]
          expect(helper_module).to receive(:get_repository_teams_and_access_permissions).and_return(correct_team_data)
          expect(helper_module).to receive(:add_collaborator_to_team).with(TEST_TEAM, TEST_USER_1)
          result = helper_module.add_collaborator_to_automation_generated_team(REPOSITORY_NAME, TEST_USER_1, "admin")
          test_equal(result, true)
        end
      end

      context "when post to GitHub is disabled" do
        before do
          ENV.delete("REALLY_POST_TO_GH")
        end

        it "so do not call remove_user_from_team" do
          expect(http_client).not_to receive(:delete)
          helper_module.remove_user_from_team(TEST_TEAM, TEST_USER_1)
        end

        context "" do
          before do
            expect(http_client).not_to receive(:put_json)
          end

          it "so do not call add_collaborator_to_team" do
            helper_module.add_collaborator_to_team(TEST_TEAM, TEST_USER_1)
          end

          it "so do not create_team" do
            helper_module.create_team(REPOSITORY_NAME, TEST_TEAM)
          end

          it "so do not call add_team_to_repository" do
            helper_module.add_team_to_repository(REPOSITORY_NAME, TEST_TEAM, "admin")
          end
        end
      end

      it "call create_team_name with all the permissions" do
        permissions = ["admin", "pull", "push", "maintain", "triage"]
        permissions.each do |permission|
          created_name = helper_module.create_team_name(TEST_TEAM, permission)
          expected_name = if permission == "pull"
            "#{TEST_TEAM}-read-team"
          elsif permission == "push"
            "#{TEST_TEAM}-write-team"
          else
            "#{TEST_TEAM}-#{permission}-team"
          end
          test_equal(created_name, expected_name)
        end
      end

      context "when post to GitHub is enabled" do
        before do
          ENV["REALLY_POST_TO_GH"] = "1"
          @team_url = "#{GH_ORG_API_URL}/teams/#{TEST_TEAM}/memberships/#{TEST_USER_1}"
          @url = "#{GH_ORG_API_URL}/teams/#{TEST_TEAM}/repos/#{ORG}/#{REPOSITORY_NAME}"
        end

        context "" do
          before do
            expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client).at_least(5).time
          end

          it "call add_team_to_repository with all the permissions" do
            permissions = ["admin", "pull", "push", "maintain", "triage"]
            permissions.each do |permission|
              expected_json = %({"permission":"#{permission}"})
              expect(http_client).to receive(:put_json).with(@url, expected_json)
              helper_module.add_team_to_repository(REPOSITORY_NAME, TEST_TEAM, permission)
            end
          end
        end

        context "" do
          before do
            expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
          end

          it "call create_team" do
            url = "#{GH_ORG_API_URL}/teams"
            expected_json = %({"name":"#{TEST_TEAM}","description":"#{AUTOMATED_GENERATED_TEAM}","privacy":"closed","repo_names":["#{REPOSITORY_NAME}"]})
            expect(http_client).to receive(:post_json).with(url, expected_json)
            helper_module.create_team(REPOSITORY_NAME, TEST_TEAM)
          end

          it "call remove_user_from_team" do
            expect(http_client).to receive(:delete).with(@team_url)
            helper_module.remove_user_from_team(TEST_TEAM, TEST_USER_1)
          end

          it "call add_collaborator_to_team" do
            role = {role: "member"}.to_json
            expect(http_client).to receive(:put_json).with(@team_url, role)
            helper_module.add_collaborator_to_team(TEST_TEAM, TEST_USER_1)
          end

          it "call add_team_to_repository with read permissions" do
            expected_json = %({"permission":"pull"})
            expect(http_client).to receive(:put_json).with(@url, expected_json)
            helper_module.add_team_to_repository(REPOSITORY_NAME, TEST_TEAM, "read")
          end

          it "call add_team_to_repository with write permissions" do
            expected_json = %({"permission":"push"})
            expect(http_client).to receive(:put_json).with(@url, expected_json)
            helper_module.add_team_to_repository(REPOSITORY_NAME, TEST_TEAM, "write")
          end
        end

        after do
          ENV.delete("REALLY_POST_TO_GH")
        end
      end

      context "call add_collaborator_to_repository_team" do
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).at_least(2).times.and_return(http_client)
        end

        team_name = "#{REPOSITORY_NAME}-admin-team"
        url = "#{GH_ORG_API_URL}/teams/#{team_name}"

        it "when first http_code is 404 and second http code is 404" do
          expect(http_client).to receive(:fetch_code).with(url).and_return("404")
          expect(http_client).to receive(:fetch_code).with(url).and_return("404")
          expect(helper_module).to receive(:create_team).with(REPOSITORY_NAME, team_name)
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "nickwalt01")
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "ben-al")
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "AntonyBishop")
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "moj-operations-engineering-bot")
          expect(helper_module).not_to receive(:add_team_to_repository)
          helper_module.add_collaborator_to_repository_team(REPOSITORY_NAME, TEST_USER_1, "admin")
        end

        it "when first http_code is 200 and second http code is 404" do
          expect(http_client).to receive(:fetch_code).with(url).and_return("200")
          expect(http_client).to receive(:fetch_code).with(url).and_return("404")
          expect(helper_module).not_to receive(:create_team)
          expect(helper_module).not_to receive(:add_team_to_repository)
          helper_module.add_collaborator_to_repository_team(REPOSITORY_NAME, TEST_USER_1, "admin")
        end

        it "when first http_code is 200 and second http code is 200" do
          expect(http_client).to receive(:fetch_code).with(url).at_least(2).times.and_return("200")
          expect(helper_module).not_to receive(:create_team)
          expect(helper_module).to receive(:add_team_to_repository).with(REPOSITORY_NAME, team_name, "admin")
          expect(helper_module).to receive(:add_collaborator_to_team).with(team_name, TEST_USER_1)
          helper_module.add_collaborator_to_repository_team(REPOSITORY_NAME, TEST_USER_1, "admin")
        end

        it "when first http_code is 404 and second http code is 200" do
          expect(http_client).to receive(:fetch_code).with(url).and_return("404")
          expect(http_client).to receive(:fetch_code).with(url).and_return("200")
          expect(helper_module).to receive(:create_team).with(REPOSITORY_NAME, team_name)
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "nickwalt01")
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "ben-al")
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "AntonyBishop")
          expect(helper_module).to receive(:remove_user_from_team).with(team_name, "moj-operations-engineering-bot")
          expect(helper_module).to receive(:add_team_to_repository).with(REPOSITORY_NAME, team_name, "admin")
          expect(helper_module).to receive(:add_collaborator_to_team).with(team_name, TEST_USER_1)
          helper_module.add_collaborator_to_repository_team(REPOSITORY_NAME, TEST_USER_1, "admin")
        end
      end

      context "call get_org_outside_collaborators" do
        url = "#{GH_ORG_API_URL}/outside_collaborators?per_page=100"
        before do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
        end

        it WHEN_COLLABORATORS_EXISTS do
          json = %([{"login": "#{TEST_USER_1}"},{"login": "#{TEST_USER_2}"}])
          response = [TEST_USER_1, TEST_USER_2]
          expect(http_client).to receive(:fetch_json).with(url).and_return(json)
          test_equal(helper_module.get_org_outside_collaborators, response)
        end

        it WHEN_NO_COLLABORATORS_EXISTS do
          response = []
          expect(http_client).to receive(:fetch_json).with(url).and_return(response.to_json)
          test_equal(helper_module.get_org_outside_collaborators, [])
        end
      end

      context "call create_branch_and_pull_request" do
        pull_request_title = "sometitle"
        filenames = ["file1", "file2", "file3"]
        branch_name = BRANCH_NAME
        collaborator_name = TEST_USER
        types = [TYPE_DELETE_EMPTY_FILE, TYPE_EXTEND, TYPE_REMOVE, TYPE_PERMISSION, TYPE_ADD, TYPE_DELETE_ARCHIVE, TYPE_DELETE_FILE, TYPE_ADD_FROM_ISSUE]

        it "when branch name valid and unknown type" do
          expect(GithubCollaborators::BranchCreator).to receive(:new).and_return(branch_creator)
          expect(branch_creator).to receive(:check_branch_name_is_valid).with(branch_name, collaborator_name).and_return(branch_name)
          expect(branch_creator).to receive(:create_branch).with(branch_name)
          filenames.each do |filename|
            expect(branch_creator).to receive(:add).with(filename)
          end
          expect(branch_creator).to receive(:commit_and_push).with(pull_request_title)
          helper_module.create_branch_and_pull_request(branch_name, filenames, pull_request_title, collaborator_name, "")
        end

        it "when branch name isnt valid and unknown type" do
          expect(GithubCollaborators::BranchCreator).to receive(:new).and_return(branch_creator)
          new_branch_name = "branchname2"
          expect(branch_creator).to receive(:check_branch_name_is_valid).with(branch_name, collaborator_name).and_return(new_branch_name)
          expect(branch_creator).to receive(:create_branch).with(new_branch_name)
          filenames.each do |filename|
            expect(branch_creator).to receive(:add).with(filename)
          end
          expect(branch_creator).to receive(:commit_and_push).with(pull_request_title)
          helper_module.create_branch_and_pull_request(branch_name, filenames, pull_request_title, collaborator_name, "")
        end

        it "when branch name is valid and use known types" do
          expect(GithubCollaborators::BranchCreator).to receive(:new).and_return(branch_creator).at_least(6).times
          expect(branch_creator).to receive(:check_branch_name_is_valid).with(branch_name, collaborator_name).and_return(branch_name).at_least(6).times
          expect(branch_creator).to receive(:create_branch).with(branch_name).at_least(6).times
          filenames.each do |filename|
            expect(branch_creator).to receive(:add).with(filename).at_least(6).times
          end
          expect(branch_creator).to receive(:commit_and_push).with(pull_request_title).at_least(6).times

          types.each do |type|
            if type == TYPE_DELETE_EMPTY_FILE
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:delete_empty_files_hash).with(branch_name)
            elsif type == TYPE_EXTEND
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:extend_date_hash).with(collaborator_name, branch_name)
            elsif type == TYPE_REMOVE_FULL_ORG_MEMBER
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:remove_full_org_member_hash).with(collaborator_name, branch_name)
            elsif type == TYPE_REMOVE
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:remove_collaborator_hash).with(collaborator_name, branch_name)
            elsif type == TYPE_PERMISSION
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:modify_collaborator_permission_hash).with(collaborator_name, branch_name)
            elsif type == TYPE_ADD
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:add_collaborator_hash).with(collaborator_name, branch_name)
            elsif type == TYPE_DELETE_ARCHIVE
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:delete_archive_file_hash).with(branch_name)
            elsif type == TYPE_DELETE_FILE
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:delete_file_hash).with(branch_name)
            elsif type == TYPE_ADD_FROM_ISSUE
              expect(helper_module).to receive(:create_pull_request)
              expect(helper_module).to receive(:add_collaborator_from_issue_hash).with(collaborator_name, branch_name)
            end
            helper_module.create_branch_and_pull_request(branch_name, filenames, pull_request_title, collaborator_name, type)
          end
        end
      end

      pull_request_url = "#{GH_API_URL}/#{REPO_NAME}/pulls"

      context CALL_CREATE_PULL_REQUEST do
        before do
          ENV.delete("REALLY_POST_TO_GH")
        end

        it "when token is do nothing" do
          expect(GithubCollaborators::HttpClient).not_to receive(:new)
          helper_module.create_pull_request("")
        end
      end

      context CALL_CREATE_PULL_REQUEST do
        before do
          ENV["REALLY_POST_TO_GH"] = "0"
        end

        it "when post to github env variable is not enabled" do
          expect(GithubCollaborators::HttpClient).not_to receive(:new)
          helper_module.create_pull_request("")
        end

        after do
          ENV.delete("REALLY_POST_TO_GH")
        end
      end

      context CALL_CREATE_PULL_REQUEST do
        before do
          ENV["REALLY_POST_TO_GH"] = "1"
        end

        it "when post to github env variables is set" do
          expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
          expect(http_client).to receive(:post_pull_request_json).with(pull_request_url, "".to_json)
          helper_module.create_pull_request("")
        end

        after do
          ENV.delete("REALLY_POST_TO_GH")
        end
      end

      context "" do
        login = TEST_USER
        branch_name = BRANCH_NAME
        hash_body = {
          title: EXTEND_REVIEW_DATE_PR_TITLE + " " + login,
          head: branch_name,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
            
            The collaborator #{login} has review date/s that are close to expiring.
            
            The review date/s have automatically been extended.
            
            Either approve this pull request, modify it or delete it if it is no longer necessary.
          EOF
        }

        it "call extend_date_hash" do
          test_equal(helper_module.extend_date_hash(login, branch_name), hash_body)
        end
      end

      context "" do
        branch_name = BRANCH_NAME
        hash_body = {
          title: ARCHIVED_REPOSITORY_PR_TITLE,
          head: branch_name,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
            
            ** IMPORTANT ** Un-archive the repository before merging to main. Failure to do this will result in a Terraform apply failure. Remember to archive the repository after Terraform apply has completed.
            
            The repositories in this pull request have been archived.
            
            This pull request is to remove those Terraform files.
            
          EOF
        }

        it "call delete_archive_file_hash" do
          test_equal(helper_module.delete_archive_file_hash(branch_name), hash_body)
        end
      end

      context "" do
        branch_name = BRANCH_NAME
        hash_body = {
          title: DELETE_REPOSITORY_PR_TITLE,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
            
            The repositories in this pull request have been deleted from GitHub.
            
            This pull request is to remove those Terraform files.
    
          EOF
        }

        it "call delete_file_hash" do
          test_equal(helper_module.delete_file_hash(branch_name), hash_body)
        end
      end

      context "" do
        branch_name = BRANCH_NAME
        hash_body = {
          title: EMPTY_FILES_PR_TITLE,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
            
            The Terraform files in this pull request are empty and serve no purpose, please remove them.
            
          EOF
        }

        it "call delete_empty_files_hash" do
          test_equal(helper_module.delete_empty_files_hash(branch_name), hash_body)
        end
      end

      context "" do
        login = TEST_USER
        branch_name = BRANCH_NAME
        hash_body = {
          title: ADD_FULL_ORG_MEMBER_PR_TITLE + " " + login.downcase,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
            
            The collaborator #{login.downcase} was found to be missing from the file/s in this pull request.
            
            This is because the collaborator is a full organization member and is able to join repositories outside of Terraform.
            
            This pull request ensures we keep track of those collaborators and which repositories they are accessing.
            
            Edit the pull request file/s because some of the data about the collaborator is missing.
            
          EOF
        }

        it "call add_collaborator_hash" do
          test_equal(helper_module.add_collaborator_hash(login, branch_name), hash_body)
        end
      end

      context "" do
        login = TEST_USER
        branch_name = BRANCH_NAME
        hash_body = {
          title: ADD_COLLAB_FROM_ISSUE + " " + login.downcase,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
    
            Please merge this pull request to add the outside collaborator to the Terraform files / GitHub.
    
            If you have any questions, please post in #ask-operations-engineering on Slack.
            
          EOF
        }

        it "call add_collaborator_from_issue_hash" do
          test_equal(helper_module.add_collaborator_from_issue_hash(login, branch_name), hash_body)
        end
      end

      context "" do
        login = TEST_USER
        branch_name = BRANCH_NAME
        hash_body = {
          title: REMOVE_EXPIRED_COLLABORATOR_PR_TITLE + " " + login.downcase,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
            
            This is the GitHub-Collaborator repository bot.
            
            The collaborator #{login.downcase} review date has expired for the file/s contained in this pull request.
            
            Either approve this pull request, modify it or delete it if it is no longer necessary.
          EOF
        }

        it "call remove_collaborator_hash" do
          test_equal(helper_module.remove_collaborator_hash(login, branch_name), hash_body)
        end
      end

      context "" do
        login = TEST_USER
        branch_name = BRANCH_NAME
        hash_body = {
          title: REMOVE_FULL_ORG_MEMBER_PR_TITLE + " " + login.downcase,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
          body: <<~EOF
            Hi there
          
            **IMPORTANT** Approve and run this PR before any others. A collaborator repository access has been removed. Running tf apply on another PR will invite the collaborator to repository again.
    
            This is the GitHub-Collaborator repository bot.
            
            The full org member / collaborator #{login.downcase} access to one or more repositories has been revoked.
            
            This is because the collaborator is a full organization member and is able to join repositories outside of Terraform via Teams.
            
            This pull request ensures we keep track of those collaborators and which repositories they are accessing.
          EOF
        }

        it "call remove_full_org_member_hash" do
          test_equal(helper_module.remove_full_org_member_hash(login, branch_name), hash_body)
        end
      end

      context "" do
        login = TEST_USER
        branch_name = BRANCH_NAME
        hash_body = {
          title: CHANGE_PERMISSION_PR_TITLE + " " + login.downcase,
          head: branch_name.downcase,
          draft: true,
          base: GITHUB_BRANCH,
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

        it "call modify_collaborator_permission_hash" do
          test_equal(helper_module.modify_collaborator_permission_hash(login, branch_name), hash_body)
        end
      end

      context "call get_active_repositories" do
        it "when no repositories exist" do
          expect(helper_module).to receive(:get_active_repositories_from_github).and_return([])
          test_equal(helper_module.get_active_repositories.length, 0)
        end

        it "when repositories exist" do
          repo1 = GithubCollaborators::Repository.new(TEST_REPO_NAME1, 1)
          repo2 = GithubCollaborators::Repository.new(TEST_REPO_NAME2, 2)
          repo3 = GithubCollaborators::Repository.new(TEST_REPO_NAME3, 0)

          active_repo1 = {repository_name: TEST_REPO_NAME1, outside_collaborators_count: 1}
          active_repo2 = {repository_name: TEST_REPO_NAME2, outside_collaborators_count: 2}
          active_repo3 = {repository_name: TEST_REPO_NAME3, outside_collaborators_count: 0}
          active_repositories = [active_repo1, active_repo2, active_repo3]

          expect(helper_module).to receive(:get_active_repositories_from_github).and_return(active_repositories)
          expect(GithubCollaborators::Repository).to receive(:new).with(TEST_REPO_NAME1, 1).and_return(repo1)
          expect(GithubCollaborators::Repository).to receive(:new).with(TEST_REPO_NAME2, 2).and_return(repo2)
          expect(GithubCollaborators::Repository).to receive(:new).with(TEST_REPO_NAME3, 0).and_return(repo3)
          expect(helper_module).to receive(:fetch_all_collaborators).with(TEST_REPO_NAME1).and_return([TEST_USER_1])
          expect(helper_module).to receive(:fetch_all_collaborators).with(TEST_REPO_NAME2).and_return([TEST_USER_1, TEST_USER_2])
          expect(helper_module).not_to receive(:fetch_all_collaborators).with(TEST_REPO_NAME3)

          test_equal(helper_module.get_active_repositories.length, 3)
        end
      end

      context "call get_active_repositories_from_github" do
        return_data = File.read("spec/fixtures/repositories.json")

        json_query_public_repo = %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:false, is:public"
          first: 100
          after: null
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

        json_query_private_repo = %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:false, is:private"
          first: 100
          after: null
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

        json_query_internal_repo = %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:false, is:internal"
          first: 100
          after: null
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

        before do
          expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client).at_least(1).times
        end

        it "when repositories exist" do
          # The return_data returns three repositories in each query
          expect(graphql_client).to receive(:run_query).with(json_query_public_repo).and_return(return_data)
          expect(graphql_client).to receive(:run_query).with(json_query_private_repo).and_return(return_data)
          expect(graphql_client).to receive(:run_query).with(json_query_internal_repo).and_return(return_data)

          # so nine objects in total
          test_equal(helper_module.get_active_repositories_from_github.length, 9)
        end

        return_data_no_repositories =
          %(
        {
          "data": {
            "search": {
              "repos": [],
              "pageInfo": {
                "hasNextPage": false,
                "endCursor": null
              }
            }
          }
        }
    )

        it "when no repositories exist" do
          expect(graphql_client).to receive(:run_query).with(json_query_public_repo).and_return(return_data_no_repositories)
          expect(graphql_client).to receive(:run_query).with(json_query_private_repo).and_return(return_data_no_repositories)
          expect(graphql_client).to receive(:run_query).with(json_query_internal_repo).and_return(return_data_no_repositories)
          test_equal(helper_module.get_active_repositories_from_github.length, 0)
        end
      end

      context "call get_archived_repositories" do
        return_data = File.read("spec/fixtures/archived_repositories.json")
        json_query_public =
          %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:true, is:public"
          first: 100
          after: null
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

        json_query_private =
          %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:true, is:private"
          first: 100
          after: null
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

        json_query_internal =
          %[
      {
        search(
          type: REPOSITORY
          query: "org:#{ORG}, archived:true, is:internal"
          first: 100
          after: null
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

        before do
          expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client).at_least(1).times
        end

        it "when archived repositories exist" do
          # FUT has a loop with tree iterations. Each loop produces a list of repo names.
          expect(graphql_client).to receive(:run_query).with(json_query_public).and_return(return_data)
          expect(graphql_client).to receive(:run_query).with(json_query_private).and_return(return_data)
          expect(graphql_client).to receive(:run_query).with(json_query_internal).and_return(return_data)
          # Thus expects the three iterations to create three repos name each to make nine repo names in total
          archived_repositories = helper_module.get_archived_repositories
          test_equal(archived_repositories.length, 9)
          test_equal(archived_repositories, [TEST_REPO_NAME1, TEST_REPO_NAME1, TEST_REPO_NAME1, TEST_REPO_NAME2, TEST_REPO_NAME2, TEST_REPO_NAME2, TEST_REPO_NAME3, TEST_REPO_NAME3, TEST_REPO_NAME3])
        end

        return_data_no_repositories =
          %(
      {
        "data": {
          "search": {
            "repos": [],
            "pageInfo": {
              "hasNextPage": false,
              "endCursor": null
            }
          }
        }
      }
    )

        it "when archived repositories don't exist" do
          expect(graphql_client).to receive(:run_query).with(json_query_public).and_return(return_data_no_repositories)
          expect(graphql_client).to receive(:run_query).with(json_query_private).and_return(return_data_no_repositories)
          expect(graphql_client).to receive(:run_query).with(json_query_internal).and_return(return_data_no_repositories)
          archived_repositories = helper_module.get_archived_repositories
          test_equal(archived_repositories.length, 0)
        end
      end

      context "call fetch_all_collaborators" do
        return_data = File.read("spec/fixtures/repository-collaborators.json")
        json_query =
          %[
      {
        organization(login: "#{ORG}") {
          repository(name: "#{REPOSITORY_NAME}") {
            collaborators(
              affiliation: OUTSIDE
              first: 100
              after: null
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

        json_data_no_collaborators =
          %(
    {
      "data": {
        "organization": {
          "repository": {
            "collaborators": {
              "pageInfo": {
                "hasNextPage": false,
                "endCursor": null
              },
              "edges": []
            }
          }
        }
      }
    }
    )

        before do
          expect(GithubCollaborators::GithubGraphQlClient).to receive(:new).and_return(graphql_client).at_least(1).times
        end

        it WHEN_COLLABORATORS_EXISTS do
          expect(graphql_client).to receive(:run_query).with(json_query).and_return(return_data)
          collaborators = helper_module.fetch_all_collaborators(REPOSITORY_NAME)
          test_equal(collaborators.length, 3)
          test_equal(collaborators, [TEST_USER_1, TEST_USER_2, TEST_USER_3])
        end

        it WHEN_NO_COLLABORATORS_EXISTS do
          expect(graphql_client).to receive(:run_query).with(json_query).and_return(json_data_no_collaborators)
          collaborators = helper_module.fetch_all_collaborators(REPOSITORY_NAME)
          test_equal(collaborators.length, 0)
        end
      end

      context "call print_comparison" do
        it "call print_comparison" do
          helper_module.print_comparison([TEST_USER_2], [TEST_USER_2], TEST_REPO_NAME2)
        end
      end

      context "call find_unknown_collaborators" do
        it "when no collaborator in terraform file" do
          unknown_collaborators = helper_module.find_unknown_collaborators([], [TEST_USER_2], TEST_REPO_NAME2)
          test_equal(unknown_collaborators.length, 1)
        end

        it "when no collaborator on github" do
          unknown_collaborators = helper_module.find_unknown_collaborators([TEST_USER_2], [], TEST_REPO_NAME2)
          test_equal(unknown_collaborators.length, 0)
        end

        it "when collaborator on github and in terraform file" do
          unknown_collaborators = helper_module.find_unknown_collaborators([TEST_USER_2], [TEST_USER_2], TEST_REPO_NAME2)
          test_equal(unknown_collaborators.length, 0)
        end
      end

      context "call send_collaborator_notify_email" do
        let(:notify_client) { double(GithubCollaborators::NotifyClient) }
        let(:undelivered_notify_email_slack_message) { double(GithubCollaborators::UndeliveredExpireNotifyEmail) }

        before {
          expect(GithubCollaborators::NotifyClient).to receive(:new).and_return(notify_client)
          # Stub sleep
          allow_any_instance_of(helper_module).to receive(:sleep)
          terraform_block = create_terraform_block_review_date_empty
          @collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
          @collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, TEST_REPO_NAME)
        }

        context "" do
          context "do not email collaborator" do
            before {
              @recent_emails = [{content: "Email content #{REPOSITORY_NAME}", email: TEST_COLLABORATOR_EMAIL}]
              expect(notify_client).to receive(:get_recently_delivered_emails).and_return(@recent_emails)
              expect(notify_client).not_to receive(:send_expire_email)
              expect(notify_client).not_to receive(:check_for_undelivered_expire_emails)
            }

            it "because pass in no collaborator object even when recent emails exist" do
              helper_module.send_collaborator_notify_email([])
            end

            it "because already emailed that user" do
              helper_module.send_collaborator_notify_email([@collaborator])
            end
          end

          context "email the collaborator" do
            it "with a list of repositories" do
              expect(notify_client).to receive(:check_for_undelivered_expire_emails).and_return([])
              expect(notify_client).to receive(:send_expire_email).with(TEST_COLLABORATOR_EMAIL, [REPOSITORY_NAME, TEST_REPO_NAME])
              recent_emails = [{content: "Email content old-repo", email: TEST_RANDOM_EMAIL}]
              expect(notify_client).to receive(:get_recently_delivered_emails).and_return(recent_emails)
              helper_module.send_collaborator_notify_email([@collaborator, @collaborator1])
            end
          end
          
          context "email the collaborator" do
            before {
              expect(notify_client).to receive(:check_for_undelivered_expire_emails).and_return([])
              expect(notify_client).to receive(:send_expire_email).with(TEST_COLLABORATOR_EMAIL, [REPOSITORY_NAME])
            }

            it "because haven't emailed the collaborator in last 7 days" do
              recent_emails = [{content: "Email content #{REPOSITORY_NAME}", email: TEST_RANDOM_EMAIL}]
              expect(notify_client).to receive(:get_recently_delivered_emails).and_return(recent_emails)
              helper_module.send_collaborator_notify_email([@collaborator])
            end

            it "because haven't emailed the collaborator about a specific repository" do
              recent_emails = [{content: "Email content some-repository", email: TEST_COLLABORATOR_EMAIL}]
              expect(notify_client).to receive(:get_recently_delivered_emails).and_return(recent_emails)
              helper_module.send_collaborator_notify_email([@collaborator])
            end

            it "because no recent emails exist" do
              expect(notify_client).to receive(:get_recently_delivered_emails).and_return([])
              helper_module.send_collaborator_notify_email([@collaborator])
            end
          end
        end

        context "without any recently delivered emails" do
          before {
            expect(notify_client).to receive(:get_recently_delivered_emails).and_return([])
          }

          it "with no collaborator objects" do
            expect(notify_client).not_to receive(:send_expire_email)
            expect(notify_client).not_to receive(:check_for_undelivered_expire_emails)
            helper_module.send_collaborator_notify_email([])
          end

          context "" do
            before {
              expect(notify_client).to receive(:send_expire_email).with(TEST_COLLABORATOR_EMAIL, [REPOSITORY_NAME])
            }

            it "with a collaborator object and sent the email okay" do
              expect(notify_client).to receive(:check_for_undelivered_expire_emails).and_return([])
              helper_module.send_collaborator_notify_email([@collaborator])
            end

            it "with a collaborator object, notify failed to send the email, and returns known email" do
              expect(notify_client).to receive(:check_for_undelivered_expire_emails).and_return([TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL])
              expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::UndeliveredExpireNotifyEmail), [@collaborator]).and_return(undelivered_notify_email_slack_message)
              expect(undelivered_notify_email_slack_message).to receive(:post_slack_message)
              helper_module.send_collaborator_notify_email([@collaborator])
            end

            it "with a collaborator object, notify failed to send the email, but returns an unknown email" do
              expect(notify_client).to receive(:check_for_undelivered_expire_emails).and_return([TEST_RANDOM_EMAIL])
              helper_module.send_collaborator_notify_email([@collaborator])
            end
          end
        end
      end

      context "call send_approver_notify_email" do
        let(:notify_client) { double(GithubCollaborators::NotifyClient) }
        let(:undelivered_notify_email_slack_message) { double(GithubCollaborators::UndeliveredApproverNotifyEmail) }

        context "" do
          before {
            expect(notify_client).not_to receive(:send_approver_email)
            expect(notify_client).not_to receive(:check_for_undelivered_approver_emails)
          }

          it "with no inputs" do
            helper_module.send_approver_notify_email("", "", [], "", "", [])
          end

          it "with first input missing" do
            helper_module.send_approver_notify_email("", TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE])
          end

          it "with second input missing" do
            helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, "", [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE])
          end

          it "with third input missing" do
            helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE])
          end

          it "with fourth input" do
            helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], "", CREATED_DATE, [TEST_FILE])
          end

          it "withfifth input missing" do
            helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, "", [TEST_FILE])
          end

          it "with sixth input missing" do
            helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [])
          end
        end

        context "" do
          before do
            # Stub sleep
            allow_any_instance_of(helper_module).to receive(:sleep)
            expect(GithubCollaborators::NotifyClient).to receive(:new).and_return(notify_client)
          end

          context "" do
            before do
              expect(notify_client).to receive(:check_for_undelivered_approver_emails).and_return("")
            end

            it "with one collaborator and one repository" do
              expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL} is", "repository \"#{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
              helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE])
            end

            it "with one collaborator and two repositories" do
              expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL} is", "repositories \"#{TEST_REPO_NAME} and #{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
              helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE, TEST_FILE])
            end

            it "with one collaborator and three repositories" do
              expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL} is", "repositories \"#{TEST_REPO_NAME}, #{TEST_REPO_NAME} and #{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
              helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE, TEST_FILE, TEST_FILE])
            end

            it "with two collaborators and one repository" do
              expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL} and #{TEST_COLLABORATOR_EMAIL} are", "repository \"#{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
              helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE])
            end

            it "with three collaborator and two repositories" do
              expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL}, #{TEST_COLLABORATOR_EMAIL} and #{TEST_COLLABORATOR_EMAIL} are", "repositories \"#{TEST_REPO_NAME} and #{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
              helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE, TEST_FILE])
            end

            it "with three collaborator and three repositories" do
              expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL}, #{TEST_COLLABORATOR_EMAIL} and #{TEST_COLLABORATOR_EMAIL} are", "repositories \"#{TEST_REPO_NAME}, #{TEST_REPO_NAME} and #{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
              helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE, TEST_FILE, TEST_FILE])
            end
          end

          it "with undelivered approver email address" do
            terraform_block = create_terraform_block_review_date_empty
            terraform_block.add_collaborator_email_address(TEST_RANDOM_EMAIL)
            collaborator = GithubCollaborators::Collaborator.new(terraform_block, "")
            expect(GithubCollaborators::TerraformBlock).to receive(:new).and_return(terraform_block)
            expect(GithubCollaborators::Collaborator).to receive(:new).with(terraform_block, "").and_return(collaborator)
            expect(notify_client).to receive(:send_approver_email).with(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, "#{TEST_COLLABORATOR_EMAIL} is", "repository \"#{TEST_REPO_NAME}\"", TEST_COLLABORATOR_REASON, CREATED_DATE)
            expect(notify_client).to receive(:check_for_undelivered_approver_emails).and_return(TEST_RANDOM_EMAIL)
            expect(GithubCollaborators::SlackNotifier).to receive(:new).with(instance_of(GithubCollaborators::UndeliveredApproverNotifyEmail), [collaborator]).and_return(undelivered_notify_email_slack_message)
            expect(undelivered_notify_email_slack_message).to receive(:post_slack_message)
            helper_module.send_approver_notify_email(TEST_RANDOM_EMAIL, TEST_COLLABORATOR_PERMISSION, [TEST_COLLABORATOR_EMAIL], TEST_COLLABORATOR_REASON, CREATED_DATE, [TEST_FILE])
          end
        end
      end
    end
  end
end
