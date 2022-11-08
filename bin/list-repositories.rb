#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

repositories = GithubCollaborators::Repositories.new.get_active_repositories

repositories.map { |repo| puts repo }

puts "Finished"
