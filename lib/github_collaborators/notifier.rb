class Notifier
  def initialize(notification, enabled, collaborators)
    @notification = notification
    @enabled = !!enabled
    @collaborators = collaborators
  end

  def run
    payload = message_payload

    unless post_to_slack?
      puts "** SKIPPING POST: Not posting anything, this is a dry run"
      return
    end

    if ENV.has_key? "SLACK_WEBHOOK_URL"
      HTTP.post(ENV["SLACK_WEBHOOK_URL"], body: JSON.dump(payload))
    else
      raise "Unable to post to Slack the SLACK_WEBHOOK_URL is missing."
    end
  end

  def message_payload
    # Use the class singular or multiple message based on number of collaborators in list
    notification_message = @collaborators.length == 1 ? @notification.singular_message : @notification.multiple_message(@collaborators.length)

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
    puts "** Message to sending to Slack:"
    puts message
    puts ""
    puts "** JSON Payload:"
    puts JSON.pretty_generate(payload)

    # Return json data
    payload
  end

  def post_to_slack?
    @enabled
  end
end
