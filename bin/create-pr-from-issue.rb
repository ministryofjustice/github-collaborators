#!/usr/bin/env ruby

require_relative "../lib/create_pr_from_issue"

puts "Start"
CreatePrFromIssue.new(json_data).start
puts "Finished"
