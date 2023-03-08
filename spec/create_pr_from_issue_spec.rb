class GithubCollaborators
  include TestConstants
  include Constants

  describe CreatePrFromIssue do
    let(:http_client) { double(GithubCollaborators::HttpClient) }
    repo_url = "#{GH_API_URL}/#{TEST_REPO_NAME}"
    users_url = "#{GH_URL}/users/#{TEST_COLLABORATOR_LOGIN}"

    before do
      expect(GithubCollaborators::HttpClient).to receive(:new).and_return(http_client)
    end

    context "test good path" do
      before {
        good_json_one_user = {body: "### usernames\n\n#{TEST_COLLABORATOR_LOGIN}\n\n### names\n\n#{TEST_COLLABORATOR_NAME}\n\n### emails\n\n#{TEST_COLLABORATOR_EMAIL}\n\n### org\n\n#{TEST_COLLABORATOR_ORG}\n\n### reason\n\n#{REASON1}\n\n### added_by\n\n#{ADDED_BY_EMAIL}\n\n### review_after\n\n#{CORRECT_REVIEW_DATE}\n\n### permission\n\n#{CORRECT_PERMISSION}\n\n### repositories\n\n#{TEST_REPO_NAME}"}.to_json
        @create_pr_from_issue = CreatePrFromIssue.new(good_json_one_user)
      }

      it "call remove_characters_from_string_except_space" do
        test_equal(@create_pr_from_issue.remove_characters_from_string_except_space(""), "")
        test_equal(@create_pr_from_issue.remove_characters_from_string_except_space("abc"), "abc")
        test_equal(@create_pr_from_issue.remove_characters_from_string_except_space("abc1\n\t\r "), "abc1 ")
      end

      it "call remove_characters_from_string" do
        test_equal(@create_pr_from_issue.remove_characters_from_string(""), "")
        test_equal(@create_pr_from_issue.remove_characters_from_string("abc"), "abc")
        test_equal(@create_pr_from_issue.remove_characters_from_string("abc1\n\t\r "), "abc1")
      end

      it "call get_permission" do
        test_equal(@create_pr_from_issue.get_permission, CORRECT_PERMISSION)
      end

      it "call get_repositories" do
        expect(http_client).to receive(:fetch_code).with(repo_url).and_return("200")
        test_equal(@create_pr_from_issue.get_repositories, [TEST_REPO_NAME])
      end

      it "call get_usernames" do
        expect(http_client).to receive(:fetch_code).with(users_url).and_return("200")
        test_equal(@create_pr_from_issue.get_usernames, [TEST_COLLABORATOR_LOGIN])
      end

      it "call get_names" do
        test_equal(@create_pr_from_issue.get_names, [TEST_COLLABORATOR_NAME])
      end

      it "call get_emails" do
        test_equal(@create_pr_from_issue.get_emails, [TEST_COLLABORATOR_EMAIL])
      end

      it "call get_repositories with a bad return value" do
        expect(http_client).to receive(:fetch_code).with(repo_url).and_return("404")
        expect { @create_pr_from_issue.get_repositories }.to raise_error(SystemExit)
      end

      it "call get_usernames with a bad return value" do
        expect(http_client).to receive(:fetch_code).with(users_url).and_return("404")
        expect { @create_pr_from_issue.get_usernames }.to raise_error(SystemExit)
      end

      it "call get_org" do
        test_equal(@create_pr_from_issue.get_org, TEST_COLLABORATOR_ORG)
      end

      it "call get_reason" do
        test_equal(@create_pr_from_issue.get_reason, REASON1)
      end

      it "call get_added_by" do
        test_equal(@create_pr_from_issue.get_added_by, ADDED_BY_EMAIL)
      end

      it "call get_review_after" do
        test_equal(@create_pr_from_issue.get_review_after, CORRECT_REVIEW_DATE)
      end

      let(:terraform_files) { double(GithubCollaborators::TerraformFiles) }

      context "" do
        before do
          expect(terraform_files).to receive(:get_terraform_files).and_return([])
          expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        end

        it "call add_users_to_files when no repositories" do
          expect(@create_pr_from_issue).to receive(:get_repositories).and_return([])
          test_equal(@create_pr_from_issue.add_users_to_files([]), [])
        end

        it "call add_users_to_files when provide repositories but terraform file doesn't exist" do
          expect(@create_pr_from_issue).to receive(:get_repositories).and_return([REPOSITORY_NAME])
          expect(terraform_files).to receive(:ensure_file_exists_in_memory).with(REPOSITORY_NAME)
          test_equal(@create_pr_from_issue.add_users_to_files([]), [])
        end
      end

      context "" do
        before do
          expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
          expect(terraform_files).to receive(:ensure_file_exists_in_memory).with(REPOSITORY_NAME)
          expect(@create_pr_from_issue).to receive(:get_repositories).and_return([REPOSITORY_NAME])
        end

        it "call add_users_to_files when provide repositories but terraform file with same name doesn't exist" do
          file = create_terraform_file
          expect(terraform_files).to receive(:get_terraform_files).and_return([file])
          test_equal(@create_pr_from_issue.add_users_to_files([]), [])
        end

        it "call add_users_to_files when provide repositories and terraform file with same name exists but have no collaborators to add to file" do
          file = create_terraform_file_with_name(REPOSITORY_NAME)
          expect(terraform_files).to receive(:get_terraform_files).and_return([file])
          test_equal(@create_pr_from_issue.add_users_to_files([]), [])
        end
      end

      it "call add_users_to_files when provide repositories and terraform file with same name exists and collaborators to add to file" do
        file = create_terraform_file_with_name(REPOSITORY_NAME)
        expect(GithubCollaborators::TerraformFiles).to receive(:new).and_return(terraform_files).at_least(1).times
        expect(terraform_files).to receive(:ensure_file_exists_in_memory).with(REPOSITORY_NAME)
        expect(@create_pr_from_issue).to receive(:get_repositories).and_return([REPOSITORY_NAME])
        expect(terraform_files).to receive(:get_terraform_files).and_return([file])
        collaborator = create_collaborator_data("")
        test_equal(@create_pr_from_issue.add_users_to_files([collaborator]), ["terraform/somerepo.tf"])
      end

      it "call create_single_user_pull_request" do
        collaborator = create_collaborator_data("")
        @create_pr_from_issue.create_single_user_pull_request(["terraform/somerepo.tf"], collaborator)
        allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("add-collaborator-from-issue-#{TEST_COLLABORATOR_LOGIN}", ["terraform/somerepo.tf"], "#{ADD_COLLAB_FROM_ISSUE} #{TEST_COLLABORATOR_NAME}", TEST_COLLABORATOR_LOGIN, TYPE_ADD_FROM_ISSUE)
      end

      it "call create_multiple_users_pull_request" do
        allow_any_instance_of(HelperModule).to receive(:create_branch_and_pull_request).with("add-multiple-collaborators-from-issue", ["terraform/somerepo.tf"], MULITPLE_COLLABORATORS_PR_TITLE, "multiple-collaborators", TYPE_ADD_FROM_ISSUE)
        @create_pr_from_issue.create_multiple_users_pull_request(["terraform/somerepo.tf"])
      end
    end

    context "test start" do
      before {
        good_json_one_user = {body: "### usernames\n\n#{TEST_COLLABORATOR_LOGIN}\n\n### names\n\n#{TEST_COLLABORATOR_NAME}\n\n### emails\n\n#{TEST_COLLABORATOR_EMAIL}\n\n### org\n\n#{TEST_COLLABORATOR_ORG}\n\n### reason\n\n#{REASON1}\n\n### added_by\n\n#{ADDED_BY_EMAIL}\n\n### review_after\n\n#{CORRECT_REVIEW_DATE}\n\n### permission\n\n#{CORRECT_PERMISSION}\n\n### repositories\n\n#{TEST_REPO_NAME}"}.to_json
        @create_pr_from_issue = CreatePrFromIssue.new(good_json_one_user)
      }

      it "when lists do not match 1" do
        expect(@create_pr_from_issue).to receive(:get_emails).and_return([TEST_COLLABORATOR_EMAIL])
        expect(@create_pr_from_issue).to receive(:get_usernames).and_return([])
        expect(@create_pr_from_issue).to receive(:get_names).and_return([TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_NAME])
        expect { @create_pr_from_issue.start }.to raise_error(SystemExit)
      end

      it "when lists do not match 2" do
        expect(@create_pr_from_issue).to receive(:get_emails).and_return([TEST_COLLABORATOR_EMAIL])
        expect(@create_pr_from_issue).to receive(:get_usernames).and_return([TEST_COLLABORATOR_LOGIN, TEST_COLLABORATOR_LOGIN])
        expect(@create_pr_from_issue).to receive(:get_names).and_return([TEST_COLLABORATOR_NAME])
        expect { @create_pr_from_issue.start }.to raise_error(SystemExit)
      end

      context "" do
        before do
          expect(@create_pr_from_issue).to receive(:get_permission).and_return(TEST_COLLABORATOR_PERMISSION)
          expect(@create_pr_from_issue).to receive(:get_org).and_return(TEST_COLLABORATOR_ORG)
          expect(@create_pr_from_issue).to receive(:get_reason).and_return(TEST_COLLABORATOR_REASON)
          expect(@create_pr_from_issue).to receive(:get_added_by).and_return(TEST_COLLABORATOR_ADDED_BY)
          @collaborator1 = create_collaborator_hash_with_login(TEST_USER_1)
          @collaborator2 = create_collaborator_hash_with_login(TEST_USER_2)
          @collaborator3 = create_collaborator_hash_with_login(TEST_USER_3)
        end

        it "when mulitple users and lists match in size" do
          expect(@create_pr_from_issue).to receive(:get_emails).and_return([TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL])
          expect(@create_pr_from_issue).to receive(:get_usernames).and_return([TEST_USER_1, TEST_USER_2, TEST_USER_3])
          expect(@create_pr_from_issue).to receive(:get_names).and_return([TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_NAME])
          expect(@create_pr_from_issue).to receive(:get_review_after).and_return("")
          collaborators = [@collaborator1, @collaborator2, @collaborator3]
          expect(@create_pr_from_issue).to receive(:add_users_to_files).with(collaborators).and_return(["terraform/somerepo.tf"])
          expect(@create_pr_from_issue).to receive(:create_multiple_users_pull_request).with(["terraform/somerepo.tf"])
          @create_pr_from_issue.start
        end

        it "when single user in lists" do
          expect(@create_pr_from_issue).to receive(:get_emails).and_return([TEST_COLLABORATOR_EMAIL])
          expect(@create_pr_from_issue).to receive(:get_usernames).and_return([TEST_USER_1])
          expect(@create_pr_from_issue).to receive(:get_names).and_return([TEST_COLLABORATOR_NAME])
          expect(@create_pr_from_issue).to receive(:get_review_after).and_return("")
          collaborators = [@collaborator1]
          expect(@create_pr_from_issue).to receive(:add_users_to_files).with(collaborators).and_return(["terraform/somerepo.tf"])
          expect(@create_pr_from_issue).to receive(:create_single_user_pull_request).with(["terraform/somerepo.tf"], @collaborator1)
          @create_pr_from_issue.start
        end
      end
    end

    context "test good path when have multiple users" do
      before {
        good_json_multiple_users = {body: "### usernames\n\n#{TEST_COLLABORATOR_LOGIN}\r\n#{TEST_COLLABORATOR_LOGIN}\n\n### names\n\n#{TEST_COLLABORATOR_NAME}\r\n#{TEST_COLLABORATOR_NAME}\n\n### emails\n\n#{TEST_COLLABORATOR_EMAIL}\r\n#{TEST_COLLABORATOR_EMAIL}\n\n### org\n\n#{TEST_COLLABORATOR_ORG}\n\n### reason\n\n#{REASON1}\n\n### added_by\n\n#{ADDED_BY_EMAIL}\n\n### review_after\n\n#{CORRECT_REVIEW_DATE}\n\n### permission\n\n#{CORRECT_PERMISSION}\n\n### repositories\n\n#{TEST_REPO_NAME}\r\n#{TEST_REPO_NAME}"}.to_json
        @create_pr_from_issue = CreatePrFromIssue.new(good_json_multiple_users)
      }

      it "call get_repositories" do
        expect(http_client).to receive(:fetch_code).with(repo_url).and_return("200").at_least(2).times
        test_equal(@create_pr_from_issue.get_repositories, [TEST_REPO_NAME, TEST_REPO_NAME])
      end

      it "call get_usernames" do
        expect(http_client).to receive(:fetch_code).with(users_url).and_return("200").at_least(2).times
        test_equal(@create_pr_from_issue.get_usernames, [TEST_COLLABORATOR_LOGIN, TEST_COLLABORATOR_LOGIN])
      end

      it "call get_names" do
        test_equal(@create_pr_from_issue.get_names, [TEST_COLLABORATOR_NAME, TEST_COLLABORATOR_NAME])
      end

      it "call get_emails" do
        test_equal(@create_pr_from_issue.get_emails, [TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL])
      end
    end

    context "test bad parameters" do
      context "with missing values" do
        before {
          incorrect_json_missing_values = {body: "### usernames\n\n\n\n### names\n\n\n\n### emails\n\n\n\n### org\n\n\n\n### reason\n\n\n\n### added_by\n\n\n\n### review_after\n\n\n\n### permission\n\nwrite\n\n### repositories\n\n"}.to_json
          @create_pr_from_issue = CreatePrFromIssue.new(incorrect_json_missing_values)
        }

        it "call get_permission" do
          expect { @create_pr_from_issue.get_permission }.to raise_error(SystemExit)
        end

        it "call get_repositories" do
          expect { @create_pr_from_issue.get_repositories }.to raise_error(SystemExit)
        end

        it "call get_usernames" do
          expect { @create_pr_from_issue.get_usernames }.to raise_error(SystemExit)
        end

        it "call get_names" do
          expect { @create_pr_from_issue.get_names }.to raise_error(SystemExit)
        end

        it "call get_emails" do
          expect { @create_pr_from_issue.get_emails }.to raise_error(SystemExit)
        end

        it "call get_org" do
          expect { @create_pr_from_issue.get_org }.to raise_error(SystemExit)
        end

        it "call get_reason" do
          expect { @create_pr_from_issue.get_reason }.to raise_error(SystemExit)
        end

        it "call get_added_by" do
          expect { @create_pr_from_issue.get_added_by }.to raise_error(SystemExit)
        end

        it "call get_review_after" do
          expect { @create_pr_from_issue.get_added_by }.to raise_error(SystemExit)
        end

        it "call get_review_after" do
          expect { @create_pr_from_issue.get_review_after }.to raise_error(SystemExit)
        end
      end

      context "with blank values" do
        before {
          incorrect_json_blank_values = {body: "### usernames\n\n \n\n### names\n\n \n\n### emails\n\n \n\n### org\n\n \n\n### reason\n\n \n\n### added_by\n\n\n\n### review_after\n\n \n\n### permission\n\n \n\n### repositories\n\n "}.to_json
          @create_pr_from_issue = CreatePrFromIssue.new(incorrect_json_blank_values)
        }

        it "call get_permission" do
          expect { @create_pr_from_issue.get_permission }.to raise_error(SystemExit)
        end

        it "call get_repositories" do
          expect { @create_pr_from_issue.get_repositories }.to raise_error(SystemExit)
        end

        it "call get_usernames" do
          expect { @create_pr_from_issue.get_usernames }.to raise_error(SystemExit)
        end

        it "call get_names" do
          expect { @create_pr_from_issue.get_names }.to raise_error(SystemExit)
        end

        it "call get_emails" do
          expect { @create_pr_from_issue.get_emails }.to raise_error(SystemExit)
        end

        it "call get_org" do
          expect { @create_pr_from_issue.get_org }.to raise_error(SystemExit)
        end

        it "call get_reason" do
          expect { @create_pr_from_issue.get_reason }.to raise_error(SystemExit)
        end

        it "call get_added_by" do
          expect { @create_pr_from_issue.get_added_by }.to raise_error(SystemExit)
        end

        it "call get_review_after" do
          expect { @create_pr_from_issue.get_added_by }.to raise_error(SystemExit)
        end

        it "call get_review_after" do
          expect { @create_pr_from_issue.get_review_after }.to raise_error(SystemExit)
        end
      end

      context "with nil values" do
        before {
          incorrect_json_nil_values = {body: "### usernames\n\n\n\n### names\n\n\n\n### emails\n\n\n\n### org\n\n\n\n### reason\n\n\n\n### added_by\n\n\n\n### review_after\n\n\n\n### permission\n\n\n\n### repositories\n\n"}.to_json
          @create_pr_from_issue = CreatePrFromIssue.new(incorrect_json_nil_values)
        }

        it "call get_permission" do
          expect { @create_pr_from_issue.get_permission }.to raise_error(SystemExit)
        end

        it "call get_repositories" do
          expect { @create_pr_from_issue.get_repositories }.to raise_error(SystemExit)
        end

        it "call get_usernames" do
          expect { @create_pr_from_issue.get_usernames }.to raise_error(SystemExit)
        end

        it "call get_names" do
          expect { @create_pr_from_issue.get_names }.to raise_error(SystemExit)
        end

        it "call get_emails" do
          expect { @create_pr_from_issue.get_emails }.to raise_error(SystemExit)
        end

        it "call get_org" do
          expect { @create_pr_from_issue.get_org }.to raise_error(SystemExit)
        end

        it "call get_reason" do
          expect { @create_pr_from_issue.get_reason }.to raise_error(SystemExit)
        end

        it "call get_added_by" do
          expect { @create_pr_from_issue.get_added_by }.to raise_error(SystemExit)
        end

        it "call get_review_after" do
          expect { @create_pr_from_issue.get_review_after }.to raise_error(SystemExit)
        end
      end

      context "" do
        before {
          incorrect_json = {body: "### usernames\n\n\n\n### names\n\n\n\n### emails\n\n\n\n### org\n\n\n\n### reason\n\n\n\n### added_by\n\n\n\n### review_after\n\n#{INCORRECT_REVIEW_DATE_FUTURE}\n\n### permission\n\n\n\n### repositories\n\n"}.to_json
          @create_pr_from_issue = CreatePrFromIssue.new(incorrect_json)
        }

        it "with incorrect review dates too far in future" do
          expect { @create_pr_from_issue.get_review_after }.to raise_error(SystemExit)
        end
      end

      context "" do
        before {
          incorrect_json = {body: "### usernames\n\n\n\n### names\n\n\n\n### emails\n\n\n\n### org\n\n\n\n### reason\n\n\n\n### added_by\n\n\n\n### review_after\n\n#{INCORRECT_REVIEW_DATE_PAST}\n\n### permission\n\n\n\n### repositories\n\n"}.to_json
          @create_pr_from_issue = CreatePrFromIssue.new(incorrect_json)
        }

        it "with incorrect review date in the past" do
          expect { @create_pr_from_issue.get_review_after }.to raise_error(SystemExit)
        end
      end
    end
  end
end
