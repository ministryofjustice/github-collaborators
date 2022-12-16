class GithubCollaborators
  TEST_TITLE = "call post_slack_message when have a collaborator"

  describe SlackNotifier do
    context "test SlackNotifier" do
      it "call post_slack_message when collaborators is zero" do
        expect(HTTP).not_to receive(:post)
        slack_notififer = GithubCollaborators::SlackNotifier.new(nil, [])
        slack_notififer.post_slack_message
      end
    end

    context "test SlackNotifier when env var doesn't exist" do
      before {
        ENV.delete("REALLY_POST_TO_SLACK")
      }

      it TEST_TITLE do
        terraform_block = create_terraform_block_review_date_today
        collaborators = []
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborators.push(collaborator)
        test_object = GithubCollaborators::FullOrgMemberExpired.new
        expect(HTTP).not_to receive(:post)
        slack_notififer = GithubCollaborators::SlackNotifier.new(test_object, collaborators)
        slack_notififer.post_slack_message
      end
    end

    context "test SlackNotifier when env var exists and slack env var doesn't exist" do
      before {
        ENV["REALLY_POST_TO_SLACK"] = "1"
        ENV.delete("SLACK_WEBHOOK_URL")
      }

      it TEST_TITLE do
        terraform_block = create_terraform_block_review_date_today
        collaborators = []
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborators.push(collaborator)
        test_object = GithubCollaborators::FullOrgMemberExpired.new
        expect(HTTP).not_to receive(:post)
        slack_notififer = GithubCollaborators::SlackNotifier.new(test_object, collaborators)
        slack_notififer.post_slack_message
      end
    end

    context "test SlackNotifier when env var and slack env var exist" do
      before {
        ENV["REALLY_POST_TO_SLACK"] = "1"
        ENV["SLACK_WEBHOOK_URL"] = "someurl"
      }

      json_payload = {body: "{\"username\":\"GitHub Collaborator repository bot\",\"icon_emoji\":\":robot_face:\",\"text\":\"I've found a full Org member / collaborator whose review date has expired, a pull request has been created to remove the collaborator from the Terraform file/s. Manually remove the collaborator from the repository:\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/github-collaborators/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n\",\"mrkdwn\":true,\"channel\":\"#operations-engineering-alerts\"}"}

      it TEST_TITLE do
        terraform_block = create_terraform_block_review_date_today
        collaborators = []
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborators.push(collaborator)
        test_object = GithubCollaborators::FullOrgMemberExpired.new

        expect(HTTP).to receive(:post).with("someurl", json_payload)
        slack_notififer = GithubCollaborators::SlackNotifier.new(test_object, collaborators)
        slack_notififer.post_slack_message
      end

      json_payload_multiple = {body: "{\"username\":\"GitHub Collaborator repository bot\",\"icon_emoji\":\":robot_face:\",\"text\":\"I've found 3 full Org members / collaborators whose review dates have expired, pull requests have been created to remove these collaborators from the Terraform file/s. Manually remove the collaborator from the repository:\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/github-collaborators/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/github-collaborators/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/github-collaborators/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n\",\"mrkdwn\":true,\"channel\":\"#operations-engineering-alerts\"}"}

      it "call post_slack_message when have multiple collaborators" do
        terraform_block = create_terraform_block_review_date_today
        collaborators = []
        collaborator1 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborator2 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborator3 = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborators.push(collaborator1)
        collaborators.push(collaborator2)
        collaborators.push(collaborator3)
        test_object = GithubCollaborators::FullOrgMemberExpired.new

        expect(HTTP).to receive(:post).with("someurl", json_payload_multiple)
        slack_notififer = GithubCollaborators::SlackNotifier.new(test_object, collaborators)
        slack_notififer.post_slack_message
      end
    end
  end
end
