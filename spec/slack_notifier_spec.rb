class GithubCollaborators
  include TestConstants
  include Constants

  TEST_TITLE = "call post_slack_message when have a collaborator"
  describe SlackNotifier do
    context "test SlackNotifier" do
      before do
        @terraform_block = create_terraform_block_review_date_today
        @test_object = GithubCollaborators::Expired.new
        @collaborators = []
      end

      context "" do
        before do
          @collaborator = GithubCollaborators::Collaborator.new(@terraform_block, REPOSITORY_NAME)
          @collaborators.push(@collaborator)
        end

        it "call post_slack_message when collaborators is zero" do
          expect(HTTP).not_to receive(:post)
          slack_notififer = GithubCollaborators::SlackNotifier.new(nil, [])
          slack_notififer.post_slack_message
        end

        context "when env var doesn't exist" do
          before {
            ENV.delete("REALLY_POST_TO_SLACK")
          }

          it TEST_TITLE do
            expect(HTTP).not_to receive(:post)
            slack_notififer = GithubCollaborators::SlackNotifier.new(@test_object, @collaborators)
            slack_notififer.post_slack_message
          end
        end

        context "when env var exists and slack env var doesn't exist" do
          before {
            ENV["REALLY_POST_TO_SLACK"] = "1"
            ENV.delete("SLACK_WEBHOOK_URL")
          }

          it TEST_TITLE do
            expect(HTTP).not_to receive(:post)
            slack_notififer = GithubCollaborators::SlackNotifier.new(@test_object, @collaborators)
            slack_notififer.post_slack_message
          end
        end

        context "when env var and slack env var exist" do
          before {
            ENV["REALLY_POST_TO_SLACK"] = "1"
            ENV["SLACK_WEBHOOK_URL"] = "someurl"
          }

          json_payload = {body: "{\"username\":\"GitHub Collaborator repository bot\",\"icon_emoji\":\":robot_face:\",\"text\":\"I've found a collaborator whose review date has expired, a pull request has been created to remove the collaborator:\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/#{REPO_NAME}/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n\",\"mrkdwn\":true,\"channel\":\"#operations-engineering-alerts\"}"}
         
          it TEST_TITLE do
            expect(HTTP).to receive(:post).with("someurl", json_payload)
            slack_notififer = GithubCollaborators::SlackNotifier.new(@test_object, @collaborators)
            slack_notififer.post_slack_message
          end
        end

        after do
          ENV.delete("REALLY_POST_TO_SLACK")
          ENV.delete("SLACK_WEBHOOK_URL")
        end
      end

      before {
        ENV["REALLY_POST_TO_SLACK"] = "1"
        ENV["SLACK_WEBHOOK_URL"] = "someurl"
      }

      it "call post_slack_message when have multiple collaborators" do
        collaborator1 = GithubCollaborators::Collaborator.new(@terraform_block, REPOSITORY_NAME)
        collaborator2 = GithubCollaborators::Collaborator.new(@terraform_block, REPOSITORY_NAME)
        collaborator3 = GithubCollaborators::Collaborator.new(@terraform_block, REPOSITORY_NAME)
        @collaborators.push(collaborator1)
        @collaborators.push(collaborator2)
        @collaborators.push(collaborator3)
        json_payload_multiple = {body: "{\"username\":\"GitHub Collaborator repository bot\",\"icon_emoji\":\":robot_face:\",\"text\":\"I've found 3 collaborators whose review dates have expired, pull requests have been created to remove these collaborators:\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/#{REPO_NAME}/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/#{REPO_NAME}/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n- #{TEST_USER} in <#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}> see <#{GH_ORG_URL}/#{REPO_NAME}/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file> (today)\\n\",\"mrkdwn\":true,\"channel\":\"#operations-engineering-alerts\"}"}
        expect(HTTP).to receive(:post).with("someurl", json_payload_multiple)
        slack_notififer = GithubCollaborators::SlackNotifier.new(@test_object, @collaborators)
        slack_notififer.post_slack_message
      end
    end

    after do
      ENV.delete("REALLY_POST_TO_SLACK")
      ENV.delete("SLACK_WEBHOOK_URL")
    end
  end
end
