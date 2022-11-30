class GithubCollaborators
  describe Collaborator do
    context "checks issues" do
      subject(:collaborator) { described_class.new }

      it "check issues when review date is missing" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: ""
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_MISSING])
      end

      it "check issues when review date has passed" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: (Date.today - 1).strftime(DATE_FORMAT).to_s 
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_PASSED])
      end

      it "check issues when review date is longer than a year" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: (Date.today + 370).strftime(DATE_FORMAT).to_s 
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_TO_LONG])
      end

      it "check issues when review date is less than one week away" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: (Date.today + 6).strftime(DATE_FORMAT).to_s 
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_EXPIRES_SOON])
      end

      it "check issues when review date is less than one month away" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: (Date.today + 28).strftime(DATE_FORMAT).to_s 
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([REVIEW_DATE_WITHIN_MONTH])
      end

      it "check no issues when review date is more than one month away" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: (Date.today + 31).strftime(DATE_FORMAT).to_s 
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([])
      end

      it "check issues when all inputs are missing" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: "",
          permission: "",
          name: "",
          email: "",
          org: "",
          reason: "",
          added_by: "",
          review_after: ""
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        expect(collaborator.check_for_issues).to eq([USERNAME_MISSING, PERMISSION_MISSING, EMAIL_MISSING, NAME_MISSING, ORGANISATION_MISSING, REASON_MISSING, ADDED_BY_MISSING, REVIEW_DATE_MISSING])
      end

      it "add missing issue to collaborator" do
        terraform_block = TerraformBlock.new
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: (Date.today + 31).strftime(DATE_FORMAT).to_s 
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "somerepo")
        collaborator.add_issue("missing")
        expect(collaborator.check_for_issues).to eq([COLLABORATOR_MISSING])
      end
    end
  end
end
           
            
            
            
            