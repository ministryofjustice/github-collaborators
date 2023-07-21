# The GithubCollaborators class namespace
class GithubCollaborators
  # The NotifyClient class
  class NotifyClient
    attr_reader :api_key, :expire_email_template_id, :client
    include Logging
    include Constants

    def initialize
      logger.debug "initialize"
      @api_key = ""
      @api_key = if ENV.fetch("REALLY_SEND_TO_NOTIFY", 0) == "1"
        ENV.fetch("NOTIFY_PROD_TOKEN")
      else
        ENV.fetch("NOTIFY_TEST_TOKEN")
      end
      @client ||= Notifications::Client.new(api_key)
    end

    # Wrapper function to send an expire Notify email to the user
    #
    # @param email_address [String] the user email address
    # @param repo_name [String] repository name user expires from
    def send_expire_email(email_address, repo_name)
      personalisation = {
        repo_name: repo_name
      }
      send_email_reply_to_ops_eng(
        EXPIRE_EMAIL_TEMPLATE_ID,
        email_address,
        personalisation
      )
    end

    # Wrapper function to get the failed Notify expire emails
    #
    def check_for_undelivered_expire_emails
      check_for_undelivered_emails_for_template(EXPIRE_EMAIL_TEMPLATE_ID)
    end

    private

    # Get the emails that failed to send from Notify based on
    # the email template id
    #
    # @param template_id [String] the email template id
    # @return [Array<Hash{email_address => String, created_at => String, status => String}>] data from the failed emails
    def check_for_undelivered_emails_for_template(template_id)
      undelivered_emails = []
      the_notifications = get_notifications_by_type_and_status("email", "failed")
      the_notifications[:notifications].each do |notification|
        created_at = Date.parse(notification[:created_at])
        notification_id = notification[:template][:id]
        if notification_id == template_id && created_at == Date.today
          undelivered_emails.push(
            {
              email_address: notification[:email_address],
              created_at: Date.parse(notification[:created_at]).strftime(DATE_FORMAT),
              status: notification[:status]
            }
          )
        end
      end
      undelivered_emails
    end

    # Get the notifications from Notify based on the input criteria
    #
    # @param template_type [String] the type of data to obtain
    # @param status [String] success or failed
    # @return [Array] the notifications from Notify
    def get_notifications_by_type_and_status(template_type, status)
      @client.get_all_notifications(status, template_type)
    end

    # Send an email using Notify and use the operations-engineering
    # ID for replies.
    #
    # @param template_id [String] the email template id
    # @param email [String] the user email address
    # @param personalisation [Hash{repo_name => String}] the repository name
    def send_email_reply_to_ops_eng(template_id, email, personalisation)
      @client.send_email(email, template_id, personalisation, OPERATIONS_ENGINEERING_EMAIL_ID)
      logger.debug "Sent Notify email to #{email}"
    end
  end
end
