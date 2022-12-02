#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"
include HelperModule

puts "Start"

repositories ||= get_active_repositories

repositories.each do |repository|
  close_expired_issues(repository.name)
end

puts "Finished"
