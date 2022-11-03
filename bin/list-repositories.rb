#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

repositories = GithubCollaborators::Repositories.new.active_repositories

repositories.map { |repo| puts repo }

puts "Finished"