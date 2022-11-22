class GithubCollaborators
  describe FullOrgMemberExpired do
    context "call" do

      subject(:expired) { described_class.new }

      it "create line when collaborator expired today" do
        terraform_block = TerraformBlock.new

        today = (Date.today).strftime("%Y-%m-%d").to_s
        
        collaborator = {
          login: "bob123",
          permission: "maintain",
          name: "bob jones",
          email: "bob123@some-emmail.com",
          org: "some org",
          reason: "some reason",
          added_by: "john",
          review_after: today
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (today)")
      end

      it "create line when collaborator expired yesterday" do
        terraform_block = TerraformBlock.new

        yesterday = (Date.today - 1).strftime("%Y-%m-%d").to_s
        
        collaborator = {
          login: "bob123",
          permission: "maintain",
          name: "bob jones",
          email: "bob123@some-emmail.com",
          org: "some org",
          reason: "some reason",
          added_by: "john",
          review_after: yesterday
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (yesterday)")
      end

      it "create line when collaborator expired two days ago" do
        terraform_block = TerraformBlock.new

        review_date = (Date.today - 2).strftime("%Y-%m-%d").to_s

        collaborator = {
          login: "bob123",
          permission: "maintain",
          name: "bob jones",
          email: "bob123@some-emmail.com",
          org: "some org",
          reason: "some reason",
          added_by: "john",
          review_after: review_date
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (2 days ago)")
      end

      it "create line when collaborator expired no date provided" do
        terraform_block = TerraformBlock.new

        today = (Date.today - 2).strftime("%Y-%m-%d").to_s

        collaborator = {
          login: "bob123",
          permission: "maintain",
          name: "bob jones",
          email: "bob123@some-emmail.com",
          org: "some org",
          reason: "some reason",
          added_by: "john",
          review_after: ""
        }

        terraform_block.add_terraform_file_collaborator_data(collaborator)
        collaborator = Collaborator.new(terraform_block, "operations")
        line = expired.create_line(collaborator)
        expect(line).to eq("- bob123 in <https://github.com/ministryofjustice/operations|operations> see <https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/operations.tf|terraform file> (today)")
      end

      it "singular message" do
        line = expired.singular_message
        expect(line).to eq("I've found a full Org member / collaborator whose review date has expired, a pull request has been created to remove the collaborator from the Terraform file/s. Manually remove the collaborator from the repository")
      end

      it "multiple message" do
        line = expired.multiple_message(4)
        expect(line).to eq("I've found 4 full Org members / collaborators whose review dates have expired, pull requests have been created to remove these collaborators from the Terraform file/s. Manually remove the collaborator from the repository")
      end
    end
  end
end
