# The GithubCollaborators class namespace
class GithubCollaborators
  # The NotifyClient class
  class NotifyClient
    attr_reader :api_key, :expire_email_template_id, :client
    include Logging
    include Constants

    def initialize
      logger.debug "initialize"
      @api_key = ENV.fetch("NOTIFY_TEST_TOKEN")
      if ENV.fetch("REALLY_SEND_TO_NOTIFY", 0) == "1"
        @api_key = ENV.fetch("NOTIFY_PROD_TOKEN")
      end
      @client ||= Notifications::Client.new(api_key)
    end

    # Wrapper function to send an expire Notify email to the user
    #
    # @param email_address [String] the user email address
    # @param repo_name [String] repository name user expires from
    def send_expire_email(email_address, repo_name)
      logger.debug "send_expire_email"
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
      logger.debug "check_for_undelivered_expire_emails"
      sleep 90
      check_for_undelivered_emails_for_template(EXPIRE_EMAIL_TEMPLATE_ID)
    end

    private

    # Get the emails that failed to send from Notify based on
    # the email template id
    #
    # @param template_id [String] the email template id
    # @return [Array<email_address => String>] the failed email addresses
    def check_for_undelivered_emails_for_template(template_id)
      logger.debug "check_for_undelivered_emails_for_template"
      undelivered_emails = []
      the_notifications = get_notifications_by_type_and_status("email", "failed")
      the_notifications.collection.each do |notification|
        created_at = notification.created_at.strftime(DATE_FORMAT).to_s
        today = Date.today.strftime(DATE_FORMAT).to_s
        notification_id = notification.template["id"]
        if notification_id == template_id && created_at == today
          undelivered_emails.push(notification.email_address)
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
      logger.debug "get_notifications_by_type_and_status"
      @client.get_notifications(status: status, template_type: template_type)
    end

    # Send an email using Notify and use the operations-engineering
    # ID for replies.
    #
    # @param template_id [String] the email template id
    # @param email [String] the user email address
    # @param personalisation [Hash{repo_name => String}] the repository name
    def send_email_reply_to_ops_eng(template_id, email, personalisation)
      logger.debug "send_email_reply_to_ops_eng"
      @client.send_email(email_address: email, template_id: template_id, personalisation: personalisation, email_reply_to_id: OPERATIONS_ENGINEERING_EMAIL_ID)
    end
  end
end
