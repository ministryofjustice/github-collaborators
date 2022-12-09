class GithubCollaborators
  REPO_URL = "https://github.com/ministryofjustice/#{REPOSITORY_NAME}|#{REPOSITORY_NAME}"
  HREF = "https://github.com/ministryofjustice/github-collaborators/blob/main/terraform/somerepo.tf|terraform file"
  describe ExpiresSoon do
    context "call" do
      subject(:expires_soon) { described_class.new }

      it "create line when collaborator expires today" do
        terraform_block = create_terraform_block_review_date_today
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expires_soon.create_line(collaborator)
        test_equal(line, "- someuser in <#{REPO_URL}> see <#{HREF}> (today)")
      end

      it "create line when collaborator expires tomorrow" do
        terraform_block = create_terraform_block_review_date_tomorrow
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expires_soon.create_line(collaborator)
        test_equal(line, "- someuser in <#{REPO_URL}> see <#{HREF}> (tomorrow)")
      end

      it "create line when collaborator in two days" do
        terraform_block = create_terraform_block_review_date_in_two_days
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expires_soon.create_line(collaborator)
        test_equal(line, "- someuser in <#{REPO_URL}> see <#{HREF}> (in 2 days)")
      end

      it "create line when collaborator expired no date provided" do
        terraform_block = create_terraform_block_review_date_empty
        collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
        line = expires_soon.create_line(collaborator)
        test_equal(line, "- someuser in <#{REPO_URL}> see <#{HREF}> (today)")
      end

      it "singular message" do
        line = expires_soon.singular_message
        test_equal(line, "I've found a collaborator whose review date will expire shortly, a pull request has been created to extend the date for this collaborator")
      end

      it "multiple message" do
        line = expires_soon.multiple_message(4)
        test_equal(line, "I've found 4 collaborators whose review date will expire shortly, pull requests have been created to extend the date for these collaborators")
      end
    end
  end
end
