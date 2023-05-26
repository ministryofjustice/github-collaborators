#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

class CheckCollaboratorUsernames
  include Logging
  include HelperModule

  def start
    found_error = false
    all_collaborators = []
    http_client = GithubCollaborators::HttpClient.new
    the_terraform_files = GithubCollaborators::TerraformFiles.new
    the_terraform_files.get_terraform_files.each do |terraform_file|
      all_collaborators += the_terraform_files.get_collaborators_in_file(terraform_file.filename)
    end

    all_collaborators.sort!
    all_collaborators.uniq!

    all_collaborators.each do |collaborator|
      url = "#{GH_URL}/users/#{collaborator}"
      http_code = http_client.fetch_code(url)
      if http_code != "200"
        logger.error("Collaborator #{collaborator} username not found on GitHub")
        found_error = true
      end
    end

    if found_error == true
      exit 1
    end
  end
end

puts "Start"
CheckCollaboratorUsernames.new.start
puts "Finished"
