# #!/usr/bin/env ruby

require_relative "../lib/github_collaborators"
include HelperModule

puts "Start"

# Create a Organization object, which Contains the Org repositories, full
# Org members, Org outside collaborators and each repository collaborators.
organization = GithubCollaborators::Organization.new

# For each repository
organization.repositories.each do |repository|
  # Get the repository invites
  repository_invites = get_repository_invites(repository_name)

  # Check the repository invites
  # using a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
  repository_invites.each do |invite|
    invite_login = invite[:login]
    invite_expired = invite[:expired]

    # Delete expired invites
    if invite_expired
      delete_expired_invite(repository_name, invite_login)
    end
  end
end

puts "Finished"
