class GithubCollaborators
  describe FullOrgMemberExpired do
    context "call" do

      REPOSITORY_NAME = "somerepo"
      REPO_URL = "https://github.com/ministryofjustice/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}"
      HREF = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/somerepo.tf|terraform file"  

      subject(:expired) { described_class.new }

      it "create line when collaborator expired today" do
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expired.create_line(collaborator)
        expect(line).to eq("- someuser in <#{REPO_URL}> see <#{HREF}> (today)")
      end

      it "create line when collaborator expired yesterday" do
        terraform_block = create_terraform_block_review_date_yesterday
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expired.create_line(collaborator)
        expect(line).to eq("- someuser in <#{REPO_URL}> see <#{HREF}> (yesterday)")
      end

      it "create line when collaborator expired two days ago" do
        terraform_block = create_terraform_block_review_date_two_days_ago
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expired.create_line(collaborator)
        expect(line).to eq("- someuser in <#{REPO_URL}> see <#{HREF}> (2 days ago)")
      end

      it "create line when collaborator expired no date provided" do
        terraform_block = create_terraform_block_review_date_empty
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expired.create_line(collaborator)
        expect(line).to eq("- someuser in <#{REPO_URL}> see <#{HREF}> (today)")
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
