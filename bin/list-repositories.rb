#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

puts "Start"

repositories = get_active_repositories

repositories.each do |repo|
  puts repo
end

puts "Finished"
