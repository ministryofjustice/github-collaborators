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
      @client ||= Notifications::Client.new(@api_key)
    end

    # Wrapper function to send an expire Notify email to the user
    #
    # @param email_address [String] the user email address
    # @param repository_names [Array<String>] names of the repositories
    def send_expire_email(email_address, repository_names)
      logger.debug "send_expire_email"
      personalisation = {
        repo_names: repository_names.join(', ')
      }
      send_email_reply_to_ops_eng(
        EXPIRE_EMAIL_TEMPLATE_ID,
        email_address,
        personalisation
      )
    end

    # Wrapper function to send an approver Notify email
    #
    # @param email_address [String] the approver email address
    # @param requested_permission [String] repository access level
    # @param collaborators [String] list of collaborators email addresses
    # @param repositories [String] list of repositories names
    # @param reason [String] reason to access repositories
    # @param review_after_date [String] renewal date
    def send_approver_email(email_address, requested_permission, collaborators, repositories, reason, review_after_date)
      logger.debug "send_approver_email"
      personalisation = {
        collaborators: collaborators,
        requested_permission: requested_permission,
        repositories: repositories,
        review_after_date: review_after_date,
        reason: reason
      }
      send_email_reply_to_ops_eng(
        APPROVER_EMAIL_TEMPLATE_ID,
        email_address,
        personalisation
      )
    end

    # Wrapper function to get the recently delivered expire Notify emails
    #
    def get_recently_delivered_emails
      logger.debug "get_recently_delivered_emails"
      check_for_delivered_emails_by_template(EXPIRE_EMAIL_TEMPLATE_ID)
    end

    # Wrapper function to get the failed expire Notify emails
    #
    def check_for_undelivered_expire_emails
      logger.debug "check_for_undelivered_expire_emails"
      # Give Notify time to receive undelivered emails
      sleep 90
      check_for_undelivered_emails_for_template(EXPIRE_EMAIL_TEMPLATE_ID)
    end

    # Wrapper function to get the failed approver Notify emails
    #
    def check_for_undelivered_approver_emails
      logger.debug "check_for_undelivered_approver_emails"
      # Give Notify time to receive undelivered emails
      sleep 90
      check_for_undelivered_emails_for_template(APPROVER_EMAIL_TEMPLATE_ID)
    end

    private

    # Get the emails delivered by Notify based on the email template id
    #
    # @param template_id [String] the email template id
    # @return [Array<Hash{email => String, content => String}>] the delivered email addresses and email body
    def check_for_delivered_emails_by_template(template_id)
      logger.debug "check_for_delivered_emails_by_template"
      delivered_emails = []
      the_notifications = get_notifications_by_type_and_status("email", "delivered")
      the_notifications.collection.each do |notification|
        created_at = notification.created_at.to_datetime
        today_minus_a_week = (Date.today - 7).to_datetime
        notification_id = notification.template["id"]
        if notification_id == template_id && created_at > today_minus_a_week
          delivered_emails.push({email: notification.email_address, content: notification.body})
        end
      end
      delivered_emails.uniq!
      delivered_emails.sort_by { |delivered_email| delivered_email[:email].downcase }
    end

    # Get the emails that failed to send from Notify based on
    # the email template id
    #
    # @param template_id [String] the email template id
    # @return [Array<String>] the failed email addresses
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
    # @return [Array<Array<Notify objects>>] the notification objects from Notify
    def get_notifications_by_type_and_status(template_type, status)
      logger.debug "get_notifications_by_type_and_status"
      @client.get_notifications(status: status, template_type: template_type)
    end

    # Send an email using Notify and use the operations-engineering
    # email ID for the reply address.
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
