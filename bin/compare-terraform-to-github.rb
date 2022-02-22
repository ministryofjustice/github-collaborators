#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

terraform_collaborators = GithubCollaborators::TerraformCollaborators.new(
  base_url: "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"
)

repos = GithubCollaborators::Repositories.new(
  login: "ministryofjustice"
).current

outside_collaborators = GithubCollaborators::OrganizationOutsideCollaborators.new(
  login: "ministryofjustice",
  base_url: "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform"
)

# For each repo
repos.each do |repo|
  # Get the GitHub outside collaborators for current repo
  gc = outside_collaborators.for_repository(repo.name)
  # Get the Terraform collaborators for current repo
  tc = terraform_collaborators.return_collaborators_from_file("terraform/#{GithubCollaborators.tf_safe(repo.name)}.tf")

  # Edge cases
  if gc.nil? || tc.nil?
    next
  end

  if (gc.length == 0) && (tc.length == 0)
    next
  end

  if tc.length == 0
    next
  end

  # Report when defined in Terraform but not GitHub.
  if gc.length != tc.length
    # Report
    puts "====================================="
    puts "Difference in repo #{repo.name}"
    puts "GC Length: #{gc.length}"
    puts "TC Length: #{tc.length}"
    puts "Extra Names:"
    tc.each do |tc_collab|
      puts tc_collab.login unless gc.any? { |x| x.fetch(:login) == tc_collab.login }
    end
    puts "-------------------------------------"
    puts "GC Members"
    gc.each do |i|
      puts i.fetch(:login)
    end
    puts "====================================="
  end
end
