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
require "logger"
require_relative "./logging"
require_relative "./github_collaborators/access_remover"
require_relative "./github_collaborators/archived_repositories"
require_relative "./github_collaborators/branch_creator"
require_relative "./github_collaborators/collaborator"
require_relative "./github_collaborators/expired"
require_relative "./github_collaborators/expires_soon"
require_relative "./github_collaborators/full_org_member_expired"
require_relative "./github_collaborators/full_org_member_expires_soon"
require_relative "./github_collaborators/full_org_member"
require_relative "./github_collaborators/github_graph_ql_client"
require_relative "./github_collaborators/http_client"
require_relative "./github_collaborators/invites"
require_relative "./github_collaborators/issue_close"
require_relative "./github_collaborators/issue_creator"
require_relative "./github_collaborators/odd_full_org_members"
require_relative "./github_collaborators/organization_members"
require_relative "./github_collaborators/organization"
require_relative "./github_collaborators/outside_collaborators"
require_relative "./github_collaborators/pull_requests"
require_relative "./github_collaborators/removed"
require_relative "./github_collaborators/repositories"
require_relative "./github_collaborators/repository_collaborators"
require_relative "./github_collaborators/slack_notifier"
require_relative "./github_collaborators/terraform_files"
require_relative "./github_collaborators/unknown_collaborators"

class GithubCollaborators
  DATE_FORMAT = "%Y-%m-%d"

  # Issue raised on Github
  COLLABORATOR_EXPIRES_SOON = "Collaborator review date expires soon for user"
  COLLABORATOR_EXPIRY_UPCOMING = "Review after date expiry is upcoming for user"
  DEFINE_COLLABORATOR_IN_CODE = "Please define outside collaborators in code"
  USE_TEAM_ACCESS = "User access removed, access is now via a team"

  # Internal issues
  REVIEW_DATE_WITHIN_MONTH = "Review after date is within a month"
  REVIEW_DATE_PASSED = "Review after date has passed"
  REVIEW_DATE_TO_LONG = "Review after date is more than a year in the future"
  REVIEW_DATE_EXPIRES_SOON = "Review after date is within a week"

  # Pull request titles
  EMPTY_FILES_PR_TITLE = "Delete empty Terraform file/s"
  ADD_FULL_ORG_MEMBER_PR_TITLE = "Add full Org member / collaborator to Terraform file/s for"
  EXTEND_REVIEW_DATE_PR_TITLE = "Extend review date in Terraform file/s for"
  REMOVE_EXPIRED_COLLABORATOR_PR_TITLE = "Remove expired collaborator from Terraform file/s for"
  CHANGE_PERMISSION_PR_TITLE = "Modify permission in Terraform file/s for"
  ARCHIVED_REPOSITORY_PR_TITLE = "Delete archived repository Terraform file/s"

  # Collaborator data issues
  USERNAME_MISSING = "Collaborator username is missing"
  PERMISSION_MISSING = "Collaborator permission is missing"
  NAME_MISSING = "Collaborator name is missing"
  EMAIL_MISSING = "Collaborator email is missing"
  ORGANISATION_MISSING = "Collaborator organisation is missing"
  REASON_MISSING = "Collaborator reason is missing"
  ADDED_BY_MISSING = "Person who added this collaborator is missing"
  REVIEW_DATE_MISSING = "Collaboration review date is missing"
  COLLABORATOR_MISSING = "Collaborator not defined in terraform"

  # Test strings
  TEST_COLLABORATOR_NAME = "bob jones"
  TEST_COLLABORATOR_LOGIN = "bob123"
  TEST_COLLABORATOR_EMAIL = "bob123@some-emmail.com"
  TEST_COLLABORATOR_ORG = "some org"
  TEST_COLLABORATOR_REASON = "some reason"
  TEST_COLLABORATOR_ADDED_BY = "john"
  TEST_COLLABORATOR_PERMISSION = "maintain"

  def self.tf_safe(string)
    string.tr(".", "-")
  end
end
