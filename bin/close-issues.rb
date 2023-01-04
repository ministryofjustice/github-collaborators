#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

class CloseIssues
  include Logging
  include HelperModule

  def close_issues
    repositories ||= get_active_repositories

    repositories.each do |repository|
      close_expired_issues(repository.name)
    end
  end
end

puts "Start"
CloseIssues.new.close_issues
puts "Finished"
