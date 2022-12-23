# The GithubCollaborators class namespace
class GithubCollaborators
  # The SlackNotifier class
  class SlackNotifier
    include Logging

    def initialize(notification, collaborators)
      logger.debug "initialize"
      @notification = notification
      @collaborators = collaborators
    end

    # Call the function to create a message payload then post a message
    # to Slack
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

    # Create a message payload using the object passed to the initialize function,
    # then print the message contents for debugging
    # @return [ Hash{username => String, icon_emoji => String>, text => String, mrkdwn => Bool, channel => String} ] the message
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
