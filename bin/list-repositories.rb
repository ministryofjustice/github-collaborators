#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

repositories = GithubCollaborators::Repositories.new(login: "ministryofjustice").current

repositories.map(&:name).sort.each { |repo| puts repo }
