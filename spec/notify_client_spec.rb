class GithubCollaborators
  include TestConstants
  include Constants

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
            ENV.delete("NOTIFY_TEST_TOKEN")
          }
          it "" do
            expect(Notifications::Client).to receive(:new).and_return(notifications_client)
            notify_client = GithubCollaborators::NotifyClient.new
            test_equal(notify_client.api_key, NOTIFY_PROD_API_TOKEN)
          end
          after do
            ENV.delete("REALLY_SEND_TO_NOTIFY")
            ENV.delete("NOTIFY_PROD_TOKEN")
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

        it "test check_for_undelivered_expire_emails calls check_for_undelivered_emails_for_template" do
          expect(@notify_client).to receive(:check_for_undelivered_emails_for_template).with(EXPIRE_EMAIL_TEMPLATE_ID)
          @notify_client.check_for_undelivered_expire_emails
        end

        it "test check_for_undelivered_expire_emails when no notifications exist" do
          expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return({notifications: []})
          test_equal([], @notify_client.check_for_undelivered_expire_emails)
        end

        it "test check_for_undelivered_expire_emails when notifications exist" do
          today = Date.today.strftime(DATE_FORMAT)
          today_date = "#{today}T12:15:30.000000Z"
          the_notifications = {created_at: today_date, email_address: TEST_COLLABORATOR_EMAIL, status: "permanent-failure", template: {id: EXPIRE_EMAIL_TEMPLATE_ID}}
          expect(@notify_client).to receive(:get_notifications_by_type_and_status).with("email", "failed").and_return({notifications: [the_notifications]})
          failed_notifications = @notify_client.check_for_undelivered_expire_emails
          expected_notification = {
            email_address: TEST_COLLABORATOR_EMAIL,
            created_at: today,
            status: "permanent-failure"
          }
          test_equal(expected_notification, failed_notifications[0])
        end

        it "test check_for_undelivered_expire_emails when notifications exist but has an old date" do
          the_notifications = {created_at: "2016-07-21T12:15:30.000000Z", email_address: TEST_COLLABORATOR_EMAIL, status: "permanent-failure", template: {id: EXPIRE_EMAIL_TEMPLATE_ID}}
          expect(@notify_client.client).to receive(:get_all_notifications).with("failed", "email").and_return({notifications: [the_notifications]})
          test_equal([], @notify_client.check_for_undelivered_expire_emails)
        end

        it "test check_for_undelivered_expire_emails when notifications exist but incorrect template id" do
          today = Date.today.strftime(DATE_FORMAT)
          today_date = "#{today}T12:15:30.000000Z"
          the_notifications = {created_at: today_date, email_address: TEST_COLLABORATOR_EMAIL, status: "permanent-failure", template: {id: 123}}
          expect(@notify_client.client).to receive(:get_all_notifications).with("failed", "email").and_return({notifications: [the_notifications]})
          test_equal([], @notify_client.check_for_undelivered_expire_emails)
        end

        it "test send_email_reply_to_ops_eng" do
          expect(@notify_client.client).to receive(:send_email).with(TEST_COLLABORATOR_EMAIL, EXPIRE_EMAIL_TEMPLATE_ID, {repo_name: REPOSITORY_NAME}, OPERATIONS_ENGINEERING_EMAIL_ID)
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
