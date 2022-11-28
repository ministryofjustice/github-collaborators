class GithubCollaborators
  class Invites
    include Logging

    # Called when an invite has expired
    def delete_expired_invite(repository_name, invite_login)
      logger.debug "delete_expired_invite"
      logger.warn "The invite for #{invite_login} on #{repository_name} has expired. Deleting the invite."
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/invitations/#{invite_login}"
      GithubCollaborators::HttpClient.new.delete(url)
      sleep 1
    end

    # Get the collaborator invites for the repository and store the data as
    # a hash like this { :login => "name", :expired => "true/false", :invite_id => "number" }
    def get_repository_invites(repository_name)
      logger.debug "get_repository_invites"
      repository_invites = []
      url = "https://api.github.com/repos/ministryofjustice/#{repository_name}/invitations"
      json = GithubCollaborators::HttpClient.new.fetch_json(url)
      JSON.parse(json)
        .find_all { |invite| invite["invitee"]["login"] }
        .map { |invite| repository_invites.push({login: invite["invitee"]["login"], expired: invite["expired"], invite_id: invite["id"]}) }
      repository_invites
    end
  end
end
