#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

outside_collaborators = GithubCollaborators::OutsideCollaborators.new
# outside_collaborators.close_expired_issues
# outside_collaborators.is_renewal_within_one_month
# outside_collaborators.remove_unknown_collaborators
outside_collaborators.is_review_date_within_a_week

# # Get list of users whose review date has expired
# expired_users = []
# outside_collaborator_list.each do |x|
#   x["issues"].each do |issue|
#     if issue == "Review after date has passed"
#       expired_users.push(x)
#     end
#   end
# end

# Sort list by usernames
# expired_users.sort_by! { |x| x["login"] }

# # Loop through those users
# if expired_users.length > 0
#   # Raise Slack message
#   GithubCollaborators::SlackNotifier.new(Expired.new, POST_TO_SLACK, expired_users).run
# end

# To Do: Create a PR with the user removed from the repos when 'Review after date has passed' is true (once)
