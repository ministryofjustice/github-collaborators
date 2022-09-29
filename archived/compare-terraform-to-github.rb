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

collaborators_who_are_members = []

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
    puts "=" * 37
    puts "Repository: #{repo.name}"
    puts "Number of Outside Collaborators: #{gc.length}"
    puts "These Outside Collaborator/s are not defined in Terraform:"
    gc.each do |gc_collaborator|
      puts gc_collaborator.fetch(:login)
    end
    puts "=" * 37
    puts ""
  elsif gc.length != tc.length

    # Some collaborators have been upgraded to full organization members, this checks for them.
    tc.each do |tc_collaborator|
      if outside_collaborators.is_an_org_member(tc_collaborator.login) == true
        collaborators_who_are_members.push(tc_collaborator.login)
        gc.push({
          login: tc_collaborator.login,
          login_url: nil,
          permission: nil,
        })

      end
    end

    # Do the check again with the new value added above
    if gc.length != tc.length
      # Report when collaborator/s are defined in Terraform but not GitHub.
      puts "====================================="
      puts "Difference in repository: #{repo.name}"
      puts "Number of Outside Collaborators: #{gc.length}"
      puts "Defined in Terraform: #{tc.length}"
      puts "The Outside Collaborator/s not attached to the repository but defined in Terraform:"

      # Get the pending collaborator invites for the repository
      pending_invites = []
      url = "https://api.github.com/repos/ministryofjustice/#{repo.name}/invitations"
      json = GithubCollaborators::HttpClient.new.fetch_json(url).body
      if json != ""
        JSON.parse(json)
          .find_all { |c| c["invitee"]["login"] }
          .map { |c| pending_invites.push(c) }
      end

      # Print collaborator name + pending invite or name only
      tc.each do |tc_collaborator|
        if pending_invites.length != 0
          print tc_collaborator.login.to_s unless gc.any? { |x| x.fetch(:login) == tc_collaborator.login }
          pending_invites.each do |x|
            if x["invitee"]["login"] == tc_collaborator.login
              print ": Has a pending invite \n"
            end
          end
        else
          puts tc_collaborator.login unless gc.any? { |x| x.fetch(:login) == tc_collaborator.login }
        end
      end

      # Print all the repository outside collaborators if any exist
      if gc.length > 0
        puts "-" * 37
        puts "The #{gc.length} Outside Collaborator/s for this repository are:"
        gc.each do |i|
          puts i.fetch(:login)
        end
      end
      puts "=" * 37
      puts ""
    end
  end
end

# Print collaborator login who are also a member of the org
puts "These Outside Collaborators are defined within Terraform and are full Organization Members:"
collaborators_who_are_members = collaborators_who_are_members.uniq
collaborators_who_are_members.each do |collaborator|
  puts collaborator.to_s
end
