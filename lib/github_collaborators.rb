require "rubygems"
require "bundler/setup"
require "date"
require "erb"
require "json"
require "http"
require "net/http"
require "uri"
require "git"
require "uuidtools"
require 'logger'
require_relative "./executor"
require_relative "./logging"
require_relative "./github_graph_ql_client"
require_relative "./github_collaborators/repository_collaborators"
require_relative "./github_collaborators/organization"
require_relative "./github_collaborators/repositories"
require_relative "./github_collaborators/organization_outside_collaborators"
require_relative "./github_collaborators/repository_collaborator_importer"
require_relative "./github_collaborators/terraform_collaborator"
require_relative "./github_collaborators/access_remover"
require_relative "./github_collaborators/issue_close"
require_relative "./github_collaborators/issue_creator"
require_relative "./github_collaborators/http_client"
require_relative "./github_collaborators/pull_requests"
require_relative "./github_collaborators/pull_request_creator"
require_relative "./github_collaborators/terraform_block_creator"
require_relative "./github_collaborators/slack_notifier"
require_relative "./github_collaborators/expired"
require_relative "./github_collaborators/will_expire_by"

PAGE_SIZE = 100

class GithubCollaborators
  def self.tf_safe(string)
    string.tr(".", "-")
  end
end
