class GithubCollaborators
  describe Expired do
    context "call" do
      subject(:expired) { described_class.new }

      it "create line when collaborator expired today" do
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
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (today)")
      end

      it "create line when collaborator expired yesterday" do
        terraform_block = TerraformBlock.new

        yesterday = (Date.today - 1).strftime(DATE_FORMAT).to_s
        collaborator = {
          login: TEST_COLLABORATOR_LOGIN,
          permission: TEST_COLLABORATOR_PERMISSION,
          name: TEST_COLLABORATOR_NAME,
          email: TEST_COLLABORATOR_EMAIL,
          org: TEST_COLLABORATOR_ORG,
          reason: TEST_COLLABORATOR_REASON,
          added_by: TEST_COLLABORATOR_ADDED_BY,
          review_after: yesterday
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (yesterday)")
      end

      it "create line when collaborator expired two days ago" do
        terraform_block = TerraformBlock.new

        review_date = (Date.today - 2).strftime(DATE_FORMAT).to_s

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
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (2 days ago)")
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
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (today)")
      end

      it "singular message" do
        line = expired.singular_message
        expect(line).to eq("I've found a collaborator whose review date has expired, a pull request has been created to remove the collaborator")
      end

      it "multiple message" do
        line = expired.multiple_message(4)
        expect(line).to eq("I've found 4 collaborators whose review dates have expired, pull requests have been created to remove these collaborators")
      end
    end
  end
end
