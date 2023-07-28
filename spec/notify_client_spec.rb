class GithubCollaborators
  include TestConstants
  include Constants

  class MockNotifications
    attr_reader :collection
    attr_writer :collection
    class MockNotificationsReply
      attr_reader :created_at, :template, :email_address, :status
      attr_writer :created_at, :template, :email_address, :status
      def initialize
        @created_at = ""
        @template = {id: ""}
        @email_address = ""
        @status = ""
      end
    end

    def initialize
      notification = MockNotificationsReply.new
      @collection = [notification]
    end
  end

  describe NotifyClient do
    let(:notifications_client) { double(Notifications::Client) }

    context "test NotifyClient" do
      context "test initialize" do
        context "when top level env var doesn't exist" do
          before {
            ENV.delete("REALLY_SEND_TO_NOTIFY")
          }

          it CATCH_ERROR do
            expect { GithubCollaborators::NotifyClient.new }.to raise_error(KeyError)
          end
        end

        context "when top level env var does exist" do
          context "and inner level env car doesn't exist" do
            before {
              ENV["REALLY_SEND_TO_NOTIFY"] = "0"
              ENV.delete("NOTIFY_TEST_TOKEN")
            }

            it CATCH_ERROR do
              expect { GithubCollaborators::NotifyClient.new }.to raise_error(KeyError)
            end
          end

          context "and inner level env car doesn't exist" do
            before {
              ENV["REALLY_SEND_TO_NOTIFY"] = "1"
              ENV.delete("NOTIFY_PROD_TOKEN")
            }

            it CATCH_ERROR do
              expect { GithubCollaborators::NotifyClient.new }.to raise_error(KeyError)
            end
          end
        end

        context "test the Notify test api key is correct" do
          before {
            ENV["REALLY_SEND_TO_NOTIFY"] = "0"
            ENV["NOTIFY_TEST_TOKEN"] = NOTIFY_TEST_API_TOKEN
            ENV.delete("NOTIFY_PROD_TOKEN")
            expect(Notifications::Client).to receive(:new).and_return(notifications_client)
            @notify_client = GithubCollaborators::NotifyClient.new
          }

          it "" do
            test_equal(@notify_client.api_key, NOTIFY_TEST_API_TOKEN)
          end

          after do
            ENV.delete("REALLY_SEND_TO_NOTIFY")
            ENV.delete("NOTIFY_TEST_TOKEN")
          end
        end

        context "test the Notify prod api key is correct" do
          before {
            ENV["REALLY_SEND_TO_NOTIFY"] = "1"
            ENV["NOTIFY_PROD_TOKEN"] = NOTIFY_PROD_API_TOKEN
            ENV["NOTIFY_TEST_TOKEN"] = NOTIFY_TEST_API_TOKEN
          }
          it "" do
            expect(Notifications::Client).to receive(:new).and_return(notifications_client)
            notify_client = GithubCollaborators::NotifyClient.new
            test_equal(notify_client.api_key, NOTIFY_PROD_API_TOKEN)
          end
          after do
            ENV.delete("REALLY_SEND_TO_NOTIFY")
            ENV.delete("NOTIFY_PROD_TOKEN")
            ENV.delete("NOTIFY_TEST_TOKEN")
          end
        end
      end

      context "tests functions" do
        before {
          ENV["REALLY_SEND_TO_NOTIFY"] = "0"
          ENV["NOTIFY_TEST_TOKEN"] = NOTIFY_TEST_API_TOKEN
          expect(Notifications::Client).to receive(:new).and_return(notifications_client)
          @notify_client = GithubCollaborators::NotifyClient.new
        }

        it "test send_expire_email" do
          expect(@notify_client).to receive(:send_email_reply_to_ops_eng).with(EXPIRE_EMAIL_TEMPLATE_ID, TEST_COLLABORATOR_EMAIL, {repo_name: REPOSITORY_NAME})
          @notify_client.send_expire_email(TEST_COLLABORATOR_EMAIL, REPOSITORY_NAME)
        end

        context "test check_for_undelivered_expire_emails" do
          before {
            @notifications_object = MockNotifications.new
            @notifications_object.collection[0].created_at = Date.today
            @notifications_object.collection[0].email_address = TEST_COLLABORATOR_EMAIL
            @notifications_object.collection[0].status = "permanent-failure"
            @notifications_object.collection[0].template["id"] = EXPIRE_EMAIL_TEMPLATE_ID
            # Stub sleep
            allow_any_instance_of(GithubCollaborators::NotifyClient).to receive(:sleep)
          }

          it "calls check_for_undelivered_emails_for_template" do
            expect(@notify_client).to receive(:check_for_undelivered_emails_for_template).with(EXPIRE_EMAIL_TEMPLATE_ID)
            @notify_client.check_for_undelivered_expire_emails
          end

          it "when no notifications exist" do
            @notifications_object.collection = []
            expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return(@notifications_object)
            test_equal([], @notify_client.check_for_undelivered_expire_emails)
          end

          it "when notifications exist" do
            @notifications_object.collection[0].template["id"] = EXPIRE_EMAIL_TEMPLATE_ID
            expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return(@notifications_object)
            failed_notifications = @notify_client.check_for_undelivered_expire_emails
            test_equal(failed_notifications, [TEST_COLLABORATOR_EMAIL])
          end

          it "when notifications exist but has an old date" do
            @notifications_object.collection[0].created_at = Date.today - 1
            expect(@notify_client.client).to receive(:get_notifications).with(status: "failed", template_type: "email").and_return(@notifications_object)
            test_equal([], @notify_client.check_for_undelivered_expire_emails)
          end

          it "when notifications exist but incorrect template id" do
            @notifications_object.collection[0].template["id"] = 123
            expect(@notify_client.client).to receive(:get_notifications).with(status: "failed", template_type: "email").and_return(@notifications_object)
            test_equal([], @notify_client.check_for_undelivered_expire_emails)
          end
        end

        it "test send_email_reply_to_ops_eng" do
          expect(@notify_client.client).to receive(:send_email).with(email_address: TEST_COLLABORATOR_EMAIL, template_id: EXPIRE_EMAIL_TEMPLATE_ID, personalisation: {repo_name: REPOSITORY_NAME}, email_reply_to_id: OPERATIONS_ENGINEERING_EMAIL_ID)
          @notify_client.send_expire_email(TEST_COLLABORATOR_EMAIL, REPOSITORY_NAME)
        end

        after do
          ENV.delete("REALLY_SEND_TO_NOTIFY")
          ENV.delete("NOTIFY_TEST_TOKEN")
        end
      end
    end
  end
end
