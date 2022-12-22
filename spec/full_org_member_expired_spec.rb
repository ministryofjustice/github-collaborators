class GithubCollaborators
  include TestConstants
  include Constants

  describe FullOrgMemberExpired do
    context "test FullOrgMemberExpired" do
      subject(:expired) { described_class.new }

      context "call create_line" do
        it "when collaborator expired today" do
          terraform_block = create_terraform_block_review_date_today
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
          line = expired.create_line(collaborator)
          test_equal(line, "- #{TEST_USER} in <#{REPO_URL}> see <#{HREF}> (today)")
        end

        it "when collaborator expired yesterday" do
          terraform_block = create_terraform_block_review_date_yesterday
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
          line = expired.create_line(collaborator)
          test_equal(line, "- #{TEST_USER} in <#{REPO_URL}> see <#{HREF}> (yesterday)")
        end

        it "when collaborator expired two days ago" do
          terraform_block = create_terraform_block_review_date_two_days_ago
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
          line = expired.create_line(collaborator)
          test_equal(line, "- #{TEST_USER} in <#{REPO_URL}> see <#{HREF}> (2 days ago)")
        end

        it "when collaborator expired no date provided" do
          terraform_block = create_terraform_block_review_date_empty
          collaborator = GithubCollaborators::Collaborator.new(terraform_block, REPOSITORY_NAME)
          line = expired.create_line(collaborator)
          test_equal(line, "- #{TEST_USER} in <#{REPO_URL}> see <#{HREF}> (today)")
        end
      end

      it "singular message" do
        line = expired.singular_message
        test_equal(line, "I've found a full Org member / collaborator whose review date has expired, a pull request has been created to remove the collaborator from the Terraform file/s. Manually remove the collaborator from the repository")
      end

      it "multiple message" do
        line = expired.multiple_message(4)
        test_equal(line, "I've found 4 full Org members / collaborators whose review dates have expired, pull requests have been created to remove these collaborators from the Terraform file/s. Manually remove the collaborator from the repository")
      end
    end
  end
end
