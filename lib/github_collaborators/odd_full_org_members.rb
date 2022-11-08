class GithubCollaborators
  class OddFullOrgMembers
    include Logging

    def create_line(collaborator)
      logger.debug "create_line"
      "- #{collaborator}."
    end

    def singular_message
      "I've found a collaborator who is a full Org member but isn't attached to any GitHub repositories except the all-org-members team respositories. Consider removing this collaborator."
    end

    def multiple_message(collaborators)
      "I've found #{collaborators} collaborators who are full Org members but are not attached to any GitHub repositories except the all-org-members team respositories. Consider removing these collaborators."
    end
  end
end
