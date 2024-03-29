require "date"
require_relative "../lib/constants"

# Strings used within the tests
module TestConstants
  include Constants
  TEST_COLLABORATOR_NAME = "some user"
  TEST_COLLABORATOR_LOGIN = "someuser"
  TEST_COLLABORATOR_EMAIL = "someuser@some-email.com"
  TEST_COLLABORATOR_ORG = "some org"
  TEST_COLLABORATOR_REASON = "some reason"
  TEST_COLLABORATOR_ADDED_BY = "other user"
  TEST_COLLABORATOR_PERMISSION = "maintain"
  REPOSITORY_NAME = "somerepo"
  BRANCH_NAME = "somebranch"
  EMPTY_REPOSITORY_NAME = "empty-file"
  TEST_TERRAFORM_FILE = "#{REPOSITORY_NAME}.tf"
  TEST_TERRAFORM_FILE_FULL_PATH = "#{TERRAFORM_DIR}/#{REPOSITORY_NAME}.tf"
  TEST_REPO_NAME = "test-repo"
  TEST_REPO_NAME_TERRAFORM_FILE = "#{TEST_REPO_NAME}.tf"
  TEST_FILE = "#{TERRAFORM_DIR}/#{TEST_REPO_NAME}.tf"
  TEST_USER = "someuser"
  TEST_USER_1 = "someuser1"
  TEST_USER_2 = "someuser2"
  TEST_USER_3 = "someuser3"
  TEST_USER_4 = "someuser4"
  TEST_REPO_NAME1 = "test-repo1"
  TEST_REPO_NAME2 = "test-repo2"
  TEST_REPO_NAME3 = "test-repo3"
  TEST_REPO_NAME4 = "test-repo4"
  TEST_REPO_NAME5 = "test-repo5"
  TEST_REPO_NAME_EXPIRED_USER = "test-repo-user-expired"
  TEST_DIR = "spec/fixtures"
  TEST_SPEC_FILE = "spec/fixtures/#{REPOSITORY_NAME}.tf"
  TEST_DIR_OVERRIDE = "Constants::TERRAFORM_DIR"
  REPO_URL = "#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}"
  URL = "#{GH_API_URL}/#{REPOSITORY_NAME}/issues"
  TEST_URL = "#{GH_API_URL}/#{REPO_NAME}/issues"
  HREF = "#{GH_ORG_URL}/#{REPO_NAME}/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file"
  COLLABORATOR_EXISTS = "when collaborator does exist"
  COLLABORATOR_DOESNT_EXIST = "when collaborator doesn't exist"
  CALL_CREATE_PULL_REQUEST = "call create_pull_request"
  WHEN_COLLABORATORS_EXISTS = "when collaborators exist"
  WHEN_NO_COLLABORATORS_EXISTS = "when collaborators don't exist"
  WHEN_NO_COLLABORATORS_PASSED_IN = "when no collaborator is passed in"
  WITH_COLLABORATOR = "when collaborator is passed in "
  WHEN_PULL_REQUEST_DOESNT_EXIST = "when pull request doesn't exist"
  GRACE_PERIOD_OKAY = (Date.today - 45).strftime(DATE_FORMAT)
  GRACE_PERIOD_EXPIRED = (Date.today - 46).strftime(DATE_FORMAT)
  CORRECT_REVIEW_DATE = (Date.today + 45).strftime(DATE_FORMAT)
  INCORRECT_REVIEW_DATE_PAST = GRACE_PERIOD_OKAY
  INCORRECT_REVIEW_DATE_FUTURE = (Date.today + 500).strftime(DATE_FORMAT)
  CORRECT_REVIEW_DATE_FUTURE = (Date.today + 366).strftime(DATE_FORMAT)
  CORRECT_PERMISSION = "push"
  OPEN = "open"
  CLOSED = "closed"
  CREATED_DATE = "2019-10-01"
  BODY = "abc"
  CATCH_ERROR = "catch error"
  TEMP_TERRAFORM_FILES = "spec/tmp/*.tf"
  STUB_TERRAFORM_FILES = "GithubCollaborators::TerraformFiles::TERRAFORM_FILES"
  NOTIFY_TEST_API_TOKEN = "123456"
  NOTIFY_PROD_API_TOKEN = "654321"
  PULL_REQUEST_TITLE = "Pull request 1"
  TEST_RANDOM_EMAIL = "random-email@org.com"
  TEST_RANDOM_FILE = "somefile"
end
