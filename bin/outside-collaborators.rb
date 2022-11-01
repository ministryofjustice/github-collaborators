#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

include Logging

logger.info "Start"

outside_collaborators = GithubCollaborators::OutsideCollaborators.new
outside_collaborators.is_renewal_within_one_month
outside_collaborators.remove_unknown_collaborators
outside_collaborators.is_review_date_within_a_week
outside_collaborators.has_review_date_expired

logger.info "Finished"