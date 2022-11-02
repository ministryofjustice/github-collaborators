#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

include Logging

logger.info "Start"

repositories = GithubCollaborators::Repositories.new(login: "ministryofjustice").current

repositories.map(&:name).sort.each { |repo| puts repo }

logger.info "Finished"