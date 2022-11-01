#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

outside_collaborators = GithubCollaborators::OutsideCollaborators.new
outside_collaborators.is_renewal_within_one_month
outside_collaborators.remove_unknown_collaborators
outside_collaborators.is_review_date_within_a_week
