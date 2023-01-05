#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

class CloseExpiredIssues
  include Logging
  include HelperModule

  def start
    repositories ||= get_active_repositories

    repositories.each do |repository|
      close_expired_issues(repository.name)
    end
  end
end

puts "Start"
CloseExpiredIssues.new.start
puts "Finished"
