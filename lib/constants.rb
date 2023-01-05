# String constants used in app and tests
module Constants
  # Date format
  DATE_FORMAT = "%Y-%m-%d"

  # Operations Engineering Bot account email address
  ADDED_BY_EMAIL = "opseng-bot@digital.justice.gov.uk"

  # GitHub Bot account email address
  GITHUB_BOT_EMAIL = "github-actions[bot]@users.noreply.github.com"

  # Operations Engineering Bot name
  OPS_ENG_BOT_NAME = "Operations Engineering Bot"

  # The reason why a full organisation collaborator is missing from a Terraform file
  REASON1 = "Full Org member / collaborator missing from Terraform file"

  # The reason why a collaborator is missing from a Terraform file
  REASON2 = "Collaborator missing from Terraform file"

  # The Terraform files to exclude, these are not part of the app
  EXCLUDE_FILES = ["acronyms.tf", "main.tf", "variables.tf", "versions.tf", "backend.tf"]

  # The Terraform directory folder
  TERRAFORM_DIR = "terraform"

  # The search pattern to get the Terraform files from the Terraform folder
  TERRAFORM_FILES = "#{TERRAFORM_DIR}/*.tf"

  # GitHub reply when rate limiting is active
  RATE_LIMITED = "RATE_LIMITED"

  # Pull request type
  TYPE_DELETE_EMPTY_FILE = "delete_empty_file"

  # Pull request type
  TYPE_EXTEND = "extend"

  # Pull request type
  TYPE_REMOVE = "remove"

  # Pull request type
  TYPE_PERMISSION = "permission"

  # Pull request type
  TYPE_ADD = "add"

  # Pull request type
  TYPE_DELETE_ARCHIVE = "delete_archive_file"

  # Pull request type
  TYPE_DELETE_FILE = "delete_file"

  # Github issue title
  COLLABORATOR_EXPIRES_SOON = "Collaborator review date expires soon for user"

  # Github issue title
  COLLABORATOR_EXPIRY_UPCOMING = "Review after date expiry is upcoming for user"

  # Github issue title
  DEFINE_COLLABORATOR_IN_CODE = "Please define outside collaborators in code"

  # Github issue title
  USE_TEAM_ACCESS = "User access removed, access is now via a team"

  # App internal issue
  REVIEW_DATE_WITHIN_MONTH = "Review after date is within a month"

  # App internal issue
  REVIEW_DATE_PASSED = "Review after date has passed"

  # App internal issue
  REVIEW_DATE_TO_LONG = "Review after date is more than a year in the future"

  # App internal issue
  REVIEW_DATE_EXPIRES_SOON = "Review after date is within a week"

  # Pull request title
  EMPTY_FILES_PR_TITLE = "Delete empty Terraform file/s"

  # Pull request title
  ADD_FULL_ORG_MEMBER_PR_TITLE = "Add full Org member / collaborator to Terraform file/s for"

  # Pull request title
  EXTEND_REVIEW_DATE_PR_TITLE = "Extend review date in Terraform file/s for"

  # Pull request title
  REMOVE_EXPIRED_COLLABORATOR_PR_TITLE = "Remove expired collaborator from Terraform file/s for"

  # Pull request title
  CHANGE_PERMISSION_PR_TITLE = "Modify permission in Terraform file/s for"

  # Pull request title
  ARCHIVED_REPOSITORY_PR_TITLE = "Delete archived repository Terraform file/s"

  # Pull request title
  DELETE_REPOSITORY_PR_TITLE  = "Delete repository Terraform file/s"

  # Collaborator data issue
  USERNAME_MISSING = "Collaborator username is missing"

  # Collaborator data issue
  PERMISSION_MISSING = "Collaborator permission is missing"

  # Collaborator data issue
  NAME_MISSING = "Collaborator name is missing"

  # Collaborator data issue
  EMAIL_MISSING = "Collaborator email is missing"

  # Collaborator data issue
  ORGANISATION_MISSING = "Collaborator organisation is missing"

  # Collaborator data issue
  REASON_MISSING = "Collaborator reason is missing"

  # Collaborator data issue
  ADDED_BY_MISSING = "Person who added this collaborator is missing"

  # Collaborator data issue
  REVIEW_DATE_MISSING = "Collaboration review date is missing"

  # Collaborator data issue
  COLLABORATOR_MISSING = "Collaborator not defined in terraform"

  # Collaborator data issue
  MISSING = "missing"

  # Branch name
  DELETE_ARCHIVE_FILE_BRANCH_NAME = "delete-archived-repository-file"

  # Branch name
  DELETE_FILE_BRANCH_NAME = "delete-repository-file"

  # Branch name
  UPDATE_REVIEW_DATE_BRANCH_NAME = "update-review-date-"

  # Branch name
  DELETE_EMPTY_FILE_BRANCH_NAME = "delete-empty-files"

  # Branch name
  REMOVE_EXPIRED_COLLABORATORS_BRANCH_NAME = "remove-expired-collaborator-"

  # Branch name
  MODIFY_COLLABORATORS_BRANCH_NAME = "modify-collaborator-permission-"

  # Branch name
  ADD_COLLABORATOR_BRANCH_NAME = "add-collaborator-"

  # Organization name
  ORG = "ministryofjustice"

  # The GitHub API URL for repositories
  GH_API_URL = "https://api.github.com/repos/#{ORG}"

  # The GitHub Organization URL
  GH_ORG_URL = "https://github.com/#{ORG}"

  # The GitHub GraphQL API URL
  GRAPHQL_URI = "https://api.github.com/graphql"

  # Days in a year
  YEAR = 365

  # Days in a month
  MONTH = 31

  # Days in a week
  WEEK = 7

  # A map of the expected items of a TerraformBlock within a Terraform file
  REQUIRED_ATTRIBUTES = {
    "github_user" => "Collaborator username is missing", # USERNAME_MISSING
    "permission" => "Collaborator permission is missing", # PERMISSION_MISSING
    "name" => "Collaborator name is missing", # NAME_MISSING
    "email" => "Collaborator email is missing", # EMAIL_MISSING
    "org" => "Collaborator organisation is missing", # ORGANISATION_MISSING
    "reason" => "Collaborator reason is missing", # REASON_MISSING
    "added_by" => "Person who added this collaborator is missing", # ADDED_BY_MISSING
    "review_after" => "Collaboration review date is missing" # REVIEW_DATE_MISSING
  }

  # Line offset number
  USERNAME = 0

  # Line offset number
  PERMISSION = 1

  # Line offset number
  NAME = 2

  # Line offset number
  EMAIL = 3

  # Line offset number
  ORG_LINE = 4

  # Line offset number
  REASON = 5

  # Line offset number
  ADDED_BY = 6

  # Line offset number
  REVIEW_AFTER = 7
end
