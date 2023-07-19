class GithubCollaborators
  include TestConstants
  include Constants

  describe NotifyClient do
    context "test NotifyClient" do
      # context "when env var doesn't exist" do
      #   before {
      #     ENV.delete("REALLY_SEND_TO_NOTIFY")
      #   }

      #   it "call post_slack_message when collaborators is zero" do
      #     expect(HTTP).not_to receive(:post)
      #     notify_client = GithubCollaborators::NotifyClient.new
      #     notify_client.send_expire_email
      #   end
      # end

      context "when env var exists" do
        before {
          ENV["REALLY_SEND_TO_NOTIFY"] = "0"
          ENV["NOTIFY_TEST_TOKEN"] = "123456"
        }

        it "test send_expire_email" do
          expect(NotifyClient).to receive(:send_email_reply_to_ops_eng).with(NotifyClient.expire_email_template_id, TEST_COLLABORATOR_EMAIL, {repo_name: REPOSITORY_NAME})
          notify_client = GithubCollaborators::NotifyClient.new
          notify_client.send_expire_email(TEST_COLLABORATOR_EMAIL, REPOSITORY_NAME)
        end

        after do
          ENV.delete("REALLY_SEND_TO_NOTIFY")
          ENV.delete("NOTIFY_TEST_TOKEN")
        end
      end
    end
  end
end
