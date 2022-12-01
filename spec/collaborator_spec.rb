class GithubCollaborators
  REPOSITORY_NAME = "somerepo"

  describe Collaborator do
    context "checks issues" do
      it "check issues when review date is missing" do
        terraform_block = create_terraform_block_review_date_empty
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_MISSING])
      end

      it "check issues when review date has passed" do
        terraform_block = create_terraform_block_review_date_yesterday
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_PASSED])
      end

      it "check issues when review date is longer than a year" do
        terraform_block = create_terraform_block_review_date_next_year
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_TO_LONG])
      end

      it "check issues when review date is less than one week away" do
        terraform_block = create_terraform_block_review_date_less_than_week
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_EXPIRES_SOON])
      end

      it "check issues when review date is less than one month away" do
        terraform_block = create_terraform_block_review_date_less_than_month
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_WITHIN_MONTH])
      end

      it "check no issues when review date is more than one month away" do
        terraform_block = create_terraform_block_review_date_more_than_month
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([])
      end

      it "check issues when all inputs are missing" do
        terraform_block = create_terraform_block_empty
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        expect(collaborator.check_for_issues).to eq([USERNAME_MISSING, PERMISSION_MISSING, EMAIL_MISSING, NAME_MISSING, ORGANISATION_MISSING, REASON_MISSING, ADDED_BY_MISSING, REVIEW_DATE_MISSING])
      end

      it "add missing issue to collaborator" do
        terraform_block = create_terraform_block_review_date_more_than_month
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        collaborator.add_issue("missing")
        expect(collaborator.check_for_issues).to eq([COLLABORATOR_MISSING])
      end
    end
  end
end
