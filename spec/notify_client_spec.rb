class GithubCollaborators
  include TestConstants
  include Constants

  class MockNotifications
    attr_reader :collection
    attr_writer :collection
    class MockNotificationsReply
      attr_reader :created_at, :template, :email_address, :body
      attr_writer :created_at, :template, :email_address, :body
      def initialize
        @created_at = ""
        @template = {id: ""}
        @email_address = ""
        @body = ""
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
          expect(@notify_client).to receive(:send_email_reply_to_ops_eng).with(EXPIRE_EMAIL_TEMPLATE_ID, TEST_COLLABORATOR_EMAIL, {repo_names: REPOSITORY_NAME})
          @notify_client.send_expire_email(TEST_COLLABORATOR_EMAIL, [REPOSITORY_NAME])
        end

        it "test send_approver_email" do
          personalisation = {
            collaborators: [TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL],
            requested_permission: "maintain",
            repositories: [REPOSITORY_NAME, REPOSITORY_NAME],
            review_after_date: CREATED_DATE,
            reason: TEST_COLLABORATOR_REASON
          }
          expect(@notify_client).to receive(:send_email_reply_to_ops_eng).with(APPROVER_EMAIL_TEMPLATE_ID, TEST_COLLABORATOR_ADDED_BY, personalisation)
          @notify_client.send_approver_email(TEST_COLLABORATOR_ADDED_BY, "maintain", [TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL, TEST_COLLABORATOR_EMAIL], [REPOSITORY_NAME, REPOSITORY_NAME], TEST_COLLABORATOR_REASON, CREATED_DATE)
        end

        context "" do
          before {
            # Stub sleep
            allow_any_instance_of(GithubCollaborators::NotifyClient).to receive(:sleep)
          }

          it "test check_for_undelivered_approver_emails" do
            expect(@notify_client).to receive(:check_for_undelivered_emails_for_template).with(APPROVER_EMAIL_TEMPLATE_ID)
            @notify_client.check_for_undelivered_approver_emails
          end

          it "test check_for_undelivered_expire_emails" do
            expect(@notify_client).to receive(:check_for_undelivered_emails_for_template).with(EXPIRE_EMAIL_TEMPLATE_ID)
            @notify_client.check_for_undelivered_expire_emails
          end

          it "test get_recently_delivered_emails" do
            expect(@notify_client).to receive(:check_for_delivered_emails_by_template).with(EXPIRE_EMAIL_TEMPLATE_ID)
            @notify_client.get_recently_delivered_emails
          end

          context "test check_for_undelivered_emails_for_template via check_for_undelivered_expire_emails" do
            before {
              @notifications_object = MockNotifications.new
              @notifications_object.collection[0].created_at = Date.today
              @notifications_object.collection[0].email_address = TEST_COLLABORATOR_EMAIL
              @notifications_object.collection[0].template["id"] = EXPIRE_EMAIL_TEMPLATE_ID
            }

            it "when no notifications exist" do
              # Empty the collection for this test
              @notifications_object.collection = []
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return(@notifications_object)
              test_equal([], @notify_client.check_for_undelivered_expire_emails)
            end

            it "when notifications exist" do
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return(@notifications_object)
              failed_notifications = @notify_client.check_for_undelivered_expire_emails
              test_equal(failed_notifications, [TEST_COLLABORATOR_EMAIL])
            end

            it "when notifications exist but has an old date" do
              @notifications_object.collection[0].created_at = Date.today - 1
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return(@notifications_object)
              test_equal([], @notify_client.check_for_undelivered_expire_emails)
            end

            it "when notifications exist but incorrect template id" do
              @notifications_object.collection[0].template["id"] = 123
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return(@notifications_object)
              test_equal([], @notify_client.check_for_undelivered_expire_emails)
            end
          end

          context "test check_for_delivered_emails_by_template via get_recently_delivered_emails" do
            before {
              @notifications_object = MockNotifications.new
              @notifications_object.collection[0].created_at = Date.today
              @notifications_object.collection[0].email_address = TEST_COLLABORATOR_EMAIL
              @notifications_object.collection[0].template["id"] = EXPIRE_EMAIL_TEMPLATE_ID
              @notifications_object.collection[0].body = "Email content #{REPOSITORY_NAME}"
              @expected_result = [{content: "Email content #{REPOSITORY_NAME}", email: TEST_COLLABORATOR_EMAIL}]
            }

            it "when no delivered emails exist" do
              # Empty the collection for this test
              @notifications_object.collection = []
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "delivered").and_return(@notifications_object)
              test_equal([], @notify_client.get_recently_delivered_emails)
            end

            it "when delivered email exists" do
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "delivered").and_return(@notifications_object)
              test_equal(@expected_result, @notify_client.get_recently_delivered_emails)
            end

            it "when delivered email exists but older than 7 days" do
              @notifications_object.collection[0].created_at = Date.today - 8
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "delivered").and_return(@notifications_object)
              test_equal([], @notify_client.get_recently_delivered_emails)
            end

            it "when delivered email exists but incorrect template ID" do
              @notifications_object.collection[0].template["id"] = 123
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "delivered").and_return(@notifications_object)
              test_equal([], @notify_client.get_recently_delivered_emails)
            end

            it "when more than one delivered email exists for the same email address" do
              @notifications_object.collection[1] = @notifications_object.collection[0]
              expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "delivered").and_return(@notifications_object)
              delivered_emails = @notify_client.get_recently_delivered_emails
              test_equal(@expected_result, delivered_emails)
              test_equal(1, delivered_emails.length)
            end
          end

          it "test send_email_reply_to_ops_eng via send_expire_email" do
            expect(@notify_client.client).to receive(:send_email).with(email_address: TEST_COLLABORATOR_EMAIL, template_id: EXPIRE_EMAIL_TEMPLATE_ID, personalisation: {repo_name: REPOSITORY_NAME}, email_reply_to_id: OPERATIONS_ENGINEERING_EMAIL_ID)
            @notify_client.send_expire_email(TEST_COLLABORATOR_EMAIL, REPOSITORY_NAME)
          end

          context "test get_notifications_by_type_and_status" do
            before {
              @notifications_object = MockNotifications.new
              @notifications_object.collection[0].created_at = Date.today
              @notifications_object.collection[0].template["id"] = EXPIRE_EMAIL_TEMPLATE_ID
            }

            it "via get_recently_delivered_emails" do
              expect(@notify_client.client).to receive(:get_notifications).with(status: "delivered", template_type: "email").and_return(@notifications_object)
              @notify_client.get_recently_delivered_emails
            end

            it "via check_for_undelivered_expire_emails" do
              expect(@notify_client.client).to receive(:get_notifications).with(status: "failed", template_type: "email").and_return(@notifications_object)
              @notify_client.check_for_undelivered_expire_emails
            end
          end

          after do
            ENV.delete("REALLY_SEND_TO_NOTIFY")
            ENV.delete("NOTIFY_TEST_TOKEN")
          end
        end
      end
    end
  end
end
