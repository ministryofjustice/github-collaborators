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
      if ENV.fetch("REALLY_SEND_TO_NOTIFY", 0) == "1"
        @api_key = ENV.fetch("NOTIFY_PROD_TOKEN")
      else
        @api_key = ENV.fetch("NOTIFY_TEST_TOKEN")
      end
      @client ||= Notifications::Client.new(api_key)
      @expire_email_template_id = EXPIRE_EMAIL_TEMPLATE_ID
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
        @expire_email_template_id,
        email_address,
        personalisation
      )
    end

    # Wrapper function to get the failed Notify expire emails
    #
    def check_for_undelivered_expire_emails
      check_for_undelivered_emails_for_template(@expire_email_template_id)
    end
    
    private

    # Get the emails that failed to send from Notify based on
    # the email template id
    #
    # @param template_id [String] the email template id
    # @return [Array<Hash{email_address => String, created_at => String, status => String}>] data from the failed emails
    def check_for_undelivered_emails_for_template(template_id)
      undelivered_emails = []
      the_notifications = get_notifications_by_type_and_status("email", "failed")["notifications"]
      the_notifications.each do |notification|
        created_at = notification["created_at"].to_time.iso8601
        notification_id = notification["template"]["id"]
        if notification_id == template_id and created_at == Date.today
          undelivered_emails.push(
            {
              "email_address": notification["email_address"],
              "created_at": created_at,
              "status": notification["status"]
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
      @client.get_all_notifications(status=status, template_type=template_type)
    end

    # Send an email using Notify and use the operations-engineering
    # ID for replies.
    #
    # @param template_id [String] the email template id
    # @param email [String] the user email address
    # @param personalisation [Hash{repo_name => String}] the repository name
    def send_email_reply_to_ops_eng(template_id, email, personalisation)
      operations_engineering_email_id = "6767e190-996f-462c-b7f8-9bafe7b96a01"
      @client.send_email(
          email_address=email,
          template_id=template_id,
          personalisation=personalisation,
          email_reply_to_id=operations_engineering_email_id
      )
      logger.debug "Sent Notify email to #{email}"
    end 
  end
end