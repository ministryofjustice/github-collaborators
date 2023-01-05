#!/usr/bin/env ruby

require_relative "../lib/github_collaborators"

class DeleteExpiredInvites
  include Logging
  include HelperModule

  def delete_expired_invites
    repositories ||= get_active_repositories
    repositories.each do |repository|
      # Get the repository invites
      repository_invites = get_repository_invites(repository.name)

      # Check the repository invites
      # using a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
      repository_invites.each do |invite|
        invite_login = invite[:login]
        invite_expired = invite[:expired]
        invite_id = invite[:invite_id]

        # Delete expired invites
        if invite_expired
          delete_expired_invite(repository.name, invite_login, invite_id)
        end
      end
    end
  end
end

puts "Start"
DeleteExpiredInvites.new.delete_expired_invites
puts "Finished"
