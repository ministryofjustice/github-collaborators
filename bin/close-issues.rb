#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

repositories ||= GithubCollaborators::Repositories.new.active_repositories

repositories.each do |repository|
  GithubCollaborators::IssueClose.new.close_expired_issues(repository.name)
end

puts "Finished"