#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

class CheckApproversEmailDomains
  include Logging
  include HelperModule

  def start
    found_error = false
    the_terraform_files = GithubCollaborators::TerraformFiles.new
    the_terraform_files.get_terraform_files.each do |terraform_file|
      the_terraform_files.get_collaborators_in_file(terraform_file.filename).each do |collaborator_in_file|
        added_by = terraform_file.get_collaborator_added_by(collaborator_in_file)
        if added_by.include?("@justice.gov.uk") || added_by.include?("@digital.justice.gov.uk") || added_by.include?("@yjb.gov.uk") || added_by.include?("@hmcts.net")
          logger.debug "found the correct domain"
        else
          logger.error "The added_by user has an incorrect email domain for the #{collaborator_in_file} within #{terraform_file.filename}"
          found_error = true
        end
      end
    end

    if found_error == true
      exit 1
    end
  end
end

puts "Start"
CheckApproversEmailDomains.new.start
puts "Finished"
