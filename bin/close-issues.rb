#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

include Logging

logger.info "Start"

repositories ||= GithubCollaborators::Repositories.new(login: "ministryofjustice").active_repositories

repositories.each do |repository|
  GithubCollaborators::IssueClose.new.close_expired_issues(repository.name)
end

logger.info "Finished"