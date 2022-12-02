module Constants

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
end