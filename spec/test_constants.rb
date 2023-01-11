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
  TEST_TERRAFORM_FILE_FULL_PATH = "terraform/#{REPOSITORY_NAME}.tf"
  TEST_REPO_NAME = "test-repo"
  TEST_REPO_NAME_TERRAFORM_FILE = "#{TEST_REPO_NAME}.tf"
  TEST_FILE = "terraform/#{TEST_REPO_NAME}.tf"
  TEST_USER = "someuser"
  TEST_USER_1 = "someuser1"
  TEST_USER_2 = "someuser2"
  TEST_USER_3 = "someuser3"
  TEST_USER_6 = "someuser6"
  TEST_REPO_NAME1 = "test-repo1"
  TEST_REPO_NAME2 = "test-repo2"
  TEST_REPO_NAME3 = "test-repo3"
  TEST_REPO_NAME4 = "test-repo4"
  TEST_REPO_NAME5 = "test-repo5"
  TEST_REPO_NAME_EXPIRED_USER = "test-repo-user-expired"
  TEST_DIR = "spec/fixtures"
  TEST_DIR_OVERRIDE = "Constants::TERRAFORM_DIR"
  REPO_URL = "#{GH_ORG_URL}/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}"
  URL = "#{GH_API_URL}/#{REPOSITORY_NAME}/issues"
  TEST_URL = "#{GH_API_URL}/github-collaborators/issues"
  HREF = "#{GH_ORG_URL}/github-collaborators/blob/main/terraform/#{REPOSITORY_NAME}.tf|terraform file"
  COLLABORATOR_EXISTS = "when collaborator does exist"
  COLLABORATOR_DOESNT_EXIST = "when collaborator doesn't exist"
  CALL_CREATE_PULL_REQUEST = "call create_pull_request"
  WHEN_COLLABORATORS_EXISTS = "when collaborators exist"
  WHEN_NO_COLLABORATORS_EXISTS = "when collaborators don't exist"
  WHEN_NO_COLLABORATORS_PASSED_IN = "when no collaborator is passed in"
  WHEN_COLLABORATOR_FULL_ORG_MEMBER = "when collaborator is a full org collaborator"
  WHEN_COLLABORATOR_NOT_FULL_ORG_MEMBER = "when collaborator is not a full org collaborator"
  WHEN_PULL_REQUEST_DOESNT_EXIST = "when pull request doesn't exist"
  GRACE_PERIOD_OKAY = (Date.today - 45).strftime(DATE_FORMAT)
  GRACE_PERIOD_EXPIRED = (Date.today - 46).strftime(DATE_FORMAT)
  OPEN = "open"
  CLOSED = "closed"
  CREATED_DATE = "2019-10-01"
  BODY = "abc"
  CATCH_ERROR = "catch error"
  TEMP_TERRAFORM_FILES = "spec/tmp/*.tf"
  STUB_TERRAFORM_FILES = "GithubCollaborators::TerraformFiles::TERRAFORM_FILES"
end
