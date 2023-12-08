require_relative "../lib/constants"
require "test_constants"

module TestHelpers
  include TestConstants
  include Constants

  def test_equal(value, expected_value)
    expect(value).to eq(expected_value)
  end

  def test_not_equal(value, expected_value)
    expect(value).not_to eq(expected_value)
  end

  def create_terraform_file_with_name(repo_name)
    stub_const(TEST_DIR_OVERRIDE, TEST_DIR)
    terraform_file = GithubCollaborators::TerraformFile.new(repo_name, TERRAFORM_DIR)
    terraform_file.read_file
    terraform_file.get_repository_name
    terraform_file.create_terraform_collaborator_blocks
    terraform_file
  end

  def create_terraform_file
    stub_const(TEST_DIR_OVERRIDE, TEST_DIR)
    terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME, TERRAFORM_DIR)
    terraform_file.read_file
    terraform_file.get_repository_name
    terraform_file.create_terraform_collaborator_blocks
    terraform_file
  end

  def create_empty_terraform_file
    stub_const(TEST_DIR_OVERRIDE, TEST_DIR)
    terraform_file = GithubCollaborators::TerraformFile.new(EMPTY_REPOSITORY_NAME, TERRAFORM_DIR)
    terraform_file.read_file
    terraform_file.get_repository_name
    terraform_file
  end

  def create_terraform_file_with_collaborator_issue
    stub_const(TEST_DIR_OVERRIDE, TEST_DIR)
    terraform_file = GithubCollaborators::TerraformFile.new(TEST_REPO_NAME_EXPIRED_USER, TERRAFORM_DIR)
    terraform_file.read_file
    terraform_file.get_repository_name
    terraform_file
  end

  def create_collaborator_data(review_date)
    {
      login: TEST_COLLABORATOR_LOGIN,
      permission: TEST_COLLABORATOR_PERMISSION,
      name: TEST_COLLABORATOR_NAME,
      email: TEST_COLLABORATOR_EMAIL,
      org: TEST_COLLABORATOR_ORG,
      reason: TEST_COLLABORATOR_REASON,
      added_by: TEST_COLLABORATOR_ADDED_BY,
      review_after: review_date
    }
  end

  def create_empty_block
    {
      login: "",
      permission: "",
      name: "",
      email: "",
      org: "",
      reason: "",
      added_by: "",
      review_after: ""
    }
  end

  def create_terraform_block(collaborator_data)
    terraform_block = GithubCollaborators::TerraformBlock.new
    terraform_block.add_terraform_file_collaborator_data(collaborator_data)
    terraform_block
  end

  def create_collaborator_hash_with_login(login)
    {
      login: login,
      permission: TEST_COLLABORATOR_PERMISSION,
      name: TEST_COLLABORATOR_NAME,
      email: TEST_COLLABORATOR_EMAIL,
      org: TEST_COLLABORATOR_ORG,
      reason: TEST_COLLABORATOR_REASON,
      added_by: TEST_COLLABORATOR_ADDED_BY,
      review_after: ""
    }
  end

  def create_collaborator_with_login(login)
    collaborator_data = {
      login: login,
      permission: TEST_COLLABORATOR_PERMISSION,
      name: TEST_COLLABORATOR_NAME,
      email: TEST_COLLABORATOR_EMAIL,
      org: TEST_COLLABORATOR_ORG,
      reason: TEST_COLLABORATOR_REASON,
      added_by: TEST_COLLABORATOR_ADDED_BY,
      review_after: ""
    }
    create_terraform_block(collaborator_data)
  end

  def create_test_data(review_date)
    collaborator_data = create_collaborator_data(review_date)
    create_terraform_block(collaborator_data)
  end

  def create_terraform_block_review_date_empty
    collaborator_data = create_collaborator_data("")
    create_terraform_block(collaborator_data)
  end

  def create_terraform_block_review_date_yesterday
    review_date = (Date.today - 1).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_tomorrow
    review_date = (Date.today + 1).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_next_year
    review_date = (Date.today + 370).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_less_than_week
    review_date = (Date.today + 6).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_less_than_month
    review_date = (Date.today + 27).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_more_than_month
    review_date = (Date.today + 31).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_empty
    collaborator_data = create_empty_block
    create_terraform_block(collaborator_data)
  end

  def create_terraform_block_review_date_today
    review_date = Date.today.strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_two_days_ago
    review_date = (Date.today - 2).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_in_two_days
    review_date = (Date.today + 2).strftime(DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_issues(title, created_at, state, number)
    [
      {
        title: title,
        created_at: created_at,
        state: state,
        number: number
      }
    ]
  end
end
