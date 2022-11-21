class GithubCollaborators
  class SlackNotifier
    include Logging

    def initialize(notification, collaborators)
      logger.debug "initialize"
      @notification = notification
      @collaborators = collaborators
    end

    def post_slack_message
      logger.debug "post_slack_message"

      if @collaborators.length > 0
        payload = message_payload

        if ENV.fetch("REALLY_POST_TO_SLACK", 0) == "1"
          if ENV.has_key? "SLACK_WEBHOOK_URL"
            HTTP.post(ENV["SLACK_WEBHOOK_URL"], body: JSON.dump(payload))
          else
            logger.error "Unable to post to Slack the SLACK_WEBHOOK_URL is missing."
          end
        else
          logger.info "Skipping Slack post message, this is a dry run"
        end
      end
    end

    def message_payload
      logger.debug "message_payload"
      # Use the class singular or multiple message based on number of collaborators in list
      notification_message = (@collaborators.length == 1) ? @notification.singular_message : @notification.multiple_message(@collaborators.length)

      # Create the lines that will be displayed in Slack for each collaborator per repo
      message_lines = @collaborators.map do |collaborator|
        @notification.create_line(collaborator)
      end

      # Create the full Slack message
      message = <<~DOC
        #{notification_message}:
        #{message_lines.join("\n")}
      DOC

      # Form the json representation of the Slack message
      payload = {
        username: "GitHub Collaborator repository bot",
        icon_emoji: ":robot_face:",
        text: message,
        mrkdwn: true,
        channel: "#operations-engineering-alerts"
      }

      # Print CI message
      logger.info "** Message sending to Slack:"
      logger.info message
      logger.info ""
      logger.info "** JSON Payload:"
      logger.info JSON.pretty_generate(payload)

      # Return json data
      payload
    end
  end
end
