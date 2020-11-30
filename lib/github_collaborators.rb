require "json"
require "net/http"
require "uri"
require "erb"
require_relative "./executor"
require_relative "./logger"
require_relative "./github_graph_ql_client"
require_relative "./github_collaborators/repository_collaborators"
require_relative "./github_collaborators/organization"
require_relative "./github_collaborators/repositories"
require_relative "./github_collaborators/organization_external_collaborators"
require_relative "./github_collaborators/repository_collaborator_importer"

PAGE_SIZE = 100

class GithubCollaborators
  def self.tf_safe(string)
    string.tr(".", "-")
  end
end
