module Helpers

  def create_collaborator_data(review_date)
    collaborator_data = {
      login: GithubCollaborators::TEST_COLLABORATOR_LOGIN,
      permission: GithubCollaborators::TEST_COLLABORATOR_PERMISSION,
      name: GithubCollaborators::TEST_COLLABORATOR_NAME,
      email: GithubCollaborators::TEST_COLLABORATOR_EMAIL,
      org: GithubCollaborators::TEST_COLLABORATOR_ORG,
      reason: GithubCollaborators::TEST_COLLABORATOR_REASON,
      added_by: GithubCollaborators::TEST_COLLABORATOR_ADDED_BY,
      review_after: review_date
    }
  end

  def create_empty_block
    collaborator_data = {
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

  def create_test_data(review_date)
    collaborator_data = create_collaborator_data(review_date)
    create_terraform_block(collaborator_data)
  end

  def create_terraform_block_review_date_empty
    collaborator_data = create_collaborator_data("")
    create_terraform_block(collaborator_data)
  end

  def create_terraform_block_review_date_yesterday
    review_date = (Date.today - 1).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_tomorrow
    review_date = (Date.today + 1).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_next_year
    review_date = (Date.today + 370).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_less_than_week
    review_date = (Date.today + 6).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_less_than_month
    review_date = (Date.today + 28).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_more_than_month
    review_date = (Date.today + 31).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_more_than_month
    review_date = (Date.today + 31).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_empty
    collaborator_data = create_empty_block
    create_terraform_block(collaborator_data)
  end

  def create_terraform_block_review_date_today
    review_date = Date.today.strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_two_days_ago
    review_date = (Date.today - 2).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_terraform_block_review_date_in_two_days
    review_date = (Date.today + 2).strftime(GithubCollaborators::DATE_FORMAT).to_s
    create_test_data(review_date)
  end

  def create_issues(title, created_at, state, number)
    issues = [
      {
        title: title,
        created_at: created_at,
        state: state,
        number: number
      }
    ]
    issues
  end
end