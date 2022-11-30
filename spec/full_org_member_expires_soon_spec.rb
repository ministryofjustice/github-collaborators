class GithubCollaborators
  describe FullOrgMemberExpiresSoon do
    context "call" do
      subject(:expires_soon) { described_class.new }

      it "create line when collaborator expires today" do
        terraform_block = TerraformBlock.new

        today = Date.today.strftime(DATE_FORMAT).to_s

        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: today
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expires_soon.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (today)")
      end

      it "create line when collaborator expires tomorrow" do
        terraform_block = TerraformBlock.new

        tomorrow = (Date.today + 1).strftime(DATE_FORMAT).to_s
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: tomorrow
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expires_soon.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (tomorrow)")
      end

      it "create line when collaborator in two days" do
        terraform_block = TerraformBlock.new

        review_date = (Date.today + 2).strftime(DATE_FORMAT).to_s

        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: review_date
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expires_soon.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (in 2 days)")
      end

      it "create line when collaborator expired no date provided" do
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
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expires_soon.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (today)")
      end

      it "singular message" do
        line = expires_soon.singular_message
        expect(line).to eq("I've found a collaborator who is a full Org member whose review date will expire shortly, a pull request has been created to extend the date for this collaborator")
      end

      it "multiple message" do
        line = expires_soon.multiple_message(4)
        expect(line).to eq("I've found 4 collaborators who are full Org members whose review date will expire shortly, pull requests have been created to extend the date for these collaborators")
      end
    end
  end
end
